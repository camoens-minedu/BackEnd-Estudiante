/***************************************************************************************************************************
  AUTOR:			FERNANDO RAMOS C.
  CREACION:			21/08/2018
  ACTUALIZACION:	
  BASE DE DATOS:	DB_REGIA_2
  DESCRIPCION:	REALIZAR LA BUSQUEDA DE PLAN DE ESTUDIOS
----------------------------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
----------------------------------------------------------------------------------------------------------------------------
1.0			21/08/2018		FRAMOS			CREACIÓN
1.1			20/04/2020		MALVA			SE ESTABLECE CONDICIÓN ( epplan.ES_ACTIVO=1) SOLO SI SE PUEDE REALIZAR JOIN  
											CON LA TABLA transaccional.enfoques_por_plan_estudio. 
1.2			17/05/2022		JCHAVEZ			MOSTRAR SOLO LOS PLANES QUE TENGAN ENFOQUE ACTIVO

TEST:
	EXEC USP_INSTITUCION_SEL_PLAN_ESTUDIO_PAGINADO 443,'',0,0,1,20
***************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_PLAN_ESTUDIO_PAGINADO]
(
	@ID_INSTITUCION			INT,				
	@NOMBRE_PLAN_ESTUDIOS	VARCHAR(150),		
	@ID_ITINERARIO			INT,				
	@ID_CARRERA				INT,				

	@Pagina					int = 1,
	@Registros				int = 10

	--DECLARE @ID_INSTITUCION			INT=	1514		
	--DECLARE @NOMBRE_PLAN_ESTUDIOS	VARCHAR(150)=''	
	--DECLARE @ID_ITINERARIO			INT=	0		
	--DECLARE @ID_CARRERA				INT=	0		

	--DECLARE @Pagina					int = 1
	--DECLARE @Registros				int = 10
)
AS
BEGIN
	SET NOCOUNT ON;


	Begin --> DECLARACION DE VARIABLES

		DECLARE @TIPO_ITINERARIO					INT = 33	--//Itinerario en tabla enumerados es 33
		DECLARE @TIPO_ESTADO						INT = 29	--//Estado de Plan de Estudios en tabla enumerados es 38	
		
		DECLARE @MODULAR_PRESENCIAL_DUAL			INT = 2		--//Extraido de la base de dato tbl: sistema.enumerado ID_TIPO_ENUMERADO = 37 y tbl: maestro.enfoque
		DECLARE @MODULAR_PRESENCIAL_ALTERNANCIA		INT = 3		--//Extraido de la base de dato tbl: sistema.enumerado ID_TIPO_ENUMERADO = 37 y tbl: maestro.enfoque
		DECLARE @MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL	INT = 4		--//Extraido de la base de dato tbl: sistema.enumerado ID_TIPO_ENUMERADO = 37 y tbl: maestro.enfoque
				
		DECLARE @ID_PLANESTUDIO INT
		DECLARE @TotalCreditos DECIMAL

		DECLARE @desde INT , @hasta INT;
		SET @desde = ( @Pagina - 1 ) * @Registros;
		SET @hasta = ( @Pagina * @Registros ) + 1;

	End

	
	--SET @ID_PLANESTUDIO = (SELECT pest.ID_PLAN_ESTUDIO FROM transaccional.carreras_por_institucion cpinst INNER JOIN db_auxiliar.dbo.UVW_CARRERA c
	--						ON cpinst.ID_CARRERA = c.ID_CARRERA INNER JOIN transaccional.plan_estudio pest
	--						ON cpinst.ID_CARRERAS_POR_INSTITUCION = pest.ID_CARRERAS_POR_INSTITUCION
	--						WHERE c.ID_CARRERA=@ID_CARRERA and cpinst.ID_INSTITUCION=@ID_INSTITUCION AND cpinst.ID_TIPO_ITINERARIO=@ID_ITINERARIO)



    --SET @TotalCreditos = (SELECT ROUND(SUM(ud.CREDITOS), 0) 
						
				--			FROM
				--			transaccional.plan_estudio pe
				--			INNER JOIN	transaccional.modulo mo								ON pe.ID_PLAN_ESTUDIO					= mo.ID_PLAN_ESTUDIO
				--			INNER JOIN	transaccional.unidad_didactica ud					ON mo.ID_MODULO							= ud.ID_MODULO				
				--			INNER JOIN	transaccional.enfoques_por_plan_estudio epe			ON pe.ID_PLAN_ESTUDIO					= epe.ID_PLAN_ESTUDIO
				--			INNER JOIN	maestro.enfoque en									ON epe.ID_ENFOQUE						= en.ID_ENFOQUE
				--			INNER JOIN	transaccional.unidades_didacticas_por_enfoque udf	ON udf.ID_ENFOQUES_POR_PLAN_ESTUDIO		= epe.ID_ENFOQUES_POR_PLAN_ESTUDIO AND udf.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA
				--			INNER JOIN	maestro.tipo_unidad_didactica tud					ON tud.ID_TIPO_UNIDAD_DIDACTICA			= udf.ID_TIPO_UNIDAD_DIDACTICA
							   
				--			WHERE 1 = 1 
				--			AND pe.ID_PLAN_ESTUDIO = @ID_PLANESTUDIO
				--			GROUP BY pe.ID_PLAN_ESTUDIO)



	Begin --> MOSTRAR EN GRILLA
	
		WITH    tempPaginado AS
		(	   
				SELECT 				
					IdPlanEstudio			= pe.ID_PLAN_ESTUDIO
					,IdTipoItinerario		= enum.ID_ENUMERADO

					,ProgramaEstudios		= UPPER(c.NOMBRE_CARRERA)					
					,TipoItinerario			= UPPER(enum.VALOR_ENUMERADO)				
					,NivelFormacion			= UPPER(nf.NOMBRE_NIVEL_FORMACION)	
					,NombrePlanEstudios		= UPPER(pe.NOMBRE_PLAN_ESTUDIOS)
					,Modalidad              = UPPER(enumerado3.VALOR_ENUMERADO)
					,Enfoque                = UPPER(enfo.NOMBRE_ENFOQUE)
					
					,FechaCreacion			= CONVERT(VARCHAR(10), pe.FECHA_CREACION, 103)
					,Estado					= UPPER(enum2.VALOR_ENUMERADO)

					,AsignarEnfoque =	CASE 
											WHEN 
												@MODULAR_PRESENCIAL_DUAL = epe.ID_ENFOQUE OR 
												@MODULAR_PRESENCIAL_ALTERNANCIA = epe.ID_ENFOQUE OR 
												@MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL = epe.ID_ENFOQUE
												THEN 1
											ELSE
												0
										END
					,NombreConcepto =	CASE	WHEN	@MODULAR_PRESENCIAL_DUAL = epe.ID_ENFOQUE OR 
														@MODULAR_PRESENCIAL_ALTERNANCIA = epe.ID_ENFOQUE
														THEN 'Horas'
												WHEN @MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL = epe.ID_ENFOQUE
														THEN 'Créditos'
										END
					,NombreEnfoque =	(select NOMBRE_ENFOQUE from maestro.enfoque where ID_ENFOQUE =  epe.ID_ENFOQUE)



					,TotalCreditos          = (    SELECT SUM(ud.CREDITOS)  
						
													FROM transaccional.modulo mo								   
													INNER JOIN	transaccional.unidad_didactica ud					ON mo.ID_MODULO							= ud.ID_MODULO				
													INNER JOIN	transaccional.enfoques_por_plan_estudio epe			ON pe.ID_PLAN_ESTUDIO					= epe.ID_PLAN_ESTUDIO
													INNER JOIN	maestro.enfoque en									ON epe.ID_ENFOQUE						= en.ID_ENFOQUE
													INNER JOIN	transaccional.unidades_didacticas_por_enfoque udf	ON udf.ID_ENFOQUES_POR_PLAN_ESTUDIO		= epe.ID_ENFOQUES_POR_PLAN_ESTUDIO AND udf.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA
													INNER JOIN	maestro.tipo_unidad_didactica tud					ON tud.ID_TIPO_UNIDAD_DIDACTICA			= udf.ID_TIPO_UNIDAD_DIDACTICA
							   
													WHERE 1 = 1 
													AND mo.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO
													)


					, MinimoConceptosUDEnfoque = CASE WHEN  @MODULAR_PRESENCIAL_DUAL = epe.ID_ENFOQUE
													THEN (	SELECT ROUND(SUM(UD.HORAS) * 0.5,0) FROM transaccional.modulo M
															INNER JOIN transaccional.unidad_didactica UD ON M.ID_MODULO = UD.ID_MODULO
															WHERE M.ID_PLAN_ESTUDIO= pe.ID_PLAN_ESTUDIO
														  )
													WHEN @MODULAR_PRESENCIAL_ALTERNANCIA = epe.ID_ENFOQUE
													THEN (	SELECT ROUND((SUM(UD.HORAS) * 0.2),0) FROM transaccional.modulo M
															INNER JOIN transaccional.unidad_didactica UD ON M.ID_MODULO = UD.ID_MODULO
															WHERE M.ID_PLAN_ESTUDIO= pe.ID_PLAN_ESTUDIO
														  )
													WHEN @MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL = epe.ID_ENFOQUE
													THEN 
														(	SELECT ROUND((SUM(UD.CREDITOS) * 0.3),1) FROM transaccional.modulo M
															INNER JOIN transaccional.unidad_didactica UD ON M.ID_MODULO = UD.ID_MODULO
															WHERE M.ID_PLAN_ESTUDIO= pe.ID_PLAN_ESTUDIO
														  )
													END
					, MaximoConceptosUDEnfoque = CASE WHEN  @MODULAR_PRESENCIAL_DUAL = epe.ID_ENFOQUE
													THEN (	SELECT ROUND((SUM(UD.HORAS) * 0.8),0) FROM transaccional.modulo M
															INNER JOIN transaccional.unidad_didactica UD ON M.ID_MODULO = UD.ID_MODULO
															WHERE M.ID_PLAN_ESTUDIO= pe.ID_PLAN_ESTUDIO
														  )
													WHEN @MODULAR_PRESENCIAL_ALTERNANCIA = epe.ID_ENFOQUE
													THEN (	SELECT ROUND((SUM(UD.HORAS) * 0.6),0) FROM transaccional.modulo M
															INNER JOIN transaccional.unidad_didactica UD ON M.ID_MODULO = UD.ID_MODULO
															WHERE M.ID_PLAN_ESTUDIO= pe.ID_PLAN_ESTUDIO
														  )
													WHEN @MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL = epe.ID_ENFOQUE
													THEN 
														(	SELECT ROUND((SUM(UD.CREDITOS) * 0.5),1) FROM transaccional.modulo M
															INNER JOIN transaccional.unidad_didactica UD ON M.ID_MODULO = UD.ID_MODULO
															WHERE M.ID_PLAN_ESTUDIO= pe.ID_PLAN_ESTUDIO
														  )
													END
					, MinimoPorcentaje =	CASE	WHEN  @MODULAR_PRESENCIAL_DUAL = epe.ID_ENFOQUE THEN 50												
													WHEN  @MODULAR_PRESENCIAL_ALTERNANCIA = epe.ID_ENFOQUE THEN 20													
													WHEN @MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL = epe.ID_ENFOQUE THEN 30
											END
					, MaximoPorcentaje =	CASE	WHEN  @MODULAR_PRESENCIAL_DUAL = epe.ID_ENFOQUE THEN 80												
													WHEN  @MODULAR_PRESENCIAL_ALTERNANCIA = epe.ID_ENFOQUE THEN 60													
													WHEN @MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL = epe.ID_ENFOQUE THEN 50
											END
					, TotalHoras = (SELECT SUM(UD.HORAS)  FROM transaccional.modulo M
															INNER JOIN transaccional.unidad_didactica UD ON M.ID_MODULO = UD.ID_MODULO
															WHERE M.ID_PLAN_ESTUDIO= pe.ID_PLAN_ESTUDIO)
					,ROW_NUMBER() OVER ( ORDER BY c.NOMBRE_CARRERA,enum.ID_ENUMERADO ) AS Row
					,Total					= COUNT(1) OVER ( )				
				FROM
					transaccional.carreras_por_institucion cpi
					INNER JOIN transaccional.plan_estudio pe					ON cpi.ID_CARRERAS_POR_INSTITUCION		= pe.ID_CARRERAS_POR_INSTITUCION
					LEFT JOIN transaccional.enfoques_por_plan_estudio epe		ON pe.ID_PLAN_ESTUDIO					= epe.ID_PLAN_ESTUDIO AND epe.ES_ACTIVO = 1
					INNER JOIN db_auxiliar.dbo.UVW_CARRERA c					ON cpi.ID_CARRERA						= c.ID_CARRERA
					INNER JOIN maestro.nivel_formacion nf						ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO		--c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION		--reemplazoPorVista
					INNER JOIN sistema.enumerado enum							ON cpi.ID_TIPO_ITINERARIO				= enum.ID_ENUMERADO					AND enum.ID_TIPO_ENUMERADO	= @TIPO_ITINERARIO
					INNER JOIN sistema.enumerado enum2							ON pe.ESTADO							= enum2.CODIGO_ENUMERADO			AND enum2.ID_TIPO_ENUMERADO	= @TIPO_ESTADO
					LEFT JOIN transaccional.enfoques_por_plan_estudio epplan   ON pe.ID_PLAN_ESTUDIO                   = epplan.ID_PLAN_ESTUDIO      	AND epplan.ES_ACTIVO = 1
					LEFT JOIN maestro.enfoque enfo                             ON epplan.ID_ENFOQUE                    = enfo.ID_ENFOQUE
					LEFT JOIN sistema.enumerado enumerado3                     ON enfo.ID_MODALIDAD_ESTUDIO            = enumerado3.ID_ENUMERADO
				WHERE 1 = 1 AND	
					UPPER(pe.NOMBRE_PLAN_ESTUDIOS) LIKE '%' + UPPER(@NOMBRE_PLAN_ESTUDIOS) + '%'
					AND enum.ID_ENUMERADO =	CASE WHEN @ID_ITINERARIO IS NULL	OR	LEN(@ID_ITINERARIO) = 0		OR @ID_ITINERARIO = ''	THEN enum.ID_ENUMERADO	ELSE @ID_ITINERARIO	END
					AND cpi.ID_CARRERA =	CASE WHEN @ID_CARRERA IS NULL		OR	LEN(@ID_CARRERA) = 0		OR @ID_CARRERA = ''		THEN cpi.ID_CARRERA		ELSE @ID_CARRERA	END
					AND cpi.ID_INSTITUCION = @ID_INSTITUCION
					AND cpi.ES_ACTIVO = 1 AND pe.ES_ACTIVO = 1
					--AND epplan.ES_ACTIVO = 1
		)
		SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 

	End
	 
END
GO


