/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de matriculados por traslado
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			15/01/2020		MALVA			SE OBTIENEN COLUMNAS PlanEstudiosOrigen Y PlanEstudiosDestino. 
1.1			28/01/2020		MALVA			SE MODIFICA EL VALOR DE COLUMNA SedeDestino. 
--  TEST:			
/*
	USP_MATRICULA_SEL_TRASLADO_PAGINADO 1106,10319,0,'',0,0,0,'178'
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_TRASLADO_PAGINADO]
(  
	@IdInstitucion					INT,
	@IdPeriodoLectivoInstitucion	INT,
	@IdTipoDocumento				INT,
	@NroDocumento					VARCHAR(50),
	@IdInstitucionOrigen			INT,
	@IdTipoTraslado					INT,
	@IdTipoEstado					INT,
	@IdTipoSolicitud				INT,
	@Pagina							INT = 1,
	@Registros						INT = 10  
)  
AS  
BEGIN  
	SET NOCOUNT ON; 
	SELECT ID_CARRERA, NOMBRE_CARRERA INTO #tmpCARRERA FROM db_auxiliar.dbo.UVW_CARRERA

	DECLARE @desde INT , @hasta INT;  
	SET @desde = ( @Pagina - 1 ) * @Registros;  
	SET @hasta = ( @Pagina * @Registros ) + 1;    

		WITH tempPaginado AS  
		( 	
			SELECT TE.ID_TRASLADO_ESTUDIANTE						IdTrasladoEstudiante, 
			se_tipodoc.VALOR_ENUMERADO								TipoDocumento,
			MP.NUMERO_DOCUMENTO_PERSONA								NroDocumento,
			UPPER(MP.APELLIDO_PATERNO_PERSONA)  + ' ' + UPPER(MP.APELLIDO_MATERNO_PERSONA) + ', ' + dbo.UFN_CAPITALIZAR(MP.NOMBRE_PERSONA) Estudiante,
			se_tipotras.VALOR_ENUMERADO								TipoTraslado,
			TE.ID_TIPO_TRASLADO										IdTipoTraslado,
			MPI.ID_INSTITUCION										IdInstitucion,
			MI.NOMBRE_INSTITUCION									NombreInstitucion,
			MC.NOMBRE_CARRERA										ProgramaEstudiosOrigen,
			se_itin_o.VALOR_ENUMERADO								TipoItinerarioOrigen,
			ts.VALOR_ENUMERADO + ' - ' + SI_D.NOMBRE_SEDE 			SedeDestino,			
			MC_D.NOMBRE_CARRERA										ProgramaEstudiosDestino,
			se_itin_d.VALOR_ENUMERADO								TipoItinerarioDestino, 
			PEO.NOMBRE_PLAN_ESTUDIOS								PlanEstudiosOrigen,
			PED.NOMBRE_PLAN_ESTUDIOS								PlanEstudiosDestino
			,ROW_NUMBER() OVER ( ORDER BY MP.APELLIDO_PATERNO_PERSONA, MP.APELLIDO_MATERNO_PERSONA, MP.NOMBRE_PERSONA) AS Row 
							,Total = COUNT(1) OVER ( )  
			FROM transaccional.traslado_estudiante TE 
			INNER JOIN transaccional.estudiante_institucion EI ON TE.ID_ESTUDIANTE_INSTITUCION= EI.ID_ESTUDIANTE_INSTITUCION AND TE.ES_ACTIVO=1
			--AND EI.ES_ACTIVO=1
			INNER JOIN maestro.persona_institucion MPI ON MPI.ID_PERSONA_INSTITUCION= EI.ID_PERSONA_INSTITUCION
			INNER JOIN maestro.persona MP ON MP.ID_PERSONA= MPI.ID_PERSONA
			INNER JOIN sistema.enumerado se_tipodoc ON se_tipodoc.ID_ENUMERADO= MP.ID_TIPO_DOCUMENTO
			INNER JOIN sistema.enumerado se_tipotras	ON se_tipotras.ID_ENUMERADO= TE.ID_TIPO_TRASLADO		
			INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION MI ON MI.ID_INSTITUCION= MPI.ID_INSTITUCION
			INNER JOIN transaccional.carreras_por_institucion_detalle CXID ON CXID.ID_CARRERAS_POR_INSTITUCION_DETALLE = EI.ID_CARRERAS_POR_INSTITUCION_DETALLE
			AND CXID.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion CXI ON CXI.ID_CARRERAS_POR_INSTITUCION= CXID.ID_CARRERAS_POR_INSTITUCION AND CXI.ES_ACTIVO=1
			INNER JOIN #tmpCARRERA MC ON MC.ID_CARRERA= CXI.ID_CARRERA
			INNER JOIN sistema.enumerado se_itin_o on se_itin_o.ID_ENUMERADO= CXI.ID_TIPO_ITINERARIO
			INNER JOIN transaccional.situacion_academica_estudiante SAE_D ON  SAE_D.ID_SITUACION_ACADEMICA_ESTUDIANTE= TE.ID_SITUACION_ACADEMICA_DESTINO
			INNER JOIN maestro.sede_institucion  SI_D ON SI_D.ID_SEDE_INSTITUCION= SAE_D.ID_SEDE_INSTITUCION AND SI_D.ES_ACTIVO=1			
			INNER JOIN sistema.enumerado ts ON ts.ID_ENUMERADO = SI_D.ID_TIPO_SEDE
			INNER JOIN transaccional.plan_estudio PED ON PED.ID_PLAN_ESTUDIO= SAE_D.ID_PLAN_ESTUDIO AND PED.ES_ACTIVO=1
			INNER JOIN transaccional.carreras_por_institucion CXI_D ON CXI_D.ID_CARRERAS_POR_INSTITUCION= PED.ID_CARRERAS_POR_INSTITUCION AND CXI_D.ES_ACTIVO=1
			INNER JOIN #tmpCARRERA MC_D ON MC_D.ID_CARRERA= CXI_D.ID_CARRERA 			
			inner join sistema.enumerado se_itin_d on se_itin_d.ID_ENUMERADO= CXI_D.ID_TIPO_ITINERARIO
			INNER JOIN transaccional.traslado_estudiante_detalle tedet ON TE.ID_TRASLADO_ESTUDIANTE = tedet.ID_TRASLADO_ESTUDIANTE
			INNER JOIN transaccional.situacion_academica_estudiante SAE_O ON SAE_O.ID_SITUACION_ACADEMICA_ESTUDIANTE=  TE.ID_SITUACION_ACADEMICA_ORIGEN AND SAE_O.ES_ACTIVO=1
			INNER JOIN transaccional.plan_estudio PEO ON PEO.ID_PLAN_ESTUDIO = SAE_O.ID_PLAN_ESTUDIO AND PEO.ES_ACTIVO=1
			WHERE SI_D.ID_INSTITUCION=@IdInstitucion
				AND SAE_D.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @IdPeriodoLectivoInstitucion AND TE.ES_ACTIVO=1 AND tedet.ES_ACTIVO=1
				AND (MP.ID_TIPO_DOCUMENTO = @IdTipoDocumento OR @IdTipoDocumento = 0)  		--1
				AND (MP.NUMERO_DOCUMENTO_PERSONA) LIKE '%' + @NroDocumento + '%' COLLATE LATIN1_GENERAL_CI_AI	--2
				AND (TE.ID_TIPO_TRASLADO = @IdTipoTraslado OR @IdTipoTraslado = 0)	--3
				AND (MPI.ID_INSTITUCION = @IdInstitucionOrigen OR @IdInstitucionOrigen = 0)
		)
		SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END

--************************************************************************
--53. USP_MATRICULA_SEL_RESUMEN_NOMINA_MATRICULA.sql
GO


