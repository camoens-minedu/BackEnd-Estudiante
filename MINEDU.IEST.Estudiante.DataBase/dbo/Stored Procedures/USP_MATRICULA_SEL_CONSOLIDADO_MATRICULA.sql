/********************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Retorna los datos para el reporte de consolidado de matrícula del estudiante.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			01/10/2018		JTOVAR          CREACIÓN
2.0			07/02/2022		JCHAVEZ			Se modificó a left join las tablas de personal_institucion para registros sin docente

TEST:			
	USP_MATRICULA_SEL_PROGRAMACION_CLASE 1911,3882,112155
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA]
(  
	@ID_MATRICULA_ESTUDIANTE INT	
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
    DECLARE @IdPlanEstudios int
	SET @IdPlanEstudios= (select tpe.ID_PLAN_ESTUDIO from transaccional.matricula_estudiante tme
							INNER JOIN transaccional.estudiante_institucion tei on tme.ID_ESTUDIANTE_INSTITUCION= tei.ID_ESTUDIANTE_INSTITUCION and tme.ES_ACTIVO=1 and tei.ES_ACTIVO=1
							INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tei.ID_CARRERAS_POR_INSTITUCION_DETALLE and tcid.ES_ACTIVO=1
							INNER JOIN transaccional.plan_estudio tpe on tpe.ID_CARRERAS_POR_INSTITUCION= tcid.ID_CARRERAS_POR_INSTITUCION and tpe.ES_ACTIVO=1 AND tei.ID_PLAN_ESTUDIO = tpe.ID_PLAN_ESTUDIO 	
							where ID_MATRICULA_ESTUDIANTE=@ID_MATRICULA_ESTUDIANTE)
	 
	SELECT 
		T.*,
		ROW_NUMBER() OVER ( ORDER BY  T.IdEstadoUnidadDidactica, T.IdUnidadDidactica) AS Row,
		STUFF((			 
			SELECT ', '+  LTRIM(RTRIM(ma.NOMBRE_AULA)) from transaccional.sesion_programacion_clase tspc
			inner join maestro.aula ma on ma.ID_AULA= tspc.ID_AULA
			where ID_PROGRAMACION_CLASE =T.IdProgramacionClase  AND tspc.ES_ACTIVO=1
			FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
			, 1, 1, '') as Aulas,
	  STUFF((			 
			SELECT ', '+  se.VALOR_ENUMERADO  + ' ' + tspc.HORA_INICIO + ' - ' +tspc.HORA_FIN from transaccional.sesion_programacion_clase tspc
			inner join sistema.enumerado se on se.ID_ENUMERADO = tspc.DIA
			where ID_PROGRAMACION_CLASE =T.IdProgramacionClase AND tspc.ES_ACTIVO=1
			FOR XML PATH (''),TYPE).value('.[1]', 'nvarchar(max)')
			, 1, 1, '') as Horarios
	FROM (
		SELECT DISTINCT
				tpc.ID_PROGRAMACION_CLASE					IdProgramacionClase,
				tud.ID_UNIDAD_DIDACTICA						IdUnidadDidactica, 
				se_semestre.VALOR_ENUMERADO					SemestreAcademico,
				ISNULL(mtud.NOMBRE_TIPO_UNIDAD,'Curso')		NombreTipoUnidadDidactica, 
				ISNULL(tud.CODIGO_UNIDAD_DIDACTICA,'')		CodigoUnidadDidactica,
				tud.NOMBRE_UNIDAD_DIDACTICA					NombreUnidadDidactica,
				ISNULL( tud.CREDITOS,0)						Creditos,
				se_estadoUD.VALOR_ENUMERADO					Estado,
				tpcme.ID_ESTADO_UNIDAD_DIDACTICA			IdEstadoUnidadDidactica, 
				se_seccion.VALOR_ENUMERADO					Seccion,
				se_turno.VALOR_ENUMERADO				Turno,
				msi.NOMBRE_SEDE Sede,
				ISNULL((UPPER(mp.APELLIDO_PATERNO_PERSONA) + ' ' +UPPER(mp.APELLIDO_MATERNO_PERSONA) + ', '  + dbo.UFN_CAPITALIZAR( mp.NOMBRE_PERSONA)),'SIN DOCENTE') Docente
			from transaccional.matricula_estudiante tme
			INNER JOIN transaccional.programacion_clase_por_matricula_estudiante tpcme on tme.ID_MATRICULA_ESTUDIANTE= tpcme.ID_MATRICULA_ESTUDIANTE
			AND tme.ES_ACTIVO=1 AND tpcme.ES_ACTIVO=1
			INNER JOIN transaccional.programacion_clase tpc on tpc.ID_PROGRAMACION_CLASE= tpcme.ID_PROGRAMACION_CLASE 
			AND tpc.ES_ACTIVO=1
			INNER JOIN transaccional.unidades_didacticas_por_programacion_clase tudpc on tudpc.ID_PROGRAMACION_CLASE= tpcme.ID_PROGRAMACION_CLASE AND tudpc.ES_ACTIVO = 1
			INNER JOIN transaccional.unidades_didacticas_por_enfoque tude on tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
			INNER JOIN transaccional.unidad_didactica tud on tud.ID_UNIDAD_DIDACTICA= tude.ID_UNIDAD_DIDACTICA
			INNER JOIN sistema.enumerado se_semestre on se_semestre.ID_ENUMERADO= tud.ID_SEMESTRE_ACADEMICO
			INNER JOIN sistema.enumerado se_seccion on se_seccion.ID_ENUMERADO= tpc.ID_SECCION
			INNER JOIN maestro.turnos_por_institucion mti on mti.ID_TURNOS_POR_INSTITUCION= tpc.ID_TURNOS_POR_INSTITUCION
			INNER JOIN maestro.turno_equivalencia mte on mte.ID_TURNO_EQUIVALENCIA= mti.ID_TURNO_EQUIVALENCIA
			INNER JOIN sistema.enumerado se_turno on se_turno.ID_ENUMERADO= mte.ID_TURNO
			LEFT JOIN maestro.personal_institucion mpli on mpli.ID_PERSONAL_INSTITUCION = tpc.ID_PERSONAL_INSTITUCION
			LEFT JOIN maestro.persona_institucion mpi on mpi.ID_PERSONA_INSTITUCION= mpli.ID_PERSONA_INSTITUCION
			LEFT JOIN maestro.persona mp on mp.ID_PERSONA= mpi.ID_PERSONA
			INNER JOIN sistema.enumerado se_estadoUD on se_estadoUD.ID_ENUMERADO = tpcme.ID_ESTADO_UNIDAD_DIDACTICA
			INNER JOIN maestro.sede_institucion msi on msi.ID_SEDE_INSTITUCION= tpc.ID_SEDE_INSTITUCION
			INNER JOIN transaccional.modulo tm on tm.ID_MODULO= tud.ID_MODULO and tm.ES_ACTIVO=1
			left JOIN maestro.tipo_unidad_didactica mtud on mtud.ID_TIPO_UNIDAD_DIDACTICA= tud.ID_TIPO_UNIDAD_DIDACTICA		

			where tme.ID_MATRICULA_ESTUDIANTE=@ID_MATRICULA_ESTUDIANTE and tm.ID_PLAN_ESTUDIO=@IdPlanEstudios
		)T	
END
GO


