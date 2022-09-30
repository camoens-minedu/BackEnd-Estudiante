CREATE FUNCTION [dbo].[UFN_CST_numero_texto] (@Number INT)
RETURNS VARCHAR(100)
AS
BEGIN
IF @Number < 0
	RETURN 'No se puede castear números negativos'
IF @Number > 999
	RETURN 'Numero no soportado'
DECLARE		@lnEntero INT, 
			@lcRetorno VARCHAR(512), 
			@lnTerna INT, 
			@lcMiles VARCHAR(512), 
			@lcCadena VARCHAR(512), 
			@lnUnidades INT, 
			@lnDecenas INT, 
			@lnCentenas INT, 
			@lnFraccion INT 
SELECT	@lnEntero = CAST(@Number AS INT), 
		@lnFraccion = (@Number - @lnEntero) * 100, 
		@lcRetorno = '',
		@lnTerna = 1 
--WHILE @lnEntero > 0 
--BEGIN /* WHILE */ 
-- Recorro terna por terna 
SELECT @lcCadena = '' 
SELECT @lnUnidades = @lnEntero % 10 
SELECT @lnDecenas = CAST(@lnEntero/10 AS INT) % 10 
SELECT @lnCentenas = CAST(CAST(@lnEntero/10 AS INT)/10 AS INT)  % 10 
SELECT @lnEntero = CAST(CAST(CAST(@lnEntero/10 AS INT)/10 AS INT)/10 AS INT) 

-- Analizo las unidades 

SELECT @lcCadena = 
CASE /* UNIDADES */ 
WHEN @lnUnidades = 1 AND @lnTerna = 1 THEN 'UNO' + @lcCadena 
WHEN @lnUnidades = 1 AND @lnTerna <> 1 THEN 'UN ' + @lcCadena 
WHEN @lnUnidades = 2 THEN 'DOS' + @lcCadena 
WHEN @lnUnidades = 3 THEN 'TRES' + @lcCadena 
WHEN @lnUnidades = 4 THEN 'CUATRO' + @lcCadena 
WHEN @lnUnidades = 5 THEN 'CINCO' + @lcCadena 
WHEN @lnUnidades = 6 THEN 'SEIS' + @lcCadena 
WHEN @lnUnidades = 7 THEN 'SIETE' + @lcCadena 
WHEN @lnUnidades = 8 THEN 'OCHO' + @lcCadena 
WHEN @lnUnidades = 9 THEN 'NUEVE' + @lcCadena 
ELSE @lcCadena 
END /* UNIDADES */ 

-- Analizo las decenas 
SELECT @lcCadena = 
CASE /* DECENAS */ 
WHEN @lnDecenas = 1 THEN 
CASE @lnUnidades 
WHEN 0 THEN 'DIEZ' 
WHEN 1 THEN 'ONCE' 
WHEN 2 THEN 'DOCE' 
WHEN 3 THEN 'TRECE' 
WHEN 4 THEN 'CATORCE' 
WHEN 5 THEN 'QUINCE' 
ELSE 'DIECI' + @lcCadena 
END 
WHEN @lnDecenas = 2 AND @lnUnidades = 0 THEN 'VEINTE' + @lcCadena 
WHEN @lnDecenas = 2 AND @lnUnidades <> 0 THEN 'VEINTI' + @lcCadena 
WHEN @lnDecenas = 3 AND @lnUnidades = 0 THEN 'TREINTA' + @lcCadena 
WHEN @lnDecenas = 3 AND @lnUnidades <> 0 THEN 'TREINTA Y ' + @lcCadena 
WHEN @lnDecenas = 4 AND @lnUnidades = 0 THEN 'CUARENTA' + @lcCadena 
WHEN @lnDecenas = 4 AND @lnUnidades <> 0 THEN 'CUARENTA Y ' + @lcCadena 
WHEN @lnDecenas = 5 AND @lnUnidades = 0 THEN 'CINCUENTA' + @lcCadena 
WHEN @lnDecenas = 5 AND @lnUnidades <> 0 THEN 'CINCUENTA Y ' + @lcCadena 
WHEN @lnDecenas = 6 AND @lnUnidades = 0 THEN 'SESENTA' + @lcCadena 
WHEN @lnDecenas = 6 AND @lnUnidades <> 0 THEN 'SESENTA Y ' + @lcCadena 
WHEN @lnDecenas = 7 AND @lnUnidades = 0 THEN 'SETENTA' + @lcCadena 
WHEN @lnDecenas = 7 AND @lnUnidades <> 0 THEN 'SETENTA Y ' + @lcCadena 
WHEN @lnDecenas = 8 AND @lnUnidades = 0 THEN 'OCHENTA' + @lcCadena 
WHEN @lnDecenas = 8 AND @lnUnidades <> 0 THEN 'OCHENTA Y ' + @lcCadena 
WHEN @lnDecenas = 9 AND @lnUnidades = 0 THEN 'NOVENTA' + @lcCadena 
WHEN @lnDecenas = 9 AND @lnUnidades <> 0 THEN 'NOVENTA Y ' + @lcCadena 
ELSE @lcCadena 
END /* DECENAS */ 

-- Analizo las centenas 
SELECT @lcCadena = 
CASE /* CENTENAS */ 
WHEN @lnCentenas = 1 AND @lnUnidades = 0 AND @lnDecenas = 0 THEN 'CIEN' + 
@lcCadena 
WHEN @lnCentenas = 1 AND NOT(@lnUnidades = 0 AND @lnDecenas = 0) THEN 
'CIENTO ' + @lcCadena 
WHEN @lnCentenas = 2 THEN 'DOSCIENTOS ' + @lcCadena 
WHEN @lnCentenas = 3 THEN 'TRESCIENTOS ' + @lcCadena 
WHEN @lnCentenas = 4 THEN 'CUATROCIENTOS ' + @lcCadena 
WHEN @lnCentenas = 5 THEN 'QUINIENTOS ' + @lcCadena 
WHEN @lnCentenas = 6 THEN 'SEISCIENTOS ' + @lcCadena 
WHEN @lnCentenas = 7 THEN 'SETECIENTOS ' + @lcCadena 
WHEN @lnCentenas = 8 THEN 'OCHOCIENTOS ' + @lcCadena 
WHEN @lnCentenas = 9 THEN 'NOVECIENTOS ' + @lcCadena 
ELSE @lcCadena 
END /* CENTENAS */ 

return CASE WHEN @lcCadena = '' THEN 'CERO' ELSE @lcCadena END
/*
-- Analizo la terna 
SELECT @lcCadena = 
CASE /* TERNA */ 
WHEN @lnTerna = 1 THEN @lcCadena 
WHEN @lnTerna = 2 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) THEN 
@lcCadena + ' MIL ' 
WHEN @lnTerna = 3 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) AND 
@lnUnidades = 1 AND @lnDecenas = 0 AND @lnCentenas = 0 THEN @lcCadena + ' 
MILLON ' 
WHEN @lnTerna = 3 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) AND 
NOT (@lnUnidades = 1 AND @lnDecenas = 0 AND @lnCentenas = 0) THEN @lcCadena 
+ ' MILLONES ' 
WHEN @lnTerna = 4 AND (@lnUnidades + @lnDecenas + @lnCentenas <> 0) THEN 
@lcCadena + ' MIL MILLONES ' 
ELSE '' 
END /* TERNA */ 
-- Armo el retorno terna a terna 
SELECT @lcRetorno = @lcCadena + @lcRetorno 
SELECT @lnTerna = @lnTerna + 1 
END /* WHILE */ 
IF @lnTerna = 1 
SELECT @lcRetorno = 'CERO' 
SELECT RTRIM(@lcRetorno) + ' CON ' + LTRIM(STR(@lnFraccion,2)) + '/100' 
*/
END