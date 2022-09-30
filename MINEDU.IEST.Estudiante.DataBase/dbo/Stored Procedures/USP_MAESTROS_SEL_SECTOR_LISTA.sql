CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_SECTOR_LISTA]
AS  
SELECT   
 NOMBRE_SECTOR Text,  
 ID_SECTOR Value,  
 ID_SECTOR Code  
FROM   
 maestro.sector
GO


