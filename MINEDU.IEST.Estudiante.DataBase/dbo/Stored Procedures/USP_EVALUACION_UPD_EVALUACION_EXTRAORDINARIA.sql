/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	16/02/2022
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de evaluacion extraordinaria
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			15/02/2022		JTOVAR			CREACIÓN

TEST:			
	
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_UPD_EVALUACION_EXTRAORDINARIA]
(
	@ID_INSTITUCION INT,
	@ID_EVALUACION_EXTRAORDINARIA INT,
	@ID_PERIODOLECTIVO_INSTITUCION INT,
   	@ARCHIVO_RD VARCHAR(50),
    @RUTA_RD VARCHAR(255),
	@ID_TIPO_EVALUACION INT,
	@ID_ESTUDIANTE_INSTITUCION INT, 
	@USUARIO VARCHAR(20)
)
AS
BEGIN
	DECLARE @RESULT INT	

	IF EXISTS( SELECT TOP 1 ID_EVALUACION_EXTRAORDINARIA 
				FROM transaccional.evaluacion_extraordinaria
				WHERE ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION 
				AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION 
				AND ID_EVALUACION_EXTRAORDINARIA <> @ID_EVALUACION_EXTRAORDINARIA AND ES_ACTIVO=1 
			  )
	BEGIN
		SET @RESULT = -180 -- YA SE ENCUENTRA REGISTRADO
	END
	ELSE IF EXISTS(SELECT TOP 1 pc.ID_PROGRAMACION_CLASE
					FROM transaccional.periodo_academico pa
					INNER JOIN transaccional.programacion_clase pc ON pc.ID_PERIODO_ACADEMICO = pa.ID_PERIODO_ACADEMICO AND pc.ES_ACTIVO = 1
					WHERE pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOLECTIVO_INSTITUCION AND pa.ES_ACTIVO = 1 AND pc.ESTADO = 0)
	BEGIN
		SET @RESULT = -332 -- PERIODO SE ENCUENTRA CERRADO
    END
	ELSE IF EXISTS(SELECT TOP 1 ID_EVALUACION_EXTRAORDINARIA_DETALLE
					FROM transaccional.evaluacion_extraordinaria_detalle 
					WHERE ID_EVALUACION_EXTRAORDINARIA=@ID_EVALUACION_EXTRAORDINARIA AND ES_ACTIVO=1)
	BEGIN
		SET @RESULT = -999
    END
	ELSE
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION T1	

			UPDATE transaccional.evaluacion_extraordinaria
			SET ARCHIVO_RD = @ARCHIVO_RD, 
				ARCHIVO_RUTA = @RUTA_RD, 
				ID_TIPO_EVALUACION =  @ID_TIPO_EVALUACION, 
				FECHA_MODIFICACION=GETDATE(), 
				USUARIO_MODIFICACION= @USUARIO
			WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA 
				AND ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION AND ES_ACTIVO=1

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
	END

	SELECT @RESULT
END