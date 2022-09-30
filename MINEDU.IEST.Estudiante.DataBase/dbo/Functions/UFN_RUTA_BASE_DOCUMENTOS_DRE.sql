-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			Consultores DRE
--  CREACION:		28/11/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	

--  TEST:			SELECT dbo.UFN_RUTA_BASE_DOCUMENTOS_DRE(0,1)

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].UFN_RUTA_BASE_DOCUMENTOS_DRE 
(
	@IdDocumentosDre INT,
	@IdClaseHistorica INT	
)
RETURNS varchar(100)
AS
BEGIN		
	DECLARE @RUTA		VARCHAR(MAX) = ''

	SET @RUTA = (SELECT TOP 1 CONCAT(clas_hist.ID_INSTITUCION, '_', TRIM(enum_hist_per.VALOR_ENUMERADO_HISTORICO), '_', TRIM(enum_hist_cicl.VALOR_ENUMERADO_HISTORICO), '_', @IdDocumentosDre) FROM maestro.clase_historica as clas_hist
	INNER JOIN sistema.enumerado_historico as enum_hist_per on clas_hist.ID_PERIODO_LECTIVO = enum_hist_per.ID_ENUMERADO_HISTORICO
	INNER JOIN sistema.enumerado_historico as enum_hist_cicl on clas_hist.CICLO = enum_hist_cicl.ID_ENUMERADO_HISTORICO
	WHERE clas_hist.ID_CLASE_HISTORICA = @IdClaseHistorica)


	RETURN (SELECT dbo.UFN_RUTA_BASE_ARCHIVOS())+'DATA_DOCUMENTOS_DRE\' + @RUTA
END