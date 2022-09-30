/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro de un miembro de la comisión del proceso de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_INS_COMISION_PROCESO_ADMISION]
(
	@ID_PERSONAL_INSTITUCION		INT,
	@ID_PROCESO_ADMISION_PERIODO	INT,
	@ID_CARGO						INT,
	@USUARIO						VARCHAR(20)
)AS 
BEGIN
	IF EXISTS (SELECT TOP 1 ID_COMISION_PROCESO_ADMISION FROM transaccional.comision_proceso_admision
				WHERE ID_CARGO = @ID_CARGO AND ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO AND ES_ACTIVO =1)
		SELECT -180
	ELSE
	BEGIN
		INSERT INTO transaccional.comision_proceso_admision
		(ID_PERSONAL_INSTITUCION,ID_PROCESO_ADMISION_PERIODO,ID_CARGO,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
		VALUES(@ID_PERSONAL_INSTITUCION,@ID_PROCESO_ADMISION_PERIODO,@ID_CARGO,1,1,@USUARIO,GETDATE())

		SELECT 1
	END
END
GO


