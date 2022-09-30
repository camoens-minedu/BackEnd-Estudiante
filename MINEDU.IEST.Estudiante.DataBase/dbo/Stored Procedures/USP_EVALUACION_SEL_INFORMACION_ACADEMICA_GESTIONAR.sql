/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	16/02/2022
LLAMADO POR			:
DESCRIPCION			:	Lista de las unidades didácticas y notas por plan de estudio
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			16/02/2022		JTOVAR			CREACIÓN
2.0			20/05/2022		JCHAVEZ			CORRECCIÓN DE SCRIPT PARA EVITAR DUPLICIDAD CUANDO TIENE VARIAS MATRICULAS

TEST:  
	USP_EVALUACION_SEL_INFORMACION_ACADEMICA_GESTIONAR 7843,45093,3
	USP_EVALUACION_SEL_INFORMACION_ACADEMICA_GESTIONAR 4139,137928,9
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_INFORMACION_ACADEMICA_GESTIONAR]
(
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT,
	@ID_ESTUDIANTE_INSTITUCION INT,
	@ID_EVALUACION_EXTRAORDINARIA INT
)
AS
BEGIN
SET NOCOUNT ON;
	
	DECLARE @ID_INSTITUCION INT = (SELECT ID_INSTITUCION FROM transaccional.periodos_lectivos_por_institucion WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
	DECLARE @NOTA_APROBATORIA INT = (SELECT VALOR_PARAMETRO FROM maestro.parametros_institucion WHERE ID_INSTITUCION=@ID_INSTITUCION AND NOMBRE_PARAMETRO='NOTA_MINIMA_APROBATORIA')
	
	SELECT 
		eins.ID_ESTUDIANTE_INSTITUCION IdEstudianteInstitucion,
		ud.ID_UNIDAD_DIDACTICA IdUnidadDidactica,
		ud.NOMBRE_UNIDAD_DIDACTICA NombreUnidadDidactica,
		ud.ID_SEMESTRE_ACADEMICO IdSemestreAcademico,
		enu_sem.VALOR_ENUMERADO SemestreAcademico,
		@NOTA_APROBATORIA NotaRegular,
		eexd.NOTA Nota,
		pe.ID_PLAN_ESTUDIO IdPlanEstudios,
		pe.NOMBRE_PLAN_ESTUDIOS NombrePlanEstudios,
		pe.ID_TIPO_ITINERARIO IdTipoItinerario,
		enu_ti.VALOR_ENUMERADO TipoItinerario,
		c.ID_CARRERA IdProgramaEstudios,
		c.NOMBRE_CARRERA ProgramaEstudios,
		c.NIVEL_FORMACION NivelFormacion,
		eex.ID_EVALUACION_EXTRAORDINARIA IdEvaluacionExtraordinaria,
		eexd.ID_EVALUACION_EXTRAORDINARIA_DETALLE IdEvaluacionExtraordinariaDetalle,
		(CASE WHEN eexd.ID_EVALUACION_EXTRAORDINARIA_DETALLE IS NOT NULL THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END) EsMatriculado,
		ROW_NUMBER() OVER ( ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.ID_UNIDAD_DIDACTICA) AS Row,
	    Total = COUNT(1) OVER ( )
	FROM transaccional.estudiante_institucion eins
	INNER JOIN transaccional.carreras_por_institucion_detalle cpid ON cpid.ID_CARRERAS_POR_INSTITUCION_DETALLE = eins.ID_CARRERAS_POR_INSTITUCION_DETALLE AND cpid.ES_ACTIVO=1
	INNER JOIN transaccional.carreras_por_institucion cpi ON cpi.ID_CARRERAS_POR_INSTITUCION = cpid.ID_CARRERAS_POR_INSTITUCION AND cpi.ES_ACTIVO=1
	INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON c.ID_CARRERA = cpi.ID_CARRERA
	INNER JOIN transaccional.plan_estudio pe ON eins.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO
	INNER JOIN transaccional.modulo m ON m.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1
	INNER JOIN transaccional.unidad_didactica ud ON ud.ID_MODULO = m.ID_MODULO AND m.ES_ACTIVO=1
	INNER JOIN sistema.enumerado enu_sem ON ud.ID_SEMESTRE_ACADEMICO=enu_sem.ID_ENUMERADO
	INNER JOIN sistema.enumerado enu_ti ON pe.ID_TIPO_ITINERARIO=enu_ti.ID_ENUMERADO
	--LEFT JOIN transaccional.matricula_estudiante me ON me.ID_ESTUDIANTE_INSTITUCION = eins.ID_ESTUDIANTE_INSTITUCION AND me.ES_ACTIVO=1
	--LEFT JOIN transaccional.evaluacion e ON e.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA AND e.ES_ACTIVO=1
	--LEFT JOIN transaccional.evaluacion_detalle ed ON ed.ID_MATRICULA_ESTUDIANTE = me.ID_MATRICULA_ESTUDIANTE AND e.ID_EVALUACION = ed.ID_EVALUACION AND ed.ES_ACTIVO=1 AND ed.NOTA>=@NOTA_APROBATORIA
	LEFT JOIN transaccional.evaluacion_extraordinaria eex ON eex.ID_ESTUDIANTE_INSTITUCION = eins.ID_ESTUDIANTE_INSTITUCION AND eex.ES_ACTIVO=1
	LEFT JOIN transaccional.evaluacion_extraordinaria_detalle eexd ON eexd.ID_EVALUACION_EXTRAORDINARIA = eex.ID_EVALUACION_EXTRAORDINARIA AND eexd.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA AND eexd.ES_ACTIVO=1
	WHERE eins.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION 
		AND ud.ID_UNIDAD_DIDACTICA NOT IN ( 
											SELECT udxe.ID_UNIDAD_DIDACTICA --NO MOSTRAR UNIDADES DIDÁCTICAS MATRICULADAS QUE HAYAN TENIDO NOTAS EN PERIODOS ANTERIORES
											FROM transaccional.matricula_estudiante me
											INNER JOIN transaccional.programacion_clase_por_matricula_estudiante pcxme ON pcxme.ID_MATRICULA_ESTUDIANTE = me.ID_MATRICULA_ESTUDIANTE AND pcxme.ES_ACTIVO=1
											INNER JOIN transaccional.unidades_didacticas_por_programacion_clase udxpc ON udxpc.ID_PROGRAMACION_CLASE = pcxme.ID_PROGRAMACION_CLASE AND udxpc.ES_ACTIVO=1
											INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe ON udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = udxpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND udxe.ES_ACTIVO=1
											INNER JOIN transaccional.evaluacion e ON pcxme.ID_PROGRAMACION_CLASE=e.ID_PROGRAMACION_CLASE AND e.ID_UNIDAD_DIDACTICA = udxe.ID_UNIDAD_DIDACTICA AND e.ES_ACTIVO=1
											INNER JOIN transaccional.evaluacion_detalle ed ON ed.ID_MATRICULA_ESTUDIANTE = me.ID_MATRICULA_ESTUDIANTE AND e.ID_EVALUACION = ed.ID_EVALUACION AND ed.ES_ACTIVO=1 AND ed.NOTA>=@NOTA_APROBATORIA
											WHERE me.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION
												AND me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION<>@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
												AND me.ES_ACTIVO=1
											UNION ALL
											SELECT udxe.ID_UNIDAD_DIDACTICA --NO MOSTRAR UNIDADES DIDÁCTICAS MATRICULADAS EN EL PRESENTE PERIODO LECTIVOMO
											FROM transaccional.matricula_estudiante me_act
											INNER JOIN transaccional.programacion_clase_por_matricula_estudiante pcxme ON pcxme.ID_MATRICULA_ESTUDIANTE = me_act.ID_MATRICULA_ESTUDIANTE AND pcxme.ES_ACTIVO=1
											INNER JOIN transaccional.unidades_didacticas_por_programacion_clase udxpc ON udxpc.ID_PROGRAMACION_CLASE = pcxme.ID_PROGRAMACION_CLASE AND udxpc.ES_ACTIVO=1
											INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe ON udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = udxpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND udxe.ES_ACTIVO=1
											WHERE me_act.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION
												AND me_act.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
												AND me_act.ES_ACTIVO=1
											UNION ALL
											SELECT udxe.ID_UNIDAD_DIDACTICA --NO MOSTRAR UNIDADES DIDÁCTICAS QUE TENGAN NOTA APROBATORIA DE EXPERIENCIA FORMATIVA
											FROM transaccional.evaluacion_experiencia_formativa eef
											INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe ON eef.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE=udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND udxe.ES_ACTIVO=1
											INNER JOIN transaccional.matricula_estudiante me ON me.ID_MATRICULA_ESTUDIANTE=eef.ID_MATRICULA_ESTUDIANTE
											WHERE me.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION
												AND eef.NOTA>=@NOTA_APROBATORIA AND eef.ES_ACTIVO=1
											UNION ALL
											SELECT eexd.ID_UNIDAD_DIDACTICA --NO MOSTRAR UNIDADES DIDÁCTICAS QUE TENGAN NOTA APROBATORIA DE EVALUACIÓN EXTRAORDINARIA
											FROM transaccional.estudiante_institucion eins
											INNER JOIN transaccional.evaluacion_extraordinaria eex ON eins.ID_ESTUDIANTE_INSTITUCION = eex.ID_ESTUDIANTE_INSTITUCION AND eex.ES_ACTIVO=1
											INNER JOIN transaccional.evaluacion_extraordinaria_detalle eexd ON eexd.ID_EVALUACION_EXTRAORDINARIA = eex.ID_EVALUACION_EXTRAORDINARIA AND eexd.ES_ACTIVO=1
											WHERE eex.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION
												AND eexd.NOTA>=@NOTA_APROBATORIA AND eins.ES_ACTIVO=1 
												AND eex.ID_EVALUACION_EXTRAORDINARIA <> @ID_EVALUACION_EXTRAORDINARIA
											)
	ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.ID_UNIDAD_DIDACTICA
END