-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		14/09/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	SP PARA COMBO ENFOQUE POR MODALIDAD DE ESTUDIO

--  TEST:			EXEC USP_MAESTROS_SEL_ENFOQUE_POR_MODALIDAD 109

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_ENFOQUE_POR_MODALIDAD]
(
	@ID_MODALIDAD_ESTUDIO	INT	
)
AS

SELECT 	
	IdEnfoque = e.ID_ENFOQUE,
	NombreEnfoque = e.NOMBRE_ENFOQUE	
FROM 
	maestro.enfoque e
WHERE
	e.ID_MODALIDAD_ESTUDIO = @ID_MODALIDAD_ESTUDIO
	and ESTADO = 1
GO


