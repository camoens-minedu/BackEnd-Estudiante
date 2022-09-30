/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el detalle de metas
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			17/01/2020		MALVA			SE AÑADEN FILTROS @ID_SEDE_INSTITUCION, @ID_CARRERA Y @ID_TIPO_ITINERARIO.
--											SE OBTIENEN COLUMNAS IdCarrera, IdTipoPlanEstudio,TipoPlanEstudios, IdPlanEstudio y PlanEstudios.
--											SE CONSIDERA OTRA FORMA DE CONSULTA A UVW_CARRERA. 
--  TEST:			
/*
exec dbo.USP_ADMISION_SEL_META_CARRERA_INSTITUCION_DETALLE 10319, 4221, 1101, 101
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_META_CARRERA_INSTITUCION_DETALLE]
(
	@ID_PERIODO_LECTIVO_INSTITUCION INT,
	@ID_SEDE_INSTITUCION			INT, 
	@ID_CARRERA						INT,
	@ID_TIPO_ITINERARIO				INT
)AS	

BEGIN

SELECT A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
		C.ID_SEDE_INSTITUCION					IdSedeInstitucion,
		C.NOMBRE_SEDE							SedeInstitucion,
		vc.ID_CARRERA							IdCarrera,
	    vc.NOMBRE_CARRERA						NombreCarrera,
		pe.ID_TIPO_ITINERARIO					IdTipoPlanEstudio,
		ti.VALOR_ENUMERADO						TipoPlanEstudios,
		pe.ID_PLAN_ESTUDIO						IdPlanEstudio,
		pe.NOMBRE_PLAN_ESTUDIOS					PlanEstudios,
		G.ID_ENUMERADO							IdTurno,
		G.VALOR_ENUMERADO						Turno,
		A.ID_META_CARRERA_INSTITUCION_DETALLE	IdMetaCarreraInstitucionDetalle
	
	
	FROM 
		transaccional.meta_carrera_institucion_detalle A
		INNER JOIN transaccional.meta_carrera_institucion B ON A.ID_META_CARRERA_INSTITUCION = B.ID_META_CARRERA_INSTITUCION and B.ES_ACTIVO=1
		INNER JOIN maestro.sede_institucion C ON A.ID_SEDE_INSTITUCION = C.ID_SEDE_INSTITUCION
		---INNER JOIN UVW_CARRERA D ON D.ID_CARRERAS_POR_INSTITUCION = B.ID_CARRERAS_POR_INSTITUCION
		INNER JOIN transaccional.carreras_por_institucion ci ON ci.ID_CARRERAS_POR_INSTITUCION = B.ID_CARRERAS_POR_INSTITUCION AND ci.ES_ACTIVO=1
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA vc on vc.ID_CARRERA = ci.ID_CARRERA
		INNER JOIN maestro.turnos_por_institucion E ON E.ID_TURNOS_POR_INSTITUCION = B.ID_TURNOS_POR_INSTITUCION
		INNER JOIN maestro.turno_equivalencia F ON F.ID_TURNO_EQUIVALENCIA = E.ID_TURNO_EQUIVALENCIA
		INNER JOIN sistema.enumerado G ON G.ID_ENUMERADO = F.ID_TURNO
		INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = B.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO=1
		INNER JOIN sistema.enumerado ti ON ti.ID_ENUMERADO = pe.ID_TIPO_ITINERARIO 
	WHERE
		A.ES_ACTIVO = 1
		AND A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
		AND A.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION
		AND vc.ID_CARRERA = @ID_CARRERA
		AND pe.ID_TIPO_ITINERARIO =@ID_TIPO_ITINERARIO
END

--****************************************************************************************************************
--73. USP_ADMISION_INS_RESULTADOS_MODALIDAD.sql
GO


