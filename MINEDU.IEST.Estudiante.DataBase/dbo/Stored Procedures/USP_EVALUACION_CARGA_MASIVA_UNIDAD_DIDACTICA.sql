-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		07/11/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	INSERTA EN EL FORMATO DESCARGADO EXCEL DE CARGA MASIVA EVALUACION LA UNIDAD DIDACTICA

--  TEST:			EXEC USP_EVALUACION_CARGA_MASIVA_UNIDAD_DIDACTICA 7,101,112

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_EVALUACION_CARGA_MASIVA_UNIDAD_DIDACTICA]
(
	@ID_CARRERA						INT,
	@ID_TIPO_ITINERARIO				INT,
	@ID_SEMESTRE_ACADEMICO			INT	
)
AS

BEGIN

	BEGIN	PRINT '--//PRUEBAS BORRAR AL FINAL'

			--SET @ID_CARRERA						= 7;
			--SET @ID_TIPO_ITINERARIO				= 101;
			--SET @ID_SEMESTRE_ACADEMICO			= 112;			

	END

	BEGIN	--> DECLARACION DE VARIABLES	
		PRINT 'DECLARE @LISTADO_UNIDADES_DIDACTICAS VARCHAR(MAX)'
	END

	BEGIN	--> OBTENER UNIDAD DIDACTICA
			
					SELECT 
						 IdUnidadDidactica		= TUD.ID_UNIDAD_DIDACTICA
						,NombreUnidadDidactica	= UPPER(TUD.NOMBRE_UNIDAD_DIDACTICA) 	
					FROM 
						transaccional.unidad_didactica TUD
					INNER JOIN transaccional.modulo TM						ON TM.ID_MODULO= TUD.ID_MODULO
					INNER JOIN transaccional.plan_estudio TPE				ON TPE.ID_PLAN_ESTUDIO = TM.ID_PLAN_ESTUDIO
					INNER JOIN transaccional.carreras_por_institucion TCI	ON TCI.ID_CARRERAS_POR_INSTITUCION= TPE.ID_CARRERAS_POR_INSTITUCION
					WHERE 1 = 1
						AND TCI.ID_CARRERA				= @ID_CARRERA	 
						AND TCI.ID_TIPO_ITINERARIO		= @ID_TIPO_ITINERARIO
						AND TUD.ID_SEMESTRE_ACADEMICO	= @ID_SEMESTRE_ACADEMICO

						AND TUD.ES_ACTIVO=1 
						AND  TM.ES_ACTIVO=1
						AND TPE.ES_ACTIVO=1
						AND TCI.ES_ACTIVO=1
					ORDER BY TUD.ID_UNIDAD_DIDACTICA ASC
			
	END

	BEGIN --> RESPUESTA A CONSULTA
			PRINT 'SELECT UnidadesDidacticasPorSeccion = @LISTADO_UNIDADES_DIDACTICAS'
	END

END
GO


