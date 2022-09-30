/*********************************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Retorna los datos de un enumerado.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2021		JCHAVEZ         CREACIÓN

TEST:			
	EXEC USP_MAESTROS_SEL_ENUMERADO_ID 35
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_ENUMERADO_ID]
 @ID_ENUMERADO INT
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT 
		e.ID_ENUMERADO IdEnumerado,
		e.ID_TIPO_ENUMERADO IdTipoEnumerado,
		e.CODIGO_ENUMERADO CodigoEnumerado,
		e.VALOR_ENUMERADO ValorEnumerado
	FROM sistema.enumerado e
	WHERE e.ID_ENUMERADO = @ID_ENUMERADO
	ORDER BY 1
END