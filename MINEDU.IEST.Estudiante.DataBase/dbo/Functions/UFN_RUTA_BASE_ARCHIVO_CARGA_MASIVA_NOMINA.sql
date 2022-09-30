
-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			JUAN TOVAR YAÑEZ.
--  CREACION:		01/03/2021
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	FUNCION QUE OBTIENE LA RUTA DE LA DESCARGA DE FORMATO CARGA MASIVA NOMINA

--  TEST:			SELECT dbo.UFN_RUTA_BASE_ARCHIVO_CARGA_MASIVA_NOMINA()

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[UFN_RUTA_BASE_ARCHIVO_CARGA_MASIVA_NOMINA] 
(
	--@IdItinerario INT
	--,@IdModalidad INT
	--,@IdEnfoque INT
	--,@SemestresAcademicos INT
)
RETURNS varchar(MAX)
AS
BEGIN		
		
		--//DECLARACION DE VARIABLES
		BEGIN

		DECLARE @RUTA_BASE										VARCHAR(MAX)
		DECLARE @RUTA_CARPETA									VARCHAR(MAX) = ''
		DECLARE @RUTA_ARCHIVO									VARCHAR(MAX) = ''
		DECLARE @RUTA											VARCHAR(MAX) = ''
		DECLARE @CARPETA_DESCARGA_TEMPORAL						VARCHAR(5) = 'tmp'		
					

		END
				
		--//RUTA BASE REGISTRADA EN EL CODIGO FUENTE
		BEGIN
			SET @RUTA_BASE = (SELECT dbo.UFN_RUTA_BASE_ARCHIVOS());			
		END
		
		--//RUTA TEMPORAL_COPIA_FORMATO
		BEGIN			
				SET @RUTA_CARPETA = @RUTA_BASE + 'DATA_CARGA_MASIVA_NOMINA\' + @CARPETA_DESCARGA_TEMPORAL
		END

		--//RUTA ARCHIVO
		BEGIN			
				SET @RUTA_ARCHIVO = @RUTA_BASE + 'DATA_CARGA_MASIVA_NOMINA\PlantillaCargaNomina.xlsx'				
		END

		--//DOS RUTAS SEPARADA POR PALOTE
		BEGIN			
				SET @RUTA = @RUTA_CARPETA +'|'+ @RUTA_ARCHIVO
				
		END
			
		RETURN @RUTA						
END