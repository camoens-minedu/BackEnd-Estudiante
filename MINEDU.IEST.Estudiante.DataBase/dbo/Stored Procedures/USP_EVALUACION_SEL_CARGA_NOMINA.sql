/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	31/03/2021
LLAMADO POR			:
DESCRIPCION			:	Obtiene el id del registro de una persona en una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	USP_EVALUACION_GET_IdPersonalInstitucion 23985770
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_CARGA_NOMINA] (
	
	@CICLO                              VARCHAR(100),
    @PERIODO_CLASES                     VARCHAR(100),
    @SECCION                            VARCHAR(100),
    @SEDE                               VARCHAR(100),
    @TURNO                              VARCHAR(100),
    @PLAN_ESTUDIOS                      VARCHAR(100),
    @CARRERA                            VARCHAR(100),
    @INSTITUCION                        VARCHAR(100)

)
AS
BEGIN
DECLARE @RESULT INT
SET @RESULT = 0
SET NOCOUNT ON;

	IF EXISTS (SELECT TOP 1 ID_CARGA_MASIVA_NOMINAS_CABECERA as IdCargaMasivaNominasCabecera 
	           FROM transaccional.carga_masiva_nominas_cabecera cmnc
	            WHERE
				cmnc.NOMBRE_SEDE = CASE WHEN @SEDE IS NULL OR LEN(@SEDE) = 0 OR @SEDE = '' OR @SEDE ='TODOS' THEN cmnc.NOMBRE_SEDE ELSE @SEDE END AND
				cmnc.CICLO = CASE WHEN @CICLO IS NULL OR LEN(@CICLO) = 0 OR @CICLO = '' OR @CICLO ='TODOS' THEN cmnc.CICLO ELSE @CICLO END AND
				cmnc.CARRERA = CASE WHEN @CARRERA  IS NULL OR LEN(@CARRERA) = 0 OR @CARRERA = '' OR @CARRERA ='TODOS' THEN cmnc.CARRERA ELSE @CARRERA END AND
				cmnc.SECCION = CASE WHEN @SECCION  IS NULL OR LEN(@SECCION) = 0 OR @SECCION = '' OR @SECCION = 'TODOS' THEN cmnc.CARRERA ELSE @SECCION END AND
				cmnc.PLAN_ESTUDIO = CASE WHEN @PLAN_ESTUDIOS  IS NULL OR LEN(@PLAN_ESTUDIOS) = 0 OR @PLAN_ESTUDIOS = '' OR @PLAN_ESTUDIOS = 'TODOS' THEN cmnc.CARRERA ELSE @PLAN_ESTUDIOS END AND
				cmnc.TURNO = CASE WHEN @TURNO  IS NULL OR LEN(@TURNO) = 0 OR @TURNO = '' OR @TURNO = 'TODOS' THEN cmnc.TURNO ELSE @TURNO END AND
				cmnc.PERIODO_ACADEMICO = CASE WHEN @PERIODO_CLASES  IS NULL OR LEN(@PERIODO_CLASES) = 0 OR @PERIODO_CLASES = '' OR @PERIODO_CLASES = 'TODOS' THEN cmnc.PERIODO_ACADEMICO ELSE @PERIODO_CLASES END AND cmnc.ES_ACTIVO=1)
	BEGIN

	SET @RESULT = 1

	END
	ELSE
	BEGIN
	 SET @RESULT = -381

	END 
	
	END
SELECT @RESULT