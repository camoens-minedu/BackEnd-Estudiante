/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro del evaluador del proceso de admisi>n por tipo de modalidad
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_INS_EVALUADORES]
(
	@ID_PERSONAL_INSTITUCION				INT,
	@ID_MODALIDADES_POR_PROCESO_ADMISION	INT,
	@USUARIO								VARCHAR(20)
)AS 
BEGIN
	IF EXISTS (SELECT TOP 1 ID_EVALUADOR_ADMISION_MODALIDAD FROM transaccional.evaluador_admision_modalidad
				WHERE ID_PERSONAL_INSTITUCION = @ID_PERSONAL_INSTITUCION AND ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION AND ES_ACTIVO =1)
		SELECT -180
	ELSE
	BEGIN
		INSERT INTO transaccional.evaluador_admision_modalidad
		(ID_MODALIDADES_POR_PROCESO_ADMISION,ID_PERSONAL_INSTITUCION,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
		VALUES(@ID_MODALIDADES_POR_PROCESO_ADMISION,@ID_PERSONAL_INSTITUCION,1,1,@USUARIO,GETDATE())

		SELECT 1
	END
END
GO


