/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	17/02/2022
LLAMADO POR			:
DESCRIPCION			:	Inserta el registro de nota de unidades didactica en evaluacion extraordinaria 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			17/02/2022		JTOVAR			CREACIÓN

TEST:			
	USP_EVALUACION_INS_NOTA_UNIDAD_DIDACTICA
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_INS_NOTA_UNIDAD_DIDACTICA]
(
	@ID_UNIDAD_DIDACTICA INT,
	@ID_EVALUACION_EXTRAORDINARIA INT,
	@NOTA VARCHAR(15),
	@USUARIO VARCHAR(20)
)
AS
BEGIN
	DECLARE @EVALUACION_EXTRAORDINARIA INT = 395

	DECLARE @RESULT INT, @ID_PERIODOS_LECTIVOS_INSTITUCION INT, @TIPO_EVALUACION INT, @CANTIDAD_NOTAS INT

	SELECT @ID_PERIODOS_LECTIVOS_INSTITUCION = ID_PERIODOS_LECTIVOS_POR_INSTITUCION,@TIPO_EVALUACION = ID_TIPO_EVALUACION
	FROM transaccional.evaluacion_extraordinaria 
	WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA AND ES_ACTIVO = 1

	SET @CANTIDAD_NOTAS = (SELECT COUNT(1)
							FROM transaccional.evaluacion_extraordinaria_detalle
							WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA AND ES_ACTIVO = 1)

	/*IF EXISTS(	SELECT TOP 1 ID_EVALUACION_EXTRAORDINARIA_DETALLE 
				FROM [transaccional].[evaluacion_extraordinaria_detalle] 
				WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA 
				AND ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA AND ES_ACTIVO=1 
			)
	BEGIN
		SET @RESULT = -180 -- YA SE ENCUENTRA REGISTRADO
	END
	ELSE*/ IF EXISTS(SELECT TOP 1 pc.ID_PROGRAMACION_CLASE
					FROM transaccional.periodo_academico pa
					INNER JOIN transaccional.programacion_clase pc ON pc.ID_PERIODO_ACADEMICO = pa.ID_PERIODO_ACADEMICO AND pc.ES_ACTIVO = 1
					WHERE pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_INSTITUCION AND pa.ES_ACTIVO = 1 AND pc.ESTADO = 0)
	BEGIN
		SET @RESULT = -332 -- PERIODO SE ENCUENTRA CERRADO
    END
	ELSE IF(@TIPO_EVALUACION = @EVALUACION_EXTRAORDINARIA AND @CANTIDAD_NOTAS >= 2)
	BEGIN
		SET @RESULT = -408
	END
	ELSE
	BEGIN    
		BEGIN TRY		
			BEGIN TRANSACTION T1

			IF EXISTS(SELECT TOP 1 ID_EVALUACION_EXTRAORDINARIA_DETALLE 
						FROM [transaccional].[evaluacion_extraordinaria_detalle] 
						WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA 
						AND ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA)
			BEGIN
				UPDATE ee SET
					ee.ES_ACTIVO = 1,
					ee.NOTA = @NOTA,
					ee.USUARIO_MODIFICACION = @USUARIO,
					ee.FECHA_MODIFICACION = GETDATE()
				FROM transaccional.evaluacion_extraordinaria_detalle ee
				WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA 
				AND ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA
			END
            ELSE BEGIN
				INSERT INTO [transaccional].[evaluacion_extraordinaria_detalle]
				([ID_EVALUACION_EXTRAORDINARIA]
				,[ID_UNIDAD_DIDACTICA]
				,[NOTA]
				,[ES_ACTIVO]
				,[ESTADO]
				,[FECHA_CREACION]
				,[USUARIO_CREACION]
				)
				VALUES
				(@ID_EVALUACION_EXTRAORDINARIA
				,@ID_UNIDAD_DIDACTICA	  
				,@NOTA	  
				,1	  
				,1 
				,GETDATE()
				,@USUARIO	  
				)
			END
			
			COMMIT TRANSACTION T1
		
			SET @RESULT = 1
		END TRY	   
		BEGIN CATCH
			IF @@ERROR<>0
			BEGIN
				ROLLBACK TRANSACTION T1	   
				SELECT -1
			END
		END CATCH
	END	
	SELECT @RESULT
END