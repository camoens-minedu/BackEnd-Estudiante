
-------------------------------------------------------------------------------------------------------------
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	12/04/2020
--LLAMADO POR			:
--DESCRIPCION			:	registrar habilitacion de postulante
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ADMISION_INS_HABILITACION_POSTULANTE]
(
	@ID_POSTULANTE_ADMISION          		INT,
	@ESTADO				                    INT,
	@USUARIO								VARCHAR(20)
)AS 
BEGIN
	IF EXISTS (SELECT TOP 1 ID_HABILITACION_ADMISION_POSTULANTE FROM transaccional.habilitacion_admision_postulante
				WHERE ID_POSTULANTES_POR_MODALIDAD = @ID_POSTULANTE_ADMISION AND ES_ACTIVO =1 AND ESTADO = @ESTADO)
		SELECT -180
	ELSE
	BEGIN
		INSERT INTO transaccional.habilitacion_admision_postulante
		(ID_POSTULANTES_POR_MODALIDAD,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
		VALUES(@ID_POSTULANTE_ADMISION,1,1,@USUARIO,GETDATE())

		SELECT 1
	END
END
GO


