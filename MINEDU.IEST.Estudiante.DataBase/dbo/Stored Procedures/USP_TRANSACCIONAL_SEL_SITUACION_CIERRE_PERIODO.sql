/*************************************************************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Obtiene situación de cierre periodo. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO				DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE		Creación

TEST:
	USP_TRANSACCIONAL_SEL_SITUACION_CIERRE_PERIODO 1235,'','',1,0
**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_SITUACION_CIERRE_PERIODO] (
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@CODIGO_DEPARTAMENTO			VARCHAR(MAX),
	@CODIGO_PROVINCIA				VARCHAR(MAX),
	@Pagina							int = 1,
	@Registros						int = 10  
) AS
DECLARE @ID_PERIODO_LECTIVO_R INT;
BEGIN  
	SET NOCOUNT ON;  
 
	DECLARE @desde INT , @hasta INT;  
	SET @desde = ( @Pagina - 1 ) * @Registros;  
    SET @hasta = ( @Pagina * @Registros ) + 1;    
  
	SET @ID_PERIODO_LECTIVO_R = (SELECT TOP 1 ID_PERIODO_LECTIVO FROM transaccional.periodos_lectivos_por_institucion
								WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION);

	WITH    tempPaginado AS  
	( 
		SELECT DISTINCT  
		PER_ACA.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AS IdPeriodosLectivosPorInstitucion, 
		PC.ID_PERIODO_ACADEMICO AS IdPeriodoAcademico,
		UPPER(PER_ACA.NOMBRE_PERIODO_ACADEMICO) AS NombrePeriodoAcademico,  
		convert(varchar, PER_ACA.FECHA_INICIO, 103) AS FechaInicio,
		convert(varchar, PER_ACA.FECHA_FIN, 103) AS FechaFin,
		CAST(PC.ESTADO AS VARCHAR(1)) AS Estado,
		INST.ID_INSTITUCION AS IdInstitucion, 
		INST.NOMBRE_INSTITUCION,
		INST.CODIGO_MODULAR + ' - ' + INST.NOMBRE_INSTITUCION AS NombreInstitucion
		,pl.CODIGO_PERIODO_LECTIVO
		FROM  transaccional.programacion_clase PC
		INNER JOIN transaccional.evaluacion as EVAL ON PC.ID_PROGRAMACION_CLASE = EVAL.ID_PROGRAMACION_CLASE AND EVAL.ES_ACTIVO = 1
		INNER JOIN transaccional.periodo_academico as PER_ACA ON PC.ID_PERIODO_ACADEMICO = PER_ACA.ID_PERIODO_ACADEMICO AND PER_ACA.ES_ACTIVO = 1
		INNER JOIN maestro.sede_institucion as SINST ON PC.ID_SEDE_INSTITUCION = SINST.ID_SEDE_INSTITUCION
		INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION as INST ON SINST.ID_INSTITUCION = INST.ID_INSTITUCION
		INNER JOIN transaccional.periodos_lectivos_por_institucion as PLPI ON INST.ID_INSTITUCION = PLPI.ID_INSTITUCION AND PER_ACA.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = PLPI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND PLPI.ES_ACTIVO = 1
		INNER JOIN maestro.periodo_lectivo pl ON pl.ID_PERIODO_LECTIVO = PLPI.ID_PERIODO_LECTIVO
		WHERE INST.CODIGO_PROVINCIA LIKE CONCAT(@CODIGO_DEPARTAMENTO, '%') AND PLPI.ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO_R
	)
	SELECT  *    
	FROM    (SELECT RT.* , 		
	ROW_NUMBER() OVER ( ORDER BY NOMBRE_INSTITUCION ASC ) AS Row ,
	Total = COUNT(1) OVER ( )     
	FROM    tempPaginado RT) as T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
END