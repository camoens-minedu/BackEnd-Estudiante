/***************************************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de estudiante institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0		    11/02/2020		MALVA			SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
1.1			21/02/2022		JCHAVEZ			Se añade update de tabla convalidacion en caso el estudiante haya sido creado con una convalidación

TEST:	
	USP_MATRICULA_DEL_ESTUDIANTE_INSTITUCION 1106, 206, 'MALVA'
****************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_DEL_ESTUDIANTE_INSTITUCION]
(
	@ID_INSTITUCION				INT,
	@ID_ESTUDIANTE_INSTITUCION	INT,
	@USUARIO					VARCHAR(20)
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	SELECT @ID_INSTITUCION_CONSULTA = mpi.ID_INSTITUCION  
	FROM transaccional.estudiante_institucion ei
	INNER JOIN maestro.persona_institucion mpi ON mpi.ID_PERSONA_INSTITUCION = ei.ID_PERSONA_INSTITUCION AND ei.ES_ACTIVO=1 
	WHERE ID_ESTUDIANTE_INSTITUCION =  @ID_ESTUDIANTE_INSTITUCION

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE IF (EXISTS (SELECT TOP 1 mestu.ID_ESTUDIANTE_INSTITUCION FROM transaccional.estudiante_institucion einsti INNER JOIN transaccional.matricula_estudiante mestu
					ON einsti.ID_ESTUDIANTE_INSTITUCION = mestu.ID_ESTUDIANTE_INSTITUCION
					WHERE mestu.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION AND einsti.ES_ACTIVO=1 AND mestu.ES_ACTIVO=1))		
		SET @RESULT =-162
	ELSE
	BEGIN
		UPDATE [transaccional].estudiante_institucion
		SET ES_ACTIVO = 0,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION
		
		IF EXISTS(SELECT TOP 1 ID_ESTUDIANTE_INSTITUCION FROM transaccional.convalidacion WHERE ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION)
		BEGIN
			DECLARE @ID_CONVALIDACION INT = (SELECT TOP 1 ID_CONVALIDACION FROM transaccional.convalidacion WHERE ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION)
			
			EXEC USP_CONVALIDACION_DEL_CONVALIDACION @ID_INSTITUCION, @ID_CONVALIDACION, @USUARIO
		END
		SET @RESULT =1	 
	END
	SELECT @RESULT
END
GO


