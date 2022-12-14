/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta el registro de la matricula de un estudiante 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		MALVA			CREACIÓN
1.1			14/04/2021		JCHAVEZ			MODIFICACIÓN, SE AGREGÓ ES_ACTIVO=1 EN LA VALIDACIÓN 322
1.2			07/02/2022		JCHAVEZ			MODIFICACIÓN, SE AGREGÓ PARÁMETRO @PERMITE_EDITAR

--  TEST:			
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_INS_MATRICULA_ESTUDIANTE]
(  
@ID_PROGRAMACION_MATRICULA				INT,
@ID_ESTUDIANTE_INSTITUCION				INT, 
@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT, 
@ID_PERIODO_ACADEMICO					INT, 
@ID_SEMESTRE_ACADEMICO					INT, 
@PROGRAMACIONES_CLASES					VARCHAR(MAX), --'9:170,19:170'
@FECHA_MATRICULA						DATE,
@PERMITE_EDITAR							BIT,
@USUARIO								VARCHAR(20)
)  
AS
BEGIN
	DECLARE @RESULT INT

	IF EXISTS (SELECT TOP 1 ID_LIBERACION_ESTUDIANTE FROM transaccional.liberacion_estudiante WHERE ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION /*AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION*/ 
           AND ES_ACTIVO = 1)
		SET @RESULT = -330
	ELSE IF EXISTS (SELECT TOP 1 ID_PROGRAMACION_CLASE FROM transaccional.programacion_clase WHERE ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO AND ESTADO = 0 AND ES_ACTIVO = 1)
					AND (@PERMITE_EDITAR = 0)
		SET @RESULT = -322
	ELSE IF EXISTS(SELECT TOP 1 ID_MATRICULA_ESTUDIANTE  from transaccional.matricula_estudiante 
					WHERE ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION
					AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
					AND ID_PERIODO_ACADEMICO= @ID_PERIODO_ACADEMICO AND ES_ACTIVO=1
					)
		SET @RESULT = -180  
	ELSE IF EXISTS (SELECT TOP 1 EIN.ID_ESTUDIANTE_INSTITUCION FROM transaccional.programacion_clase PC 
					INNER JOIN maestro.personal_institucion PIN ON PC.ID_PERSONAL_INSTITUCION= PIN.ID_PERSONAL_INSTITUCION AND PC.ES_ACTIVO=1 AND PIN.ES_ACTIVO=1
					INNER JOIN maestro.persona_institucion PINS ON PINS.ID_PERSONA_INSTITUCION= PIN.ID_PERSONA_INSTITUCION 
					INNER JOIN transaccional.estudiante_institucion EIN ON EIN.ID_PERSONA_INSTITUCION= PINS.ID_PERSONA_INSTITUCION AND EIN.ES_ACTIVO=1						
					WHERE ID_PROGRAMACION_CLASE IN (SELECT SUBSTRING(SplitData,0,CHARINDEX(':', SplitData)) ID_PROGRAMACION_CLASE
													FROM dbo.UFN_SPLIT(@PROGRAMACIONES_CLASES, ','))
					AND EIN.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION)
		SET @RESULT = -294  
	ELSE
	BEGIN  
		BEGIN TRANSACTION T1
		BEGIN TRY
	
		DECLARE @ID_MATRICULA_ESTUDIANTE INT
		
		INSERT INTO transaccional.matricula_estudiante
		(
			ID_PROGRAMACION_MATRICULA,
			ID_ESTUDIANTE_INSTITUCION,
			ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
			ID_PERIODO_ACADEMICO,
			ID_SEMESTRE_ACADEMICO,
			ES_ACTIVO,
			ESTADO,
			USUARIO_CREACION,
			FECHA_CREACION,
			FECHA_MATRICULA
		)
		VALUES 
		(
			@ID_PROGRAMACION_MATRICULA,
			@ID_ESTUDIANTE_INSTITUCION,
			@ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
			@ID_PERIODO_ACADEMICO,
			@ID_SEMESTRE_ACADEMICO,
			1,
			1,
			@USUARIO,
			GETDATE(),
			@FECHA_MATRICULA
		)

		SELECT @ID_MATRICULA_ESTUDIANTE= @@IDENTITY
					
		SELECT SUBSTRING(SplitData,0,CHARINDEX(':', SplitData)) ID_PROGRAMACION_CLASE,  
				SUBSTRING(SplitData, CHARINDEX(':',SplitData)+1, LEN(SplitData) - CHARINDEX(':',SplitData)) ID_ESTADO_UNIDAD_DIDACTICA
		INTO #TempProgramacionesClases
		FROM dbo.UFN_SPLIT(@PROGRAMACIONES_CLASES, ',')

		DECLARE @ID INT =0
		DECLARE @TotalProgramaciones INT = 0
		DECLARE @ID_PROGRAMACION_CLASE_TEMP INT
		DECLARE @ID_ESTADO_UNIDAD_DIDACTICA_TEMP INT

		SET @TotalProgramaciones= ( SELECT COUNT(1) FROM #TempProgramacionesClases)

		WHILE @ID <@TotalProgramaciones
		BEGIN
			SET @ID_PROGRAMACION_CLASE_TEMP =(SELECT TOP 1 ID_PROGRAMACION_CLASE FROM #TempProgramacionesClases )
			SELECT 
					@ID_ESTADO_UNIDAD_DIDACTICA_TEMP= ID_ESTADO_UNIDAD_DIDACTICA								
			FROM #TempProgramacionesClases where ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE_TEMP

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
						
			DELETE FROM #TempProgramacionesClases where ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE_TEMP
			SET @ID = @ID+1
		END
			
		DROP TABLE #TempProgramacionesClases
		COMMIT TRANSACTION T1
		SET @RESULT = 1
		END TRY
		BEGIN CATCH
			IF @@ERROR<>0
			BEGIN
				ROLLBACK TRANSACTION T1	   
				SET @RESULT = -1
			END
		END CATCH
	END    
	SELECT @RESULT
END
GO


