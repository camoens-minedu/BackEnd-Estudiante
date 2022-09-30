CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_TIPO_MODALIDAD_CONFIG_PAGINADO]


(
	@ID_INSTITUCION					INT,
	@ID_PROCESO_ADMISION_PERIODO	INT,
	@ID_MODALIDAD					INT,
	@ID_TIPO_MODALIDAD				INT,
	@ID_TIPO_META					INT,

	@Pagina					int = 1,
	@Registros				int = 10
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1;  

	WITH    tempPaginado AS
	(	   				

		SELECT 
				TMXPA.ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION	IdTipoModalidadProcesoAdmision,
				TMXPA.ID_PROCESO_ADMISION_PERIODO				IdProcesoAdmisionPeriodo,
				TMXPA.ID_TIPOS_MODALIDAD_POR_INSTITUCION		IdTipoModalidadInstitucion,
				TMXI.ID_TIPO_MODALIDAD							IdTipoModalidad,
				MXPA.ID_MODALIDADES_POR_PROCESO_ADMISION		IdModalidadProcesoAdmision, 
				se_modalidad.VALOR_ENUMERADO					Modalidad,
				TM.NOMBRE_TIPO_MODALIDAD						TipoModalidad,
				TMXPA.ID_TIPO_META								IdTipoMeta,
				se_tipoMeta.VALOR_ENUMERADO						TipoMeta,
				TMXPA.META										Meta,
				ROW_NUMBER() OVER ( ORDER BY TM.NOMBRE_TIPO_MODALIDAD) AS Row,
				Total = COUNT(1) OVER ( )
		 FROM transaccional.tipos_modalidad_por_proceso_admision TMXPA
		 INNER JOIN maestro.tipos_modalidad_por_institucion TMXI ON TMXPA.ID_TIPOS_MODALIDAD_POR_INSTITUCION= TMXI.ID_TIPOS_MODALIDAD_POR_INSTITUCION 
		 AND TMXI.ID_INSTITUCION= @ID_INSTITUCION
		 INNER JOIN maestro.tipo_modalidad  TM ON TM.ID_TIPO_MODALIDAD = TMXI.ID_TIPO_MODALIDAD AND TMXI.ES_ACTIVO=1 
		 INNER JOIN transaccional.modalidades_por_proceso_admision MXPA ON MXPA.ID_MODALIDAD = TM.ID_MODALIDAD AND MXPA.ID_PROCESO_ADMISION_PERIODO= @ID_PROCESO_ADMISION_PERIODO
		 AND TMXPA.ES_ACTIVO=1 AND TMXI.ES_ACTIVO=1
		 INNER JOIN sistema.enumerado se_modalidad ON se_modalidad.ID_ENUMERADO= TM.ID_MODALIDAD 
		 INNER JOIN sistema.enumerado se_tipoMeta ON se_tipoMeta.ID_ENUMERADO= TMXPA.ID_TIPO_META 
		 WHERE TMXPA.ID_PROCESO_ADMISION_PERIODO= @ID_PROCESO_ADMISION_PERIODO
			AND (TM.ID_MODALIDAD = @ID_MODALIDAD OR @ID_MODALIDAD = 0)
			AND (TMXI.ID_TIPOS_MODALIDAD_POR_INSTITUCION = @ID_TIPO_MODALIDAD OR @ID_TIPO_MODALIDAD = 0)
			AND (TMXPA.ID_TIPO_META = @ID_TIPO_META OR @ID_TIPO_META = 0)
			--and TM.ID_MODALIDAD=23
		)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END
GO


