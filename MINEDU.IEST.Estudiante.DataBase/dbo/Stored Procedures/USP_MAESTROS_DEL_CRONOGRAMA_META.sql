
/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro del cronograma de meta de atención
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			Creación
2.0			21/01/2021		LESPINOZA		Cambio de delete a update
--  TEST:  
--			USP_MAESTROS_DEL_CRONOGRAMA_META 3, 42122536
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_DEL_CRONOGRAMA_META]
(
	@ID_CRONOGRAMA_META INT,
	@USUARIO	VARCHAR(20)
)
AS
BEGIN

--DELETE FROM maestro.cronograma_meta_atencion
--WHERE
--	ID_CRONOGRAMA_META_ATENCION = @ID_CRONOGRAMA_META

UPDATE maestro.cronograma_meta_atencion
	SET 
		[ESTADO] = 0 
		,[FECHA_MODIFICACION]	  = GETDATE()   
		,[USUARIO_MODIFICACION]	  = @USUARIO 
	WHERE 
		ID_CRONOGRAMA_META_ATENCION = @ID_CRONOGRAMA_META

SELECT @ID_CRONOGRAMA_META

END
GO


