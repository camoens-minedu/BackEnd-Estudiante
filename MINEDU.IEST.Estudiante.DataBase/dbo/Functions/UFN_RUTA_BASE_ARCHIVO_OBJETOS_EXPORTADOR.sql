-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		07/06/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	FUNCION QUE OBTIENE LA RUTA DE LA DESCARGA DE FORMATO PARA EXPORTADOR DATOS

--  TEST:			
/*
SELECT dbo.UFN_RUTA_BASE_ARCHIVO_OBJETOS_EXPORTADOR(0)
*/
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[UFN_RUTA_BASE_ARCHIVO_OBJETOS_EXPORTADOR] 
(
	@OpcionObtenerRuta INT	
)
RETURNS varchar(100)
AS
BEGIN		
		--//DECLARACION DE VARIABLES
		BEGIN
			DECLARE @RUTA											VARCHAR(MAX) = ''		
			DECLARE @CARPETA_DESCARGA_TEMPORAL						VARCHAR(5) = 'tmp'
			DECLARE @CODIGO_BORRAR_ARCHIVOS_TMP						INT	= 0					--//Codigo con en cual envia la ruta de los archivos tmp descargados 
			DECLARE @CODIGO_ARCHIVO_DESCARGAR						INT = 1		
			DECLARE @RUTA_BASE										VARCHAR(100)			--//Ruta base registrada en la fuente
		END

		--//RUTA BASE REGISTRADA EN EL CODIGO FUENTE
		BEGIN
			SET @RUTA_BASE = (SELECT dbo.UFN_RUTA_BASE_ARCHIVOS());	
			--SET @RUTA_BASE = @RUTA_BASE + 'PLANTILLAS\'		
			SET @RUTA_BASE = @RUTA_BASE + 'PLANTILLAS\'
			
		END

		--//RUTA TEMPORAL_COPIA_FORMATO
		BEGIN
			IF @CODIGO_BORRAR_ARCHIVOS_TMP = @OpcionObtenerRuta
			BEGIN
				SET @RUTA = @RUTA_BASE + @CARPETA_DESCARGA_TEMPORAL				
			END
		END

		--//RUTA PLANTILLA EXPORTADOR DATOS
		BEGIN
			IF @CODIGO_ARCHIVO_DESCARGAR = @OpcionObtenerRuta
			BEGIN				
				SET @RUTA = @RUTA_BASE + 'ExportadorDatos.xlsx'												 
			END
		END
			
		RETURN @RUTA						
END