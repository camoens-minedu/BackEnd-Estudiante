-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			JUAN TOVAR Y.
--  CREACION:		06/08/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	INSERTA EN EL FORMATO DESCARGADO EXCEL DATA

--  TEST:			EXEC USP_INSTITUCION_SEL_PLAN_ESTUDIOS_INSERTAR_FORMATO_EXCEL 443,3

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_PLAN_ESTUDIOS_INSERTAR_FORMATO_EXCEL]
(
	@ID_INSTITUCION	INT --= 443
	,@ID_CARRERA	INT --= 3
	,@ID_TIPO_ITINERARIO INT --=101
)
AS

BEGIN	--DECLARACION DE VARIABLES	
	DECLARE @TIPO_ITINERARIO	INT = 33
END

BEGIN	--//OBTENER PROGRAMA ESTUDIOS, NIVEL INFORMACION, TIPO ITINERARIO	

	SELECT --'*' as BORRAR --Eliminar
		IdProgramaEstudios =		c.ID_CARRERA
		,ProgramaEstudios =			UPPER(c.NOMBRE_CARRERA)

		,IdNivelFormacion =			nf.ID_NIVEL_FORMACION
		,NivelFormacion =			UPPER(nf.NOMBRE_NIVEL_FORMACION)

		,IdTipoItinerario =			enum.ID_ENUMERADO
		,TipoItinerario =			UPPER(enum.VALOR_ENUMERADO)		
	FROM
		transaccional.carreras_por_institucion cpi
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA
		INNER JOIN maestro.nivel_formacion nf ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO  --c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION	--reemplazoPorVista
		INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
	WHERE --1 = 1 AND
			cpi.ID_INSTITUCION =		@ID_INSTITUCION
		AND cpi.ID_CARRERA =			@ID_CARRERA
		AND enum.ID_TIPO_ENUMERADO =	@TIPO_ITINERARIO
		AND cpi.ID_TIPO_ITINERARIO =	@ID_TIPO_ITINERARIO
		AND cpi.ES_ACTIVO =				1
		--AND c.ESTADO =					1	--reemplazoPorVista
		AND nf.ESTADO =					1
		AND enum.ESTADO =				1

END