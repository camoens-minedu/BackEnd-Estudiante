
--/*************************************************************************************************************************************************
--AUTOR				    :	Jose Alvaro Del Castillo  Aquino
--FECHA DE CREACION	    :	21/09/2020
--LLAMADO POR			:
--DESCRIPCION			:	Listado de enumerados
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------

--**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_ENUMERADO_TIPOS] (   
   @ID_TIPO_ENUMERADOS	NVARCHAR(MAX)
)AS 
BEGIN
SELECT 
	ID_ENUMERADO		IdEnumerado,
	ID_TIPO_ENUMERADO	IdTipoEnumerado,
	CODIGO_ENUMERADO	CodigoEnumerado,
	VALOR_ENUMERADO		ValorEnumerado,
	ORDEN_ENUMERADO		OrdenEnumerado 
FROM sistema.enumerado 
WHERE 
     ID_TIPO_ENUMERADO IN(
	                      SELECT * 
	                      FROM  dbo.UFN_SPLIT(@ID_TIPO_ENUMERADOS,',')  
						  )  
	 AND ESTADO = 1 
END
GO


