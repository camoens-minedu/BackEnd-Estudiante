CREATE FUNCTION [dbo].[UFN_CST_numero_romano] (@Number INT)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @RomanNumeral AS NVARCHAR(100)
DECLARE @RomanSystem TABLE (symbol NVARCHAR(20) 
                            COLLATE SQL_Latin1_General_CP850_BIN ,
                            DecimalValue INT PRIMARY KEY)
IF @Number < 0
	RETURN 'No se puede castear números negativos'
IF @Number = 0
	RETURN '0'
IF @Number > 399
	RETURN 'Numero no soportado'
INSERT  INTO @RomanSystem (symbol, DecimalValue) 
SELECT  'I' AS symbol, 1 AS DecimalValue
UNION ALL SELECT  'IV', 4 
UNION ALL SELECT  'V', 5 
UNION ALL SELECT  'IX', 9 
UNION ALL SELECT  'X', 10 
UNION ALL SELECT  'XL', 40
UNION ALL SELECT  'L', 50
UNION ALL SELECT  'XC', 90
UNION ALL SELECT  'C', 100 

WHILE @Number > 0 
    SELECT  @RomanNumeral = COALESCE(@RomanNumeral, '') + symbol, 
            @Number = @Number - DecimalValue 
    FROM    @RomanSystem 
    WHERE   DecimalValue = (SELECT  MAX(DecimalValue) 
                            FROM    @RomanSystem 
                            WHERE   DecimalValue <= @Number) 
RETURN COALESCE(@RomanNumeral,'0') 

END