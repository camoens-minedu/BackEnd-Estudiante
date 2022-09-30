-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		22/05/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	OBTIENE LISTADO DE REGION X DISTRITO X PROVINCIA

--  TEST:			
/*
EXEC USP_MATRICULA_CARGA_MASIVA_ESTUDIANTE_RESIDENCIA
*/
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_MATRICULA_CARGA_MASIVA_ESTUDIANTE_RESIDENCIA]

AS

BEGIN		

	BEGIN	--> LISTADO DE REGION x PROVINCIA x DISTRITO

		SELECT
		Departamento	= DEPARTAMENTO_UBIGEO,
		Provincia		= PROVINCIA_UBIGEO,
		Distrito		= DISTRITO_UBIGEO
		FROM db_auxiliar.dbo.UVW_UBIGEO_RENIEC
		ORDER BY DEPARTAMENTO_UBIGEO ASC, PROVINCIA_UBIGEO ASC, DISTRITO_UBIGEO ASC

	END

END
GO


