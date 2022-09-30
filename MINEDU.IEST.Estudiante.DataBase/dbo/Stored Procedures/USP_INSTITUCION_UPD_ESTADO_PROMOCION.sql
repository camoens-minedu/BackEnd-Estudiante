/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	26/08/2021
LLAMADO POR			:
DESCRIPCION			:	Actualiza el estado del promocion de una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_UPD_ESTADO_PROMOCION]
(
	@ID_PROMOCION_INSTITUCION_ESTUDIANTE        INT,
	@USUARIO					                VARCHAR(20)

	--DECLARE @ID_PERSONAL_INSTITUCION	        INT=1295
	--DECLARE @USUARIO					        VARCHAR(20)='42122536'
)
AS
BEGIN
DECLARE @RESULT INT
				
IF EXISTS(SELECT TOP 1 ID_PROMOCION_INSTITUCION_ESTUDIANTE FROM [transaccional].promocion_institucion_estudiante
WHERE ID_PROMOCION_INSTITUCION_ESTUDIANTE = @ID_PROMOCION_INSTITUCION_ESTUDIANTE AND ESTADO=2)
BEGIN
	SET @RESULT = -392 -- YA SE ENCUENTRA INACTIVO
END
ELSE
	BEGIN    	--print 'dentro de la transaccion'
	
	
				UPDATE transaccional.promocion_institucion_estudiante
				SET ESTADO = CASE WHEN ESTADO = 1 THEN 2 ELSE 1 END,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
				WHERE ID_PROMOCION_INSTITUCION_ESTUDIANTE = @ID_PROMOCION_INSTITUCION_ESTUDIANTE

		
	SET @RESULT = 1
END	
				
	END	
SELECT @RESULT