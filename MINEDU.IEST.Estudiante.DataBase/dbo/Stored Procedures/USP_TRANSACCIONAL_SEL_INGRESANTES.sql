--/*********************************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Retorna la lista de ingresantes
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--	1.0			24/01/2020		MALVA			SE AÑADIÓ PARÁMETRO @ID_PLAN_ESTUDIO, SE QUITA @IdProgramaEstudio
--*/
--  TEST:		USP_TRANSACCIONAL_SEL_INGRESANTES 1106,4221,7053,10319,23
--***********************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_INGRESANTES] 
(

	@IdInstituto INT,
	@IdSedeInstitucion	INT,
	@ID_PLAN_ESTUDIO	INT,  ---@IdProgramaEstudio
	@IdPeriodoInstitucion INT,
	@IdModalidad INT

	--DECLARE @IdInstituto INT=440
	--DECLARE @IdSedeInstitucion	INT=1965
	--DECLARE @IdProgramaEstudio	INT=64
	--DECLARE @IdPeriodoInstitucion INT=5517
	--DECLARE @IdModalidad INT=24
)
AS
BEGIN
	

	SELECT 
	    
		ppmod.ID_POSTULANTES_POR_MODALIDAD                                      Value,
		UPPER(persona.APELLIDO_PATERNO_PERSONA) + ' ' +
		UPPER(persona.APELLIDO_MATERNO_PERSONA) + ', ' + 
		dbo.UFN_CAPITALIZAR(persona.NOMBRE_PERSONA)								Text,
		pinstitucion.ID_PERSONA_INSTITUCION                                     Code
		
		FROM transaccional.resultados_por_postulante rpp
		INNER JOIN transaccional.postulantes_por_modalidad ppmod ON rpp.ID_POSTULANTES_POR_MODALIDAD = ppmod.ID_POSTULANTES_POR_MODALIDAD AND rpp.ES_ACTIVO=1 and ppmod.ES_ACTIVO=1
		INNER JOIN transaccional.modalidades_por_proceso_admision mppadm ON ppmod.ID_MODALIDADES_POR_PROCESO_ADMISION = mppadm.ID_MODALIDADES_POR_PROCESO_ADMISION AND mppadm.ES_ACTIVO=1 
		INNER JOIN transaccional.proceso_admision_periodo padmp ON mppadm.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO  AND padmp.ES_ACTIVO=1
		--INNER JOIN transaccional.periodos_lectivos_por_institucion plpins 	ON padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plpins.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND plpins.ES_ACTIVO=1 
		INNER JOIN sistema.enumerado enu ON enu.ID_ENUMERADO = mppadm.ID_MODALIDAD 		
		INNER JOIN transaccional.opciones_por_postulante oppost ON ppmod.ID_POSTULANTES_POR_MODALIDAD = oppost.ID_POSTULANTES_POR_MODALIDAD and oppost.ES_ACTIVO=1 and oppost.ID_OPCIONES_POR_POSTULANTE = rpp.ID_OPCIONES_POR_POSTULANTE
		INNER JOIN transaccional.meta_carrera_institucion_detalle mcidet ON oppost.ID_META_CARRERA_INSTITUCION_DETALLE = mcidet.ID_META_CARRERA_INSTITUCION_DETALLE and mcidet.ES_ACTIVO=1
		INNER JOIN transaccional.meta_carrera_institucion mci ON mcidet.ID_META_CARRERA_INSTITUCION = mci.ID_META_CARRERA_INSTITUCION 	AND mci.ES_ACTIVO=1 
		INNER JOIN transaccional.carreras_por_institucion cpinst ON mci.ID_CARRERAS_POR_INSTITUCION = cpinst.ID_CARRERAS_POR_INSTITUCION and cpinst.ES_ACTIVO=1
		--INNER JOIN db_auxiliar.dbo.UVW_CARRERA carrera ON cpinst.ID_CARRERA = carrera.ID_CARRERA 
		INNER JOIN maestro.persona_institucion pinstitucion ON ppmod.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION 
		INNER JOIN maestro.persona persona ON pinstitucion.ID_PERSONA = persona.ID_PERSONA 
		
		WHERE 		
		cpinst.ID_INSTITUCION = @IdInstituto
		AND padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @IdPeriodoInstitucion
		AND enu.ID_ENUMERADO = @IdModalidad
		AND mcidet.ID_SEDE_INSTITUCION = @IdSedeInstitucion
		--AND carrera.ID_CARRERA=@IdProgramaEstudio
		AND mci.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
		 --AND oppost.ORDEN=1 		
		AND rpp.ESTADO=174 	
		order by persona.APELLIDO_PATERNO_PERSONA, persona.APELLIDO_MATERNO_PERSONA,persona.NOMBRE_PERSONA
END

--******************************************************************
--56. USP_MATRICULA_UPD_RESERVA_MATRICULA.sql
GO


