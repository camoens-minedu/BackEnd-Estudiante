/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	09/07/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene los datos que se muestran en el reporte de ficha de matricula
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			14/01/2020		MALVA			MODIFICACIÓN, SE OBTIENE COLUMNA PlanEstudios
--  TEST:			
/*
	EXEC USP_MATRICULA_RPT_FICHA_MATRICULA 3436, 8045
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_RPT_FICHA_MATRICULA]
(
	@ID_MATRICULA_ESTUDIANTE INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT
)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE
		@ThorasRegular INT,
		@TCreditosRegular decimal(5,1),
		@ThorasNoRegular int,
		@TCreditoNoRegular decimal(5,1)
	select 
		TME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
		TME.ID_ESTUDIANTE_INSTITUCION,
		UD.NOMBRE_UNIDAD_DIDACTICA,
		UD.HORAS,
		UD.CREDITOS,
		PCXME.ID_ESTADO_UNIDAD_DIDACTICA,
		TME.ID_PERIODO_ACADEMICO, 
		TME.ID_SEMESTRE_ACADEMICO,
		PM.ID_TIPO_MATRICULA,
		UD.ID_SEMESTRE_ACADEMICO ID_SEMESTRE_ACADEMICO_UD,
		CASE WHEN PCXME.ID_ESTADO_UNIDAD_DIDACTICA = 170 THEN 'UD_REGULAR'
		ELSE 'UD_REGULAR_NO' END ESTADO_UD
		INTO #TempUnidadesDidacticas
		from transaccional.matricula_estudiante TME
		INNER JOIN transaccional.programacion_clase_por_matricula_estudiante PCXME ON TME.ID_MATRICULA_ESTUDIANTE= PCXME.ID_MATRICULA_ESTUDIANTE AND TME.ES_ACTIVO=1 AND PCXME.ES_ACTIVO=1
		INNER JOIN transaccional.programacion_clase PC ON PC.ID_PROGRAMACION_CLASE = PCXME.ID_PROGRAMACION_CLASE AND PC.ES_ACTIVO=1
		INNER JOIN transaccional.unidades_didacticas_por_programacion_clase UDXPC ON UDXPC.ID_PROGRAMACION_CLASE= PC.ID_PROGRAMACION_CLASE AND UDXPC.ES_ACTIVO=1
		INNER JOIN transaccional.unidades_didacticas_por_enfoque UDXE ON UDXE.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= UDXPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND UDXE.ES_ACTIVO=1
		INNER JOIN transaccional.unidad_didactica UD ON UD.ID_UNIDAD_DIDACTICA=UDXE.ID_UNIDAD_DIDACTICA AND UD.ES_ACTIVO=1		
		INNER JOIN transaccional.programacion_matricula PM ON PM.ID_PROGRAMACION_MATRICULA= TME.ID_PROGRAMACION_MATRICULA AND PM.ES_ACTIVO=1
		where TME.ID_MATRICULA_ESTUDIANTE=@ID_MATRICULA_ESTUDIANTE and TME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION

		SELECT @ThorasRegular = SUM(HORAS), 
		@TCreditosRegular = SUM(CREDITOS) FROM #TempUnidadesDidacticas
		group by ESTADO_UD
		HAVING ESTADO_UD = 'UD_REGULAR'

		SELECT @ThorasNoRegular = SUM(HORAS) ,
		@TCreditoNoRegular = SUM(CREDITOS)   FROM #TempUnidadesDidacticas
		group by ESTADO_UD
		HAVING ESTADO_UD = 'UD_REGULAR_NO'

		SELECT 
		ROW_NUMBER() OVER(PARTITION BY TEMP.ESTADO_UD ORDER BY TEMP.ID_ESTADO_UNIDAD_DIDACTICA ASC, TEMP.ID_SEMESTRE_ACADEMICO_UD ASC ) AS Row2,
		TEI.ID_ESTUDIANTE_INSTITUCION,		
		VISTA_INS.NOMBRE_INSTITUCION, 
		VISTA_INS.DRE_GRE,
		VISTA_INS.CODIGO_MODULAR,		
		E_TG.VALOR_ENUMERADO gestion,
		VISTA_UBI.DEPARTAMENTO_UBIGEO, 
		VISTA_UBI.PROVINCIA_UBIGEO,
		VISTA_UBI.DISTRITO_UBIGEO,
		VISTA_CAR.NOMBRE_CARRERA, 
		PL.CODIGO_PERIODO_LECTIVO,
		NF.NOMBRE_NIVEL_FORMACION, 
		TPA.NOMBRE_PERIODO_ACADEMICO,
		E_TP.VALOR_ENUMERADO tipoPlanEstudios,
		E_CI.VALOR_ENUMERADO ciclo,
		UPPER(P.APELLIDO_PATERNO_PERSONA) + ' '+ UPPER(P.APELLIDO_MATERNO_PERSONA)+ ', ' +  dbo.UFN_CAPITALIZAR( P.NOMBRE_PERSONA) as nomEstudiante,
		P.NUMERO_DOCUMENTO_PERSONA,
		E_TM.VALOR_ENUMERADO tipoMatricula,
		TEI.ARCHIVO_RUTA	foto,
		TEMP.NOMBRE_UNIDAD_DIDACTICA,
		TEMP.HORAS, 
		TEMP.CREDITOS, 
		E_UD.VALOR_ENUMERADO condicion,
		pe.NOMBRE_PLAN_ESTUDIOS	PlanEstudios, 
		ISNULL(@ThorasRegular,0) ThorasRegular, 
		ISNULL(@TCreditosRegular,0) TCreditosRegular,
		ISNULL(@ThorasNoRegular,0) ThorasNoRegular,
		ISNULL(@TCreditoNoRegular,0) TCreditoNoRegular 
		FROM #TempUnidadesDidacticas TEMP
		inner join sistema.enumerado E_UD on E_UD.ID_ENUMERADO= ID_ESTADO_UNIDAD_DIDACTICA
		inner join transaccional.estudiante_institucion TEI ON TEI.ID_ESTUDIANTE_INSTITUCION= TEMP.ID_ESTUDIANTE_INSTITUCION
		inner join transaccional.periodos_lectivos_por_institucion TPLXI ON TPLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= TEMP.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND TEI.ES_ACTIVO=1 AND TPLXI.ES_ACTIVO=1
		inner join db_auxiliar.dbo.UVW_INSTITUCION VISTA_INS on VISTA_INS.ID_INSTITUCION= TPLXI.ID_INSTITUCION 
		left join sistema.enumerado E_TG ON E_TG.ID_ENUMERADO= VISTA_INS.TIPO_GESTION
		inner join db_auxiliar.dbo.UVW_UBIGEO VISTA_UBI on VISTA_UBI.CODIGO_UBIGEO = VISTA_INS.CODIGO_DISTRITO
	    inner join transaccional.carreras_por_institucion_detalle TCID ON TCID.ID_CARRERAS_POR_INSTITUCION_DETALLE= TEI.ID_CARRERAS_POR_INSTITUCION_DETALLE AND TCID.ES_ACTIVO=1
		inner join transaccional.carreras_por_institucion TCI ON TCI.ID_CARRERAS_POR_INSTITUCION= TCID.ID_CARRERAS_POR_INSTITUCION AND TCI.ES_ACTIVO=1
		inner join db_auxiliar.dbo.UVW_CARRERA VISTA_CAR on VISTA_CAR.ID_CARRERA= TCI.ID_CARRERA
		inner join maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO = TPLXI.ID_PERIODO_LECTIVO 
		inner join maestro.nivel_formacion NF ON NF.CODIGO_TIPO= VISTA_CAR.TIPO_NIVEL_FORMACION
		inner join transaccional.periodo_academico TPA ON TPA.ID_PERIODO_ACADEMICO= TEMP.ID_PERIODO_ACADEMICO
		inner join sistema.enumerado E_TP ON E_TP.ID_ENUMERADO= TCI.ID_TIPO_ITINERARIO
		inner join sistema.enumerado E_CI ON E_CI.ID_ENUMERADO= TEMP.ID_SEMESTRE_ACADEMICO
		inner join maestro.persona_institucion PEI ON PEI.ID_PERSONA_INSTITUCION= TEI.ID_PERSONA_INSTITUCION 
		inner join maestro.persona P ON P.ID_PERSONA= PEI.ID_PERSONA
		inner join sistema.enumerado E_TM ON E_TM.ID_ENUMERADO = TEMP.ID_TIPO_MATRICULA
		INNER JOIN transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = TEI.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO=1
		DROP TABLE #TempUnidadesDidacticas
END


--********************************************************
--54. USP_MATRICULA_INS_LICENCIA_ESTUDIANTE.sql
GO


