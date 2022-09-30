/****************************************************************************************************************
  AUTOR:			FERNANDO RAMOS C.
  CREACION:		06/08/2018
  ACTUALIZACION:	12/10/2018	
  BASE DE DATOS:	DB_REGIA_2
  DESCRIPCION:	FUNCION QUE OBTIENE LA RUTA DE LA DESCARGA DE FORMATO PARA PLAN DE ESTUDIOS

  TEST:			SELECT dbo.UFN_RUTA_BASE_ARCHIVO_PLAN_ESTUDIOS(101,109,1,8)

 ****************************************************************************************************************/
CREATE FUNCTION [dbo].[UFN_RUTA_BASE_ARCHIVO_PLAN_ESTUDIOS] 
(
	@IdItinerario INT,
	@IdModalidad INT,
	@IdEnfoque INT,
	@SemestresAcademicos INT
)
RETURNS varchar(100)
AS
BEGIN		
		
		--//DECLARACION DE VARIABLES
		BEGIN

		DECLARE @RUTA											VARCHAR(MAX) = ''		
		DECLARE @CARPETA_DESCARGA_TEMPORAL						VARCHAR(5) = 'tmp'
		DECLARE @CODIGO_BORRAR_ARCHIVOS_TMP						INT	= 0					--//Codigo con en cual envia la ruta de los archivos tmp descargados 
		
		DECLARE @ITINERARIO_POR_ASIGNATURA						INT = 99				--//Extraido de la base de dato tbl: sistema.enumerado WHERE ID_TIPO_ENUMERADO = 33
		DECLARE @ITINERARIO_TRANSVERSAL							INT	= 100				--//Extraido de la base de dato tbl: sistema.enumerado WHERE ID_TIPO_ENUMERADO = 33
		DECLARE @ITINERARIO_MODULAR								INT	= 101				--//Extraido de la base de dato tbl: sistema.enumerado WHERE ID_TIPO_ENUMERADO = 33

		DECLARE @ITINERARIO_MODULAR_PRESENCIAL					INT = 109				--//Extraido de la base de dato tbl: sistema.enumerado WHERE ID_TIPO_ENUMERADO = 37
		DECLARE @ITINERARIO_MODULAR_SEMI_PRESENCIAL				INT = 110				--//Extraido de la base de dato tbl: sistema.enumerado WHERE ID_TIPO_ENUMERADO = 37
		DECLARE @ITINERARIO_MODULAR_DISTANCIA					INT = 124				--//Extraido de la base de dato tbl: sistema.enumerado WHERE ID_TIPO_ENUMERADO = 37
		
		DECLARE @ITINERARIO_MODULAR_PRESENCIAL_DUAL				INT	= 2					--//Extraido de la base de dato tbl: maestro.enfoque WHERE ID_MODALIDAD_ESTUDIO = 109
		DECLARE @ITINERARIO_MODULAR_PRESENCIAL_ALTERNANCIA		INT	= 3					--//Extraido de la base de dato tbl: maestro.enfoque WHERE ID_MODALIDAD_ESTUDIO = 109
		
		DECLARE @RUTA_BASE										VARCHAR(100)			--//Ruta base registrada en la fuente

		END


		--//RUTA BASE REGISTRADA EN EL CODIGO FUENTE
		BEGIN
			SET @RUTA_BASE = (SELECT dbo.UFN_RUTA_BASE_ARCHIVOS());			
		END


		--//RUTA TEMPORAL_COPIA_FORMATO
		BEGIN
			IF @CODIGO_BORRAR_ARCHIVOS_TMP = @IdItinerario
			BEGIN
				SET @RUTA = @RUTA_BASE + 'DATA_CARGA_EXCEL\' + @CARPETA_DESCARGA_TEMPORAL
				--  --para que genere error
			END
		END

		--//RUTA ITINERARIO_POR_ASIGNATURA
		BEGIN
			IF @ITINERARIO_POR_ASIGNATURA = @IdItinerario
			BEGIN				
				--SET @RUTA = @RUTA_BASE + 'DATA_CARGA_EXCEL\PlanEstudioPorAsignatura.xlsx'
				SET @RUTA = @RUTA_BASE + (
						CASE WHEN @SemestresAcademicos = 6 THEN 'DATA_CARGA_EXCEL\PlanEstudioPorAsignatura_pt.xlsx'
							 WHEN @SemestresAcademicos = 4 THEN 'DATA_CARGA_EXCEL\PlanEstudioPorAsignatura_t.xlsx'
							 WHEN @SemestresAcademicos = 2 THEN 'DATA_CARGA_EXCEL\PlanEstudioPorAsignatura_at.xlsx'
						END
				)				
			END
		END

		--//RUTA ITINERARIO_TRANSVERSAL
		BEGIN
			IF @ITINERARIO_TRANSVERSAL = @IdItinerario
			BEGIN
				--SET @RUTA = @RUTA_BASE + 'DATA_CARGA_EXCEL\PlanEstudioTranversal.xlsx'				
				SET @RUTA = @RUTA_BASE + (
						CASE WHEN @SemestresAcademicos = 6 THEN 'DATA_CARGA_EXCEL\PlanEstudioTranversal_pt.xlsx'
							 WHEN @SemestresAcademicos = 4 THEN 'DATA_CARGA_EXCEL\PlanEstudioTranversal_t.xlsx'
							 WHEN @SemestresAcademicos = 2 THEN 'DATA_CARGA_EXCEL\PlanEstudioTranversal_at.xlsx'
						END
				)	
			END
		END

		--//RUTA ITINERARIO_MODULAR_PRESENCIAL_DUAL Y 
		--//RUTA ITINERARIO_MODULAR_PRESENCIAL_ALTERNANCIA
		BEGIN
			IF	@ITINERARIO_MODULAR								= @IdItinerario AND 
				@ITINERARIO_MODULAR_PRESENCIAL					= @IdModalidad AND
				(
					@ITINERARIO_MODULAR_PRESENCIAL_DUAL			= @IdEnfoque OR 
					@ITINERARIO_MODULAR_PRESENCIAL_ALTERNANCIA	= @IdEnfoque
				)
				BEGIN
					--SET @RUTA = @RUTA_BASE + 'DATA_CARGA_EXCEL\PlanEstudioModularPDA.xlsx'
					SET @RUTA = @RUTA_BASE + (
						CASE WHEN @SemestresAcademicos = 8 THEN 'DATA_CARGA_EXCEL\PlanEstudioModularPDA_p.xlsx'
						     WHEN @SemestresAcademicos = 6 THEN 'DATA_CARGA_EXCEL\PlanEstudioModularPDA_pt.xlsx'
							 WHEN @SemestresAcademicos = 4 THEN 'DATA_CARGA_EXCEL\PlanEstudioModularPDA_t.xlsx'
							 WHEN @SemestresAcademicos = 2 THEN 'DATA_CARGA_EXCEL\PlanEstudioModularPDA_at.xlsx'
						END
					)				
				END
			ELSE

			--//RUTA ITINERARIO_MODULAR EL RESTO
			BEGIN			
				IF	@ITINERARIO_MODULAR							= @IdItinerario 			
				BEGIN
					--SET @RUTA = @RUTA_BASE + 'DATA_CARGA_EXCEL\PlanEstudioModular.xlsx'
					SET @RUTA = @RUTA_BASE + (
						CASE WHEN @SemestresAcademicos = 8 THEN 'DATA_CARGA_EXCEL\PlanEstudioModular_p.xlsx'
						     WHEN @SemestresAcademicos = 6 THEN 'DATA_CARGA_EXCEL\PlanEstudioModular_pt.xlsx'
							 WHEN @SemestresAcademicos = 4 THEN 'DATA_CARGA_EXCEL\PlanEstudioModular_t.xlsx'
							 WHEN @SemestresAcademicos = 2 THEN 'DATA_CARGA_EXCEL\PlanEstudioModular_at.xlsx'
						END
					)				
				END
			END
		END
			
		RETURN @RUTA						
END