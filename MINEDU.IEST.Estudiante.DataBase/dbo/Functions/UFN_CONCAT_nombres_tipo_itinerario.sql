-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		13/09/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	FUNCION QUE OBTIENE EL CONCATENADO DE LOS NOMBRES DE LOS TIPOS DE ITINERARIOS

--  TEST:			SELECT dbo.UFN_CONCAT_nombres_tipo_itinerario(33)

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[UFN_CONCAT_nombres_tipo_itinerario] (@codigo INT)
RETURNS varchar(100)
AS
BEGIN
	DECLARE @out	VARCHAR(300) --= ''

	/******************************************************************/
	
		SELECT 			 
			 @out = COALESCE(@out+'|' ,'') + UPPER(enum.VALOR_ENUMERADO) + '=' + UPPER(enum.ID_ENUMERADO)
		FROM 
			sistema.enumerado enum
		WHERE 
			enum.ID_TIPO_ENUMERADO = @codigo --33

	/******************************************************************/

	RETURN @out						
END