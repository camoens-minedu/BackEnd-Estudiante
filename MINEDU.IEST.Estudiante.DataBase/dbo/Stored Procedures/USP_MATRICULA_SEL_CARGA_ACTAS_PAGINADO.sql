CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_CARGA_ACTAS_PAGINADO](
--declare
	@INSTITUCION							VARCHAR(100), 
	@NOMBRE_SEDE                        	VARCHAR(100), 
	@CICLO              					VARCHAR(100), 	 
	@PROGRAMA_ESTUDIOS                      VARCHAR(100),
    @SECCION                                VARCHAR(100),
    @TIPO_PLANESTUDIOS                      VARCHAR(100),
    @TURNO                                  VARCHAR(100),
    @PLAN_ESTUDIO                           VARCHAR(100),
    @PERIODO_CLASES                         VARCHAR(100),

	@Pagina									INT	=1, 
	@Registros								INT	=10

	--DECLARE @INSTITUCION							VARCHAR(100)='1233410 - 1/2 DE CAMBIO'
	--DECLARE @NOMBRE_SEDE                        	VARCHAR(100)='PRINCIPAL - PRINCIPAL'
	--DECLARE @CICLO              					VARCHAR(100)='TODOS' 	 
	--DECLARE @PROGRAMA_ESTUDIOS                      VARCHAR(100)='TODOS'
 --   DECLARE @SECCION                                VARCHAR(100)='TODOS'
 --   DECLARE @TIPO_PLANESTUDIOS                      VARCHAR(100)='TODOS'
 --   DECLARE @TURNO                                  VARCHAR(100)='TODOS'
 --   DECLARE @PLAN_ESTUDIO                           VARCHAR(100)='TODOS'
 --   DECLARE @PERIODO_CLASES                         VARCHAR(100)='TODOS'

	--DECLARE @Pagina									INT	=1
	--DECLARE @Registros								INT	=10

	)
	AS 
BEGIN
SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT, @IdInstituto INT, @SEDE VARCHAR(100);

	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 
    
	WITH    tempPaginado AS
	(
				
			SELECT 	
		cmnc.ID_CARGA_MASIVA_ACTAS_CABECERA,
		cmnc.NOMBRE_SEDE,
		cmnc.CARRERA,
		cmnc.PLAN_ESTUDIO,
		cmnc.TURNO,
		cmnc.SECCION,
		cmnc.CICLO,
		cmnc.PERIODO_ACADEMICO,
		cmnc.CANTIDAD_ALUMNOS,

		ROW_NUMBER() OVER ( ORDER BY cmnc.NOMBRE_SEDE, cmnc.CARRERA) AS Row,
		Total = COUNT(1) OVER ( ) 

		FROM transaccional.carga_masiva_actas_cabecera cmnc
		WHERE 
		cmnc.NOMBRE_SEDE = CASE WHEN @NOMBRE_SEDE IS NULL OR LEN(@NOMBRE_SEDE) = 0 OR @NOMBRE_SEDE = '' OR @NOMBRE_SEDE ='TODOS' THEN cmnc.NOMBRE_SEDE ELSE @NOMBRE_SEDE END AND
		cmnc.CICLO = CASE WHEN @CICLO IS NULL OR LEN(@CICLO) = 0 OR @CICLO = '' OR @CICLO ='TODOS' THEN cmnc.CICLO ELSE @CICLO END AND
	    cmnc.CARRERA = CASE WHEN @PROGRAMA_ESTUDIOS  IS NULL OR LEN(@PROGRAMA_ESTUDIOS) = 0 OR @PROGRAMA_ESTUDIOS = '' OR @PROGRAMA_ESTUDIOS ='TODOS' THEN cmnc.CARRERA ELSE @PROGRAMA_ESTUDIOS END AND
		--cmnc.SECCION = CASE WHEN @SECCION  IS NULL OR LEN(@SECCION) = 0 OR @SECCION = '' OR @SECCION = 'TODOS' THEN cmnc.CARRERA ELSE @SECCION END
		--cmnc.PLAN_ESTUDIO = CASE WHEN @TIPO_PLANESTUDIOS  IS NULL OR LEN(@TIPO_PLANESTUDIOS) = 0 OR @TIPO_PLANESTUDIOS = '' OR @TIPO_PLANESTUDIOS = 'TODOS' THEN cmnc.CARRERA ELSE @TIPO_PLANESTUDIOS END
		cmnc.TURNO = CASE WHEN @TURNO  IS NULL OR LEN(@TURNO) = 0 OR @TURNO = '' OR @TURNO = 'TODOS' THEN cmnc.TURNO ELSE @TURNO END AND
		cmnc.PERIODO_ACADEMICO = CASE WHEN @PERIODO_CLASES  IS NULL OR LEN(@PERIODO_CLASES) = 0 OR @PERIODO_CLASES = '' OR @PERIODO_CLASES = 'TODOS' THEN cmnc.PERIODO_ACADEMICO ELSE @PERIODO_CLASES END AND cmnc.ES_ACTIVO=1
	)
	SELECT  *
    FROM    tempPaginado T   WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END