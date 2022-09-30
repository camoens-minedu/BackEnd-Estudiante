-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		06/08/2018
--  ACTUALIZACION:	17/09/2019
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	OBTENER PROGRAMA DE ESTUDIOS E ITINERARIOS

--  TEST:			EXEC USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_INSTITUCION 443

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_INSTITUCION]
(
	@ID_INSTITUCION	INT
)
AS

SELECT 
	IdTipoItinerario = cpi.ID_TIPO_ITINERARIO,
	IdCarrera = cpi.ID_CARRERA,
	NombreCarrera = car.NOMBRE_CARRERA	
FROM 
	transaccional.carreras_por_institucion cpi	
	INNER JOIN db_auxiliar.dbo.UVW_CARRERA car ON cpi.ID_CARRERA = car.ID_CARRERA AND cpi.ES_ACTIVO=1 
WHERE
	cpi.ID_INSTITUCION = @ID_INSTITUCION
GO


