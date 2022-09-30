/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de periodos lectivos habilitados para la institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
----  TEST:		EXEC USP_MAESTROS_SEL_PERIODO_LECTIVO_INSTITUCION_LISTA 620
--/*
--	1.0			19/12/2019		MALVA          MODIFICACIÓN PARA QUE LISTE LOS PERIODOS LECTIVOS CON ESTADO = 1
--*/
**********************************************************************************************************/

CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PERIODO_LECTIVO_INSTITUCION_LISTA]
(
	@ID_INSTITUCION						INT
)
AS
SET NOCOUNT ON;
DECLARE @numerologia CHAR(1)
SELECT @numerologia = CONVERT (CHAR, VALOR_PARAMETRO) FROM sistema.parametro WHERE NOMBRE_PARAMETRO = 'Numerologia'
SELECT	DISTINCT PL.ID_PERIODO_LECTIVO Value,
		--PL.CODIGO_PERIODO_LECTIVO Text,
		CASE @numerologia
		WHEN '1' THEN CAST(PL.CODIGO_PERIODO_LECTIVO AS VARCHAR)
		WHEN 'I' THEN CAST(PL.ANIO AS VARCHAR) + '-' + dbo.UFN_CST_numero_romano(CAST(SUBSTRING(PL.CODIGO_PERIODO_LECTIVO,6,1) AS INT)) 
		WHEN 'A' THEN CAST(PL.ANIO AS VARCHAR) + '-' + dbo.UFN_CST_numero_texto(CAST(SUBSTRING(PL.CODIGO_PERIODO_LECTIVO,6,1) AS INT)) 
		ELSE CAST(PL.CODIGO_PERIODO_LECTIVO AS VARCHAR) 
		END AS Text	
FROM	transaccional.periodos_lectivos_por_institucion PLI
		INNER JOIN maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO = PLI.ID_PERIODO_LECTIVO
		--INNER JOIN sistema.enumerado E ON E.ID_ENUMERADO = PLI.ESTADO
WHERE 			
		PLI.ID_INSTITUCION = @ID_INSTITUCION
		AND PLI.ES_ACTIVO = 1
		AND PLI.ESTADO IN (6,7)
		AND PL.ESTADO=1
GO


