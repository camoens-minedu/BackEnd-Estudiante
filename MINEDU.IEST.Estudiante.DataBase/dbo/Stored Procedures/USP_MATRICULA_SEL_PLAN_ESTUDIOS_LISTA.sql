CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_PLAN_ESTUDIOS_LISTA] 
(
@ID_INSTITUCION INT,
@ID_CARRERA INT
)  
AS  
BEGIN  
	SET NOCOUNT ON;  
	
	SELECT 
    pestudio.ID_PLAN_ESTUDIO                                      IdPlanEstudio,
	pestudio.NOMBRE_PLAN_ESTUDIOS                                 PlanEstudio,
	cinstitucion.ID_CARRERAS_POR_INSTITUCION                      IdCarreraInstitucionDestino,
	carrera.NOMBRE_CARRERA                                        CarreraDestino,
	enu.ID_ENUMERADO                                              IdModalidad,
	enu.VALOR_ENUMERADO                                           Modalidad,
	enfoque.ID_ENFOQUE                                            IdEnfoque,
	enfoque.NOMBRE_ENFOQUE                                        Enfoque

	FROM transaccional.carreras_por_institucion cinstitucion INNER JOIN transaccional.plan_estudio pestudio
	ON cinstitucion.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION LEFT JOIN transaccional.enfoques_por_plan_estudio eppestudio
	ON pestudio.ID_PLAN_ESTUDIO = eppestudio.ID_PLAN_ESTUDIO INNER JOIN sistema.enumerado enumerado
	ON pestudio.ID_TIPO_ITINERARIO = enumerado.ID_ENUMERADO INNER JOIN maestro.enfoque enfoque
	ON eppestudio.ID_ENFOQUE = enfoque.ID_ENFOQUE INNER JOIN sistema.enumerado enu
	ON enfoque.ID_MODALIDAD_ESTUDIO = enu.ID_ENUMERADO INNER JOIN db_auxiliar.dbo.UVW_CARRERA carrera
	ON cinstitucion.ID_CARRERA = carrera.ID_CARRERA INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION institucion
	ON cinstitucion.ID_INSTITUCION = institucion.ID_INSTITUCION

	WHERE 
	cinstitucion.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1 AND eppestudio.ES_ACTIVO=1 AND
	cinstitucion.ID_CARRERAS_POR_INSTITUCION = @ID_CARRERA AND institucion.ID_INSTITUCION = @ID_INSTITUCION

END
GO


