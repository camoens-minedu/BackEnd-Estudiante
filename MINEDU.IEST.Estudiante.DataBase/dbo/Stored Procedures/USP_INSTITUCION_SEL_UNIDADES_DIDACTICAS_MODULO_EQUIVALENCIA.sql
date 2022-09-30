/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	10/03/2022
LLAMADO POR			:
DESCRIPCION			:	Lista las unidades didácticas disponibles o asociadas a un módulo equivalente
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			10/03/2022		JCHAVEZ			Creación

TEST:  
	USP_INSTITUCION_SEL_UNIDADES_DIDACTICAS_MODULO_EQUIVALENCIA 4048,14,1
**********************************************************************************************************/
CREATE PROCEDURE [dbo].USP_INSTITUCION_SEL_UNIDADES_DIDACTICAS_MODULO_EQUIVALENCIA
 @ID_PLAN_ESTUDIO INT,
 @ID_MODULO_EQUIVALENCIA INT,
 @MOSTRAR_UD_DISPONIBLES BIT
AS
BEGIN
	SELECT 
		pe.ID_PLAN_ESTUDIO IdPlanEstudio,
		pe.ID_TIPO_ITINERARIO IdTipoItinerario,
		pe.NOMBRE_PLAN_ESTUDIOS NombrePlanEstudios,
		m.ID_MODULO IdModulo,
		m.NOMBRE_MODULO NombreModulo,
		--m.TOTAL_HORAS_UD TotalHoras,
		--m.TOTAL_CREDITOS_UD TotalCreditos,
		ud.ID_UNIDAD_DIDACTICA IdUnidadDidactica,
		ud.CODIGO_UNIDAD_DIDACTICA Codigo,
		ud.ID_TIPO_UNIDAD_DIDACTICA IdTipoUnidadDidactica,
		tud.NOMBRE_TIPO_UNIDAD TipoUnidadDidactica,
		ud.NOMBRE_UNIDAD_DIDACTICA NombreUnidadDidactica,
		ud.ID_SEMESTRE_ACADEMICO IdSemestreAcademico,
		enu_sa.VALOR_ENUMERADO SemestreAcademico,
		(CASE ud.ID_SEMESTRE_ACADEMICO WHEN 111 THEN ud.PERIODO_ACADEMICO_I
										WHEN 112 THEN ud.PERIODO_ACADEMICO_II
										WHEN 113 THEN ud.PERIODO_ACADEMICO_III
										WHEN 114 THEN ud.PERIODO_ACADEMICO_IV
										WHEN 115 THEN ud.PERIODO_ACADEMICO_V
										WHEN 116 THEN ud.PERIODO_ACADEMICO_VI
										WHEN 137 THEN ud.PERIODO_ACADEMICO_VII
										WHEN 138 THEN ud.PERIODO_ACADEMICO_VIII END) Horas,
		ud.TEORICO_PRACTICO_HORAS_UD HorasTP,
		ud.PRACTICO_HORAS_UD HorasP,
		ud.CREDITOS Creditos,
		ud.TEORICO_PRACTICO_CREDITOS_UD CreditosT,
		ud.PRACTICO_CREDITOS_UD CreditosP,
		ISNULL(mequi.ID_MODULO_EQUIVALENCIA,0) IdModuloEquivalencia,
		ISNULL(mequi.NOMBRE_MODULO,'') ModuloEquivalente,
		ISNULL(udme.ID_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA,0) IdUnidadDidacticaModuloEquivalente
	INTO #TmpUDModuloEquivalencia
	FROM transaccional.plan_estudio pe
		INNER JOIN transaccional.modulo m ON m.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1 AND pe.ES_ACTIVO=1
		INNER JOIN transaccional.unidad_didactica ud ON ud.ID_MODULO = m.ID_MODULO AND ud.ES_ACTIVO=1
		INNER JOIN maestro.tipo_unidad_didactica tud ON tud.ID_TIPO_UNIDAD_DIDACTICA = ud.ID_TIPO_UNIDAD_DIDACTICA
		INNER JOIN sistema.enumerado enu_sa ON ud.ID_SEMESTRE_ACADEMICO=enu_sa.ID_ENUMERADO
		LEFT JOIN transaccional.unidad_didactica_modulo_equivalencia udme ON ud.ID_UNIDAD_DIDACTICA = udme.ID_UNIDAD_DIDACTICA AND udme.ES_ACTIVO=1
		LEFT JOIN transaccional.modulo_equivalencia mequi ON udme.ID_MODULO_EQUIVALENCIA = mequi.ID_MODULO_EQUIVALENCIA AND mequi.ES_ACTIVO = 1
	WHERE pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
	ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.ID_UNIDAD_DIDACTICA

	IF (@MOSTRAR_UD_DISPONIBLES = 1) 
	BEGIN
		SELECT *,ROW_NUMBER() OVER(ORDER BY IdSemestreAcademico,IdUnidadDidactica ASC) AS Row
		FROM #TmpUDModuloEquivalencia
		WHERE IdModuloEquivalencia = 0
	END ELSE 
	BEGIN
		SELECT *,ROW_NUMBER() OVER(ORDER BY IdSemestreAcademico,IdUnidadDidactica ASC) AS Row
		FROM #TmpUDModuloEquivalencia
		WHERE IdModuloEquivalencia = @ID_MODULO_EQUIVALENCIA
	END

	DROP TABLE #TmpUDModuloEquivalencia
END