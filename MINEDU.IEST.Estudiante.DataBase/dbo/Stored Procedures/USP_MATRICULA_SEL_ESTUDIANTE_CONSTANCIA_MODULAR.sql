/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	11/02/2022
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de modulos del pland e estudios del estudiante.
REVISIONES			:  
---------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
---------------------------------------------------------------------------------------------------------

TEST:			
	USP_MATRICULA_SEL_ESTUDIANTE_CONSTANCIA_MODULAR 1911,4048, 137908
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_ESTUDIANTE_CONSTANCIA_MODULAR]
(  
	@ID_INSTITUCION					INT,
	@ID_PLAN_ESTUDIO            	INT,
	@ID_ESTUDIANTE_INSTITUCION		INT
)
AS  
BEGIN  
	SET NOCOUNT ON;  

	DECLARE @NOTA_MINIMA INT = (SELECT VALOR_PARAMETRO FROM maestro.parametros_institucion WHERE ID_INSTITUCION = @ID_INSTITUCION AND NOMBRE_PARAMETRO = 'NOTA_MINIMA_APROBATORIA')
	
	IF OBJECT_ID('tempdb..#TmpDetalleEstudianteModulosAprobados') IS NOT NULL
		DROP TABLE #TmpDetalleEstudianteModulosAprobados

	SELECT 
		eins.ID_ESTUDIANTE_INSTITUCION,
		CAST(mequi.NUMERO_MODULO AS INT) NUMERO_MODULO,
		mequi.ID_MODULO_EQUIVALENCIA,
		mequi.NOMBRE_MODULO,
		udme.ID_UNIDAD_DIDACTICA,
		NOTA_MAX = MAX(ISNULL(edet.NOTA,0))
	INTO #TmpDetalleEstudianteModulosAprobados
	FROM transaccional.estudiante_institucion eins 
		INNER JOIN transaccional.modulo_equivalencia mequi ON mequi.ID_PLAN_ESTUDIO = eins.ID_PLAN_ESTUDIO AND mequi.ES_ACTIVO = 1
		INNER JOIN transaccional.unidad_didactica_modulo_equivalencia udme ON mequi.ID_MODULO_EQUIVALENCIA = udme.ID_MODULO_EQUIVALENCIA AND udme.ES_ACTIVO = 1
		LEFT JOIN transaccional.matricula_estudiante me ON me.ID_ESTUDIANTE_INSTITUCION = eins.ID_ESTUDIANTE_INSTITUCION AND me.ES_ACTIVO = 1
		LEFT JOIN transaccional.programacion_clase_por_matricula_estudiante pcme ON pcme.ID_MATRICULA_ESTUDIANTE = me.ID_MATRICULA_ESTUDIANTE AND pcme.ES_ACTIVO = 1
		LEFT JOIN transaccional.evaluacion e ON pcme.ID_PROGRAMACION_CLASE = e.ID_PROGRAMACION_CLASE AND udme.ID_UNIDAD_DIDACTICA = e.ID_UNIDAD_DIDACTICA AND e.ES_ACTIVO = 1
		LEFT JOIN transaccional.evaluacion_detalle edet ON e.ID_EVALUACION = edet.ID_EVALUACION AND me.ID_MATRICULA_ESTUDIANTE = edet.ID_MATRICULA_ESTUDIANTE AND edet.ES_ACTIVO = 1
	WHERE eins.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION AND eins.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO AND eins.ES_ACTIVO=1
	GROUP BY eins.ID_ESTUDIANTE_INSTITUCION,mequi.ID_MODULO_EQUIVALENCIA,mequi.NUMERO_MODULO,mequi.NOMBRE_MODULO,udme.ID_UNIDAD_DIDACTICA

	DECLARE @CANT_UD_PLAN INT = (SELECT COUNT(ud.ID_UNIDAD_DIDACTICA)
								FROM transaccional.modulo m 
								INNER JOIN transaccional.unidad_didactica ud ON ud.ID_MODULO = m.ID_MODULO 
								WHERE m.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1 AND ud.ES_ACTIVO=1)
	DECLARE @CANT_UD_CONF INT = (SELECT COUNT(ud.ID_UNIDAD_DIDACTICA)
								FROM transaccional.modulo_equivalencia m
								INNER JOIN transaccional.unidad_didactica_modulo_equivalencia ud ON ud.ID_MODULO_EQUIVALENCIA = m.ID_MODULO_EQUIVALENCIA
								WHERE m.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1 AND ud.ES_ACTIVO=1)

	SELECT 
		ROW_NUMBER() OVER ( ORDER BY NUMERO_MODULO) AS Row,
		ID_ESTUDIANTE_INSTITUCION IdEstudianteInstitucion,
		ID_MODULO_EQUIVALENCIA IdModulo,
		NUMERO_MODULO NumeroModulo,
		NOMBRE_MODULO NombreModulo,
		CANTIDAD_UD CantidadUD, CANTIDAD_UD_APROBADOS CantidadUDAprobados,
		@CANT_UD_PLAN CantidadUDPlan, @CANT_UD_CONF CantidaUDConfiguradas,
		CAST((CASE WHEN CANTIDAD_UD_APROBADOS >= CANTIDAD_UD THEN 1 ELSE 0 END) AS BIT) EsModuloAprobado
	FROM (
		SELECT
			ID_ESTUDIANTE_INSTITUCION,
			ID_MODULO_EQUIVALENCIA,
			NUMERO_MODULO,
			NOMBRE_MODULO,
			CANTIDAD_UD = COUNT(DISTINCT ID_UNIDAD_DIDACTICA),
			CANTIDAD_UD_APROBADOS = SUM(CASE WHEN NOTA_MAX >= @NOTA_MINIMA THEN 1 ELSE 0 END)
		FROM #TmpDetalleEstudianteModulosAprobados M
		GROUP BY ID_ESTUDIANTE_INSTITUCION,ID_MODULO_EQUIVALENCIA,NUMERO_MODULO,NOMBRE_MODULO
	) M
	ORDER BY NUMERO_MODULO

	DROP TABLE #TmpDetalleEstudianteModulosAprobados
END