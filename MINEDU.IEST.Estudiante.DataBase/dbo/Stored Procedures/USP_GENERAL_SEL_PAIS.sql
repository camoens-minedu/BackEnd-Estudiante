
/******************************************************************************************************   
   AUTOR				   :	
   FECHA DE CREACIÓN	   :	-
   LLAMADO POR			   :	APP REGIA
   DESCRIPCIÓN			   :	
   REVISIONES			   :
   ----------------------------------------------------------------------------------------------------
   VERSIÓN	FECHA MODIF.	USUARIO				DESCRIPCIÓN
   ----------------------------------------------------------------------------------------------------
   1.0.0	    -		    				    Creación


   TEST			:
   ---------------------------------------------------------------------------------------------------
   Grilla

    EXEC 
	
   ******************************************************************************************************/
   
CREATE PROCEDURE  [dbo].[USP_GENERAL_SEL_PAIS]
AS
BEGIN

	SELECT ISNULL(CAST(SUBSTRING(CODIGO, 1, 5) AS int), 0) AS Value, ISNULL(CAST(SUBSTRING(CODIGO, 1, 5) AS int), 0) AS Code, up.DSCPAIS AS [Text], '1' AS Orden INTO #Paises
	FROM db_auxiliar.dbo.UVW_PAIS up	

UPDATE #Paises
    SET  #Paises.Orden='0'
where #Paises.[Value]=92330

SELECT P.[Value], P.Code, P.Text FROM #Paises P ORDER BY P.Orden, P.Text
--DROP TABLE #Paises
END
GO


