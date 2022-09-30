--/*********************************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Listado de metas por sedes de institución
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--	1.0			24/01/2020		MALVA			MODIFICACIÓN DE LA COLUMNA PlanEstudios
--*/
--  TEST:		USP_ADMISION_SEL_META_CARRERA_INSTITUCION_DETALLE_PAGINADO 2027,0,565,1,10
--***********************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_META_CARRERA_INSTITUCION_DETALLE_PAGINADO]
(
	@ID_INSTITUCION INT,
	@ID_SEDE_INSTITUCION INT,
	@ID_PERIODO_LECTIVO_INSTITUCION INT,
	@Pagina					INT = 1,
	@Registros				INT = 10
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1;  

	WITH    tempPaginado AS
	(	   
		SELECT	MCID.ID_META_CARRERA_INSTITUCION_DETALLE							IdMetaCarreraInstitucionDetalle,
				MCI.ID_META_CARRERA_INSTITUCION										IdMetaCarreraInstitucion,
				MCI.ID_CARRERAS_POR_INSTITUCION										IdCarreraInstitucion,
				MCI.ID_TURNOS_POR_INSTITUCION										IdTurno,
				T.VALOR_ENUMERADO													Turno,
				SI.ID_SEDE_INSTITUCION												IdSedeInstitucion,
				SE_ITIN.ID_ENUMERADO												IdTipoItinerario,					
				pe.ID_PLAN_ESTUDIO													IdPlanEstudio,			
				pe.NOMBRE_PLAN_ESTUDIOS												NombrePlan,
				pe.NOMBRE_PLAN_ESTUDIOS + ' (' + SE_ITIN.VALOR_ENUMERADO	+')'	PlanEstudios,				
				(ETipoSede.VALOR_ENUMERADO + ' - ' + SI.NOMBRE_SEDE)				SedeInstitucion,
				MC.NOMBRE_CARRERA													NombreCarrera,
				MCID.META_SEDE														MetaLocal,
				ROW_NUMBER() OVER ( ORDER BY MCID.ID_META_CARRERA_INSTITUCION_DETALLE) AS Row,
				Total = COUNT(1) OVER ( )
		FROM	transaccional.meta_carrera_institucion_detalle MCID
				INNER JOIN transaccional.meta_carrera_institucion MCI ON MCI.ID_META_CARRERA_INSTITUCION = MCID.ID_META_CARRERA_INSTITUCION AND MCI.ES_ACTIVO = 1
				INNER JOIN maestro.sede_institucion SI ON SI.ID_SEDE_INSTITUCION = MCID.ID_SEDE_INSTITUCION AND SI.ESTADO = 1				
				INNER JOIN transaccional.carreras_por_institucion TCI on TCI.ID_CARRERAS_POR_INSTITUCION= MCI.ID_CARRERAS_POR_INSTITUCION				
				INNER JOIN transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = MCI.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO=1
				INNER JOIN db_auxiliar.dbo.UVW_CARRERA MC on MC.ID_CARRERA= TCI.ID_CARRERA	
				INNER JOIN sistema.enumerado SE_ITIN ON SE_ITIN.ID_ENUMERADO= TCI.ID_TIPO_ITINERARIO
				INNER JOIN maestro.turnos_por_institucion TXI ON TXI.ID_TURNOS_POR_INSTITUCION = MCI.ID_TURNOS_POR_INSTITUCION AND TXI.ES_ACTIVO = 1
				INNER JOIN maestro.turno_equivalencia TE ON TE.ID_TURNO_EQUIVALENCIA = TXI.ID_TURNO_EQUIVALENCIA AND TE.ESTADO = 1
				INNER JOIN sistema.enumerado T ON T.ID_ENUMERADO = TE.ID_TURNO AND T.ESTADO = 1
				INNER JOIN sistema.enumerado ETipoSede on ETipoSede.ID_ENUMERADO= SI.ID_TIPO_SEDE
		WHERE	TCI.ID_INSTITUCION = @ID_INSTITUCION
				AND (MCID.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION = 0)
				AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
				AND MCID.ES_ACTIVO = 1
	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END

--****************************************************
--32. USP_ADMISION_SEL_META_CARRERA_INSTITUCION_DETALLE.sql
GO


