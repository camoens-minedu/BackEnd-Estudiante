/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	29/12/2021
LLAMADO POR			:
DESCRIPCION			:	Obtiene los datos que se muestran en el reporte de boleta de notas
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			29/12/2021		JTOVAR			Creación		
1.1			17/05/2022		JCHAVEZ			Corrección de inner en tabla plan_estudio para hacer match con estudiante_institucion y evitar duplicidad

TEST:			
	EXEC USP_MATRICULA_RPT_BOLETA_NOTAS 228850,4133
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_RPT_BOLETA_NOTAS]
(
	@ID_MATRICULA_ESTUDIANTE INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @RUTA_FOTO VARCHAR(500) = (SELECT dbo.UFN_RUTA_BASE_ARCHIVOS() + 'ESTUDIANTES_FOTOS\')

	SELECT
		ROW_NUMBER() OVER(ORDER BY ud.NOMBRE_UNIDAD_DIDACTICA ASC, enu.VALOR_ENUMERADO ASC ) AS ROW,
		i.NOMBRE_DEPARTAMENTO
		,i.NOMBRE_PROVINCIA
		, i.NOMBRE_DISTRITO
		, i.CODIGO_MODULAR
		,i.DRE_GRE
		,i.NOMBRE_INSTITUCION
		,i.TIPO_GESTION_NOMBRE
		,p.NUMERO_DOCUMENTO_PERSONA
		,UPPER(p.APELLIDO_PATERNO_PERSONA) + ' '+ UPPER(p.APELLIDO_MATERNO_PERSONA)+ ', ' +  dbo.UFN_CAPITALIZAR( p.NOMBRE_PERSONA) as ESTUDIANTE
		,c.NIVEL_FORMACION
		,@RUTA_FOTO + eins.ARCHIVO_FOTO FOTO
		,pl.CODIGO_PERIODO_LECTIVO
   		,c.NOMBRE_CARRERA
		,enume.VALOR_ENUMERADO TIPO_PLAN_ESTUDIOS
		,pestudio.NOMBRE_PLAN_ESTUDIOS
		,enu.VALOR_ENUMERADO SEMESTRE_ACADEMICO_ESTUDIANTE
		,enu_semud.VALOR_ENUMERADO SEMESTRE_ACADEMICO_UNIDAD_DIDACTICA
		,pacademico.NOMBRE_PERIODO_ACADEMICO
		,mestu.ID_MATRICULA_ESTUDIANTE
		,UPPER(ud.NOMBRE_UNIDAD_DIDACTICA) NOMBRE_UNIDAD_DIDACTICA
		,edet.NOTA
	FROM maestro.persona p 
	INNER JOIN maestro.persona_institucion pins ON p.ID_PERSONA = pins.ID_PERSONA 
	INNER JOIN transaccional.estudiante_institucion eins ON pins.ID_PERSONA_INSTITUCION = eins.ID_PERSONA_INSTITUCION AND eins.ES_ACTIVO=1 
	INNER JOIN transaccional.matricula_estudiante mestu	ON eins.ID_ESTUDIANTE_INSTITUCION = mestu.ID_ESTUDIANTE_INSTITUCION AND mestu.ES_ACTIVO=1
	INNER JOIN transaccional.periodos_lectivos_por_institucion plec	ON mestu.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plec.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND plec.ES_ACTIVO=1
	INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON plec.ID_INSTITUCION = i.ID_INSTITUCION 
	INNER JOIN transaccional.carreras_por_institucion_detalle cpdet	ON eins.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpdet.ID_CARRERAS_POR_INSTITUCION_DETALLE AND cpdet.ES_ACTIVO=1
	INNER JOIN transaccional.carreras_por_institucion ci ON cpdet.ID_CARRERAS_POR_INSTITUCION = ci.ID_CARRERAS_POR_INSTITUCION AND ci.ES_ACTIVO=1
	INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON ci.ID_CARRERA = c.ID_CARRERA 
	INNER JOIN transaccional.programacion_clase_por_matricula_estudiante pcme ON mestu.ID_MATRICULA_ESTUDIANTE = pcme.ID_MATRICULA_ESTUDIANTE AND pcme.ES_ACTIVO=1
	INNER JOIN transaccional.evaluacion eva ON pcme.ID_PROGRAMACION_CLASE = eva.ID_PROGRAMACION_CLASE AND eva.ES_ACTIVO=1
	INNER JOIN transaccional.evaluacion_detalle edet ON eva.ID_EVALUACION = edet.ID_EVALUACION AND mestu.ID_MATRICULA_ESTUDIANTE=edet.ID_MATRICULA_ESTUDIANTE AND edet.ES_ACTIVO=1
	INNER JOIN transaccional.unidades_didacticas_por_programacion_clase udppc ON pcme.ID_PROGRAMACION_CLASE = udppc.ID_PROGRAMACION_CLASE AND udppc.ES_ACTIVO=1
	INNER JOIN transaccional.unidades_didacticas_por_enfoque udpe ON udppc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = udpe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND udpe.ES_ACTIVO=1
	INNER JOIN transaccional.unidad_didactica ud ON udpe.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA AND ud.ES_ACTIVO=1
	INNER JOIN sistema.enumerado enu ON mestu.ID_SEMESTRE_ACADEMICO = enu.ID_ENUMERADO
	INNER JOIN sistema.enumerado enu_semud ON ud.ID_SEMESTRE_ACADEMICO = enu_semud.ID_ENUMERADO
	INNER JOIN maestro.periodo_lectivo pl ON plec.ID_PERIODO_LECTIVO = pl.ID_PERIODO_LECTIVO
	INNER JOIN sistema.enumerado enume ON ci.ID_TIPO_ITINERARIO = enume.ID_ENUMERADO
	INNER JOIN transaccional.plan_estudio pestudio ON ci.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION AND pestudio.ID_PLAN_ESTUDIO=eins.ID_PLAN_ESTUDIO AND pestudio.ES_ACTIVO=1
	INNER JOIN transaccional.periodo_academico pacademico ON mestu.ID_PERIODO_ACADEMICO = pacademico.ID_PERIODO_ACADEMICO AND pacademico.ES_ACTIVO=1
	WHERE mestu.ID_MATRICULA_ESTUDIANTE=@ID_MATRICULA_ESTUDIANTE AND plec.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	ORDER BY ud.ID_SEMESTRE_ACADEMICO,NOMBRE_UNIDAD_DIDACTICA,ud.ID_UNIDAD_DIDACTICA
END