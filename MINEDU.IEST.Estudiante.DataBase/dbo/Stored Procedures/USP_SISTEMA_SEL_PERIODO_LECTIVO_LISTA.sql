/************************************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Listado de periodos lectivos
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/11/2019		MALVA			MODIFICACIÓN PARA LISTADO DE PERIODOS LECTIVOS DISPONIBLES SOLA HASTA 2 PERIODOS POR AÑO. 
2.0			10/09/2021		JCHAVEZ			MODIFICACIÓN PARA PARAMETRIZAR LA CANTIDAD DE PERIODOS POR AÑO

  TEST:		USP_SISTEMA_SEL_PERIODO_LECTIVO_LISTA
*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_PERIODO_LECTIVO_LISTA]
AS
BEGIN
	DECLARE @startnum INT,@endnum INT,@interval INT,@numerologia CHAR(1),@inicioperiodolectivo INT, @CantidadPeriodosAnio INT, @nro INT = 1
	SELECT @interval = CAST(VALOR_PARAMETRO AS INT) FROM sistema.parametro WHERE NOMBRE_PARAMETRO = 'Intervalo'
	SELECT @numerologia = CONVERT (CHAR, VALOR_PARAMETRO) FROM sistema.parametro WHERE NOMBRE_PARAMETRO = 'Numerologia'
	SELECT @startnum = YEAR(GETDATE())-@interval
	SELECT @endnum = YEAR(GETDATE())+@interval
	SELECT @inicioperiodolectivo = CAST(VALOR_PARAMETRO AS INT) FROM sistema.parametro WHERE NOMBRE_PARAMETRO = 'InicioPeriodoLectivo'
	SELECT @CantidadPeriodosAnio = CAST(VALOR_PARAMETRO AS INT) FROM sistema.parametro WHERE NOMBRE_PARAMETRO = 'CantidadPeriodosPorAño'
	
	/*;
	WITH gen AS (
		SELECT @startnum AS Anio
		UNION ALL
		SELECT Anio+1 FROM gen WHERE Anio+1<=@endnum
	)

	SELECT Anio AS Value ,
		CAST(Anio AS VARCHAR) + '-' +
		CASE @numerologia
		WHEN '1' THEN CAST(TrueVal AS VARCHAR)
		WHEN 'I' THEN dbo.UFN_CST_numero_romano(TrueVal) 
		WHEN 'A' THEN dbo.UFN_CST_numero_texto(TrueVal) 
		ELSE CAST(TrueVal AS VARCHAR) END AS Text,
		CAST(TrueVal AS VARCHAR) AS Code
	FROM (
		SELECT T1.Anio Anio,ISNULL(T2.ArabicVal,@inicioperiodolectivo) TrueVal FROM gen T1
		LEFT JOIN (SELECT 
						PL.ANIO Anio, 
						MAX(CONVERT(INT,SUBSTRING(PL.CODIGO_PERIODO_LECTIVO,6,1))) + 1 ArabicVal
					FROM maestro.periodo_lectivo PL
					WHERE PL.ESTADO = 1
					GROUP BY PL.ANIO) T2 ON T1.Anio = T2.Anio) PL  
					WHERE PL.TrueVal<=@CantidadPeriodosAnio
	*/
	DECLARE @gen TABLE (Anio INT)
	DECLARE @genFinal TABLE (Anio INT, TrueVal INT)
	;
	WITH gen AS (
		SELECT @startnum AS Anio
		UNION ALL
		SELECT Anio+1 FROM gen WHERE Anio+1<=@endnum
	)

	INSERT INTO @gen
	SELECT Anio FROM gen
	 
	WHILE (@nro <= @CantidadPeriodosAnio)
	BEGIN
		INSERT INTO @genFinal
		SELECT Anio, @nro TrueVal FROM @gen

		SET  @nro = @nro + 1
	END
	
	SELECT CAST(CAST(Anio AS VARCHAR) + CAST(TrueVal AS VARCHAR) AS INT) AS Value ,
		CAST(Anio AS VARCHAR) + '-' +
		CASE @numerologia
		WHEN '1' THEN CAST(TrueVal AS VARCHAR)
		WHEN 'I' THEN dbo.UFN_CST_numero_romano(TrueVal) 
		WHEN 'A' THEN dbo.UFN_CST_numero_texto(TrueVal) 
		ELSE CAST(TrueVal AS VARCHAR) END AS Text,
		CAST(TrueVal AS VARCHAR) AS Code
	FROM @genFinal
	ORDER BY Value,Code

option (maxrecursion 100)
END
GO


