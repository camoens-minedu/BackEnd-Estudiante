/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el listado de convalidaciones 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			15/01/2020		MALVA			SE AÑADE FILTRO @ID_PLAN_ESTUDIO
--											SE OBTIENEN COLUMNAS PlanEstudios Y PlanEstudiosOrigen.
1.1			22/05/2020		MALVA			SE OBTIENEN COLUMNAS IdSedeInstitucion, IdCarrera.
--  TEST:			
/*
USP_CONVALIDACION_SEL_ESTUDIANTE_PAGINADO 565,0,'',0,0,0,0,0
*/
--**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_CONVALIDACION_SEL_ESTUDIANTE_PAGINADO] 
(  
	@ID_PERIODO_LECTIVO_INSTITUCION		INT,
	@ID_TIPO_DOCUMENTO					INT,
	@NUMERO_DOCUMENTO_PERSONA			VARCHAR(50),
	@ID_TIPO_CONVALIDACION				INT,
	@ID_SEDE_INSTITUCION				INT,
	@ID_CARRERA							INT,
	@ID_TIPO_ITINERARIO					INT,
	@ID_PLAN_ESTUDIO					INT,
	@Pagina								int = 1,
	@Registros							int = 10  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE 
			@ID_TIPO_CONVALIDACION_TRASLADO_INTERNO	INT =194,
			@ID_TIPO_CONVALIDACION_TRASLADO_EXTERNO	INT =197,
			@TIPO_CONVALIDACION_TRASLADO_INTERNO VARCHAR(30),
			@TIPO_CONVALIDACION_TRASLADO_EXTERNO VARCHAR(30),
			@ID_TIPO_TRASLADO_INTERNO	INT =141,
			@ID_TIPO_TRASLADO_EXTERNO	INT =142,
			@ID_TIPO_TRASLADO			INT,
			@ESTADO_CONVALIDADO			INT = 201


			SET @TIPO_CONVALIDACION_TRASLADO_INTERNO = (SELECT VALOR_ENUMERADO FROM sistema.enumerado WHERE ID_ENUMERADO=@ID_TIPO_CONVALIDACION_TRASLADO_INTERNO )
			SET @TIPO_CONVALIDACION_TRASLADO_EXTERNO = (SELECT VALOR_ENUMERADO FROM sistema.enumerado WHERE ID_ENUMERADO=@ID_TIPO_CONVALIDACION_TRASLADO_EXTERNO )
 
			SET @ID_TIPO_TRASLADO = CASE WHEN @ID_TIPO_CONVALIDACION = @ID_TIPO_CONVALIDACION_TRASLADO_INTERNO THEN @ID_TIPO_TRASLADO_INTERNO
									    WHEN @ID_TIPO_CONVALIDACION = @ID_TIPO_CONVALIDACION_TRASLADO_EXTERNO THEN @ID_TIPO_TRASLADO_EXTERNO
										ELSE 0 END 

 	DECLARE @desde INT , @hasta INT;  
	SET @desde = ( @Pagina - 1 ) * @Registros;  
	SET @hasta = ( @Pagina * @Registros ) + 1;   
	WITH    tempPaginado AS  
	(  
 SELECT	
			MP.ID_TIPO_DOCUMENTO							IdTipoDocumento,
			se_tipodoc.VALOR_ENUMERADO						TipoDocumento, 
			MP.NUMERO_DOCUMENTO_PERSONA						NumeroDocumento,
			MP.APELLIDO_PATERNO_PERSONA						ApPaterno,
			MP.APELLIDO_MATERNO_PERSONA						ApMaterno,
			MP.NOMBRE_PERSONA								Nombres,
			TEI.ID_ESTUDIANTE_INSTITUCION					IdEstudianteInstitucion,
			MP.APELLIDO_PATERNO_PERSONA + ' ' 
			+ MP.APELLIDO_MATERNO_PERSONA + ', ' 
			+ dbo.UFN_CAPITALIZAR(MP.NOMBRE_PERSONA)		Estudiante,
			TC.ID_TIPO_CONVALIDACION						IdTipoConvalidacion,
			se_tipoconv.VALOR_ENUMERADO						TipoConvalidacion,
			MC.ID_CARRERA									IdCarrera,
			MC.NOMBRE_CARRERA								ProgramaEstudios,
			se_tipoitin.VALOR_ENUMERADO						TipoItinerario,
			TC.ARCHIVO_CONVALIDACION						ArchivoConvalidacion,
			TPE.ID_PLAN_ESTUDIO								IdPlanEstudio,
			MNF.SEMESTRES_ACADEMICOS						NroSemestres,		
			TC.ID_CONVALIDACION								IdConvalidacion,
			ISNULL(A.NOMBRE_INSTITUCION,'')					InstitutoOrigen,
			ISNULL(A.NOMBRE_CARRERA,'')						ProgramaEstudiosOrigen,
			CASE WHEN A.ID_TIPO_ITINERARIO IS NOT NULL THEN (SELECT VALOR_ENUMERADO FROM sistema.enumerado WHERE ID_ENUMERADO= A.ID_TIPO_ITINERARIO) ELSE '' END  TipoItinerarioOrigen,
			ISNULL( A.ID_PLAN_ESTUDIO, 0)					IdPlanEstudioOrigen,
			ISNULL(A.SEMESTRES_ACADEMICOS,0)				NroSemestresOrigen,
			TC.ESTADO										IdEstado,
			case when TC.ESTADO = @ESTADO_CONVALIDADO	THEN 'PROCESADO'	ELSE	 se_estcon.VALOR_ENUMERADO	END Estado	 ,
			MSI.ID_SEDE_INSTITUCION							IdSedeInstitucion,
			MSI.NOMBRE_SEDE									SedeInstitucion,
			TEI.ID_TURNOS_POR_INSTITUCION					IdTurnoInstitucion,
			TEI.ID_SEMESTRE_ACADEMICO						IdSemestreAcademico,
			ISNULL(A.ID_ESTUDIANTE_INSTITUCION_ORIGEN,0)	IdEstudianteInstitucionOrigen,
			CASE WHEN ME.ID_MATRICULA_ESTUDIANTE IS NOT NULL THEN CAST('true' as bit) ELSE CAST('false' as bit) END EsMatriculado,
			TC.NRO_RD                                       NRO_RD,
			TC.ARCHIVO_RD                                   ARCHIVO_RD,
			TPE.NOMBRE_PLAN_ESTUDIOS						PlanEstudios,
			A.PLAN_ESTUDIOS_ORIGEN							PlanEstudiosOrigen,
			ROW_NUMBER() OVER ( ORDER BY MP.APELLIDO_PATERNO_PERSONA,MP.APELLIDO_MATERNO_PERSONA,MP.NOMBRE_PERSONA) AS Row ,
			Total = COUNT(1) OVER ( )     
	 FROM	
			transaccional.convalidacion TC
			INNER JOIN transaccional.estudiante_institucion TEI				ON TC.ID_ESTUDIANTE_INSTITUCION= TEI.ID_ESTUDIANTE_INSTITUCION AND TEI.ES_ACTIVO=1 AND TC.ES_ACTIVO=1
			INNER JOIN maestro.persona_institucion MPI						ON MPI.ID_PERSONA_INSTITUCION= TEI.ID_PERSONA_INSTITUCION 
			INNER JOIN maestro.persona MP									ON MP.ID_PERSONA= MPI.ID_PERSONA 
			INNER JOIN transaccional.carreras_por_institucion_detalle TCID	ON TCID.ID_CARRERAS_POR_INSTITUCION_DETALLE= TEI.ID_CARRERAS_POR_INSTITUCION_DETALLE 
																			AND TCID.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion TCI			ON TCI.ID_CARRERAS_POR_INSTITUCION= TCID.ID_CARRERAS_POR_INSTITUCION 
																			AND TCI.ES_ACTIVO=1
			INNER JOIN transaccional.plan_estudio TPE						ON TPE.ID_PLAN_ESTUDIO= TEI.ID_PLAN_ESTUDIO
																			AND TPE.ES_ACTIVO=1
			INNER JOIN db_auxiliar.dbo.UVW_CARRERA MC						ON MC.ID_CARRERA = TCI.ID_CARRERA 
			INNER JOIN sistema.enumerado se_tipodoc							ON se_tipodoc.ID_ENUMERADO= MP.ID_TIPO_DOCUMENTO
			INNER JOIN sistema.enumerado se_tipoconv						ON se_tipoconv.ID_ENUMERADO= TC.ID_TIPO_CONVALIDACION
			INNER JOIN sistema.enumerado se_tipoitin						ON se_tipoitin.ID_ENUMERADO= TCI.ID_TIPO_ITINERARIO
			INNER JOIN maestro.nivel_formacion MNF							ON MC.TIPO_NIVEL_FORMACION = MNF.CODIGO_TIPO --MC.ID_NIVEL_FORMACION=  MNF.ID_NIVEL_FORMACION			--reemplazoPorVista
			INNER JOIN sistema.enumerado se_estcon							ON se_estcon.ID_ENUMERADO= TC.ESTADO
			INNER JOIN maestro.sede_institucion	MSI							ON MSI.ID_SEDE_INSTITUCION= TCID.ID_SEDE_INSTITUCION
			LEFT JOIN 
			(
				SELECT TTE.ID_TRASLADO_ESTUDIANTE, MI.NOMBRE_INSTITUCION, MC.NOMBRE_CARRERA, TCI.ID_TIPO_ITINERARIO, TSAE.ID_PLAN_ESTUDIO, NF.SEMESTRES_ACADEMICOS,
				TTE.ID_ESTUDIANTE_INSTITUCION ID_ESTUDIANTE_INSTITUCION_ORIGEN, TPE.NOMBRE_PLAN_ESTUDIOS PLAN_ESTUDIOS_ORIGEN
				FROM transaccional.traslado_estudiante TTE 
				INNER JOIN transaccional.situacion_academica_estudiante TSAE ON TTE.ID_SITUACION_ACADEMICA_ORIGEN = TSAE.ID_SITUACION_ACADEMICA_ESTUDIANTE 
				AND TTE.ES_ACTIVO=1 AND TSAE.ES_ACTIVO=1
				INNER JOIN transaccional.periodos_lectivos_por_institucion TPLXI ON TPLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= TSAE.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
				AND TPLXI.ES_ACTIVO=1
				INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION MI ON MI.ID_INSTITUCION= TPLXI.ID_INSTITUCION 
				INNER JOIN transaccional.plan_estudio TPE ON TPE.ID_PLAN_ESTUDIO = TSAE.ID_PLAN_ESTUDIO AND TPE.ES_ACTIVO=1
				INNER JOIN transaccional.carreras_por_institucion TCI ON TCI.ID_CARRERAS_POR_INSTITUCION= TPE.ID_CARRERAS_POR_INSTITUCION AND TCI.ES_ACTIVO=1
				INNER JOIN db_auxiliar.dbo.UVW_CARRERA MC ON MC.ID_CARRERA = TCI.ID_CARRERA 
				INNER JOIN maestro.nivel_formacion NF ON	NF.CODIGO_TIPO = MC.TIPO_NIVEL_FORMACION --NF.ID_NIVEL_FORMACION = MC.ID_NIVEL_FORMACION	--reemplazoPorVista
			)A ON A.ID_TRASLADO_ESTUDIANTE= TC.ID_TRASLADO_ESTUDIANTE
			LEFT JOIN transaccional.matricula_estudiante	ME				ON ME.ID_ESTUDIANTE_INSTITUCION = TEI.ID_ESTUDIANTE_INSTITUCION 			
			AND ME.ES_ACTIVO=1
			AND  ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION

	WHERE
		(MP.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO = 0)  		
			AND (MP.NUMERO_DOCUMENTO_PERSONA) LIKE '%' + @NUMERO_DOCUMENTO_PERSONA + '%' COLLATE LATIN1_GENERAL_CI_AI
			AND (TC.ID_TIPO_CONVALIDACION =@ID_TIPO_CONVALIDACION OR @ID_TIPO_CONVALIDACION=0)
			AND (TCID.ID_SEDE_INSTITUCION= @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION=0)
			AND (TCI.ID_CARRERA= @ID_CARRERA OR @ID_CARRERA =0)
			AND (TCI.ID_TIPO_ITINERARIO = @ID_TIPO_ITINERARIO OR @ID_TIPO_ITINERARIO=0)
			AND TC.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION
			AND (TEI.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO OR @ID_PLAN_ESTUDIO =0)
		)
SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   

END  


--/************************************************************************************************************************************
--AUTOR				:	Mayra Alva
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Consulta unidades didácticas por programación de clase. 
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		USP_PLANIFICACION_SEL_PROGRAMACION_UNIDADES_DIDACTICAS 4979
--/*
--	1.0			12/12/2019		MALVA          MODIFICACIÓN PARA QUE LA COLUMNA PlanEstudio retorne el nombre del plan de estudios,
--											   y TipoPlanEstudio retorne el nombre del tipo de itinerario. Además, se muestra correctamente
--											   las columnas IdTipoPlanEstudio y IdPlanEstudio.	
--*/
--*************************************************************************************************************************************/
GO


