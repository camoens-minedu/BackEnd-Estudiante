--/***********************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Elimina un registro de postulante modalidad por proceso de admisión. 
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------	
--/*
--	1.0			09/01/2020		MALVA          MODIFICACIÓN, SE CONSIDERA EL VALOR DE @RESULT = 1, EN CASO EL PROCESO SEA EXITOSO.
--	1.1		    11/02/2020		MALVA          SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--*/
--  TEST:  
--			USP_ADMISION_DEL_POSTULANTE_MODALIDAD 1106, 1103, 'MALVA'
--************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_DEL_POSTULANTE_MODALIDAD]
(
	@ID_INSTITUCION				INT, 
	@ID_POSTULANTE_MODALIDAD	INT,
	@USUARIO					VARCHAR(20)
)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0	

		SELECT 
			@ID_INSTITUCION_CONSULTA = mpi.ID_INSTITUCION 
		FROM 
			transaccional.postulantes_por_modalidad pxm
		INNER JOIN maestro.persona_institucion mpi ON mpi.ID_PERSONA_INSTITUCION = pxm.ID_PERSONA_INSTITUCION AND pxm.ES_ACTIVO=1 
		WHERE 
			pxm.ID_POSTULANTES_POR_MODALIDAD = @ID_POSTULANTE_MODALIDAD

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA 
		SET @RESULT = -362
	ELSE IF EXISTS (SELECT TOP 1 ID_POSTULANTES_POR_MODALIDAD FROM transaccional.distribucion_evaluacion_admision_detalle WHERE ID_POSTULANTES_POR_MODALIDAD=@ID_POSTULANTE_MODALIDAD AND ES_ACTIVO=1  )
			OR EXISTS(SELECT TOP 1 ID_POSTULANTES_POR_MODALIDAD FROM transaccional.resultados_por_postulante WHERE ID_POSTULANTES_POR_MODALIDAD=@ID_POSTULANTE_MODALIDAD AND ES_ACTIVO=1 )
		SET @RESULT =-162
	ELSE
		BEGIN	
			BEGIN TRANSACTION T1
			BEGIN TRY
			UPDATE transaccional.postulantes_por_modalidad
			SET ES_ACTIVO = 0,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
			WHERE ID_POSTULANTES_POR_MODALIDAD = @ID_POSTULANTE_MODALIDAD

			UPDATE transaccional.opciones_por_postulante
			SET ES_ACTIVO=0,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
			WHERE ID_POSTULANTES_POR_MODALIDAD = @ID_POSTULANTE_MODALIDAD

			UPDATE transaccional.requisitos_por_postulante
			SET ES_ACTIVO=0,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
			WHERE ID_POSTULANTES_POR_MODALIDAD = @ID_POSTULANTE_MODALIDAD
		
			COMMIT TRANSACTION T1
			SET @RESULT = 1
			END TRY
			BEGIN CATCH
				IF @@ERROR<>0
				BEGIN
					ROLLBACK TRANSACTION T1	   
					SET @RESULT =  -1
				END
			END CATCH				
		END
SELECT @RESULT
END
GO


