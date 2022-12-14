CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_INS_PERIODO_ACADEMICO]
(	
	@ID_PERIODO_LECTIVO_INSTITUCION INT,
	@NOMBRE_PERIODO_ACADEMICO VARCHAR(50),
	@FECHA_INICIO DATE,
	@FECHA_FIN DATE,

	--@FECHA_INICIO VARCHAR(20),
	--@FECHA_FIN VARCHAR(20),
	@USUARIO VARCHAR(20)

	--DECLARE @ID_PERIODO_LECTIVO_INSTITUCION INT=5493
	--DECLARE @NOMBRE_PERIODO_ACADEMICO VARCHAR(50)='periodo1b'
	--DECLARE @FECHA_INICIO DATE ='2019-02-0'
	--DECLARE @FECHA_FIN DATE ='2019-07-03'
	--DECLARE @USUARIO VARCHAR(20)='42122536'
)
AS

DECLARE @RESULT INT
DECLARE @FECHA_INICIO_INSTITUTO DATE
DECLARE @FECHA_FIN_INSTITUTO DATE


SET @FECHA_INICIO_INSTITUTO=(SELECT CONVERT (DATE,FECHA_INICIO_INSTITUCION,103) FROM transaccional.periodos_lectivos_por_institucion 
WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION) 

SET @FECHA_FIN_INSTITUTO=(SELECT CONVERT (DATE,FECHA_FIN_INSTITUCION,103) FROM transaccional.periodos_lectivos_por_institucion 
WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION)

	IF (@FECHA_FIN > @FECHA_FIN_INSTITUTO OR @FECHA_INICIO < @FECHA_INICIO_INSTITUTO)--RANGO DE FECHA EXCEDE
	BEGIN	
		SET @RESULT = -196 -- FECHAS NO SE ENCUENTRAN DENTRO DEL RANGO DE FECHAS DEL PERIODO LECTIVO
	END
	ELSE
	
	BEGIN 
		--IF EXISTS(SELECT TOP 1 ID_PERIODO_ACADEMICO 
		--		 FROM transaccional.periodo_academico 
		--		 WHERE NOMBRE_PERIODO_ACADEMICO = UPPER(@NOMBRE_PERIODO_ACADEMICO) COLLATE LATIN1_GENERAL_CI_AI)
		IF EXISTS(SELECT TOP 1 ID_PERIODO_ACADEMICO 
				 FROM transaccional.periodo_academico 
				 WHERE 
				 ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND ES_ACTIVO=1
				 AND (UPPER(NOMBRE_PERIODO_ACADEMICO) = UPPER(@NOMBRE_PERIODO_ACADEMICO) COLLATE LATIN1_GENERAL_CI_AI
				 OR (FECHA_INICIO = @FECHA_INICIO OR FECHA_FIN = @FECHA_FIN)) --AND ES_ACTIVO = 1
					--AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION 
					--AND FECHA_INICIO = CONVERT (DATETIME, @FECHA_INICIO, 103) 
					--AND FECHA_FIN = CONVERT (DATETIME, @FECHA_FIN, 103)

									
					)
			SET @RESULT = -180 --ya existe
		ELSE
		BEGIN    
			--print 'antes de la transaccion'
			BEGIN TRANSACTION T1
			BEGIN TRY
				--print 'dentro de la transaccion'
				INSERT INTO transaccional.periodo_academico(ID_PERIODOS_LECTIVOS_POR_INSTITUCION,NOMBRE_PERIODO_ACADEMICO,FECHA_INICIO,FECHA_FIN,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
				VALUES(	@ID_PERIODO_LECTIVO_INSTITUCION,UPPER(@NOMBRE_PERIODO_ACADEMICO),@FECHA_INICIO,@FECHA_FIN,1,1,@USUARIO,GETDATE())
			
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
	END
SELECT @RESULT
GO


