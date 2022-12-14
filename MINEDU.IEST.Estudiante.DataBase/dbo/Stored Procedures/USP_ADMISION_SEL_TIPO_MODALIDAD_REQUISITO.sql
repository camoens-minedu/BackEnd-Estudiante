CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_TIPO_MODALIDAD_REQUISITO]
(
	@ID_TIPO_MODALIDAD_INSTITUCION	INT
)
AS
BEGIN
	SELECT	A.ID_REQUISITOS_POR_TIPO_MODALIDAD	IdRequisitoTipoModalidad,
			B.NOMBRE_REQUISITO					RequisitoTipoModalidad
	FROM maestro.requisitos_por_tipo_modalidad A
	INNER JOIN maestro.requisito B ON B.ID_REQUISITO = A.ID_REQUISITO
	WHERE A.ID_TIPOS_MODALIDAD_POR_INSTITUCION = @ID_TIPO_MODALIDAD_INSTITUCION
	AND A.ES_ACTIVO = 1
END
GO


