/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene lista de retiro de matricula por estudiante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_RETIRO_ESTUDIANTE_PAGINADO]
(  
	@ID_PERIODO_LECTIVO_INSTITUCION		INT,
	@ID_TIPO_DOCUMENTO					INT,
	@NUMERO_DOCUMENTO_PERSONA			VARCHAR(50),
	@ID_MOTIVO_RETIRO					INT =0,
	@ID_SEDE_INSTITUCION				INT =0,
	@ID_CARRERA							INT =0,
	@ID_TIPO_ITINERARIO					INT =0,
	@Pagina								int = 1,
	@Registros							int = 10  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  

 	DECLARE @desde INT , @hasta INT;  
	SET @desde = ( @Pagina - 1 ) * @Registros;  
	SET @hasta = ( @Pagina * @Registros ) + 1;   
	WITH    tempPaginado AS  
	(  
		select 
		TRE.ID_RETIRO_ESTUDIANTE							IdRetiroEstudiante, 
		TEI.ID_ESTUDIANTE_INSTITUCION						IdEstudianteInstitucion,
		MP.ID_TIPO_DOCUMENTO								IdTipoDocumento, 
		E_TIPO_DOC.VALOR_ENUMERADO							TipoDocumento,
		MP.NUMERO_DOCUMENTO_PERSONA							NumeroDocumento,		
		MP.APELLIDO_PATERNO_PERSONA + ' ' 
		+ MP.APELLIDO_MATERNO_PERSONA + ', ' 
		+ dbo.UFN_CAPITALIZAR(MP.NOMBRE_PERSONA)			Estudiante,
		MSI.NOMBRE_SEDE										SedeInstitucion, 
		MC.NOMBRE_CARRERA									ProgramaEstudios,
		TCI.ID_TIPO_ITINERARIO								IdTipoItinerario, 
		E_ITINERARIO.VALOR_ENUMERADO						TipoItinerario,
		CONVERT (VARCHAR(10),  TRE.FECHA_CREACION, 103)		FechaRetiro,
		E_TURNO.VALOR_ENUMERADO								TurnoInstitucion,
		E_SEMESTRE.VALOR_ENUMERADO							SemestreAcademico,
		TRE.ID_MOTIVO										IdMotivoRetiro,
		E_MOTIVO.VALOR_ENUMERADO							MotivoRetiro,		
		ROW_NUMBER() OVER ( ORDER BY MP.APELLIDO_PATERNO_PERSONA,MP.APELLIDO_MATERNO_PERSONA,MP.NOMBRE_PERSONA) AS Row ,
		Total = COUNT(1) OVER ( )     
		from transaccional.retiro_estudiante TRE
		INNER JOIN transaccional.estudiante_institucion TEI ON TRE.ID_ESTUDIANTE_INSTITUCION = TEI.ID_ESTUDIANTE_INSTITUCION AND TEI.ES_ACTIVO=0
		INNER JOIN maestro.persona_institucion MPI ON MPI.ID_PERSONA_INSTITUCION= TEI.ID_PERSONA_INSTITUCION
		INNER JOIN maestro.persona MP ON MP.ID_PERSONA= MPI.ID_PERSONA
		INNER JOIN sistema.enumerado E_TIPO_DOC ON E_TIPO_DOC.ID_ENUMERADO= MP.ID_TIPO_DOCUMENTO
		INNER JOIN transaccional.carreras_por_institucion_detalle TCID ON TCID.ID_CARRERAS_POR_INSTITUCION_DETALLE= TEI.ID_CARRERAS_POR_INSTITUCION_DETALLE AND TCID.ES_ACTIVO=1
		INNER JOIN transaccional.carreras_por_institucion TCI ON TCI.ID_CARRERAS_POR_INSTITUCION= TCID.ID_CARRERAS_POR_INSTITUCION AND TCI.ES_ACTIVO=1
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA MC ON MC.ID_CARRERA= TCI.ID_CARRERA --AND MC.ESTADO=1		--reemplazoPorVista
		INNER JOIN maestro.sede_institucion MSI ON MSI.ID_SEDE_INSTITUCION= TCID.ID_SEDE_INSTITUCION AND MSI.ES_ACTIVO=1
		INNER JOIN maestro.turnos_por_institucion MTXI ON MTXI.ID_TURNOS_POR_INSTITUCION= TEI.ID_TURNOS_POR_INSTITUCION AND MTXI.ES_ACTIVO=1
		INNER JOIN maestro.turno_equivalencia MTE ON MTE.ID_TURNO_EQUIVALENCIA= MTXI.ID_TURNO_EQUIVALENCIA 
		INNER JOIN sistema.enumerado E_ITINERARIO ON E_ITINERARIO.ID_ENUMERADO= TCI.ID_TIPO_ITINERARIO 
		INNER JOIN sistema.enumerado E_MOTIVO ON E_MOTIVO.ID_ENUMERADO= TRE.ID_MOTIVO		
		INNER JOIN sistema.enumerado E_SEMESTRE ON E_SEMESTRE.ID_ENUMERADO= TEI.ID_SEMESTRE_ACADEMICO
		INNER JOIN sistema.enumerado	E_TURNO ON E_TURNO.ID_ENUMERADO= MTE.ID_TURNO 

		WHERE TRE.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION
		AND (MP.ID_TIPO_DOCUMENTO= @ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO=0)
		AND (MP.NUMERO_DOCUMENTO_PERSONA) LIKE '%' + @NUMERO_DOCUMENTO_PERSONA + '%' COLLATE LATIN1_GENERAL_CI_AI
		AND (TRE.ID_MOTIVO= @ID_MOTIVO_RETIRO OR @ID_MOTIVO_RETIRO=0)
		AND (TCID.ID_SEDE_INSTITUCION= @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION=0)
		AND (MC.ID_CARRERA= @ID_CARRERA OR @ID_CARRERA=0)
		AND (TCI.ID_TIPO_ITINERARIO = @ID_TIPO_ITINERARIO OR @ID_TIPO_ITINERARIO =0)
)
SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   

END
GO


