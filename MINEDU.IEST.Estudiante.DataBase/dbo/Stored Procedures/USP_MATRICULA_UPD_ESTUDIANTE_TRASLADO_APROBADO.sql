/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de un estudiante por traslado aprobado
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_ESTUDIANTE_TRASLADO_APROBADO]
(
	@ID_TIPO_TRASLADO			INT,
	@ID_TRASLADO_ESTUDIANTE		INT,
	@USUARIO					VARCHAR(20)
)
AS
BEGIN

	IF @ID_TIPO_TRASLADO = 141

		UPDATE [transaccional].traslado_estudiante
		SET ESTADO = 144/*146*/,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE ID_TRASLADO_ESTUDIANTE = @ID_TRASLADO_ESTUDIANTE

	ELSE

		UPDATE [transaccional].traslado_estudiante
		SET ESTADO = 144,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE ID_TRASLADO_ESTUDIANTE = @ID_TRASLADO_ESTUDIANTE

	SELECT @@rowcount
END
GO


