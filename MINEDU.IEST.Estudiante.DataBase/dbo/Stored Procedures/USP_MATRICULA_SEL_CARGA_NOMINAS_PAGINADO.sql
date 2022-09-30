/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	12/03/2021
LLAMADO POR			:
DESCRIPCION			:	Lista los registros realizados a traves de la carga masiva nominas
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			12/03/2021		JTOVAR			CREACIÓN
--  TEST:	
	EXEC USP_MATRICULA_SEL_CARGA_NOMINAS_PAGINADO 2945,'','',0,'',0,0,0
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_CARGA_NOMINAS_PAGINADO](
--DECLARE
 @ID_INSTITUCION INT,
 @NOMBRE_PERIODO_LECTIVO VARCHAR(100), 
 @NOMBRE_SEDE VARCHAR(100),
 @ID_CARRERA INT,
 @NOMBRE_PLAN_ESTUDIO VARCHAR(100),
 @ID_SEMESTRE_ACADEMICO INT,
 @ID_TURNO INT,
 @ID_SECCION INT,
 @Pagina INT = 1, 
 @Registros	 INT = 10

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
			cmn.ID_CARGA_MASIVA_NOMINA IdCargaMasivaNomina,
			cmn.ID_INSTITUCION IdInstitucion,
			cmn.NOMBRE_PERIODO_LECTIVO NombrePeriodoLectivo,
			cmn.NOMBRE_SEDE_INSTITUCION NombreSede,
			cmn.ID_CARRERA IdCarrera,
			c.NOMBRE_CARRERA NombreCarrera,
			cmn.NOMBRE_PLAN_ESTUDIO NombrePlanEstudios,
			enum_sa.VALOR_ENUMERADO NombreSemestreAcademico,
			enum_t.VALOR_ENUMERADO NombreTurno,
			enum_s.VALOR_ENUMERADO NombreSeccion,
			cmn.CANTIDAD_ALUMNOS CantidadAlumnos,
			ROW_NUMBER() OVER ( ORDER BY cmn.ID_CARGA_MASIVA_NOMINA) AS Row,
			Total = COUNT(1) OVER ( ) 
		FROM transaccional.carga_masiva_nominas cmn
			INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cmn.ID_CARRERA = c.ID_CARRERA
			INNER JOIN sistema.enumerado enum_sa ON enum_sa.ID_ENUMERADO = cmn.ID_SEMESTRE_ACADEMICO
			INNER JOIN sistema.enumerado enum_t ON enum_t.ID_ENUMERADO = cmn.ID_TURNO
			INNER JOIN sistema.enumerado enum_s ON enum_s.ID_ENUMERADO = cmn.ID_SECCION
		WHERE cmn.ES_ACTIVO=1 AND cmn.ID_INSTITUCION = @ID_INSTITUCION AND
			cmn.NOMBRE_PERIODO_LECTIVO = (CASE WHEN @NOMBRE_PERIODO_LECTIVO IS NULL OR LEN(@NOMBRE_PERIODO_LECTIVO) = 0 OR @NOMBRE_PERIODO_LECTIVO = '' OR @NOMBRE_PERIODO_LECTIVO ='TODOS' THEN cmn.NOMBRE_PERIODO_LECTIVO ELSE @NOMBRE_PERIODO_LECTIVO END) AND
			cmn.NOMBRE_SEDE_INSTITUCION = (CASE WHEN @NOMBRE_SEDE IS NULL OR LEN(@NOMBRE_SEDE) = 0 OR @NOMBRE_SEDE = '' OR @NOMBRE_SEDE ='TODOS' THEN cmn.NOMBRE_SEDE_INSTITUCION ELSE @NOMBRE_SEDE END) AND
			cmn.ID_CARRERA = (CASE WHEN @ID_CARRERA = 0 THEN cmn.ID_CARRERA	ELSE @ID_CARRERA END) AND
			cmn.NOMBRE_PLAN_ESTUDIO = (CASE WHEN @NOMBRE_PLAN_ESTUDIO IS NULL OR LEN(@NOMBRE_PLAN_ESTUDIO) = 0 OR @NOMBRE_PLAN_ESTUDIO = '' OR @NOMBRE_PLAN_ESTUDIO ='TODOS' THEN cmn.NOMBRE_PLAN_ESTUDIO ELSE @NOMBRE_PLAN_ESTUDIO END) AND
			cmn.ID_SEMESTRE_ACADEMICO = (CASE WHEN @ID_SEMESTRE_ACADEMICO = 0 THEN cmn.ID_SEMESTRE_ACADEMICO ELSE @ID_SEMESTRE_ACADEMICO END) AND
			cmn.ID_TURNO = (CASE WHEN @ID_TURNO = 0 THEN cmn.ID_TURNO ELSE @ID_TURNO END) AND
			cmn.ID_SECCION = (CASE WHEN @ID_SECCION = 0 THEN cmn.ID_SECCION ELSE @ID_SECCION END)
	)
	SELECT  *
    FROM    tempPaginado T   WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END