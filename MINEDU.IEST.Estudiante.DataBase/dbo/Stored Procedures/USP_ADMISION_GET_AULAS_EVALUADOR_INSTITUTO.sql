/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista evaluadores por aula de la institución en el proceso de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_GET_AULAS_EVALUADOR_INSTITUTO]
(
	@ID_PERIODOLECTIVO_INSTITUCION INT='',
	@ID_SEDE_INSTITUCION	INT ='',
	@ID_MODALIDAD	INT	='',
	@Pagina						int		=1,
	@Registros					int		=10
	
)
AS
BEGIN
SET NOCOUNT ON;
	
    DECLARE @desde INT , @hasta INT;
	
	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 
    
	WITH    tempPaginado AS
	(

	SELECT 
		deadm.ID_DISTRIBUCION_EXAMEN_ADMISION                                                                         IdDistribucionExamenAdmision,
		sinsti.NOMBRE_SEDE                                                                                            SedeInstitucion,
		enu.VALOR_ENUMERADO                                                                                           Modalidad,
		aula.ID_AULA                                                                                                  IdAula,
		aula.NOMBRE_AULA                                                                                              AulaInstitucion,
		aula.AFORO_AULA                                                                                               AforoAula,
		persona.ID_PERSONA                                                                                            IdPersonalInstitucion,
		persona.APELLIDO_PATERNO_PERSONA + ' ' + persona.APELLIDO_MATERNO_PERSONA + ', ' + dbo.UFN_CAPITALIZAR(persona.NOMBRE_PERSONA)      Evaluador,
		(select count(1) from transaccional.distribucion_evaluacion_admision_detalle tdead 
		where tdead.ID_DISTRIBUCION_EXAMEN_ADMISION=deadm.ID_DISTRIBUCION_EXAMEN_ADMISION and tdead.ES_ACTIVO=1 )     CantidadPostulantes,
		ROW_NUMBER() OVER ( ORDER BY eadse.ID_SEDE_INSTITUCION) AS Row,
		Total = COUNT(1) OVER ( )           

		FROM transaccional.distribucion_examen_admision deadm JOIN transaccional.examen_admision_sede eadse 
		ON deadm.ID_EXAMEN_ADMISION_SEDE = eadse.ID_EXAMEN_ADMISION_SEDE JOIN maestro.sede_institucion sinsti 
		ON eadse.ID_SEDE_INSTITUCION = sinsti.ID_SEDE_INSTITUCION JOIN transaccional.proceso_admision_periodo padmp
		ON eadse.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO JOIN maestro.aula aula
		ON deadm.ID_AULA = aula.ID_AULA JOIN transaccional.evaluador_admision_modalidad eadmod
		ON deadm.ID_EVALUADOR_ADMISION_MODALIDAD = eadmod.ID_EVALUADOR_ADMISION_MODALIDAD JOIN transaccional.modalidades_por_proceso_admision mppradm
		ON eadmod.ID_MODALIDADES_POR_PROCESO_ADMISION = mppradm.ID_MODALIDADES_POR_PROCESO_ADMISION  AND padmp.ID_PROCESO_ADMISION_PERIODO = mppradm.ID_PROCESO_ADMISION_PERIODO JOIN sistema.enumerado enu
		ON enu.ID_ENUMERADO = mppradm.ID_MODALIDAD JOIN maestro.personal_institucion personalInstitucion
		ON eadmod.ID_PERSONAL_INSTITUCION = personalInstitucion.ID_PERSONAL_INSTITUCION JOIN maestro.persona_institucion pinstitucion
		ON personalInstitucion.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION JOIN maestro.persona persona
		ON pinstitucion.ID_PERSONA = persona.ID_PERSONA		
		WHERE padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION AND sinsti.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION 
		AND mppradm.ID_MODALIDAD=@ID_MODALIDAD AND eadse.ES_ACTIVO=1 AND padmp.ES_ACTIVO=1 AND eadmod.ES_ACTIVO=1 AND mppradm.ES_ACTIVO=1 AND deadm.ES_ACTIVO=1
		
	)
	SELECT  *
    FROM    tempPaginado T   WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
	
END
GO


