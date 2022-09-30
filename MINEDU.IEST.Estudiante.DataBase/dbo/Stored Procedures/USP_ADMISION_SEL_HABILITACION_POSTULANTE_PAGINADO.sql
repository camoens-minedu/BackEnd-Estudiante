CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_HABILITACION_POSTULANTE_PAGINADO]
( 
	@ID_INSTITUCION		                INT,
	@ID_SEDEINSTITUCION		            INT,
	@ID_PERIODOLECTIVO_INSTITUCION		INT,
	@ID_CARRERA                     	INT,
	@ID_TIPO_ITINERARIO                	INT,
	@ID_TIPO_DOCUMENTO       			INT,
	@NRO_DOCUMENTO					    VARCHAR(16),
	@Pagina								int = 1,
	@Registros							int = 1000  

	--DECLARE @ID_INSTITUCION		                INT=1911
	--DECLARE @ID_SEDEINSTITUCION		            INT=1942
	--DECLARE @ID_PERIODOLECTIVO_INSTITUCION		INT=5495
	--DECLARE @ID_CARRERA                     	INT=1179
	--DECLARE @ID_TIPO_ITINERARIO                	INT=101
	--DECLARE @ID_TIPO_DOCUMENTO       			INT=0
	 
	--DECLARE @NRO_DOCUMENTO					    VARCHAR(16)=''
	--DECLARE @Pagina								int = 1
	--DECLARE @Registros							int = 1000  
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
		ppmod.ID_POSTULANTES_POR_MODALIDAD					IdPostulanteAdmision, 
		sinsti.ID_SEDE_INSTITUCION                          IdSedeInstitucion,
        sinsti.NOMBRE_SEDE                                  SedeInstitucion,
		enume.ID_ENUMERADO								    IdTipoDocumento, 
		p.NUMERO_DOCUMENTO_PERSONA							NumeroDocumento,		
		p.APELLIDO_PATERNO_PERSONA + ' ' 
		+ p.APELLIDO_MATERNO_PERSONA + ', ' 
		+ dbo.UFN_CAPITALIZAR(p.NOMBRE_PERSONA)			    Estudiante,
		c.ID_CARRERA                                        IdProgramaEstudio, 
		c.NOMBRE_CARRERA                                    ProgramaEstudio, 
		enu.ID_ENUMERADO                                    IdTipoItinerario,
		enu.VALOR_ENUMERADO                                 TipoItinerario,
		ppmod.ESTADO                                        Estado,
		ppmod.ARCHIVO_COMPROBANTE_RUTA                      ArchivoComprobante,
		ROW_NUMBER() OVER ( ORDER BY p.APELLIDO_PATERNO_PERSONA,p.APELLIDO_PATERNO_PERSONA,p.NOMBRE_PERSONA) AS Row ,
		Total = COUNT(1) OVER ( )     
		FROM transaccional.postulantes_por_modalidad ppmod INNER JOIN transaccional.modalidades_por_proceso_admision mooadm
		ON ppmod.ID_MODALIDADES_POR_PROCESO_ADMISION = mooadm.ID_MODALIDADES_POR_PROCESO_ADMISION INNER JOIN transaccional.proceso_admision_periodo paped
		ON mooadm.ID_PROCESO_ADMISION_PERIODO = paped.ID_PROCESO_ADMISION_PERIODO INNER JOIN transaccional.periodos_lectivos_por_institucion plec
		ON paped.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plec.ID_PERIODOS_LECTIVOS_POR_INSTITUCION INNER JOIN transaccional.opciones_por_postulante opost
		ON ppmod.ID_POSTULANTES_POR_MODALIDAD = opost.ID_POSTULANTES_POR_MODALIDAD INNER JOIN transaccional.meta_carrera_institucion_detalle mcidet
		ON opost.ID_META_CARRERA_INSTITUCION_DETALLE = mcidet.ID_META_CARRERA_INSTITUCION_DETALLE INNER JOIN transaccional.meta_carrera_institucion mci
		ON mcidet.ID_META_CARRERA_INSTITUCION = mci.ID_META_CARRERA_INSTITUCION INNER JOIN transaccional.carreras_por_institucion cins
		ON mci.ID_CARRERAS_POR_INSTITUCION = cins.ID_CARRERAS_POR_INSTITUCION INNER JOIN db_auxiliar.dbo.UVW_CARRERA c 
		ON cins.ID_CARRERA = c.ID_CARRERA INNER JOIN sistema.enumerado enu 
		ON cins.ID_TIPO_ITINERARIO = enu.ID_ENUMERADO INNER JOIN maestro.persona_institucion pins
		ON ppmod.ID_PERSONA_INSTITUCION = pins.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona p
		ON pins.ID_PERSONA = p.ID_PERSONA INNER JOIN sistema.enumerado enume 
		ON p.ID_TIPO_DOCUMENTO = enume.ID_ENUMERADO INNER JOIN maestro.sede_institucion sinsti
		ON mcidet.ID_SEDE_INSTITUCION = sinsti.ID_SEDE_INSTITUCION 

		WHERE 
		mooadm.ES_ACTIVO=1 AND paped.ES_ACTIVO=1 AND opost.ES_ACTIVO=1 AND mcidet.ES_ACTIVO=1 AND mci.ES_ACTIVO=1 AND cins.ES_ACTIVO=1 
		AND (plec.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOLECTIVO_INSTITUCION OR @ID_PERIODOLECTIVO_INSTITUCION=0) 
		AND (sinsti.ID_SEDE_INSTITUCION= @ID_SEDEINSTITUCION OR @ID_SEDEINSTITUCION=0) 
		AND (cins.ID_CARRERAS_POR_INSTITUCION= @ID_CARRERA OR @ID_CARRERA=0) 
		AND (enu.ID_ENUMERADO= @ID_TIPO_ITINERARIO OR @ID_TIPO_ITINERARIO=0) 
		AND (enume.ID_ENUMERADO= @ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO=0) 
		AND (p.NUMERO_DOCUMENTO_PERSONA= @NRO_DOCUMENTO OR @NRO_DOCUMENTO=0)
)
SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
END
GO


