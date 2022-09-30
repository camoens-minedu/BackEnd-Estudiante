/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina el registro de la programación de clase.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--/*
--	1.0		31/01/2020		MALVA          SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--*/
--  TEST:		USP_PLANIFICACION_DEL_PROGRAMACION_CLASE 1106, 1127, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_PLANIFICACION_DEL_PROGRAMACION_CLASE]  
(  
	@ID_INSTITUCION				INT, 
    @ID_PROGRAMACION_CLASE		INT,
    @USUARIO_MODIFICACION		nvarchar(20)
)  
AS  
BEGIN
SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	SELECT @ID_INSTITUCION_CONSULTA = si.ID_INSTITUCION FROM transaccional.programacion_clase pc
	INNER JOIN maestro.sede_institucion si ON si.ID_SEDE_INSTITUCION = pc.ID_SEDE_INSTITUCION AND pc.ES_ACTIVO=1 AND si.ES_ACTIVO = 1 
	WHERE pc.ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE  IF (EXISTS (SELECT TOP 1 pcpme.ID_PROGRAMACION_CLASE FROM transaccional.programacion_clase pc INNER JOIN transaccional.programacion_clase_por_matricula_estudiante pcpme
                ON pc.ID_PROGRAMACION_CLASE = pcpme.ID_PROGRAMACION_CLASE INNER JOIN transaccional.matricula_estudiante mestu
                ON pcpme.ID_MATRICULA_ESTUDIANTE = mestu.ID_MATRICULA_ESTUDIANTE
                WHERE pcpme.ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE AND pc.ES_ACTIVO=1 AND pcpme.ES_ACTIVO=1))					
		SET @RESULT =-162
	ELSE
	BEGIN
		BEGIN TRANSACTION T1
		BEGIN TRY
			UPDATE [transaccional].[unidades_didacticas_por_programacion_clase]
			SET  [ES_ACTIVO] = 0   
				  ,[FECHA_MODIFICACION]   = GETDATE()     
				  ,[USUARIO_MODIFICACION]   = @USUARIO_MODIFICACION   
				  WHERE ID_PROGRAMACION_CLASE=@ID_PROGRAMACION_CLASE


			UPDATE transaccional.sesion_programacion_clase
			SET  [ES_ACTIVO] = 0   
				  ,[FECHA_MODIFICACION]   = GETDATE()     
				  ,[USUARIO_MODIFICACION]   = @USUARIO_MODIFICACION   
				  WHERE ID_PROGRAMACION_CLASE=@ID_PROGRAMACION_CLASE

			UPDATE transaccional.programacion_clase
			SET  [ES_ACTIVO] = 0   
				  ,[FECHA_MODIFICACION]   = GETDATE()     
				  ,[USUARIO_MODIFICACION]   = @USUARIO_MODIFICACION   
				  WHERE ID_PROGRAMACION_CLASE=@ID_PROGRAMACION_CLASE		
			
			COMMIT TRANSACTION T1
			SET @RESULT = 1
		END TRY
		BEGIN CATCH
			IF @@ERROR<>0
				BEGIN
					ROLLBACK TRANSACTION T1	   
					SET @RESULT = -1
					PRINT ERROR_MESSAGE()
				END
		END CATCH
	END
	SELECT @RESULT
END
GO


