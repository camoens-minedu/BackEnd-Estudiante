CREATE PROCEDURE [dbo].[USP_ADMISION_INS_TIPO_MODALIDAD_CONFIG]
(
	@ID_PROCESO_ADMISION_PERIODO	INT,
	@ID_TIPO_MODALIDAD_INSTITUCION	INT,
	@META							INT,
	@ID_TIPO_META					INT,
	@USUARIO						VARCHAR(20)
)AS
IF EXISTS(SELECT TOP 1 ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION 
		FROM transaccional.tipos_modalidad_por_proceso_admision where ID_PROCESO_ADMISION_PERIODO=@ID_PROCESO_ADMISION_PERIODO
		AND ID_TIPOS_MODALIDAD_POR_INSTITUCION=@ID_TIPO_MODALIDAD_INSTITUCION and ES_ACTIVO=1)
		SELECT -180
ELSE
BEGIN
	INSERT INTO transaccional.tipos_modalidad_por_proceso_admision(
		ID_PROCESO_ADMISION_PERIODO,
		ID_TIPOS_MODALIDAD_POR_INSTITUCION,
		META,
		ID_TIPO_META,
		ES_ACTIVO,
		ESTADO,
		USUARIO_CREACION,
		FECHA_CREACION
	)VALUES(
		@ID_PROCESO_ADMISION_PERIODO,
		@ID_TIPO_MODALIDAD_INSTITUCION,
		@META,
		@ID_TIPO_META,
		1,
		1,
		@USUARIO,
		GETDATE()
	)

	SELECT 1
END
GO


