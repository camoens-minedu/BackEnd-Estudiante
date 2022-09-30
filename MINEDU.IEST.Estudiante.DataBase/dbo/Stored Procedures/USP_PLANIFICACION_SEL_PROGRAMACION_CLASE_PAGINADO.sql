/********************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Retorna la lista de clases.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			01/10/2018		JTOVAR          CREACIÓN
2.0			27/07/2021		JCHAVEZ			Se agregó variable table @programacion_clase para optimizar la consulta
3.0			07/02/2022		JCHAVEZ			Se modificó a left join las tablas de personal_institucion para registros sin docente

  TEST:			
/*
	USP_PLANIFICACION_SEL_PROGRAMACION_CLASE_PAGINADO 221,3842,0,0,0,0,0,0,0,0
	USP_PLANIFICACION_SEL_PROGRAMACION_CLASE_PAGINADO 1911,4139,0,0,0,0,0,0,0,0
*/
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_PLANIFICACION_SEL_PROGRAMACION_CLASE_PAGINADO]
(  
	@ID_INSTITUCION				INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT, 
	@ID_SEDE_INSTITUCION		INT,
	@ID_PERIODO_ACADEMICO		INT = 0, 
	@ID_PROGRAMA_ESTUDIOS		INT= 0,
	@ID_SECCION					INT =0,
	@ID_TURNO_POR_INSTITUCION	INT = 0,
	@ID_PERSONAL_INSTITUCION	INT = 0,
	@ID_TIPO_ITINERARIO			INT =0,
	@ID_SEMESTRE_ACADEMICO		INT, 
	@ID_PLAN_ESTUDIO			INT = 0,						 
	@Pagina						int = 1,
	@Registros					int = 10
)  
AS  
BEGIN  
 SET NOCOUNT ON;
 DECLARE @desde INT , @hasta INT;  
    SET @desde = ( @Pagina - 1 ) * @Registros;  
    SET @hasta = ( @Pagina * @Registros ) + 1;   
	
	DECLARE @programacion_clase TABLE(ID_PROGRAMACION_CLASE ID,ID_PERIODO_ACADEMICO ID,ID_SECCION ID,ID_TURNOS_POR_INSTITUCION ID,ID_PERSONAL_INSTITUCION ID, ID_PERSONAL_INSTITUCION_SECUNDARIO ID NULL,
									  NOMBRE_CLASE NOMBRE_CORTO,VACANTE_CLASE NUMERO_ENTERO)

	INSERT INTO @programacion_clase
	SELECT ID_PROGRAMACION_CLASE,pc.ID_PERIODO_ACADEMICO,ID_SECCION,ID_TURNOS_POR_INSTITUCION,ID_PERSONAL_INSTITUCION,ID_PERSONAL_INSTITUCION_SECUNDARIO,pc.NOMBRE_CLASE,pc.VACANTE_CLASE
	FROM transaccional.programacion_clase pc
	INNER JOIN transaccional.periodo_academico pa ON pc.ID_PERIODO_ACADEMICO=pa.ID_PERIODO_ACADEMICO
	INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
	WHERE plxi.ID_INSTITUCION=@ID_INSTITUCION AND plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		AND pc.ES_ACTIVO=1 AND pa.ES_ACTIVO=1 AND plxi.ES_ACTIVO=1

	SELECT
		TPF.*,				  
		STUFF(
			(
				SELECT ', '+  LTRIM(RTRIM(ma.NOMBRE_AULA)) from transaccional.sesion_programacion_clase tspc
					inner join maestro.aula ma on ma.ID_AULA= tspc.ID_AULA
					where ID_PROGRAMACION_CLASE =TPF.IdProgramacionClase  AND tspc.ES_ACTIVO=1
			FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
			, 1, 1, '') as Aulas,
		STUFF(
				(
					SELECT ', ' +  se.VALOR_ENUMERADO  + ' ' + tspc.HORA_INICIO + ' - ' +tspc.HORA_FIN 
					FROM transaccional.sesion_programacion_clase tspc inner join sistema.enumerado se on se.ID_ENUMERADO = tspc.DIA
					WHERE ID_PROGRAMACION_CLASE =TPF.IdProgramacionClase AND tspc.ES_ACTIVO=1
				FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
				, 1, 1, '') as Horarios,
		STUFF(
				(
					SELECT ', '  + se.VALOR_ENUMERADO 
					FROM transaccional.unidades_didacticas_por_programacion_clase tudxpc
					INNER JOIN transaccional.unidades_didacticas_por_enfoque tudxe on tudxpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= tudxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
					AND tudxpc.ES_ACTIVO=1 AND tudxe.ES_ACTIVO=1
					INNER JOIN transaccional.unidad_didactica tud on tud.ID_UNIDAD_DIDACTICA= tudxe.ID_UNIDAD_DIDACTICA 
					AND tud.ES_ACTIVO=1
					INNER JOIN sistema.enumerado se on  se.ID_ENUMERADO= tud.ID_SEMESTRE_ACADEMICO
					WHERE tudxpc.ID_PROGRAMACION_CLASE= TPF.IdProgramacionClase
					FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
				, 1, 1, '') as Semestres,
		STUFF(
				(
				SELECT ', ' + TUD.NOMBRE_UNIDAD_DIDACTICA 
				FROM transaccional.unidades_didacticas_por_programacion_clase TUDPC
				INNER JOIN transaccional.unidades_didacticas_por_enfoque TUDE ON TUDPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= TUDE.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
				INNER JOIN transaccional.unidad_didactica TUD ON TUD.ID_UNIDAD_DIDACTICA= TUDE.ID_UNIDAD_DIDACTICA
				where TUDPC.ID_PROGRAMACION_CLASE = TPF.IdProgramacionClase AND TUDPC.ES_ACTIVO=1
				FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
				, 1, 1, '') as UnidadesDidacticas,
				CAST((CASE 
				WHEN EXISTS(SELECT TOP 1 ID_PROGRAMACION_CLASE_POR_MATRICULA_ESTUDIANTE 
									FROM transaccional.programacion_clase_por_matricula_estudiante 
									WHERE ID_PROGRAMACION_CLASE=TPF.IdProgramacionClase AND ES_ACTIVO=1) THEN
									1
				ELSE 
									0
				END) AS BIT) EnUsoMatricula,
		STUFF(
			(
			SELECT ',', mc.NOMBRE_CARRERA 
			FROM
				transaccional.unidades_didacticas_por_programacion_clase tudpc 
				inner join transaccional.unidades_didacticas_por_enfoque tudpe on tudpe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
				inner join transaccional.enfoques_por_plan_estudio tep on tudpe.ID_ENFOQUES_POR_PLAN_ESTUDIO= tep.ID_ENFOQUES_POR_PLAN_ESTUDIO
				inner join transaccional.plan_estudio tpe on tep.ID_PLAN_ESTUDIO =tpe.ID_PLAN_ESTUDIO
				inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tpe.ID_CARRERAS_POR_INSTITUCION
				inner join db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA = tci.ID_CARRERA 
			WHERE ID_PROGRAMACION_CLASE =TPF.IdProgramacionClase  AND tudpc.ES_ACTIVO=1
				AND (mc.ID_CARRERA=@ID_PROGRAMA_ESTUDIOS or @ID_PROGRAMA_ESTUDIOS=0)
				AND (tpe.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO or @ID_TIPO_ITINERARIO=0)
			FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
			, 1, 1, '') as ProgramasEstudio
	FROM (
		SELECT 
			  TP.*
		FROM (
				SELECT 
					 TN.*,
					 ROW_NUMBER() OVER ( ORDER BY TN.SedeInstitucion,TN.PeriodoAcademico, TN.NombreClase,TN.IdProgramacionClase) AS Row ,
					 Total = COUNT(1) OVER ( )
				FROM(
						SELECT distinct 
								tpc.ID_PROGRAMACION_CLASE		IdProgramacionClase, 
								msi.ID_SEDE_INSTITUCION			IdSedeInstitucion, 
								msi.NOMBRE_SEDE					SedeInstitucion, 
								tpa.ID_PERIODO_ACADEMICO		IdPeriodoAcademico, 
								tpa.NOMBRE_PERIODO_ACADEMICO	PeriodoAcademico, 
								tpc.NOMBRE_CLASE				NombreClase,
								tpc.ID_SECCION					IdSeccion,  
								se_seccion.VALOR_ENUMERADO		Seccion,
								tpc.ID_TURNOS_POR_INSTITUCION	IdTurnoPorInstitucion ,
								se_turno.VALOR_ENUMERADO		Turno,
								tpc.ID_PERSONAL_INSTITUCION		IdPersonalInstitucion, 
								tpc.ID_PERSONAL_INSTITUCION_SECUNDARIO IdPersonalInstitucionSecundario,
								ISNULL((UPPER(mp.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(mp.APELLIDO_MATERNO_PERSONA)+ ', ' + UPPER( mp.NOMBRE_PERSONA)),'SIN DOCENTE')  Docente, 
								tpc.VACANTE_CLASE				Vacante
						FROM @programacion_clase tpc
								inner join transaccional.sesion_programacion_clase tspc on tspc.ID_PROGRAMACION_CLASE= tpc.ID_PROGRAMACION_CLASE and tspc.ES_ACTIVO=1
								inner join maestro.aula ma on tspc.ID_AULA = ma.ID_AULA
								inner join maestro.sede_institucion msi on msi.ID_SEDE_INSTITUCION = ma.ID_SEDE_INSTITUCION
								inner join transaccional.periodo_academico tpa on tpa.ID_PERIODO_ACADEMICO = tpc.ID_PERIODO_ACADEMICO
								inner join sistema.enumerado se_seccion on se_seccion.ID_ENUMERADO= tpc.ID_SECCION
								inner join maestro.turnos_por_institucion mti on mti.ID_TURNOS_POR_INSTITUCION= tpc.ID_TURNOS_POR_INSTITUCION
								inner join maestro.turno_equivalencia mte on mte.ID_TURNO_EQUIVALENCIA= mti.ID_TURNO_EQUIVALENCIA
								inner join sistema.enumerado se_turno on se_turno.ID_ENUMERADO= mte.ID_TURNO 
								LEFT join maestro.personal_institucion mpli on mpli.ID_PERSONAL_INSTITUCION= tpc.ID_PERSONAL_INSTITUCION and mpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
								LEFT join maestro.persona_institucion mpi on mpli.ID_PERSONA_INSTITUCION=mpi.ID_PERSONA_INSTITUCION
								LEFT join maestro.persona mp on mp.ID_PERSONA = mpi.ID_PERSONA	
								INNER JOIN transaccional.unidades_didacticas_por_programacion_clase UDXPC ON UDXPC.ID_PROGRAMACION_CLASE= tpc.ID_PROGRAMACION_CLASE AND UDXPC.ES_ACTIVO=1
								INNER JOIN transaccional.unidades_didacticas_por_enfoque UDXE ON UDXE.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= UDXPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND UDXE.ES_ACTIVO=1
								INNER JOIN transaccional.unidad_didactica UD ON UD.ID_UNIDAD_DIDACTICA= UDXE.ID_UNIDAD_DIDACTICA AND UD.ES_ACTIVO=1				
								inner join transaccional.enfoques_por_plan_estudio tep on UDXE.ID_ENFOQUES_POR_PLAN_ESTUDIO= tep.ID_ENFOQUES_POR_PLAN_ESTUDIO AND tep.ES_ACTIVO=1
								inner join transaccional.plan_estudio tpe on tep.ID_PLAN_ESTUDIO =tpe.ID_PLAN_ESTUDIO AND tpe.ES_ACTIVO=1
								inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tpe.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1
						WHERE (msi.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION=0)
								AND (tpa.ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO OR @ID_PERIODO_ACADEMICO=0)
								AND (tpc.ID_SECCION = @ID_SECCION OR @ID_SECCION=0)
								AND (tpc.ID_TURNOS_POR_INSTITUCION =@ID_TURNO_POR_INSTITUCION OR @ID_TURNO_POR_INSTITUCION=0)
								AND (tpc.ID_PERSONAL_INSTITUCION = @ID_PERSONAL_INSTITUCION OR @ID_PERSONAL_INSTITUCION =0)
								--AND tpc.ES_ACTIVO=1
								AND msi.ID_INSTITUCION=@ID_INSTITUCION
								AND (UD.ID_SEMESTRE_ACADEMICO= @ID_SEMESTRE_ACADEMICO OR @ID_SEMESTRE_ACADEMICO=0)
								AND (tci.ID_CARRERA=@ID_PROGRAMA_ESTUDIOS or @ID_PROGRAMA_ESTUDIOS=0)
								AND (tpe.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO or @ID_TIPO_ITINERARIO=0)	
								AND (tep.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO OR @ID_PLAN_ESTUDIO =0)
								/*AND (
									SELECT count(1)
									FROM
										transaccional.unidades_didacticas_por_programacion_clase tudpc 
										inner join transaccional.unidades_didacticas_por_enfoque tudpe on tudpe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
										inner join transaccional.enfoques_por_plan_estudio tep on tudpe.ID_ENFOQUES_POR_PLAN_ESTUDIO= tep.ID_ENFOQUES_POR_PLAN_ESTUDIO
										inner join transaccional.plan_estudio tpe on tep.ID_PLAN_ESTUDIO =tpe.ID_PLAN_ESTUDIO
										inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tpe.ID_CARRERAS_POR_INSTITUCION
										inner join db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA = tci.ID_CARRERA 
									WHERE ID_PROGRAMACION_CLASE =tpc.ID_PROGRAMACION_CLASE 
										  AND tudpc.ES_ACTIVO=1
										  AND (mc.ID_CARRERA=@ID_PROGRAMA_ESTUDIOS or @ID_PROGRAMA_ESTUDIOS=0)
										  AND (tpe.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO or @ID_TIPO_ITINERARIO=0)	
										  AND (tep.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO OR @ID_PLAN_ESTUDIO =0)
								   )>0*/
						)TN
				)TP
				WHERE   ( TP.Row > @desde  AND TP.Row < @hasta) OR (@Registros = 0) 
		)TPF
	SET NOCOUNT OFF;
END
GO


