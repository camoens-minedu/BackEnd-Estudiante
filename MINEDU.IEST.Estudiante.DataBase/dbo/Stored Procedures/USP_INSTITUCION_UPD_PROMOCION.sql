/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de promoción de la institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

--  TEST:			

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_UPD_PROMOCION]
(	
	@ID_PROMOCION_INSTITUCION_ESTUDIANTE INT,
	@ID_TIPOPROMOCION INT,
	@ID_VERSION INT,
	@ID_TIPOUD INT,
	@ID_CRITERIO VARCHAR(15),
	@VALOR INT,
	@USUARIO VARCHAR(20)
)
AS

DECLARE @RESULT INT	
DECLARE @ID_INSTITUCION1 INT

SET @ID_INSTITUCION1 = (SELECT TOP 1 ID_INSTITUCION FROM transaccional.promocion_institucion_estudiante WHERE ID_PROMOCION_INSTITUCION_ESTUDIANTE = @ID_PROMOCION_INSTITUCION_ESTUDIANTE)
	
IF EXISTS(SELECT TOP 1 ID_PROMOCION_INSTITUCION_ESTUDIANTE FROM [transaccional].promocion_institucion_estudiante
WHERE ID_INSTITUCION = @ID_INSTITUCION1 AND ES_ACTIVO=1 AND TIPO_VERSION=@ID_VERSION AND ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPOUD 
AND ID_PROMOCION_INSTITUCION_ESTUDIANTE <> @ID_PROMOCION_INSTITUCION_ESTUDIANTE AND ESTADO = 1)
BEGIN
	SET @RESULT = -180 -- YA SE ENCUENTRA REGISTRADO
END
ELSE
	BEGIN    	--print 'dentro de la transaccion'
	
	UPDATE [transaccional].promocion_institucion_estudiante
		SET TIPO_PROMOCION = @ID_TIPOPROMOCION, 
		TIPO_VERSION = @ID_VERSION, 
		ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPOUD, 
		CRITERIO = @ID_CRITERIO, 
		VALOR = @VALOR, 
		USUARIO_MODIFICACION=@USUARIO, 
		FECHA_MODIFICACION=GETDATE()
		WHERE ID_PROMOCION_INSTITUCION_ESTUDIANTE = @ID_PROMOCION_INSTITUCION_ESTUDIANTE

		
	SET @RESULT = 1
END	
SELECT @RESULT
GO


