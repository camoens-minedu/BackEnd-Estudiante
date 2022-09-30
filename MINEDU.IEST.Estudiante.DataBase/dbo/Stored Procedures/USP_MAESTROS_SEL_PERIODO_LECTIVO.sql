/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de periodo lectivo
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			Creación
1.1			21/04/2022		JCHAVEZ			Corregir orden descendente en listado

TEST:			
	EXEC USP_MAESTROS_SEL_PERIODO_LECTIVO '2016-I',5
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PERIODO_LECTIVO]
(
	@CODIGO_PERIODO_LECTIVO		VARCHAR(20),--Con numerologia
	@ID_ENUMERADO_TIPO_OPCION	int,
	@Pagina						int		=1,
	@Registros					int		=10
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ESTADO_PERIODO_LECTIVO_SIN_APERTURAR INT, @numerologia CHAR(1)
	SELECT @numerologia =  CONVERT (CHAR, VALOR_PARAMETRO) FROM sistema.parametro WHERE NOMBRE_PARAMETRO = 'Numerologia'
	DECLARE @desde INT , @hasta INT
	SET @desde = ( @Pagina - 1 ) * @Registros;
	SET @hasta = ( @Pagina * @Registros ) + 1; 

	WITH    tempPaginado AS
	(
		SELECT	PL.ID_PERIODO_LECTIVO		IdPeriodoLectivo,
				CASE @numerologia
				WHEN '1' THEN PL.CODIGO_PERIODO_LECTIVO
				WHEN 'I' THEN CONVERT(VARCHAR,PL.ANIO) + '-' + dbo.UFN_CST_numero_romano(CAST(SUBSTRING(PL.CODIGO_PERIODO_LECTIVO,6,1) AS INT))
				WHEN 'A' THEN CONVERT(VARCHAR,PL.ANIO) + '-' + dbo.UFN_CST_numero_texto(CAST(SUBSTRING(PL.CODIGO_PERIODO_LECTIVO,6,1) AS INT))
				ELSE PL.CODIGO_PERIODO_LECTIVO END NombrePeriodoLectivo,
				PL.CODIGO_PERIODO_LECTIVO	CodigoPeriodoLectivo,
				E.ID_ENUMERADO				IdEnumeradoTipoOpcion,
				E.VALOR_ENUMERADO			EnumeradoTipoOpcion,		
				PL.FECHA_INICIO				FechaInicio,
				PL.FECHA_FIN				FechaFin,
				PL.ES_ASIGNADO				  EsAsignado,				  
				(select Count(PLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION) from transaccional.periodos_lectivos_por_institucion PLI  
				    WHERE PLI.ID_PERIODO_LECTIVO=PL.ID_PERIODO_LECTIVO AND PLI.ESTADO in (7,8) AND PLI.ES_ACTIVO=1)
				AS Cantidad,
				--ROW_NUMBER() OVER ( ORDER BY PL.ID_PERIODO_LECTIVO) AS Row,
				ROW_NUMBER() OVER ( ORDER BY PL.CODIGO_PERIODO_LECTIVO DESC,PL.ID_PERIODO_LECTIVO DESC) AS Row, --v1.1
				Total = COUNT(1) OVER ( )				
		FROM	maestro.periodo_lectivo PL
				INNER JOIN sistema.enumerado E ON E.ID_ENUMERADO = PL.ID_TIPO_OPCION
		WHERE 				
				--AND PL.CODIGO_PERIODO_LECTIVO LIKE @CODIGO_PERIODO_LECTIVO+'%' COLLATE LATIN1_GENERAL_CI_AI
				CASE @numerologia
				WHEN '1' THEN PL.CODIGO_PERIODO_LECTIVO
				WHEN 'I' THEN CONVERT(VARCHAR,PL.ANIO) + '-' + dbo.UFN_CST_numero_romano(CAST(SUBSTRING(PL.CODIGO_PERIODO_LECTIVO,6,1) AS INT))
				WHEN 'A' THEN CONVERT(VARCHAR,PL.ANIO) + '-' + dbo.UFN_CST_numero_texto(CAST(SUBSTRING(PL.CODIGO_PERIODO_LECTIVO,6,1) AS INT))
				ELSE PL.CODIGO_PERIODO_LECTIVO END COLLATE LATIN1_GENERAL_CI_AI LIKE @CODIGO_PERIODO_LECTIVO+'%' COLLATE LATIN1_GENERAL_CI_AI				
				AND (PL.ID_TIPO_OPCION = @ID_ENUMERADO_TIPO_OPCION OR @ID_ENUMERADO_TIPO_OPCION=0)
				AND PL.ESTADO = 1
	)
	SELECT  *,
	(CASE WHEN T.Cantidad>0 THEN 'SI' ELSE 'NO' END) AS EnUso,
	(CASE WHEN T.Cantidad>0 THEN cast(0 AS bit) ELSE cast(1 AS bit) END) AS VerEditar,
	(CASE WHEN T.Cantidad>0 THEN cast(0 AS bit)  ELSE cast(EsAsignado AS bit)  END)	 AS VerDesasignar

    FROM    tempPaginado T
    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
	--ORDER BY T.NombrePeriodoLectivo DESC v1.1
END
GO


