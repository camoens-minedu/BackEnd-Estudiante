/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/02/2021
LLAMADO POR			:
DESCRIPCION			:	Lista de las unidades didácticas por plan de estudio
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/02/2021		JCHAVEZ			Creación
1.2			04/11/2021		JCHAVEZ			Ordernar por semestre y luego por ID_UNIDAD_DIDACTICA
2.0			17/05/2022		JCHAVEZ			Mostrar datos sin necesidad que haya unidades didácticas registradas

TEST:  
	USP_INSTITUCION_SEL_PLAN_ESTUDIO_GESTIONAR 2287--ASIGNATURA
	USP_INSTITUCION_SEL_PLAN_ESTUDIO_GESTIONAR 995 --TRANSVERSAL
	USP_INSTITUCION_SEL_PLAN_ESTUDIO_GESTIONAR 905 --MODULAR
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_PLAN_ESTUDIO_GESTIONAR]
(
	@ID_PLAN_ESTUDIO INT
)
AS
BEGIN
	
	DECLARE @ID_TIPO_ITINERARIO INT = (SELECT ID_TIPO_ITINERARIO FROM transaccional.plan_estudio WHERE ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO)

	IF (@ID_TIPO_ITINERARIO = 99)
	BEGIN
		SELECT 
			ROW_NUMBER() OVER(ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.ID_UNIDAD_DIDACTICA ASC) AS Row,
			pe.ID_PLAN_ESTUDIO IdPlanEstudio,
			pe.ID_TIPO_ITINERARIO IdTipoItinerario,
			enu_ti.VALOR_ENUMERADO TipoItinerario,
			pe.NOMBRE_PLAN_ESTUDIOS NombrePlanEstudios,
			c.NOMBRE_CARRERA ProgramaEstudios,
			c.NIVEL_FORMACION NivelFormacion,

			m.ID_MODULO IdModulo,
			m.NOMBRE_MODULO NombreModulo,
			ud.ID_UNIDAD_DIDACTICA IdUnidadDidactica,
			ud.NOMBRE_UNIDAD_DIDACTICA NombreUnidadDidactica,
			ud.ID_SEMESTRE_ACADEMICO IdSemestreAcademico,
			enu_sa.VALOR_ENUMERADO SemestreAcademico,
			ud.HORAS Horas
		FROM transaccional.plan_estudio pe
			INNER JOIN transaccional.carreras_por_institucion cpi ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION AND cpi.ES_ACTIVO=1
			INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON c.ID_CARRERA = cpi.ID_CARRERA
			INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON i.ID_INSTITUCION = cpi.ID_INSTITUCION
			LEFT JOIN transaccional.modulo m ON m.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1
			LEFT JOIN transaccional.unidad_didactica ud ON ud.ID_MODULO = m.ID_MODULO AND ud.ES_ACTIVO=1
			INNER JOIN sistema.enumerado enu_ti ON pe.ID_TIPO_ITINERARIO=enu_ti.ID_ENUMERADO
			LEFT JOIN sistema.enumerado enu_sa ON ud.ID_SEMESTRE_ACADEMICO=enu_sa.ID_ENUMERADO
		WHERE pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
		ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.ID_UNIDAD_DIDACTICA
	END
	ELSE IF (@ID_TIPO_ITINERARIO = 100) 
	BEGIN
		SELECT 
			ROW_NUMBER() OVER(ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.ID_UNIDAD_DIDACTICA ASC) AS Row,
			pe.ID_PLAN_ESTUDIO IdPlanEstudio,
			pe.ID_TIPO_ITINERARIO IdTipoItinerario,
			enu_ti.VALOR_ENUMERADO TipoItinerario,
			pe.NOMBRE_PLAN_ESTUDIOS NombrePlanEstudios,
			c.NOMBRE_CARRERA ProgramaEstudios,
			c.NIVEL_FORMACION NivelFormacion,

			m.ID_MODULO IdModulo,
			m.NOMBRE_MODULO NombreModulo,
			CAST(m.TOTAL_HORAS AS DECIMAL(10,2))TotalHoras,
			m.HORAS_ME TotalCreditos,
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
			ud.CREDITOS Creditos
		FROM transaccional.plan_estudio pe
			INNER JOIN transaccional.carreras_por_institucion cpi ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION AND cpi.ES_ACTIVO=1
			INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON c.ID_CARRERA = cpi.ID_CARRERA
			INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON i.ID_INSTITUCION = cpi.ID_INSTITUCION
			LEFT JOIN transaccional.modulo m ON m.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1
			LEFT JOIN transaccional.unidad_didactica ud ON ud.ID_MODULO = m.ID_MODULO AND ud.ES_ACTIVO=1
			LEFT JOIN maestro.tipo_unidad_didactica tud ON tud.ID_TIPO_UNIDAD_DIDACTICA = ud.ID_TIPO_UNIDAD_DIDACTICA
			INNER JOIN sistema.enumerado enu_ti ON pe.ID_TIPO_ITINERARIO=enu_ti.ID_ENUMERADO
			LEFT JOIN sistema.enumerado enu_sa ON ud.ID_SEMESTRE_ACADEMICO=enu_sa.ID_ENUMERADO
			WHERE pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
		ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.ID_UNIDAD_DIDACTICA
	END
	ELSE IF (@ID_TIPO_ITINERARIO = 101)
	BEGIN
		SELECT 
			ROW_NUMBER() OVER(ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.ID_UNIDAD_DIDACTICA ASC) AS Row,
			pe.ID_PLAN_ESTUDIO IdPlanEstudio,
			pe.ID_TIPO_ITINERARIO IdTipoItinerario,
			enu_ti.VALOR_ENUMERADO TipoItinerario,
			pe.NOMBRE_PLAN_ESTUDIOS NombrePlanEstudios,
			c.NOMBRE_CARRERA ProgramaEstudios,
			c.NIVEL_FORMACION NivelFormacion,

			m.ID_MODULO IdModulo,
			m.NOMBRE_MODULO NombreModulo,
			m.TOTAL_HORAS_UD TotalHoras,
			m.TOTAL_CREDITOS_UD TotalCreditos,
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
			ud.PRACTICO_CREDITOS_UD CreditosP
		FROM transaccional.plan_estudio pe
			INNER JOIN transaccional.carreras_por_institucion cpi ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION AND cpi.ES_ACTIVO=1
			INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON c.ID_CARRERA = cpi.ID_CARRERA
			INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON i.ID_INSTITUCION = cpi.ID_INSTITUCION
			LEFT JOIN transaccional.modulo m ON m.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1
			LEFT JOIN transaccional.unidad_didactica ud ON ud.ID_MODULO = m.ID_MODULO AND ud.ES_ACTIVO=1
			LEFT JOIN maestro.tipo_unidad_didactica tud ON tud.ID_TIPO_UNIDAD_DIDACTICA = ud.ID_TIPO_UNIDAD_DIDACTICA
			INNER JOIN sistema.enumerado enu_ti ON pe.ID_TIPO_ITINERARIO=enu_ti.ID_ENUMERADO
			LEFT JOIN sistema.enumerado enu_sa ON ud.ID_SEMESTRE_ACADEMICO=enu_sa.ID_ENUMERADO
		WHERE pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
		ORDER BY ud.ID_SEMESTRE_ACADEMICO,ud.ID_UNIDAD_DIDACTICA
	END
END