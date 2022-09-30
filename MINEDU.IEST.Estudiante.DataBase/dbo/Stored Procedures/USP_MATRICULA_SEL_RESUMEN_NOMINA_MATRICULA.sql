﻿--/**********************************************************************************************************
--AUTOR				:	Mayra Alva
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Obtiene información del total registros de la consulta. 
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--1.0			29/01/2020		MALVA			SE REEMPLAZÓ @ID_TIPO_ITINERARIO POR @ID_PLAN_ESTUDIO
----  TEST:			
--/*
--	EXEC USP_MATRICULA_SEL_RESUMEN_NOMINA_MATRICULA 10319,4221,1101,6043,2255,2898,10091,113,1
--*/
--**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_RESUMEN_NOMINA_MATRICULA]
(
	@ID_PERIODO_LECTIVO_INSTITUCION			INT,
	@ID_SEDE_INSTITUCION	INT=0,
	@ID_CARRERA				INT=0,
	@ID_PLAN_ESTUDIO		INT=0,
	@ID_PERIODO_ACADEMICO	INT=0,
	@ID_TURNO_INSTITUCION	INT=0,
	@ID_SECCION				INT=0,
	@ID_SEMESTRE_ACADEMICO	INT=0,
	@TIPO_MATRICULA			INT=0  --1-->Regular / 0-->Extemporánea

	--DECLARE @ID_PERIODO_LECTIVO_INSTITUCION			INT=3905
	--DECLARE @ID_SEDE_INSTITUCION	INT=1503
	--DECLARE @ID_CARRERA				INT=1316
	--DECLARE @ID_PLAN_ESTUDIO		INT=3806
	--DECLARE @ID_PERIODO_ACADEMICO	INT=3788
	--DECLARE @ID_TURNO_INSTITUCION	INT=547
	--DECLARE @ID_SECCION				INT=105
	--DECLARE @ID_SEMESTRE_ACADEMICO	INT=111
	--DECLARE @TIPO_MATRICULA			INT= 1 --1-->Regular / 0-->Extemporánea

)
AS 
BEGIN
		DECLARE @ID_PROGRAMACION_MATRICULA INT, 
		@ID_TIPO_MATRICULA INT,
		@ID_TIPO_ENUMERADO INT 

		SET @ID_TIPO_ENUMERADO = (SELECT ID_TIPO_ENUMERADO FROM sistema.tipo_enumerado WHERE DESCRIPCION_TIPO_ENUMERADO='TIPO_MATRICULA')
		IF (@TIPO_MATRICULA =1)
				SET @ID_TIPO_MATRICULA = (SELECT ID_ENUMERADO 
													FROM sistema.enumerado 
													WHERE VALOR_ENUMERADO = 'REGULAR' AND ID_TIPO_ENUMERADO= @ID_TIPO_ENUMERADO
										 )  
		ELSE 
				SET @ID_TIPO_MATRICULA = (SELECT ID_ENUMERADO 
													FROM sistema.enumerado 
													WHERE VALOR_ENUMERADO = 'EXTEMPORÁNEA' AND ID_TIPO_ENUMERADO= @ID_TIPO_ENUMERADO
										 ) 
		
		SET @ID_PROGRAMACION_MATRICULA = (SELECT ID_PROGRAMACION_MATRICULA FROM transaccional.programacion_matricula 
											WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION AND ID_TIPO_MATRICULA=@ID_TIPO_MATRICULA AND ES_ACTIVO=1)
									

		SELECT @ID_PROGRAMACION_MATRICULA IdProgramacionMatricula, COUNT (distinct ME.ID_ESTUDIANTE_INSTITUCION) TotalRegistros	
		FROM  transaccional.matricula_estudiante ME	
			INNER JOIN transaccional.estudiante_institucion EI ON ME.ID_ESTUDIANTE_INSTITUCION= EI.ID_ESTUDIANTE_INSTITUCION AND EI.ES_ACTIVO=1 AND ME.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion_detalle CXID ON CXID.ID_CARRERAS_POR_INSTITUCION_DETALLE= EI.ID_CARRERAS_POR_INSTITUCION_DETALLE AND CXID.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion CXI ON CXI.ID_CARRERAS_POR_INSTITUCION= CXID.ID_CARRERAS_POR_INSTITUCION AND CXI.ES_ACTIVO=1
			INNER JOIN transaccional.plan_estudio	PE on PE.ID_PLAN_ESTUDIO = EI.ID_PLAN_ESTUDIO AND PE.ES_ACTIVO=1		
			INNER JOIN transaccional.programacion_clase_por_matricula_estudiante PCXME ON ME.ID_MATRICULA_ESTUDIANTE= PCXME.ID_MATRICULA_ESTUDIANTE AND PCXME.ES_ACTIVO=1
			INNER JOIN transaccional.programacion_clase PC ON PC.ID_PROGRAMACION_CLASE= PCXME.ID_PROGRAMACION_CLASE AND PC.ES_ACTIVO=1
			INNER JOIN transaccional.unidades_didacticas_por_programacion_clase UDXPC ON UDXPC.ID_PROGRAMACION_CLASE= PCXME.ID_PROGRAMACION_CLASE AND UDXPC.ES_ACTIVO=1
			INNER JOIN transaccional.unidades_didacticas_por_enfoque UDXE ON UDXE.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= UDXPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND UDXE.ES_ACTIVO =1
			INNER JOIN transaccional.unidad_didactica UD ON UD.ID_UNIDAD_DIDACTICA= UDXE.ID_UNIDAD_DIDACTICA AND UD.ES_ACTIVO=1
		WHERE 
			--ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION
			--AND ME.ID_PERIODO_ACADEMICO= @ID_PERIODO_ACADEMICO
			--AND ME.ID_PROGRAMACION_MATRICULA =@ID_PROGRAMACION_MATRICULA	
			--AND UD.ID_SEMESTRE_ACADEMICO=@ID_SEMESTRE_ACADEMICO
			--AND PC.ID_TURNOS_POR_INSTITUCION= @ID_TURNO_INSTITUCION 
			--AND PC.ID_SECCION= @ID_SECCION
			--AND CXI.ID_CARRERA= @ID_CARRERA
			--AND PE.ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO
			--AND CXID.ID_SEDE_INSTITUCION= @ID_SEDE_INSTITUCION		
			
			(ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION OR @ID_PERIODO_LECTIVO_INSTITUCION = 0)
			AND (ME.ID_PERIODO_ACADEMICO= @ID_PERIODO_ACADEMICO OR @ID_PERIODO_ACADEMICO = 0)
			AND (ME.ID_PROGRAMACION_MATRICULA =@ID_PROGRAMACION_MATRICULA OR @ID_PROGRAMACION_MATRICULA = 0)	
			AND (UD.ID_SEMESTRE_ACADEMICO=@ID_SEMESTRE_ACADEMICO OR @ID_SEMESTRE_ACADEMICO = 0)
			AND (PC.ID_TURNOS_POR_INSTITUCION= @ID_TURNO_INSTITUCION OR @ID_TURNO_INSTITUCION = 0) 
			AND (PC.ID_SECCION= @ID_SECCION OR @ID_SECCION = 0)
			AND (CXI.ID_CARRERA= @ID_CARRERA OR @ID_CARRERA = 0)
			AND (PE.ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO OR @ID_PLAN_ESTUDIO = 0)
			AND (CXID.ID_SEDE_INSTITUCION= @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION = 0)			

END

--************************************************************************************************
--77. USP_MATRICULA_SEL_PROGRAMACION_MATRICULA_VIGENTE.sql
GO


