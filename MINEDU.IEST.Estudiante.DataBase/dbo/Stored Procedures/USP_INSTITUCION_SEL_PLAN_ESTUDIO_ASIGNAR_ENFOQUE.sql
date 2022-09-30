-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		01/10/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	REALIZAR LA BUSQUEDA DE LAS UNIDADES DIDACTICAS PARA ASIGNARLE EL ENFOQUE

--  TEST:			EXEC USP_INSTITUCION_SEL_PLAN_ESTUDIO_ASIGNAR_ENFOQUE 968, 1, 1, N'**FECHO1876**', 1, 100

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_PLAN_ESTUDIO_ASIGNAR_ENFOQUE]
(
	@ID_PLAN_ESTUDIO			INT,

    @ES_ACTIVO				BIT,						
    @ESTADO					SMALLINT,				
    @USUARIO_CREACION		NVARCHAR(20),

	@Pagina					int = 1,
	@Registros				int = 10
)
AS
BEGIN
	SET NOCOUNT ON;


	Begin --> DECLARACION DE VARIABLES 

		DECLARE @desde INT , @hasta INT;
		SET @desde = ( @Pagina - 1 ) * @Registros;
		SET @hasta = ( @Pagina * @Registros ) + 1;	
	 
		DECLARE @CANTIDAD_UNIDADES_DIDACTICAS_ASIGNADAS_EXISTENTES		INT;
		
		--//prueba
		DECLARE @VALIDA_INSERCION NVARCHAR(100) = 'No inserto';
	End
	
	


	Begin --> VALIDAR SI SE A REGISTRADO: unidades_didacticas_por_enfoque 
		
		SET @CANTIDAD_UNIDADES_DIDACTICAS_ASIGNADAS_EXISTENTES = (		
																	SELECT
																		COUNT(
																		ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
																		)
																	FROM 
																		transaccional.unidades_didacticas_por_enfoque ude
																	WHERE
																		ude.ID_ENFOQUES_POR_PLAN_ESTUDIO = (				
																											SELECT																		
																												epe.ID_ENFOQUES_POR_PLAN_ESTUDIO
																											FROM
																														transaccional.plan_estudio pe
																											INNER JOIN	transaccional.enfoques_por_plan_estudio epe	ON pe.ID_PLAN_ESTUDIO = epe.ID_PLAN_ESTUDIO																	
																											WHERE
																												pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
																											)
																	)
																	
	End


	Begin --> INSERTAR: unidades_didacticas_por_enfoque 

		IF @CANTIDAD_UNIDADES_DIDACTICAS_ASIGNADAS_EXISTENTES = 0
		Begin 
			INSERT INTO transaccional.unidades_didacticas_por_enfoque
			(
				ID_ENFOQUES_POR_PLAN_ESTUDIO		
				,ID_UNIDAD_DIDACTICA				
				,ID_TIPO_UNIDAD_DIDACTICA
									
				,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
			)
			SELECT
				epe.ID_ENFOQUES_POR_PLAN_ESTUDIO	
				,ud.ID_UNIDAD_DIDACTICA							
				,tud.ID_TIPO_UNIDAD_DIDACTICA		

				,@ES_ACTIVO, @ESTADO, @USUARIO_CREACION, GETDATE()
			FROM
						transaccional.plan_estudio pe
			INNER JOIN	transaccional.modulo mo							ON pe.ID_PLAN_ESTUDIO			= mo.ID_PLAN_ESTUDIO
			INNER JOIN	transaccional.unidad_didactica ud				ON mo.ID_MODULO					= ud.ID_MODULO
			INNER JOIN	maestro.tipo_unidad_didactica tud				ON ud.ID_TIPO_UNIDAD_DIDACTICA	= tud.ID_TIPO_UNIDAD_DIDACTICA	
			INNER JOIN	transaccional.enfoques_por_plan_estudio epe		ON pe.ID_PLAN_ESTUDIO			= epe.ID_PLAN_ESTUDIO			
			WHERE
				pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
			ORDER BY mo.ID_MODULO, ud.ID_UNIDAD_DIDACTICA ASC

			SET @VALIDA_INSERCION = 'Inserto';
		End			
		
	End	


	Begin --> Mensajes de prueba con PRINT consultar en la Pestaña "Message" 
		
		PRINT ''
		PRINT '@CANTIDAD_UNIDADES_DIDACTICAS_ASIGNADAS_EXISTENTES  = ' + CONVERT(VARCHAR, @CANTIDAD_UNIDADES_DIDACTICAS_ASIGNADAS_EXISTENTES);
		PRINT '@VALIDA_INSERCION									= ' + CONVERT(VARCHAR, @VALIDA_INSERCION);  
		DECLARE @DATOS_INSERTADOS_ENCONTRADOS VARCHAR(10) = (SELECT COUNT(ID_UNIDADES_DIDACTICAS_POR_ENFOQUE) AS 'DATOS INSERTADOS ENCONTRADOS' FROM transaccional.unidades_didacticas_por_enfoque WHERE USUARIO_CREACION = '**FECHO1876**');	
		PRINT '@DATOS_INSERTADOS_ENCONTRADOS						= ' + CONVERT(VARCHAR, @DATOS_INSERTADOS_ENCONTRADOS);  	
	
	End	


	Begin --> MOSTRAR EN GRILLA	

		WITH    tempPaginado AS
		(	   

		
			
			SELECT
				IdUnidadesDidacticasPorEnfoque	= udf.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
				,IdUnidadDidactica				= ud.ID_UNIDAD_DIDACTICA
				
				,NombreModulo					= UPPER(mo.NOMBRE_MODULO)
				,NombreTipoUnidad				= UPPER(tud.NOMBRE_TIPO_UNIDAD)
				,NombreUnidadDidactica			= UPPER(ud.NOMBRE_UNIDAD_DIDACTICA)
				,TeoricoPracticoHorasUd			= CASE WHEN ud.TEORICO_PRACTICO_HORAS_UD >0 THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, ud.TEORICO_PRACTICO_HORAS_UD), 128)			
														ELSE '0'
												  END 
				,PracticoHorasUd				= CASE WHEN ud.PRACTICO_HORAS_UD>0 THEN 
													CONVERT(VARCHAR, CONVERT(FLOAT, ud.PRACTICO_HORAS_UD), 128)			
													ELSE '0'
												  END
				,Creditos						= CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128)

				--,udf.HORAS_EMPRESA
				--,udf.CREDITOS_VIRTUALES

				,NombreEnfoque					= LOWER(en.NOMBRE_ENFOQUE)
				,ValorCheck						= CASE WHEN udf.HORAS_EMPRESA IS NULL AND udf.CREDITOS_VIRTUALES IS NULL THEN '0' ELSE '1' END
				,'Row'							= ROW_NUMBER() OVER ( ORDER BY udf.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE)
				,Total							= COUNT(1) OVER ( )		
			FROM
						transaccional.plan_estudio pe
			INNER JOIN	transaccional.modulo mo								ON pe.ID_PLAN_ESTUDIO					= mo.ID_PLAN_ESTUDIO
			INNER JOIN	transaccional.unidad_didactica ud					ON mo.ID_MODULO							= ud.ID_MODULO				
			INNER JOIN	transaccional.enfoques_por_plan_estudio epe			ON pe.ID_PLAN_ESTUDIO					= epe.ID_PLAN_ESTUDIO
			INNER JOIN	maestro.enfoque en									ON epe.ID_ENFOQUE						= en.ID_ENFOQUE
			INNER JOIN	transaccional.unidades_didacticas_por_enfoque udf	ON udf.ID_ENFOQUES_POR_PLAN_ESTUDIO		= epe.ID_ENFOQUES_POR_PLAN_ESTUDIO AND udf.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA
			INNER JOIN	maestro.tipo_unidad_didactica tud					ON tud.ID_TIPO_UNIDAD_DIDACTICA			= udf.ID_TIPO_UNIDAD_DIDACTICA
							   
			WHERE 1 = 1 
			AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO

		)
		SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 

	End

	 
END
GO


