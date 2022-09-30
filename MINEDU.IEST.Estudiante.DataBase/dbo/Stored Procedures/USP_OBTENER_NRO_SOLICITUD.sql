/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	16/05/2022
LLAMADO POR			:
DESCRIPCION			:	Obtiene el numero de registro de solicitud por parte de la institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_OBTENER_NRO_SOLICITUD]  
(
   @ID_PERIODO_LECTIVO_INSTITUCION INT
	
)AS
BEGIN
	
	DECLARE @ANIO VARCHAR(MAX); 
	DECLARE @VALOR VARCHAR(MAX);
	DECLARE @ID_SOLICITUD_CARNET INT;

	SET @ANIO = (SELECT YEAR(GETDATE()) AS [Año Actual])
	
	SET @VALOR = (SELECT [dbo].[UFN_GenerarCodSolicitud] (@ANIO))

	INSERT INTO transaccional.solicitud_carnet
	(ID_PERIODOS_LECTIVOS_POR_INSTITUCION,NRO_SOLICITUD, ESTADO_ACTUAL, OBSERVACIONES, ES_ACTIVO, ESTADO,USUARIO_CREACION, FECHA_CREACION)
	VALUES (@ID_PERIODO_LECTIVO_INSTITUCION, @VALOR, '', '', 1,1, 'JTOVAR', GETDATE())
	
	SET @ID_SOLICITUD_CARNET = CONVERT(INT,@@IDENTITY)
	--SELECT @ANIO
	SELECT @VALOR as Valor, @ID_SOLICITUD_CARNET as IdSolicitudCarnet
END