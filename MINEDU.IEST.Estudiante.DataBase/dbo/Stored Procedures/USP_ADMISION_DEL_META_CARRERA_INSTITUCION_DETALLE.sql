/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro del detalle de la meta del proceso de admisi>n
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_ADMISION_DEL_META_CARRERA_INSTITUCION_DETALLE 1106, 138, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_META_CARRERA_INSTITUCION_DETALLE]
(
	@ID_INSTITUCION							INT, 
	@ID_META_CARRERA_INSTITUCION_DETALLE	INT,	
	@USUARIO								VARCHAR(20)
)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0	
	
	SELECT 
		@ID_INSTITUCION_CONSULTA = si.ID_INSTITUCION 
	FROM
		transaccional.meta_carrera_institucion_detalle mcid 
	INNER JOIN maestro.sede_institucion si ON si.ID_SEDE_INSTITUCION = mcid.ID_SEDE_INSTITUCION AND mcid.ES_ACTIVO=1 AND si.ES_ACTIVO=1
	WHERE 
		mcid.ID_META_CARRERA_INSTITUCION_DETALLE =@ID_META_CARRERA_INSTITUCION_DETALLE	

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE IF EXISTS(SELECT TOP 1 ID_OPCIONES_POR_POSTULANTE FROM transaccional.opciones_por_postulante WHERE ID_META_CARRERA_INSTITUCION_DETALLE=@ID_META_CARRERA_INSTITUCION_DETALLE 
			AND ES_ACTIVO=1)
		SET @RESULT = -162  --ya ha sido utilizado en algún proceso
	ELSE
		BEGIN
			UPDATE transaccional.meta_carrera_institucion_detalle
			SET		ES_ACTIVO = 0,
					USUARIO_MODIFICACION = @USUARIO,
					FECHA_MODIFICACION = GETDATE()
			WHERE 
					ID_META_CARRERA_INSTITUCION_DETALLE = @ID_META_CARRERA_INSTITUCION_DETALLE	
			SET @RESULT =   @ID_META_CARRERA_INSTITUCION_DETALLE
		END
SELECT @RESULT
END
GO


