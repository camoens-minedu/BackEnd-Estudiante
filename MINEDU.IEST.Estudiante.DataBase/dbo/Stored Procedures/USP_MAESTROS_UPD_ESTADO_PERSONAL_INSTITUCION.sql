/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el estado del personal de una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0          12/11/2019     JTOVAR        SE ACTUALIZO EL STORE PARA QUE PERMITA AL MOMENTO DE ACTUALIZAR UN ROL, PUEDA REGISTRAR OTRO SECRETARIO ACADEMICO
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_UPD_ESTADO_PERSONAL_INSTITUCION]
(
	@ID_PERSONAL_INSTITUCION	        INT,
	@ID_PERIODO_LECTIVO_INSTITUCION	    INT,
	@ID_ROL                             INT,
	@USUARIO					        VARCHAR(20)

	--DECLARE @ID_PERSONAL_INSTITUCION	        INT=1295
	--DECLARE @ID_PERIODO_LECTIVO_INSTITUCION	    INT=5519
	--DECLARE @ID_ROL                             INT=49
	--DECLARE @USUARIO					        VARCHAR(20)='42122536'
)
AS
--BEGIN

	DECLARE @RESULT INT
	DECLARE @ID_PROCESO_ADMISION_PERIODO INT

	SET @ID_PROCESO_ADMISION_PERIODO = (SELECT TOP 1 ID_PROCESO_ADMISION_PERIODO FROM transaccional.proceso_admision_periodo WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND ES_ACTIVO=1)

	IF EXISTS(SELECT TOP 1 ID_COMISION_PROCESO_ADMISION FROM transaccional.comision_proceso_admision 
	         WHERE ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO AND ID_PERSONAL_INSTITUCION = @ID_PERSONAL_INSTITUCION AND ES_ACTIVO = 1)
	BEGIN
	
	SET @RESULT = -312

	END
	ELSE
	BEGIN
	
		IF EXISTS(SELECT TOP 1 ID_ROL FROM maestro.personal_institucion
                  WHERE ES_ACTIVO=1 AND ESTADO=1 AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION AND ID_ROL=@ID_ROL AND ID_PERSONAL_INSTITUCION <> @ID_PERSONAL_INSTITUCION
				  AND ID_ROL IN (47,218,219,220,221,222,223,224,225))
		
		BEGIN 				
			 SET @RESULT = -114
		END
		ELSE
		   BEGIN	
						
			IF EXISTS(SELECT TOP 1 ID_PROGRAMACION_CLASE FROM transaccional.programacion_clase pclase where ID_PERSONAL_INSTITUCION=@ID_PERSONAL_INSTITUCION AND ES_ACTIVO=1 AND
					ID_PERIODO_ACADEMICO IN (SELECT ID_PERIODO_ACADEMICO FROM transaccional.periodo_academico WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION)
					AND ID_SEDE_INSTITUCION IN (SELECT sinstitutcion.ID_SEDE_INSTITUCION FROM maestro.sede_institucion sinstitutcion INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION institucion
					ON sinstitutcion.ID_INSTITUCION = institucion.ID_INSTITUCION INNER JOIN transaccional.periodos_lectivos_por_institucion pinstitucion
					ON institucion.ID_INSTITUCION = pinstitucion.ID_INSTITUCION
					WHERE pinstitucion.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION ))
			BEGIN				
				 SET @RESULT = -277
			END
			ELSE
			BEGIN	
				UPDATE maestro.personal_institucion
				SET ESTADO = CASE WHEN ESTADO = 1 THEN 2 ELSE 1 END,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
				WHERE ID_PERSONAL_INSTITUCION = @ID_PERSONAL_INSTITUCION
				SET @RESULT = 1
			END
	     END	
   END
SELECT @RESULT
GO


