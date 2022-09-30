/*************************************************************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Obtiene situación de docentes
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE		Creación

TEST:
	USP_TRANSACCIONAL_SEL_SITUACION_DOCENTES 3905,'','',1,10000
**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_SITUACION_DOCENTES] (
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

	WITH    lista AS  
	( 
		SELECT 
			i.NOMBRE_INSTITUCION,
			i.CODIGO_MODULAR + ' - ' + i.NOMBRE_INSTITUCION AS NombreInstitucion,
			Contratado = SUM(CASE WHEN per.CONDICION_LABORAL=50 THEN 1 ELSE 0 END),
			Nombrado = SUM(CASE WHEN per.CONDICION_LABORAL=51 THEN 1 ELSE 0 END),
			Encargado = SUM(CASE WHEN per.CONDICION_LABORAL=10067 THEN 1 ELSE 0 END),
			pl.CODIGO_PERIODO_LECTIVO
		FROM maestro.persona_institucion pins 
			INNER JOIN maestro.personal_institucion per ON pins.ID_PERSONA_INSTITUCION = per.ID_PERSONA_INSTITUCION 
			INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON pins.ID_INSTITUCION = i.ID_INSTITUCION 
			INNER JOIN transaccional.periodos_lectivos_por_institucion plectivo ON i.ID_INSTITUCION = plectivo.ID_INSTITUCION AND plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = per.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
			INNER JOIN maestro.periodo_lectivo pl ON pl.ID_PERIODO_LECTIVO = plectivo.ID_PERIODO_LECTIVO
		WHERE plectivo.ID_PERIODO_LECTIVO=@ID_PERIODO_LECTIVO_R AND per.ID_ROL=49 AND pins.ESTADO=1  AND per.ES_ACTIVO=1
		AND i.CODIGO_PROVINCIA LIKE CONCAT(@CODIGO_DEPARTAMENTO, '%') AND plectivo.ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO_R
		GROUP BY i.CODIGO_MODULAR,i.NOMBRE_INSTITUCION,pl.CODIGO_PERIODO_LECTIVO--,per.CONDICION_LABORAL		
	)
	SELECT  *    
	FROM    (SELECT RT.* , 		
	ROW_NUMBER() OVER ( ORDER BY RT.NOMBRE_INSTITUCION ASC ) AS Row ,
	Total = COUNT(1) OVER ( )     
	FROM    lista RT) as T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
	--SELECT  *    FROM    lista T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
END