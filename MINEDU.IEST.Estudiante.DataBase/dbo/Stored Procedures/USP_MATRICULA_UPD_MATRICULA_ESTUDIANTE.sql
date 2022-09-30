/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de matricula de un estudiante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_MATRICULA_ESTUDIANTE]
(  
@ID_MATRICULA_ESTUDIANTE				INT, 
@PROGRAMACIONES_CLASES					VARCHAR(200),
@FECHA_MATRICULA						DATE,
@USUARIO								VARCHAR(20)
)  
AS 
DECLARE @RESULT INT
SET @RESULT = 0
DECLARE @ID_ESTUDIANTE_INSTITUCION INT
SET @ID_ESTUDIANTE_INSTITUCION = (SELECT ID_ESTUDIANTE_INSTITUCION FROM transaccional.matricula_estudiante WHERE ID_MATRICULA_ESTUDIANTE= @ID_MATRICULA_ESTUDIANTE)


IF EXISTS (SELECT TOP 1 pclase.ID_PROGRAMACION_CLASE FROM transaccional.evaluacion_detalle eva INNER JOIN transaccional.evaluacion e ON eva.ID_EVALUACION = e.ID_EVALUACION
           INNER JOIN transaccional.programacion_clase pclase ON e.ID_PROGRAMACION_CLASE = pclase.ID_PROGRAMACION_CLASE
           WHERE ID_MATRICULA_ESTUDIANTE = @ID_MATRICULA_ESTUDIANTE AND eva.ES_ACTIVO = 1 AND e.ES_ACTIVO = 1 AND pclase.ES_ACTIVO = 1 AND pclase.ESTADO = 0)
BEGIN

SET @RESULT = -323

END
ELSE
BEGIN
IF EXISTS(SELECT TOP 1 EIN.ID_ESTUDIANTE_INSTITUCION FROM transaccional.programacion_clase PC 
			INNER JOIN maestro.personal_institucion PIN ON PC.ID_PERSONAL_INSTITUCION= PIN.ID_PERSONAL_INSTITUCION AND PC.ES_ACTIVO=1 AND PIN.ES_ACTIVO=1
			INNER JOIN maestro.persona_institucion PINS ON PINS.ID_PERSONA_INSTITUCION= PIN.ID_PERSONA_INSTITUCION 
			INNER JOIN transaccional.estudiante_institucion EIN ON EIN.ID_PERSONA_INSTITUCION= PINS.ID_PERSONA_INSTITUCION AND EIN.ES_ACTIVO=1						
			WHERE ID_PROGRAMACION_CLASE IN (sELECT SUBSTRING(SplitData,0,CHARINDEX(':', SplitData)) ID_PROGRAMACION_CLASE
			FROM dbo.UFN_SPLIT(@PROGRAMACIONES_CLASES, ','))
			AND EIN.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION)

 SET @RESULT = -294  
ELSE
BEGIN
	BEGIN TRANSACTION T1
	BEGIN TRY
		DECLARE @CADENA VARCHAR(150)
		DECLARE @CADENA_ESTADOS_UD VARCHAR(200)
		DECLARE @ID_PROGRAMACION_CLASE INT
		DECLARE @ID_ESTADO_UNIDAD_DIDACTICA INT

		UPDATE transaccional.matricula_estudiante
		SET FECHA_MATRICULA= @FECHA_MATRICULA,
		FECHA_MODIFICACION= GETDATE(),
		USUARIO_MODIFICACION= @USUARIO
		WHERE ID_MATRICULA_ESTUDIANTE=@ID_MATRICULA_ESTUDIANTE

		UPDATE 
		transaccional.programacion_clase_por_matricula_estudiante 
		SET ES_ACTIVO =0
		where ID_MATRICULA_ESTUDIANTE= @ID_MATRICULA_ESTUDIANTE


			SELECT SUBSTRING(SplitData,0,CHARINDEX(':', SplitData)) ID_PROGRAMACION_CLASE,  
					SUBSTRING(SplitData, CHARINDEX(':',SplitData)+1, LEN(SplitData) - CHARINDEX(':',SplitData)) ID_ESTADO_UNIDAD_DIDACTICA
			INTO #Temp_ProgramacionesClases
			FROM dbo.UFN_SPLIT(@PROGRAMACIONES_CLASES, ',')

			DECLARE @ID INT =0
			DECLARE @TotalProgramaciones INT = 0
			DECLARE @ID_PROGRAMACION_CLASE_TEMP INT
			DECLARE @ID_ESTADO_UNIDAD_DIDACTICA_TEMP INT

				SET @TotalProgramaciones= ( SELECT COUNT(1) FROM #Temp_ProgramacionesClases)

				WHILE @ID <@TotalProgramaciones
				BEGIN
						SET @ID_PROGRAMACION_CLASE_TEMP =(SELECT TOP 1 ID_PROGRAMACION_CLASE FROM #Temp_ProgramacionesClases )
						SELECT 
								@ID_ESTADO_UNIDAD_DIDACTICA_TEMP= ID_ESTADO_UNIDAD_DIDACTICA								
						FROM #Temp_ProgramacionesClases where ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE_TEMP

							if (EXISTS ( SELECT * FROM transaccional.programacion_clase_por_matricula_estudiante WHERE ID_PROGRAMACION_CLASE=@ID_PROGRAMACION_CLASE_TEMP
										and ID_MATRICULA_ESTUDIANTE=@ID_MATRICULA_ESTUDIANTE AND ES_ACTIVO=1 
									))
							BEGIN
							UPDATE 
								transaccional.programacion_clase_por_matricula_estudiante 
								SET ES_ACTIVO =1,
								ID_ESTADO_UNIDAD_DIDACTICA=@ID_ESTADO_UNIDAD_DIDACTICA_TEMP,
								USUARIO_MODIFICACION= @USUARIO,
								FECHA_MODIFICACION= GETDATE()
							
								where ID_PROGRAMACION_CLASE= @ID_PROGRAMACION_CLASE_TEMP
								AND ID_MATRICULA_ESTUDIANTE= @ID_MATRICULA_ESTUDIANTE
							END
							ELSE
							BEGIN													
									INSERT INTO transaccional.programacion_clase_por_matricula_estudiante
											(	ID_PROGRAMACION_CLASE,
												ID_MATRICULA_ESTUDIANTE,
												ID_ESTADO_UNIDAD_DIDACTICA,
												ES_ACTIVO,
												ESTADO,
												USUARIO_CREACION,
												FECHA_CREACION
											)
									VALUES (@ID_PROGRAMACION_CLASE_TEMP,
											@ID_MATRICULA_ESTUDIANTE,
											@ID_ESTADO_UNIDAD_DIDACTICA_TEMP,
											1, 
											1, 
											@USUARIO, 
											GETDATE())
							END
						

					DELETE FROM #Temp_ProgramacionesClases where ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE_TEMP
					SET @ID = @ID+1
				END
			DROP TABLE #Temp_ProgramacionesClases
					
		COMMIT TRANSACTION T1
		SET @RESULT = 1
	END TRY
	BEGIN CATCH	
		IF @@ERROR = 50000
		BEGIN
			ROLLBACK TRANSACTION T1	   
			SET @RESULT = -1 --//error desconocido
		END
		ELSE	
			IF @@ERROR<>0
			BEGIN
			   
			   ROLLBACK TRANSACTION T1	   			   
			   SET @RESULT = -1
			
			END
	END CATCH 
END 
END 
SELECT @RESULT
GO


