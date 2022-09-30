﻿CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PERIODO_ACADEMICO_LISTA]
(  
--@ID_INSTITUCION INT,
--@ID_PERIODO_LECTIVO INT
@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
--SELECT 
--	NOMBRE_PERIODO_ACADEMICO Text, 
--	ID_PERIODO_ACADEMICO Value
--FROM transaccional.periodo_academico tpa
--inner join transaccional.periodos_lectivos_por_institucion tpli on tpa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
--WHERE tpli.ID_INSTITUCION=@ID_INSTITUCION and ID_PERIODO_LECTIVO =@ID_PERIODO_LECTIVO

SELECT	
	NOMBRE_PERIODO_ACADEMICO Text,
	ID_PERIODO_ACADEMICO Value
FROM
	transaccional.periodo_academico 
WHERE 
	ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
	AND ES_ACTIVO = 1

END
GO


