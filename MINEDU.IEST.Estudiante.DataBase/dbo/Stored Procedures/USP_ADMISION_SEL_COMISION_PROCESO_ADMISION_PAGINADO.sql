
CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_COMISION_PROCESO_ADMISION_PAGINADO]
(
	@ID_PROCESO_ADMISION_PERIODO	INT,
	@ID_CARGO						INT,
	@RESPONSABLE					VARCHAR(150),

	@Pagina							int = 1,
	@Registros						int = 1000
)AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
	SET @hasta = ( @Pagina * @Registros ) + 1;  

	WITH    tempPaginado AS
	(	   
		SELECT 
			A.ID_COMISION_PROCESO_ADMISION	IdComisionProcesoAdmision,
			D.APELLIDO_PATERNO_PERSONA + ' '+ D.APELLIDO_MATERNO_PERSONA + ', ' + D.NOMBRE_PERSONA Responsable,
			A.ID_CARGO IdCargo,
			CAR.VALOR_ENUMERADO			Cargo,
			PAP.NOMBRE_PROCESO_ADMISION	ProcesoAdmisionPeriodo,
			B.ID_PERSONAL_INSTITUCION IdPersonalInstitucion,

			ROW_NUMBER() OVER ( ORDER BY D.APELLIDO_PATERNO_PERSONA, D.APELLIDO_MATERNO_PERSONA, D.NOMBRE_PERSONA) AS Row,
			Total = count(1) OVER ()
		FROM 
			transaccional.comision_proceso_admision A
			INNER JOIN maestro.personal_institucion B ON B.ID_PERSONAL_INSTITUCION = A.ID_PERSONAL_INSTITUCION
			INNER JOIN maestro.persona_institucion C ON C.ID_PERSONA_INSTITUCION = B.ID_PERSONA_INSTITUCION
			INNER JOIN maestro.persona D ON D.ID_PERSONA = C.ID_PERSONA
			INNER JOIN sistema.enumerado CAR ON CAR.ID_ENUMERADO = A.ID_CARGO
			INNER JOIN transaccional.proceso_admision_periodo PAP ON PAP.ID_PROCESO_ADMISION_PERIODO = A.ID_PROCESO_ADMISION_PERIODO
		WHERE A.ES_ACTIVO = 1
			AND A.ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO
			AND (A.ID_CARGO = @ID_CARGO OR @ID_CARGO = 0)
			AND (D.APELLIDO_PATERNO_PERSONA + ' '+ D.APELLIDO_MATERNO_PERSONA + ', ' + D.NOMBRE_PERSONA) LIKE '%'+ @RESPONSABLE +'%' COLLATE LATIN1_GENERAL_CI_AI
	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END
GO


