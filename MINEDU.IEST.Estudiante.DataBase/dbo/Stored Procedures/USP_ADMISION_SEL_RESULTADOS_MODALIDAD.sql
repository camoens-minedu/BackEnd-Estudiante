CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_RESULTADOS_MODALIDAD]
(
	@ID_PROCESO_ADMISION_PERIODO INT
)
AS
BEGIN
	DECLARE @ID_INSTITUCION INT, @IdModalidadExtraordinaria INT, @IdTipoModalidadOrdinarioAlternativo INT, @NombreTipoModalidad varchar(30)
	
	SET @NombreTipoModalidad = 'ORDINARIO ALTERNATIVO'
	SET @IdModalidadExtraordinaria  = (SELECT ID_ENUMERADO FROM sistema.enumerado where VALOR_ENUMERADO='EXTRAORDINARIO')
	SET @IdTipoModalidadOrdinarioAlternativo= (SELECT ID_TIPO_MODALIDAD FROM maestro.tipo_modalidad WHERE NOMBRE_TIPO_MODALIDAD='ORDINARIO ALTERNATIVO')
	SELECT	
		PAP.ID_PROCESO_ADMISION_PERIODO														IdProcesoAdmisionPeriodo,
		PAP.NOMBRE_PROCESO_ADMISION															ProcesoAdmisionPeriodo,
		MD.ID_ENUMERADO																		IdModalidad,
		MP.ID_MODALIDADES_POR_PROCESO_ADMISION												IdModalidadProcesoAdmision,
		CASE WHEN	MD.ID_ENUMERADO = @IdModalidadExtraordinaria 
		THEN
					MD.VALOR_ENUMERADO + ' - ' + 	@NombreTipoModalidad
		ELSE
					MD.VALOR_ENUMERADO
		END 																				ModalidadProcesoAdmision,
		CASE WHEN MD.ID_ENUMERADO = @IdModalidadExtraordinaria 
		THEN
					@IdTipoModalidadOrdinarioAlternativo	
		ELSE
					0
		END 																				IdTipoModalidad,
		CASE WHEN MD.ID_ENUMERADO = @IdModalidadExtraordinaria 
		THEN	 
					(SELECT COUNT(1)  FROM transaccional.postulantes_por_modalidad  tpxm
					INNER JOIN maestro.tipos_modalidad_por_institucion mtmxi on tpxm.ID_TIPOS_MODALIDAD_POR_INSTITUCION= mtmxi.ID_TIPOS_MODALIDAD_POR_INSTITUCION					
					WHERE tpxm.ID_MODALIDADES_POR_PROCESO_ADMISION = MP.ID_MODALIDADES_POR_PROCESO_ADMISION AND mtmxi.ID_TIPO_MODALIDAD =@IdTipoModalidadOrdinarioAlternativo
					)
		ELSE
					(SELECT COUNT(1) FROM transaccional.postulantes_por_modalidad tpxm
					WHERE tpxm.ID_MODALIDADES_POR_PROCESO_ADMISION = MP.ID_MODALIDADES_POR_PROCESO_ADMISION
					AND tpxm.ES_ACTIVO=1)
					END																		Postulantes,
		MP.ESTADO																			IdEstado,
		E.VALOR_ENUMERADO																	Estado,
		(select count(1) from transaccional.resultados_por_postulante trxp
			inner join transaccional.postulantes_por_modalidad tpxm on trxp.ID_POSTULANTES_POR_MODALIDAD= tpxm.ID_POSTULANTES_POR_MODALIDAD
			inner join transaccional.modalidades_por_proceso_admision tmxpa on tmxpa.ID_MODALIDADES_POR_PROCESO_ADMISION= tpxm.ID_MODALIDADES_POR_PROCESO_ADMISION
			where tmxpa.ID_MODALIDADES_POR_PROCESO_ADMISION=  	MP.ID_MODALIDADES_POR_PROCESO_ADMISION		
		)																					NroPostulantesEval
	FROM 
		transaccional.proceso_admision_periodo PAP
		INNER JOIN transaccional.modalidades_por_proceso_admision MP ON MP.ID_PROCESO_ADMISION_PERIODO = PAP.ID_PROCESO_ADMISION_PERIODO and PAP.ES_ACTIVO=1 and MP.ES_ACTIVO=1
		INNER JOIN sistema.enumerado MD ON MD.ID_ENUMERADO = MP.ID_MODALIDAD
		INNER JOIN sistema.enumerado E ON E.ID_ENUMERADO = MP.ESTADO	
	WHERE
		PAP.ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO
	ORDER BY MD.ID_ENUMERADO
END
GO


