/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro del examen de admisión por sede
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_EXAMEN_ADMISION_SEDE]
(
	@ID_EXAMEN_ADMISION_SEDE		INT,
	@ID_SEDE_INSTITUCION			INT,
	@ID_MODALIDAD				INT,
	@FECHA_EVALUACION				DATE,
	@HORA_EVALUACION				VARCHAR(5),	
	@USUARIO						VARCHAR(20)
)AS
--BEGIN
	--IF EXISTS (SELECT TOP 1 ID_EXAMEN_ADMISION_SEDE FROM transaccional.examen_admision_sede
	--			WHERE ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION  AND ES_ACTIVO =1
	--			AND ID_EXAMEN_ADMISION_SEDE <> @ID_EXAMEN_ADMISION_SEDE)
	--	SELECT -180
	--ELSE
	BEGIN
		UPDATE transaccional.examen_admision_sede
		SET ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION,
			ID_MODALIDAD = @ID_MODALIDAD,
			FECHA_EVALUACION = @FECHA_EVALUACION,
			HORA_EVALUACION = @HORA_EVALUACION,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE
			ID_EXAMEN_ADMISION_SEDE = @ID_EXAMEN_ADMISION_SEDE		

		SELECT 1
	END
--END
GO


