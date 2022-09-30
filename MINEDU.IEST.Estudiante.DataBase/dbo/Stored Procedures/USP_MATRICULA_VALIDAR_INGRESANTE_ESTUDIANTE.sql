/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Valida la existencia del registro del estudiante ingresante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_VALIDAR_INGRESANTE_ESTUDIANTE]
(
	@ID_PROGRAMA_ESTUDIO            INT,
	@ID_POSTULANTEXMODALIDAD        INT	
)
AS  
BEGIN

	SET NOCOUNT ON;  
	
	DECLARE @PERSONA_INSTITUCION INT
	DECLARE @RESULT INT
	
	SET @PERSONA_INSTITUCION = (SELECT TOP (1) ID_PERSONA_INSTITUCION FROM transaccional.postulantes_por_modalidad WHERE ID_POSTULANTES_POR_MODALIDAD = @ID_POSTULANTEXMODALIDAD)

	IF EXISTS(SELECT TOP (1) einstitucion.ID_ESTUDIANTE_INSTITUCION
				FROM maestro.persona p INNER JOIN maestro.persona_institucion pinstitucion
				ON p.ID_PERSONA = pinstitucion.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einstitucion
				ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION INNER JOIN transaccional.carreras_por_institucion_detalle cidet
				ON einstitucion.ID_CARRERAS_POR_INSTITUCION_DETALLE = cidet.ID_CARRERAS_POR_INSTITUCION_DETALLE INNER JOIN transaccional.carreras_por_institucion cinstitucion
				ON cidet.ID_CARRERAS_POR_INSTITUCION = cinstitucion.ID_CARRERAS_POR_INSTITUCION INNER JOIN db_auxiliar.dbo.UVW_CARRERA carrera
				ON cinstitucion.ID_CARRERA = carrera.ID_CARRERA
				WHERE 
				pinstitucion.ID_PERSONA_INSTITUCION = @PERSONA_INSTITUCION AND 
				carrera.ID_CARRERA = @ID_PROGRAMA_ESTUDIO AND 
				einstitucion.ES_ACTIVO = 1 AND
				cidet.ES_ACTIVO = 1 AND
				cinstitucion.ES_ACTIVO = 1)
		BEGIN
		
			SET @RESULT = -1 -- NO SE PUEDE PROMOVER
			
		END
		ELSE
			BEGIN    	
			
			SET @RESULT = 1 -- SI SE PUEDE PROMOVER
			
		END	
SELECT @RESULT

END
GO


