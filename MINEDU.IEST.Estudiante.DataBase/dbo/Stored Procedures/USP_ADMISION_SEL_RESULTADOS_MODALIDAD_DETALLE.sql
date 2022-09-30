/*********************************************************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Listado de resultados de postulantes por tipo de modalidad. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			24/01/2020		MALVA			MODIFICACIÓN DE LA COLUMNA PlanEstudios Y ADICIÓN DE FILTRO @ID_PLAN_ESTUDIO
1.1			29/01/2020		MALVA			SE OBTIENE COLUMNAS NombreInstituto y NombreProcesoAdmision.
1.2			04/06/2020		MALVA			OBTENCIÓN DE NOTA -1 EN CASO EL REGISTRO DE RESULTADO ESTÉ INACTIVO.  
2.0			20/05/2022		JCHAVEZ			OPTIMIZACIÓN DE SCRIPT

  TEST:		USP_ADMISION_SEL_RESULTADOS_MODALIDAD_DETALLE 6418,1807,0,0,0,0,0,1,10
***********************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_RESULTADOS_MODALIDAD_DETALLE]
(
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@ID_MODALIDADES_POR_PROCESO_ADMISION	INT,
	@ID_SEDE_INSTITUCION					INT,
	@ID_CARRERA								INT,
	@ID_TIPO_ITINERARIO						INT,
	@ID_PLAN_ESTUDIO						INT, 
	@ID_TIPO_MODALIDAD						INT,
	@Pagina									int = 1,
	@Registros								int = 10
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @NombreProcesoAdmision VARCHAR(50), @NombreInstituto VARCHAR(50)
	DECLARE @postulantes_por_modalidad TABLE (ID_POSTULANTES_POR_MODALIDAD ID,ID_PERSONA_INSTITUCION ID, ID_TIPOS_MODALIDAD_POR_INSTITUCION ID, ID_TIPO_DOCUMENTO ID, NUMERO_DOCUMENTO_PERSONA CODIGO_LARGO,
											  APELLIDO_PATERNO_PERSONA NOMBRE_CORTO, APELLIDO_MATERNO_PERSONA NOMBRE_CORTO, NOMBRE_PERSONA NOMBRE_CORTO)
	DECLARE @resultados_por_postulante TABLE (ID_POSTULANTES_POR_MODALIDAD ID, ID_OPCIONES_POR_POSTULANTE ID NULL, NOTA_RESULTADO DECIMAL_DOS, ESTADO ESTADO, ID_RESULTADOS_POR_POSTULANTE ID, ES_ACTIVO BOOLEANO)
	DECLARE @opciones_por_postulante TABLE (ID_OPCIONES_POR_POSTULANTE ID,ID_POSTULANTES_POR_MODALIDAD ID, ORDEN NUMERO_ENTERO)

	SELECT
		@NombreProcesoAdmision = NOMBRE_PROCESO_ADMISION,
		@NombreInstituto= mi.NOMBRE_INSTITUCION	--NOMBRE_INSTITUTO
	FROM transaccional.proceso_admision_periodo tpap 
		inner join transaccional.periodos_lectivos_por_institucion tplxi on tpap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tplxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		inner join db_auxiliar.dbo.UVW_INSTITUCION mi on mi.ID_INSTITUCION= tplxi.ID_INSTITUCION
	WHERE tpap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND tpap.ES_ACTIVO=1
	
	INSERT INTO @postulantes_por_modalidad
	SELECT ID_POSTULANTES_POR_MODALIDAD,ppm.ID_PERSONA_INSTITUCION,ID_TIPOS_MODALIDAD_POR_INSTITUCION,
		ID_TIPO_DOCUMENTO,NUMERO_DOCUMENTO_PERSONA,APELLIDO_PATERNO_PERSONA,APELLIDO_MATERNO_PERSONA,NOMBRE_PERSONA
	FROM transaccional.postulantes_por_modalidad ppm
	INNER JOIN maestro.persona_institucion PXI ON PXI.ID_PERSONA_INSTITUCION = ppm.ID_PERSONA_INSTITUCION
	INNER JOIN maestro.persona P ON P.ID_PERSONA = PXI.ID_PERSONA
	INNER JOIN transaccional.modalidades_por_proceso_admision mppa ON ppm.ID_MODALIDADES_POR_PROCESO_ADMISION=mppa.ID_MODALIDADES_POR_PROCESO_ADMISION AND mppa.ES_ACTIVO=1
	INNER JOIN transaccional.proceso_admision_periodo pap ON mppa.ID_PROCESO_ADMISION_PERIODO=pap.ID_PROCESO_ADMISION_PERIODO AND pap.ES_ACTIVO=1
	WHERE ppm.ES_ACTIVO=1 AND pap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND ppm.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION

	INSERT INTO @resultados_por_postulante
	SELECT rpp.ID_POSTULANTES_POR_MODALIDAD,ID_OPCIONES_POR_POSTULANTE,NOTA_RESULTADO,ESTADO,ID_RESULTADOS_POR_POSTULANTE,ES_ACTIVO
	FROM transaccional.resultados_por_postulante rpp
	INNER JOIN @postulantes_por_modalidad ppm ON ppm.ID_POSTULANTES_POR_MODALIDAD = rpp.ID_POSTULANTES_POR_MODALIDAD

	INSERT INTO @opciones_por_postulante
	SELECT ID_OPCIONES_POR_POSTULANTE,opp.ID_POSTULANTES_POR_MODALIDAD,opp.ORDEN
	FROM transaccional.opciones_por_postulante opp
	INNER JOIN @postulantes_por_modalidad ppm ON ppm.ID_POSTULANTES_POR_MODALIDAD = opp.ID_POSTULANTES_POR_MODALIDAD
	WHERE opp.ES_ACTIVO=1

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
	SET @hasta = ( @Pagina * @Registros ) + 1;  

	WITH tempPaginado AS
	(
	SELECT 
			ROW_NUMBER() OVER ( ORDER BY MSI.NOMBRE_SEDE, MC.NOMBRE_CARRERA, pe.NOMBRE_PLAN_ESTUDIOS, se_turno.VALOR_ENUMERADO, MTM.NOMBRE_TIPO_MODALIDAD ASC, RXP.NOTA_RESULTADO DESC ) AS Row,			
			MSI.NOMBRE_SEDE																								NombreSede,	
			MC.NOMBRE_CARRERA																							NombreCarrera,
			pe.NOMBRE_PLAN_ESTUDIOS  + ' (' + se_itin.VALOR_ENUMERADO	+ ')'											PlanEstudios,
			se_turno.VALOR_ENUMERADO																					Turno,
			MTM.NOMBRE_TIPO_MODALIDAD																					NombreTipoModalidad,
			PXM.NUMERO_DOCUMENTO_PERSONA																					NumeroDocumento,
			UPPER(PXM.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(PXM.APELLIDO_MATERNO_PERSONA) + ', ' + dbo.UFN_CAPITALIZAR( PXM.NOMBRE_PERSONA)	Postulante,

			CASE WHEN RXP.ES_ACTIVO = 0 THEN -1 ELSE RXP.NOTA_RESULTADO			END				Nota,

			--CASE
			--	WHEN RXP.NOTA_RESULTADO IS NULL THEN 0
			--	WHEN RXP.NOTA_RESULTADO < 1 THEN 0
			--	WHEN RXP.NOTA_RESULTADO > 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, RXP.NOTA_RESULTADO), 128)
			--END Nota,

			(SELECT VALOR_ENUMERADO FROM sistema.enumerado WHERE ID_ENUMERADO = RXP.ESTADO) Resultado,
			
			--************************************************************************

			ISNULL(RXP.ID_RESULTADOS_POR_POSTULANTE,0)																	IdResultadoPostulante,
			PXM.ID_POSTULANTES_POR_MODALIDAD																			IdPostulanteModalidad,						
			MTM.ID_TIPO_MODALIDAD																						IdTipoModalidad,			
			PXM.ID_TIPO_DOCUMENTO																							IdTipoDocumento,
			TD.VALOR_ENUMERADO																							TipoDocumento,
			se_modal.VALOR_ENUMERADO																					Modalidad,
			ISNULL(RXP.ID_OPCIONES_POR_POSTULANTE,0)																	IdOpcionAlcanzada,	
			@NombreInstituto																							NombreInstituto,	
			@NombreProcesoAdmision																						NombreProcesoAdmision,	
			Total = count(1) OVER ()		
		FROM 
			--transaccional.postulantes_por_modalidad PXM	
			--INNER JOIN maestro.persona_institucion PXI ON PXI.ID_PERSONA_INSTITUCION = PXM.ID_PERSONA_INSTITUCION
			--INNER JOIN maestro.persona P ON P.ID_PERSONA = PXI.ID_PERSONA
			@postulantes_por_modalidad PXM
			INNER JOIN sistema.enumerado TD ON TD.ID_ENUMERADO = PXM.ID_TIPO_DOCUMENTO
			INNER JOIN transaccional.opciones_por_postulante TOPC 
							ON PXM.ID_POSTULANTES_POR_MODALIDAD=TOPC.ID_POSTULANTES_POR_MODALIDAD 
							 AND TOPC.ES_ACTIVO=1
			INNER JOIN transaccional.meta_carrera_institucion_detalle TMCID ON TMCID.ID_META_CARRERA_INSTITUCION_DETALLE= TOPC.ID_META_CARRERA_INSTITUCION_DETALLE 
			INNER JOIN transaccional.meta_carrera_institucion TMCI ON TMCI.ID_META_CARRERA_INSTITUCION= TMCID.ID_META_CARRERA_INSTITUCION
			INNER JOIN maestro.turnos_por_institucion MTI ON MTI.ID_TURNOS_POR_INSTITUCION= TMCI.ID_TURNOS_POR_INSTITUCION
			INNER JOIN maestro.turno_equivalencia MTE ON MTE.ID_TURNO_EQUIVALENCIA= MTI.ID_TURNO_EQUIVALENCIA
			INNER JOIN sistema.enumerado se_turno ON se_turno.ID_ENUMERADO= MTE.ID_TURNO
			INNER JOIN maestro.sede_institucion MSI on MSI.ID_SEDE_INSTITUCION= TMCID.ID_SEDE_INSTITUCION
			INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = TMCI.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion TCI ON TCI.ID_CARRERAS_POR_INSTITUCION= TMCI.ID_CARRERAS_POR_INSTITUCION
			INNER JOIN db_auxiliar.dbo.UVW_CARRERA MC ON MC.ID_CARRERA =TCI.ID_CARRERA
			INNER JOIN sistema.enumerado se_itin on se_itin.ID_ENUMERADO= TCI.ID_TIPO_ITINERARIO
			INNER JOIN maestro.tipos_modalidad_por_institucion MTMI ON MTMI.ID_TIPOS_MODALIDAD_POR_INSTITUCION= PXM.ID_TIPOS_MODALIDAD_POR_INSTITUCION
			INNER JOIN  maestro.tipo_modalidad MTM ON MTM.ID_TIPO_MODALIDAD= MTMI.ID_TIPO_MODALIDAD
			inner join sistema.enumerado se_modal on se_modal.ID_ENUMERADO= MTM.ID_MODALIDAD			
			--LEFT JOIN transaccional.resultados_por_postulante RXP ON RXP.ID_POSTULANTES_POR_MODALIDAD = PXM.ID_POSTULANTES_POR_MODALIDAD			
			LEFT JOIN @resultados_por_postulante RXP ON RXP.ID_POSTULANTES_POR_MODALIDAD = PXM.ID_POSTULANTES_POR_MODALIDAD
			
		WHERE /*PXM.ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION
		AND*/ (MSI.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION or @ID_SEDE_INSTITUCION=0)
		AND(TCI.ID_CARRERA=@ID_CARRERA or @ID_CARRERA=0)
		AND (TCI.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO or @ID_TIPO_ITINERARIO=0)
		--AND TMCID.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION		
		and (MTMI.ID_TIPO_MODALIDAD=@ID_TIPO_MODALIDAD OR @ID_TIPO_MODALIDAD=0)
		AND (pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO OR @ID_PLAN_ESTUDIO =0)
		/*AND TOPC.ID_OPCIONES_POR_POSTULANTE = (	
												CASE WHEN RXP.ID_OPCIONES_POR_POSTULANTE IS NULL 
												THEN 	(SELECT ID_OPCIONES_POR_POSTULANTE FROM transaccional.opciones_por_postulante OXP WHERE ID_POSTULANTES_POR_MODALIDAD = PXM.ID_POSTULANTES_POR_MODALIDAD AND OXP.ORDEN=1 AND OXP.ES_ACTIVO=1)
												ELSE	RXP.ID_OPCIONES_POR_POSTULANTE END 
											)
		*/
		AND TOPC.ID_OPCIONES_POR_POSTULANTE = (	
												CASE WHEN RXP.ID_OPCIONES_POR_POSTULANTE IS NULL 
												THEN 	(SELECT ID_OPCIONES_POR_POSTULANTE FROM @opciones_por_postulante OXP WHERE ID_POSTULANTES_POR_MODALIDAD = PXM.ID_POSTULANTES_POR_MODALIDAD AND OXP.ORDEN=1)
												ELSE	RXP.ID_OPCIONES_POR_POSTULANTE END 
											)

	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 

END
GO


