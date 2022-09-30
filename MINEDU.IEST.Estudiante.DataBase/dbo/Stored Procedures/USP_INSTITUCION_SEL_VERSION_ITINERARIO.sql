/**********************************************************************************************************
AUTOR				:	Luis Espinoza
FECHA DE CREACION	:	27/02/2021
LLAMADO POR			:
DESCRIPCION			:	Selecciona los registro de tipos de planes de estudio de una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:  
--			USP_TRANSACCIONAL_DEL_PAGO 1106, 1061, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_VERSION_ITINERARIO]
(
	@ID_TIPO INT,
	@ID_INSTITUCION INT
)
AS

IF @ID_TIPO = 206

		 SELECT DISTINCT 
			ID_ENUMERADO    IdTipoItinerario,
			VALOR_ENUMERADO TipoItinerario
		 FROM 
			transaccional.carreras_por_institucion cpi
			INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION	= pe.ID_CARRERAS_POR_INSTITUCION
			LEFT JOIN sistema.enumerado se on cpi.ID_TIPO_ITINERARIO = se.ID_ENUMERADO
			where cpi.ID_INSTITUCION = @ID_INSTITUCION

ELSE
BEGIN
   IF @ID_TIPO = 207
      
		SELECT DISTINCT 
			ID_ENUMERADO    IdTipoItinerario,
			VALOR_ENUMERADO TipoItinerario
		FROM 
			transaccional.carreras_por_institucion cpi
			INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION	= pe.ID_CARRERAS_POR_INSTITUCION
			LEFT JOIN sistema.enumerado se on cpi.ID_TIPO_ITINERARIO = se.ID_ENUMERADO
			where cpi.ID_INSTITUCION = @ID_INSTITUCION AND se.ID_ENUMERADO IN (100,101)
   
   ELSE
      SELECT
		 ID_ENUMERADO    IdTipoItinerario,
		 VALOR_ENUMERADO TipoItinerario
		 FROM
		 sistema.enumerado 
		 WHERE ID_TIPO_ENUMERADO=1000
  

END;
GO


