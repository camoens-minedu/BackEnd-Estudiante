/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de requisito para una modalidad del proceso admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 11/02/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_ADMISION_DEL_TIPO_MODALIDAD_REQUISITO 1106, 1143, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_TIPO_MODALIDAD_REQUISITO]
(
	@ID_INSTITUCION					INT, 
	@ID_REQUISITO_TIPO_MODALIDAD	INT,
	@USUARIO						VARCHAR(20)
)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0	

	SELECT @ID_INSTITUCION_CONSULTA = tmxi.ID_INSTITUCION FROM maestro.requisitos_por_tipo_modalidad rxtm
	INNER JOIN maestro.tipos_modalidad_por_institucion tmxi ON tmxi.ID_TIPOS_MODALIDAD_POR_INSTITUCION = rxtm.ID_TIPOS_MODALIDAD_POR_INSTITUCION AND rxtm.ES_ACTIVO=1 AND tmxi.ES_ACTIVO=1
	WHERE rxtm.ID_REQUISITOS_POR_TIPO_MODALIDAD= @ID_REQUISITO_TIPO_MODALIDAD

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE IF EXISTS (select top 1 ID_REQUISITOS_POR_POSTULANTE from transaccional.requisitos_por_postulante 
			where ID_REQUISITOS_POR_TIPO_MODALIDAD=@ID_REQUISITO_TIPO_MODALIDAD and ES_ACTIVO=1)
		SET @RESULT =  -162
	ELSE
	BEGIN
		UPDATE maestro.requisitos_por_tipo_modalidad
		SET ES_ACTIVO = 0,
		USUARIO_MODIFICACION = @USUARIO,
		FECHA_MODIFICACION = GETDATE()
		WHERE ID_REQUISITOS_POR_TIPO_MODALIDAD = @ID_REQUISITO_TIPO_MODALIDAD

		SET @RESULT = @ID_REQUISITO_TIPO_MODALIDAD
	END

	SELECT @RESULT
END
GO


