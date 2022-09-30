﻿
--USP_SISTEMA_SEL_UBIGEO_NIVEL 3,'14','1401'


CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_UBIGEO_NIVEL]
(
	@NIVEL INT = 1,
	@DEPARTAMENTO VARCHAR(6)='',
	@PROVINCIA VARCHAR(6)=''

	--DECLARE @NIVEL INT = 2
	--DECLARE @DEPARTAMENTO VARCHAR(6)='15'
	--DECLARE @PROVINCIA VARCHAR(6)=''

)AS
BEGIN
	IF @NIVEL = 1
		SELECT DISTINCT
			CONVERT(INT, SUBSTRING(CODIGO_UBIGEO,1,2)) Value, 
			SUBSTRING(CODIGO_UBIGEO,1,2)+'0000' Code, 
			DEPARTAMENTO_UBIGEO Text  
		FROM db_auxiliar.dbo.UVW_UBIGEO_RENIEC
		WHERE CODIGO_UBIGEO IS NOT NULL
		ORDER BY 3 ASC
	IF @NIVEL = 2
		SELECT DISTINCT
			CONVERT(INT, SUBSTRING(CODIGO_UBIGEO,1,4)) Value, 
			SUBSTRING(CODIGO_UBIGEO,1,4)+'00' Code, 
			PROVINCIA_UBIGEO Text  
		FROM db_auxiliar.dbo.UVW_UBIGEO_RENIEC
		WHERE 
			CONVERT(INT, SUBSTRING(CODIGO_UBIGEO,1,2)) = CONVERT(INT, SUBSTRING(@DEPARTAMENTO,1,2))
			AND CODIGO_UBIGEO IS NOT NULL
		ORDER BY 3 ASC
	IF @NIVEL = 3
		SELECT DISTINCT
			CONVERT(INT, SUBSTRING(CODIGO_UBIGEO,1,6)) Value, 
			CODIGO_UBIGEO Code, 
			DISTRITO_UBIGEO Text  
		FROM db_auxiliar.dbo.UVW_UBIGEO_RENIEC
		WHERE 
			CONVERT(INT, SUBSTRING(CODIGO_UBIGEO,1,4)) = CONVERT(INT, SUBSTRING(@PROVINCIA,1,4))		
			AND CODIGO_UBIGEO IS NOT NULL	
		ORDER BY 3 ASC
	IF @NIVEL = 99
		SELECT
			CONVERT(INT, SUBSTRING(CODIGO_UBIGEO,1,6)) Value, 
			CODIGO_UBIGEO Code, 
			DISTRITO_UBIGEO Text  
		FROM db_auxiliar.dbo.UVW_UBIGEO_RENIEC
		WHERE CODIGO_UBIGEO IS NOT NULL	
		ORDER BY 3 ASC
END
GO

