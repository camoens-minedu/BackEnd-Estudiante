/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza un registro de maestro.cronograma_meta_atencion
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_UPD_CRONOGRAMA_META]
(
	@ID_CRONOGRAMA_META INT,
	@FECHA_INICIO DATETIME,
	@FECHA_FIN	DATETIME,
	@USUARIO	VARCHAR(20)
)
AS
BEGIN
UPDATE maestro.cronograma_meta_atencion
SET FECHA_INICIO = @FECHA_INICIO,
	FECHA_FIN = @FECHA_FIN,
	USUARIO_MODIFICACION = @USUARIO,
	FECHA_MODIFICACION = GETDATE()
WHERE
	ID_CRONOGRAMA_META_ATENCION = @ID_CRONOGRAMA_META
SELECT @ID_CRONOGRAMA_META
END
GO


