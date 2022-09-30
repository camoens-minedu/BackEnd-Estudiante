CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_EXAMEN_ADMISION_SEDE_PAGINADO]
(
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,

	@Pagina									int = 1,
	@Registros								int = 1000
)AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
	SET @hasta = ( @Pagina * @Registros ) + 1;  

	WITH    tempPaginado AS
	(	   
SELECT 
			A.ID_EXAMEN_ADMISION_SEDE	IdExamenAdmisionSede,
			B.ID_SEDE_INSTITUCION		IdSedeInstitucion,
			B.NOMBRE_SEDE				SedeInstitucion,
			A.ID_MODALIDAD				IdTipoModalidad,
			se_tipo_mod.VALOR_ENUMERADO	TipoModalidad,
			A.FECHA_EVALUACION			FechaEvaluacion,
			A.HORA_EVALUACION			HoraEvaluacion,

			ROW_NUMBER() OVER ( ORDER BY B.NOMBRE_SEDE) AS Row,
			Total = count(1) OVER ()
		FROM 
			transaccional.examen_admision_sede A
			INNER JOIN maestro.sede_institucion B ON B.ID_SEDE_INSTITUCION = A.ID_SEDE_INSTITUCION AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1
			INNER JOIN transaccional.proceso_admision_periodo PAP ON A.ID_PROCESO_ADMISION_PERIODO = PAP.ID_PROCESO_ADMISION_PERIODO AND PAP.ES_ACTIVO=1
			INNER JOIN sistema.enumerado se_tipo_mod ON A.ID_MODALIDAD = se_tipo_mod.ID_ENUMERADO
		WHERE
			PAP.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
			AND A.ES_ACTIVO = 1
	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END
GO


