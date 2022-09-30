/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de persona en su modalidad de promovido
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_UPD_PROMOVER_PERSONA]
(
	
	@ID_PROMOVER_PERSONA_INSTITUCION INT,
	@ID_PERIODO_LECTIVO_INSTITUCION INT,
	@ID_SEDE_INSTITUCION INT,
	@ID_CARRERA_INSTITUCION INT,
	@ID_MOTIVO INT,
	@ID_POSTULANTES_POR_MODALIDAD_RETIRADO INT,
	@ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO INT,
	@USUARIO VARCHAR(20)
)
AS
BEGIN
DECLARE @RESULT INT	
--DECLARE @ID_PERSONA_INSTITUCION INT
	BEGIN TRY
	BEGIN TRANSACTION T1
	
	 --SET @ID_PERSONA_INSTITUCION = (SELECT pinstitucion.ID_PERSONA_INSTITUCION FROM transaccional.promover_persona_institucion ppinsti INNER JOIN transaccional.postulantes_por_modalidad ppmod
		--							 ON ppinsti.ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO = ppmod.ID_POSTULANTES_POR_MODALIDAD INNER JOIN maestro.persona_institucion pinstitucion
		--							 ON ppmod.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION
		--							 WHERE ppinsti.ID_PROMOVER_PERSONA_INSTITUCION = @ID_PROMOVER_PERSONA_INSTITUCION)



		 --IF EXISTS (SELECT TOP (1) eins.ID_ESTUDIANTE_INSTITUCION FROM transaccional.estudiante_institucion eins INNER JOIN maestro.persona_institucion pins 
		 --           ON eins.ID_PERSONA_INSTITUCION = pins.ID_PERSONA_INSTITUCION
			--		 WHERE pins.ID_PERSONA_INSTITUCION = 1427 AND eins.ES_ACTIVO=1)
 
			--	BEGIN
			--		SET @RESULT = -162 -- YA SE ENCUENTRA REGISTRADO
			--	END
			--	ELSE
			--		BEGIN    	--print 'dentro de la transaccion'
	
			--		UPDATE transaccional.promover_persona_institucion
			--		SET 
			--			MOTIVO=@ID_MOTIVO, 
			--			ID_POSTULANTES_POR_MODALIDAD_RETIRADO=@ID_POSTULANTES_POR_MODALIDAD_RETIRADO, 
			--			ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO=@ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO, 
			--			USUARIO_MODIFICACION=@USUARIO, 
			--			FECHA_MODIFICACION=GETDATE()
			--		WHERE ID_PROMOVER_PERSONA_INSTITUCION = @ID_PROMOVER_PERSONA_INSTITUCION

			--		SET @RESULT = 1
			--	END	


		
		UPDATE transaccional.promover_persona_institucion
		SET 
			MOTIVO=@ID_MOTIVO, 
			ID_POSTULANTES_POR_MODALIDAD_RETIRADO=@ID_POSTULANTES_POR_MODALIDAD_RETIRADO, 
			ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO=@ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO, 
			USUARIO_MODIFICACION=@USUARIO, 
			FECHA_MODIFICACION=GETDATE()
		WHERE ID_PROMOVER_PERSONA_INSTITUCION = @ID_PROMOVER_PERSONA_INSTITUCION


COMMIT TRANSACTION T1		
		SET @RESULT = 1
	END TRY
	BEGIN CATCH	
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION T1	   
			SET @RESULT = -1
		END
		ELSE
			ROLLBACK TRANSACTION T1	   
	END CATCH

	SELECT @RESULT


END
GO


