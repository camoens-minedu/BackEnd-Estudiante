-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		08/05/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	FUNCION QUE OBTIENE LA RUTA DE LA DESCARGA DE FORMATO PARA CARGA MASIVA ESTUDIANTE

--  TEST:			SELECT dbo.UFN_RUTA_ARCHIVO_CARGA_MASIVA_ESTUDIANTE(0)

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[UFN_RUTA_ARCHIVO_CARGA_MASIVA_ESTUDIANTE] 
(
	@valorOpcion INT	
)
RETURNS varchar(100)
AS
BEGIN		
		
	--//DECLARACION DE VARIABLES
		BEGIN

		DECLARE @RUTA											VARCHAR(MAX) = ''	
		DECLARE @RUTA_BASE										VARCHAR(100)								--//Ruta base registrada en la fuente
		
		
		DECLARE @CODIGO_RUTA_CARPETA_TMP						INT	= 0										--//Codigo con en cual envia la ruta de los archivos tmp descargados
		DECLARE @NOMBRE_CARPETA_DESCARGA_TEMPORAL				VARCHAR(100) = 'TMP'		 		

		DECLARE @CODIGO_RUTA_ARCHIVO_FORMATO					INT	= 1										--//Codigo con en cual envia la ruta del archivo con el formato
		DECLARE @NOMBRE_CARPETA_DESCARGA_PLANTILLAS				VARCHAR(100) = 'PLANTILLAS'

		DECLARE @CODIGO_RUTA_CARPETA_PARA_ARCHIVOS_A_PROCESAR	INT	= 2										--//Codigo con en cual envia la ruta donde se guardara el archivo a procesar
		DECLARE @NOMBRE_CARPETA_COPIA_ARCHIVO_PARA_PROCESAR		VARCHAR(100) = 'DATA_CARGA_ESTUDIANTE'

		END

		--//RUTA BASE REGISTRADA EN EL CODIGO FUENTE
		BEGIN
			SET @RUTA_BASE = (SELECT dbo.UFN_RUTA_BASE_ARCHIVOS());			
		END

		--//RUTA TEMPORAL_COPIA_FORMATO = 0
		BEGIN
			IF @CODIGO_RUTA_CARPETA_TMP = @valorOpcion
			BEGIN			
				SET @RUTA = @RUTA_BASE + @NOMBRE_CARPETA_DESCARGA_TEMPORAL				
			END
		END

		--//RUTA ARCHIVO PLANTILLA = 1
		BEGIN
			IF @CODIGO_RUTA_ARCHIVO_FORMATO = @valorOpcion
			BEGIN
				SET @RUTA = @RUTA_BASE + @NOMBRE_CARPETA_DESCARGA_PLANTILLAS + '\CargaMasivaEstudiante.xlsx'
			END
		END

		--//RUTA TEMPORAL_COPIA_FORMATO = 2
		BEGIN
			IF @CODIGO_RUTA_CARPETA_PARA_ARCHIVOS_A_PROCESAR = @valorOpcion
			BEGIN			
				SET @RUTA = @RUTA_BASE + @NOMBRE_CARPETA_COPIA_ARCHIVO_PARA_PROCESAR				
			END
		END

			
		RETURN @RUTA											
END