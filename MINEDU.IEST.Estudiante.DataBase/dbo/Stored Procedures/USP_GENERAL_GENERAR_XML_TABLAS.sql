/*
-- ==================================================================================================
-- Autor			: MDIAZP
-- Creación			: 2016-10-25 11:57:36
-- Base de Datos	: db_regia
-- Descripcion		: Lista tablas que seran generadas en XML para la capa de aplicación
-- Invocado desde	: Med.REGIA.Datos.Modelo => UnitOfWorkRegiaXml => DataXmlTablas

-- Actualización	: 
-- TEST				:
					EXEC dbo.USP_GENERAL_GENERAR_XML_TABLAS
-- ==================================================================================================
*/

CREATE PROCEDURE [dbo].[USP_GENERAL_GENERAR_XML_TABLAS]
AS
BEGIN
	SET NOCOUNT ON;
		
	SELECT 
	    Value = tx.ID_TABLA_XML,
	    Text = tx.SQL_TABLAS_XML
	FROM sistema.tabla_xml tx
	WHERE tx.ES_VIGENTE = 1;	
		
END
GO


