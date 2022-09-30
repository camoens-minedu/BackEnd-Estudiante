/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro del tipo de modalidad en un IE
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_ADMISION_DEL_TIPO_MODALIDAD_IE 1106, 1128, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_TIPO_MODALIDAD_IE]
(
	@ID_INSTITUCION			INT, 
	@ID_TIPO_MODALIDAD_IE	INT,
	@USUARIO				VARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0	

	SELECT @ID_INSTITUCION_CONSULTA = tmxi.ID_INSTITUCION FROM maestro.tipos_modalidad_por_institucion tmxi 
	WHERE tmxi.ID_TIPOS_MODALIDAD_POR_INSTITUCION = @ID_TIPO_MODALIDAD_IE

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE IF	EXISTS	(	SELECT TOP 1 ID_POSTULANTES_POR_MODALIDAD FROM transaccional.postulantes_por_modalidad 
						WHERE ID_TIPOS_MODALIDAD_POR_INSTITUCION= @ID_TIPO_MODALIDAD_IE AND ES_ACTIVO=1)
						OR EXISTS 
					(	SELECT TOP 1 ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION FROM transaccional.tipos_modalidad_por_proceso_admision 
						WHERE ID_TIPOS_MODALIDAD_POR_INSTITUCION = @ID_TIPO_MODALIDAD_IE AND ES_ACTIVO=1)
		SET @RESULT = -162
	ELSE		
	BEGIN
		UPDATE maestro.tipos_modalidad_por_institucion
		SET ES_ACTIVO = 0,
		USUARIO_MODIFICACION = @USUARIO,
		FECHA_MODIFICACION = GETDATE()
		WHERE ID_TIPOS_MODALIDAD_POR_INSTITUCION = @ID_TIPO_MODALIDAD_IE
		
		SET @RESULT= 1
	END	
	SELECT @RESULT
END
GO


