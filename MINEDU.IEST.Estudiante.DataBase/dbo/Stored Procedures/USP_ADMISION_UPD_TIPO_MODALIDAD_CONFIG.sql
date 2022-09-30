--/*********************************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Actualiza el tipo de modalidad Exonerado
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--	1.0			21/11/2019		MALVA          MODIFICACIÓN PARA VALIDAR SI YA SE REALIZÓ LA EVALUACIÓN EN EL PROCESO DE ADMISIÓN DE LA MODALIDAD EXONERADO. 
--*/
--  TEST:		
--**********************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_TIPO_MODALIDAD_CONFIG]
(
	@ID_TIPO_MODALIDAD_PROCESO_ADMISION	INT,
	@META								INT,
	@ID_TIPO_META						INT,
	@USUARIO							VARCHAR(20)
)AS
IF EXISTS (SELECT TOP 1 mxpa.ESTADO FROM transaccional.tipos_modalidad_por_proceso_admision tmxpa
inner join transaccional.modalidades_por_proceso_admision mxpa on tmxpa.ID_PROCESO_ADMISION_PERIODO = mxpa.ID_PROCESO_ADMISION_PERIODO and 
tmxpa.ES_ACTIVO = 1 and mxpa.ES_ACTIVO =1
where tmxpa.ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION = @ID_TIPO_MODALIDAD_PROCESO_ADMISION and ID_MODALIDAD=23
and mxpa.ESTADO=97) --Se verifica si el estado de la modalidad Exonerado es evaluado. 
SELECT -339
ELSE
BEGIN
	UPDATE transaccional.tipos_modalidad_por_proceso_admision
	SET	META = @META,
		ID_TIPO_META = @ID_TIPO_META,
		USUARIO_MODIFICACION = @USUARIO,
		FECHA_MODIFICACION = GETDATE()
	WHERE
		ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION = @ID_TIPO_MODALIDAD_PROCESO_ADMISION	

	SELECT @ID_TIPO_MODALIDAD_PROCESO_ADMISION
END
GO


