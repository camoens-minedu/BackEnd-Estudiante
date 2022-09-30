CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_EVALUADORES]
(
	@ID_PROCESO_ADMISION_PERIODO			INT,
	@ID_MODALIDADES_POR_PROCESO_ADMISION	INT,
	@EVALUADOR								VARCHAR(150),

	@Pagina									int = 1,
	@Registros								int = 1000
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
			A.ID_EVALUADOR_ADMISION_MODALIDAD														IdEvaluadorAdmisionModalidad,
			A.ID_PERSONAL_INSTITUCION																IdPersonalInstitucion,
			D.APELLIDO_PATERNO_PERSONA + ' '+ D.APELLIDO_MATERNO_PERSONA + ', ' + D.NOMBRE_PERSONA	Evaluador,
			E.ID_MODALIDAD																			IdModalidad,
			E.ID_MODALIDADES_POR_PROCESO_ADMISION													IdModalidadProcesoAdmision,
			F.VALOR_ENUMERADO																		Modalidad,

			ROW_NUMBER() OVER ( ORDER BY D.APELLIDO_PATERNO_PERSONA, D.APELLIDO_MATERNO_PERSONA, D.NOMBRE_PERSONA) AS Row,
			Total = count(1) OVER ()
		FROM 
			transaccional.evaluador_admision_modalidad A
			INNER JOIN maestro.personal_institucion B ON A.ID_PERSONAL_INSTITUCION = B.ID_PERSONAL_INSTITUCION
			INNER JOIN maestro.persona_institucion C ON C.ID_PERSONA_INSTITUCION = B.ID_PERSONA_INSTITUCION
			INNER JOIN maestro.persona D ON D.ID_PERSONA = C.ID_PERSONA
			INNER JOIN transaccional.modalidades_por_proceso_admision E ON E.ID_MODALIDADES_POR_PROCESO_ADMISION = A.ID_MODALIDADES_POR_PROCESO_ADMISION
			INNER JOIN sistema.enumerado F ON F.ID_ENUMERADO = E.ID_MODALIDAD
		WHERE A.ES_ACTIVO = 1 
			AND B.ES_ACTIVO = 1
			AND E.ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO
			AND (E.ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION OR @ID_MODALIDADES_POR_PROCESO_ADMISION = 0)
			AND (D.APELLIDO_PATERNO_PERSONA + ' '+ D.APELLIDO_MATERNO_PERSONA + ', ' + D.NOMBRE_PERSONA) LIKE '%'+ @EVALUADOR +'%' COLLATE LATIN1_GENERAL_CI_AI
	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END
GO


