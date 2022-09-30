-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			JUAN TOVAR YAÑEZ.
--  CREACION:		02/03/2021
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	INSERTA EN EL FORMATO DESCARGADO EXCEL DE CARGA MASIVA NOMINA LA UNIDAD DIDACTICA

--  TEST:			EXEC USP_MATRICULA_CARGA_MASIVA_NOMINA_UNIDAD_DIDACTICA 4673,1911,139,101,111

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_MATRICULA_CARGA_MASIVA_NOMINA_UNIDAD_DIDACTICA]
(
	@ID_PLAN_ESTUDIO				INT,
	@ID_INSTITUCION					INT,
	@ID_CARRERA						INT,
	@ID_TIPO_ITINERARIO				INT,
	@ID_SEMESTRE_ACADEMICO			INT	
)
AS

BEGIN

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
						AND TM.ID_PLAN_ESTUDIO			= @ID_PLAN_ESTUDIO
						AND TCI.ID_INSTITUCION			= @ID_INSTITUCION
						AND TCI.ID_CARRERA				= @ID_CARRERA	 
						AND TCI.ID_TIPO_ITINERARIO		= @ID_TIPO_ITINERARIO
						AND TUD.ID_SEMESTRE_ACADEMICO	= @ID_SEMESTRE_ACADEMICO

						AND TUD.ES_ACTIVO=1 
						AND  TM.ES_ACTIVO=1
						AND TPE.ES_ACTIVO=1
						AND TCI.ES_ACTIVO=1
					ORDER BY TUD.ID_UNIDAD_DIDACTICA ASC			
	END

END