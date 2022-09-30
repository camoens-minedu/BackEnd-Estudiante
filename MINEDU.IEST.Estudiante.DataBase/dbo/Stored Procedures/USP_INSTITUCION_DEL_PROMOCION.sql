/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de promoción estudiante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_INSTITUCION_DEL_PROMOCION 1106, 40, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_DEL_PROMOCION]
(
	@ID_INSTITUCION							INT, 
    @ID_PROMOCION_INSTITUCION_ESTUDIANTE	INT	,        
    @USUARIO								nvarchar(20)
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

SELECT @ID_INSTITUCION_CONSULTA = ID_INSTITUCION FROM transaccional.promocion_institucion_estudiante WHERE ID_PROMOCION_INSTITUCION_ESTUDIANTE = @ID_PROMOCION_INSTITUCION_ESTUDIANTE
	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE 
	BEGIN
		UPDATE [transaccional].promocion_institucion_estudiante
		   SET 
			   [ES_ACTIVO]	= 0 
			  ,[FECHA_MODIFICACION]	  = GETDATE()   
			  ,[USUARIO_MODIFICACION]	  = @USUARIO
		 WHERE 
			   [ID_PROMOCION_INSTITUCION_ESTUDIANTE]			  = @ID_PROMOCION_INSTITUCION_ESTUDIANTE		      

		SET @RESULT = @@ROWCOUNT

	END
	SELECT @RESULT
END
GO


