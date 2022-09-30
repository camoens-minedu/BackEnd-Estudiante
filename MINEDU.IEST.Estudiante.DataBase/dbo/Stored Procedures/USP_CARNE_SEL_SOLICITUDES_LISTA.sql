﻿CREATE PROCEDURE [dbo].[USP_CARNE_SEL_SOLICITUDES_LISTA]
(
	@ID_PERIODO_LECTIVO_INSTITUCION	INT

	--DECLARE @ID_INSTITUCION					INT=1911
	--DECLARE @ID_PERIODO_LECTIVO_INSTITUCION	INT=5493
)AS 
BEGIN
	SELECT 
	ID_SOLICITUD_CARNET  Value,
	NRO_SOLICITUD        Text,
	ID_SOLICITUD_CARNET  code
	FROM 
	transaccional.solicitud_carnet
	WHERE 
	ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
	AND ES_ACTIVO = 1
	
END