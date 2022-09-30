--/*************************************************************************************************************************************************
--AUTOR				:	Mayra Alva
--FECHA DE CREACION	:	29/01/2020
--LLAMADO POR			:
--DESCRIPCION			:	Consulta información para cabecera del reporte de consolidado de matrícula.
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--1.1			08/06/2020		MALVA			MODIFICACIÓN DE CONSULTA ID_PLAN_ESTUDIO, COLUMNAS NombreInstituto y NombrePlanEstudios.
--*/
--  TEST:		USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_CAB 3439
--**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_CAB]
(  
	@ID_MATRICULA_ESTUDIANTE INT	
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
SELECT
'Periodo lectivo ' + mpl.CODIGO_PERIODO_LECTIVO		CodigoPeriodoLectivo,
				UPPER(tpa.NOMBRE_PERIODO_ACADEMICO)	NombrePeriodoAcademico,
				UPPER(mp.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(mp.APELLIDO_MATERNO_PERSONA) + ', '+ dbo.UFN_CAPITALIZAR( mp.NOMBRE_PERSONA) Estudiante,
				mc.NOMBRE_CARRERA				NombreProgramaEstudio,
				se_tipo_itin.VALOR_ENUMERADO	NombreTipoPlanEstudios,
				INS.CODIGO_MODULAR + ' - ' + INS.NOMBRE_INSTITUCION			NombreInstituto,
				tpe.NOMBRE_PLAN_ESTUDIOS+ 	' (' + se_tipo_itin.VALOR_ENUMERADO	+ ')'NombrePlanEstudios
		FROM transaccional.matricula_estudiante tme
				INNER JOIN transaccional.programacion_matricula tpm on tpm.ID_PROGRAMACION_MATRICULA= tme.ID_PROGRAMACION_MATRICULA and tpm.ES_ACTIVO=1
				INNER JOIN transaccional.estudiante_institucion tei on tei.ID_ESTUDIANTE_INSTITUCION = tme.ID_ESTUDIANTE_INSTITUCION AND tei.ES_ACTIVO=1
				INNER JOIN maestro.persona_institucion mpi on mpi.ID_PERSONA_INSTITUCION = tei.ID_PERSONA_INSTITUCION
				INNER JOIN maestro.persona mp on mp.ID_PERSONA = mpi.ID_PERSONA
				INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tei.ID_CARRERAS_POR_INSTITUCION_DETALLE AND tcid.ES_ACTIVO=1
				INNER JOIN transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1
				INNER JOIN transaccional.plan_estudio tpe on tpe.ID_PLAN_ESTUDIO = tei.ID_PLAN_ESTUDIO AND tpe.ES_ACTIVO=1
				INNER JOIN db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA = tci.ID_CARRERA
				INNER JOIN sistema.enumerado se_semestre on se_semestre.ID_ENUMERADO = tme.ID_SEMESTRE_ACADEMICO
				INNER JOIN maestro.turnos_por_institucion mti on mti.ID_TURNOS_POR_INSTITUCION = tei.ID_TURNOS_POR_INSTITUCION
				INNER JOIN maestro.turno_equivalencia mte on mte.ID_TURNO_EQUIVALENCIA = mti.ID_TURNO_EQUIVALENCIA 
				INNER JOIN sistema.enumerado se_turno on se_turno.ID_ENUMERADO = mte.ID_TURNO
				INNER JOIN transaccional.periodo_academico tpa on tpa.ID_PERIODO_ACADEMICO= tme.ID_PERIODO_ACADEMICO and tpa.ES_ACTIVO=1
				inner join transaccional.periodos_lectivos_por_institucion tpli on tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tpa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND tpli.ES_ACTIVO=1
				inner join maestro.periodo_lectivo mpl on mpl.ID_PERIODO_LECTIVO= tpli.ID_PERIODO_LECTIVO
				INNER JOIN sistema.enumerado se_tipo_itin on se_tipo_itin.ID_ENUMERADO= tpe.ID_TIPO_ITINERARIO	
				INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION INS ON INS.ID_INSTITUCION = mti.ID_INSTITUCION	
	WHERE 
	tme.ID_MATRICULA_ESTUDIANTE = @ID_MATRICULA_ESTUDIANTE AND tme.ES_ACTIVO=1
END


--************************************************************************
 --31. USP_MAESTROS_SEL_TIPO_PLAN_ESTUDIO_LISTA.sql