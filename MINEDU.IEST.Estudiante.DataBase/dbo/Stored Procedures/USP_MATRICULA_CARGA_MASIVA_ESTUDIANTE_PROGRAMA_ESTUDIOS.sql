-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		13/05/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	INSERTA EN EL FORMATO DESCARGADO EXCEL DE CARGA MASIVA ESTUDIANTE PROGRAMA DE ESTUDIOS

--  TEST:			
/*
EXEC USP_MATRICULA_CARGA_MASIVA_ESTUDIANTE_PROGRAMA_ESTUDIOS 443
*/
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_MATRICULA_CARGA_MASIVA_ESTUDIANTE_PROGRAMA_ESTUDIOS]
(
	@ID_INSTITUCION INT
)
AS

BEGIN	

	BEGIN   --> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS 
		IF (OBJECT_ID('tempdb.dbo.#temporal01','U')) IS NOT NULL DROP TABLE #temporal01
	END

	BEGIN	--> LISTADO DE SEDE x CURSOS x PLAN DE ESTUDIOS

			SELECT DISTINCT
				sed.IdSedeInstitucion,			
				------------------------

				UPPER(sed.TipoLocal) + ' - ' + UPPER(sed.NombreRef)	AS Sede
				,UPPER(mc.NOMBRE_CARRERA)								AS NombreCarrera
				,UPPER(se_itin.VALOR_ENUMERADO)							AS NombrePlanEstudios
			FROM 	
				transaccional.carreras_por_institucion tci
				INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tci.ID_CARRERAS_POR_INSTITUCION= tcid.ID_CARRERAS_POR_INSTITUCION and tci.ES_ACTIVO=1 AND tcid.ES_ACTIVO=1 
				INNER JOIN sistema.enumerado se_itin on se_itin.ID_ENUMERADO= tci.ID_TIPO_ITINERARIO
				LEFT JOIN transaccional.plan_estudio tpe on tpe.ID_CARRERAS_POR_INSTITUCION= tci.ID_CARRERAS_POR_INSTITUCION and tpe.ES_ACTIVO=1
				INNER JOIN UVW_SEDE sed ON sed.IdSedeInstitucion = tcid.ID_SEDE_INSTITUCION
				INNER JOIN db_auxiliar.dbo.UVW_CARRERA mc ON tci.ID_CARRERA= mc.ID_CARRERA
			WHERE 
				tci.ID_INSTITUCION=@ID_INSTITUCION  AND tci.ESTADO = 1			
			ORDER BY IdSedeInstitucion, NombreCarrera
	END

END
GO


