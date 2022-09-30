/*
-- ==================================================================================================
-- Autor			: MDIAZP
-- Creación			: 2016-10-26 12:19:07
-- Base de Datos	: db_regia
-- Descripcion		: Retorna la ruta del servidor de archivos para la aplicación
-- Invocado desde	: Med.REGIA.Datos.Modelo =>UnitOfWorkRegia = > UFN_RUTA_BASE_ARCHIVOS
*******************************************************************************************************************************
-- PARA CALIDAD	: Modificar la raiz "\\10.200.2.40\FILESYSTEM\regia\" con la ruta que nos brinden con el archivo compartido
*******************************************************************************************************************************
-- Actualización	: 
-- TEST				:

-- ==================================================================================================
*/

CREATE FUNCTION [dbo].[UFN_RUTA_BASE_ARCHIVOS] ()
RETURNS varchar(100)
AS
    BEGIN		
			--RETURN '\\10.200.4.164\Registra\P\';			
    	 RETURN '\\10.1.1.74\FileSystem\Fabrica\Regia\dev\';		
	
	END;