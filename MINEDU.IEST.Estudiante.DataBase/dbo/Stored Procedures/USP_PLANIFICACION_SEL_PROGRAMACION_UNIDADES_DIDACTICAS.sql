/********************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Retorna la lista de unidades didácticas de una clase.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			01/10/2018		JTOVAR          CREACIÓN
2.0			07/02/2022		JCHAVEZ			Se agregó campo EnUsoMatricula

  TEST:			
	USP_PLANIFICACION_SEL_PROGRAMACION_UNIDADES_DIDACTICAS 3842
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_PLANIFICACION_SEL_PROGRAMACION_UNIDADES_DIDACTICAS]
(  
@ID_PROGRAMACION_CLASE INT
)  
AS  
BEGIN  
	SET NOCOUNT ON; 

	SELECT	
		tudp.ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE  IdUnidadesDidacticasPorProgramacionClase, 
		tudp.ID_PROGRAMACION_CLASE							IdProgramacionClase,
		tudp.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE				IdUnidadDidacticaPorEnfoque,
		mc.ID_CARRERA										IdProgramaEstudio,
		mc.NOMBRE_CARRERA									ProgramaEstudio,
		tpe.ID_TIPO_ITINERARIO								IdTipoPlanEstudio,
		se_itin.VALOR_ENUMERADO								TipoPlanEstudio,
		tud.NOMBRE_UNIDAD_DIDACTICA							UnidadDidactica ,
		tud.CREDITOS										Creditos,
		se_ciclo.VALOR_ENUMERADO							Semestre,
		tudp.ES_ACTIVO										EsActivo,
		tpe.NOMBRE_PLAN_ESTUDIOS							PlanEstudio,
		tpe.ID_PLAN_ESTUDIO									IdPlanEstudio,
		EnUsoMatricula = CAST((CASE WHEN EXISTS(SELECT TOP 1 pcxm.ID_MATRICULA_ESTUDIANTE
												FROM transaccional.programacion_clase_por_matricula_estudiante pcxm
												INNER JOIN transaccional.matricula_estudiante me ON me.ID_MATRICULA_ESTUDIANTE = pcxm.ID_MATRICULA_ESTUDIANTE AND me.ES_ACTIVO = 1
												INNER JOIN transaccional.estudiante_institucion ei ON ei.ID_ESTUDIANTE_INSTITUCION = me.ID_ESTUDIANTE_INSTITUCION AND ei.ES_ACTIVO = 1
												INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = ei.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO=1
												INNER JOIN transaccional.modulo m ON m.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1
												INNER JOIN transaccional.unidad_didactica ud ON ud.ID_MODULO = m.ID_MODULO
												INNER JOIN transaccional.unidades_didacticas_por_enfoque udxe ON udxe.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA AND udxe.ES_ACTIVO=1
												INNER JOIN transaccional.unidades_didacticas_por_programacion_clase udxpc ON udxpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE 
													AND udxpc.ID_PROGRAMACION_CLASE=pcxm.ID_PROGRAMACION_CLASE AND udxpc.ES_ACTIVO=1
												WHERE udxpc.ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE = tudp.ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE AND pcxm.ES_ACTIVO=1) 
								THEN 1 ELSE 0 END) AS BIT)
	FROM 
		[transaccional].[unidades_didacticas_por_programacion_clase]  tudp
		inner join [transaccional].[unidades_didacticas_por_enfoque] tude on tudp.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE=tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
		AND tudp.ES_ACTIVO=1 AND tude.ES_ACTIVO=1 
		inner join [transaccional].[enfoques_por_plan_estudio] tep on tep.ID_ENFOQUES_POR_PLAN_ESTUDIO=tude.ID_ENFOQUES_POR_PLAN_ESTUDIO
		AND tep.ES_ACTIVO=1  
		inner join [transaccional].[plan_estudio] tpe on tpe.ID_PLAN_ESTUDIO =tep.ID_PLAN_ESTUDIO
		AND tpe.ES_ACTIVO=1
		inner join [transaccional].[carreras_por_institucion] tci on tci.ID_CARRERAS_POR_INSTITUCION = tpe.ID_CARRERAS_POR_INSTITUCION
		AND tci.ES_ACTIVO=1
		inner join db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA= tci.ID_CARRERA		
		inner join [transaccional].[unidad_didactica] tud on tud.ID_UNIDAD_DIDACTICA= tude.ID_UNIDAD_DIDACTICA
		AND tud.ES_ACTIVO=1
		INNER JOIN sistema.enumerado se_itin on se_itin.ID_ENUMERADO= tpe.ID_TIPO_ITINERARIO
		INNER JOIN	sistema.enumerado se_ciclo on se_ciclo.ID_ENUMERADO= tud.ID_SEMESTRE_ACADEMICO
	WHERE 
		ID_PROGRAMACION_CLASE=@ID_PROGRAMACION_CLASE
	order by 1 asc
END
GO


