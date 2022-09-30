/*************************************************************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Obtiene situación cierre de matrícula
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO				DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE		Creación

TEST:
	USP_TRANSACCIONAL_SEL_SITUACION_CIERRE_MATRICULA 4039,'','',1,0
**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_SITUACION_CIERRE_MATRICULA] (
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@CODIGO_DEPARTAMENTO			VARCHAR(MAX),
	@CODIGO_PROVINCIA				VARCHAR(MAX),
	@Pagina							int = 1,
	@Registros						int = 10
 --DECLARE @ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT=3905
 --DECLARE @CODIGO_DEPARTAMENTO			VARCHAR(MAX)='15'
 --DECLARE @CODIGO_PROVINCIA				VARCHAR(MAX)='150101'
 --DECLARE @Pagina							int = 1
 --DECLARE @Registros						int = 10  
) AS
DECLARE @ID_PERIODO_LECTIVO_R INT
BEGIN  
	SET NOCOUNT ON;  
 
	DECLARE @desde INT , @hasta INT;  
	SET @desde = ( @Pagina - 1 ) * @Registros;  
    SET @hasta = ( @Pagina * @Registros ) + 1;    
  
	SET @ID_PERIODO_LECTIVO_R = (SELECT TOP 1 ID_PERIODO_LECTIVO FROM transaccional.periodos_lectivos_por_institucion
								WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION);


	WITH tempPaginado AS  
	( 
		SELECT 
		INST.ID_INSTITUCION AS IdInstitucion, 
		INST.CODIGO_MODULAR + ' - ' + INST.NOMBRE_INSTITUCION AS NombreInstitucion, 
		SETM.VALOR_ENUMERADO AS TipoMatricula, 
		convert(varchar, PM.FECHA_INICIO, 103) AS FechaInicio,
		convert(varchar, PM.FECHA_FIN, 103) AS FechaFin,
		CAST((case when getdate() < CONVERT(DATETIME, PM.FECHA_FIN, 120) then 0 ELSE 1 END) AS VARCHAR(1)) Cerrado,
        --PM.CERRADO AS Cerrado,
		pl.CODIGO_PERIODO_LECTIVO,
		ROW_NUMBER() OVER ( ORDER BY  INST.NOMBRE_INSTITUCION ASC, SETM.VALOR_ENUMERADO DESC ) AS Row ,
		Total = COUNT(1) OVER ( )  
		FROM db_auxiliar.dbo.UVW_INSTITUCION as INST
		INNER JOIN transaccional.periodos_lectivos_por_institucion as PLPI ON INST.ID_INSTITUCION = PLPI.ID_INSTITUCION AND PLPI.ES_ACTIVO = 1
		INNER JOIN transaccional.programacion_matricula as PM ON PLPI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = PM.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND PM.ES_ACTIVO = 1 
		INNER JOIN sistema.enumerado as SETM ON PM.ID_TIPO_MATRICULA = SETM.ID_ENUMERADO
		INNER JOIN maestro.periodo_lectivo pl ON pl.ID_PERIODO_LECTIVO = PLPI.ID_PERIODO_LECTIVO
		WHERE INST.CODIGO_PROVINCIA LIKE CONCAT(@CODIGO_DEPARTAMENTO, '%') AND PLPI.ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO_R
	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
END