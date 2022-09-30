/************************************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Listado de postulantes por distribución de aulas
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO		DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR		CREACIÓN
2.0			26/12/2019		MALVA       SE AGREGA PARÁMETRO @EsReporte PARA CONSULTA DE REPORTE DE DISTRIBUCIÓN DE POSTULANTES.
3.0			20/05/2022		JCHAVEZ		OPTIMIZACIÓN DE SCRIPT

TEST:
	USP_ADMISION_SEL_DISTRIBUCION_POSTULANTES_PAGINADO 1082, 393, 24, 1060
*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_DISTRIBUCION_POSTULANTES_PAGINADO](
	@ID_PERIODO_LECTIVO_INSTITUCION		INT,
	@ID_SEDE_INSTITUCION				INT,
	@ID_MODALIDAD						INT,
	@ID_DISTRIBUCION_EXAMEN_ADMISION	INT, 
	@Pagina								INT = 1,
	@Registros							INT = 1000,
	@EsReporte							BIT= 0
)
AS  
BEGIN  
	SET NOCOUNT ON;

	--VARIABLES PARA PAGINADO:
		DECLARE @desde INT , @hasta INT;
		SET @desde = ( @Pagina - 1 ) * @Registros;
		SET @hasta = ( @Pagina * @Registros ) + 1;

		WITH  tempPaginado AS
		(
			SELECT 
			DEA.ID_DISTRIBUCION_EXAMEN_ADMISION		IdDistribucionExamenAdmision, 
			SI.NOMBRE_SEDE							SedeInstitucion,
			EAS.ID_MODALIDAD						idModalidad,
			E_MOD.VALOR_ENUMERADO					Modalidad,
			A.ID_AULA								IdAula,
			A.NOMBRE_AULA							AulaInstitucion,
			A.AFORO_AULA							AforoAula,
			MPI_E.ID_PERSONAL_INSTITUCION			IdPersonalInstitucion,
			UPPER(P_E.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(P_E.APELLIDO_MATERNO_PERSONA) + ', ' + dbo.UFN_CAPITALIZAR( P_E.NOMBRE_PERSONA)      AS Evaluador,
			P_P.ID_TIPO_DOCUMENTO,					
			E_TDOC.VALOR_ENUMERADO 					IdTipoDocumento,
			P_P.NUMERO_DOCUMENTO_PERSONA			NumeroDocumento,	
			P_P.APELLIDO_PATERNO_PERSONA			ApellidoPaterno,
			P_P.APELLIDO_MATERNO_PERSONA			ApellidoMaterno,
			P_P.NOMBRE_PERSONA						Nombre,
			UPPER(P_P.APELLIDO_PATERNO_PERSONA) + ' ' + UPPER(P_P.APELLIDO_MATERNO_PERSONA) + ', ' + dbo.UFN_CAPITALIZAR(P_P.NOMBRE_PERSONA)      AS NombreCompleto,
			CASE WHEN @EsReporte = 1 THEN  PXM.ARCHIVO_RUTA 	ELSE '' END			ArchivoRuta,
			PXM.ARCHIVO_FOTO						ArchivoFoto,
			PAP.NOMBRE_PROCESO_ADMISION				NombreProcesoAdmision,
			INS.NOMBRE_INSTITUCION					Institucion,			
			ROW_NUMBER() OVER ( ORDER BY DEA.ID_EXAMEN_ADMISION_SEDE) AS Row,
			Total = count(1) OVER ()			
			FROM transaccional.distribucion_examen_admision DEA
			INNER JOIN transaccional.examen_admision_sede EAS ON DEA.ID_EXAMEN_ADMISION_SEDE= EAS.ID_EXAMEN_ADMISION_SEDE 
			AND DEA.ES_ACTIVO=1 AND EAS.ES_ACTIVO=1
			INNER JOIN transaccional.proceso_admision_periodo PAP ON PAP.ID_PROCESO_ADMISION_PERIODO= EAS.ID_PROCESO_ADMISION_PERIODO 
			AND PAP.ES_ACTIVO=1
			INNER JOIN maestro.sede_institucion SI ON SI.ID_SEDE_INSTITUCION= EAS.ID_SEDE_INSTITUCION AND SI.ES_ACTIVO=1
			INNER JOIN sistema.enumerado E_MOD ON E_MOD.ID_ENUMERADO= EAS.ID_MODALIDAD
			INNER JOIN maestro.aula A ON A.ID_AULA= DEA.ID_AULA AND A.ES_ACTIVO=1
			INNER JOIN transaccional.evaluador_admision_modalidad EAM ON EAM.ID_EVALUADOR_ADMISION_MODALIDAD = DEA.ID_EVALUADOR_ADMISION_MODALIDAD AND EAM.ES_ACTIVO=1
			INNER JOIN maestro.personal_institucion MPI_E ON  MPI_E.ID_PERSONAL_INSTITUCION= EAM.ID_PERSONAL_INSTITUCION AND MPI_E.ES_ACTIVO=1
			INNER JOIN maestro.persona_institucion PI_E  ON PI_E.ID_PERSONA_INSTITUCION = MPI_E.ID_PERSONA_INSTITUCION 
			INNER JOIN maestro.persona P_E ON P_E.ID_PERSONA= PI_E.ID_PERSONA
			INNER JOIN transaccional.distribucion_evaluacion_admision_detalle DEAD ON DEAD.ID_DISTRIBUCION_EXAMEN_ADMISION= DEA.ID_DISTRIBUCION_EXAMEN_ADMISION AND DEAD.ES_ACTIVO=1
			INNER JOIN transaccional.postulantes_por_modalidad PXM ON PXM.ID_POSTULANTES_POR_MODALIDAD = DEAD.ID_POSTULANTES_POR_MODALIDAD AND PXM.ES_ACTIVO=1
			INNER JOIN maestro.persona_institucion PI_P ON PI_P.ID_PERSONA_INSTITUCION= PXM.ID_PERSONA_INSTITUCION 
			INNER JOIN maestro.persona P_P ON P_P.ID_PERSONA= PI_P.ID_PERSONA
			INNER JOIN sistema.enumerado E_TDOC ON E_TDOC.ID_ENUMERADO = P_P.ID_TIPO_DOCUMENTO
			INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION INS ON INS.ID_INSTITUCION = SI.ID_INSTITUCION
			WHERE PAP.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION
			AND EAS.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION
			AND EAS.ID_MODALIDAD = @ID_MODALIDAD 
			AND DEA.ID_DISTRIBUCION_EXAMEN_ADMISION= @ID_DISTRIBUCION_EXAMEN_ADMISION
		)
		SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 

END
GO


