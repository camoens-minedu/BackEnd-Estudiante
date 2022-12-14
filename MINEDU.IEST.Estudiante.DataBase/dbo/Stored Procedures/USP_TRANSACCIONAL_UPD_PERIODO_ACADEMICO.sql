/**********************************************************************************************************
AUTOR				:	FERNANDO RAMOS C.
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de periodo academico
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		FRAMOS			Creación
1.1			10/08/2021		JCHAVEZ			Se corrigió validación -306

TEST:	USP_TRANSACCIONAL_UPD_PERIODO_ACADEMICO 3938,3804,'PERIODO-II','20200701','20210731','70557821'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_UPD_PERIODO_ACADEMICO]
(
	@ID_PERIODO_LECTIVO_INSTITUCION INT,
	@ID_PERIODO_ACADEMICO INT,
	@NOMBRE_PERIODO_ACADEMICO VARCHAR(50),
	@FECHA_INICIO DATE,
	@FECHA_FIN DATE,
	@USUARIO VARCHAR(20)
)
AS
BEGIN
DECLARE @RESULT INT	

DECLARE @FECHA_INICIO_INSTITUTO DATE
DECLARE @FECHA_FIN_INSTITUTO DATE
DECLARE @ID_PROGRAMACION_CLASE INT

SET @FECHA_INICIO_INSTITUTO=(SELECT CONVERT (DATE,FECHA_INICIO_INSTITUCION,103) FROM transaccional.periodos_lectivos_por_institucion 
WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION) 

SET @FECHA_FIN_INSTITUTO=(SELECT CONVERT (DATE,FECHA_FIN_INSTITUCION,103) FROM transaccional.periodos_lectivos_por_institucion 
WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION)

SET @ID_PROGRAMACION_CLASE = (SELECT TOP 1 pc.ID_PROGRAMACION_CLASE FROM transaccional.programacion_clase pc INNER JOIN transaccional.periodo_academico pa 
                              ON pc.ID_PERIODO_ACADEMICO = pa.ID_PERIODO_ACADEMICO WHERE pa.ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO AND pc.ES_ACTIVO=1 AND pa.ES_ACTIVO=1)

--IF EXISTS (SELECT TOP 1 ID_EVALUACION FROM transaccional.evaluacion WHERE ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE AND CIERRE_PROGRAMACION = 235 AND ES_ACTIVO=1)
IF EXISTS (	SELECT TOP 1 pc.ID_PROGRAMACION_CLASE 
			FROM transaccional.programacion_clase pc 
			INNER JOIN transaccional.periodo_academico pa ON pc.ID_PERIODO_ACADEMICO = pa.ID_PERIODO_ACADEMICO 
			WHERE pa.ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO AND pc.ES_ACTIVO=1 AND pa.ES_ACTIVO=1 AND pc.ESTADO=0)
BEGIN
SET @RESULT = -306

END
ELSE
BEGIN

IF (@FECHA_FIN > @FECHA_FIN_INSTITUTO OR @FECHA_INICIO < @FECHA_INICIO_INSTITUTO)--RANGO DE FECHA EXCEDE
				BEGIN	
		SET @RESULT = -196 -- FECHAS NO SE ENCUENTRAN DENTRO DEL RANGO DE FECHAS DEL PERIODO LECTIVO
	END
	ELSE
		BEGIN 
		IF EXISTS(SELECT TOP 1 ID_PERIODO_ACADEMICO 
				 FROM transaccional.periodo_academico 
				 WHERE 
				 ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND ID_PERIODO_ACADEMICO <> @ID_PERIODO_ACADEMICO AND ES_ACTIVO = 1	
				 AND (UPPER(NOMBRE_PERIODO_ACADEMICO) = UPPER(@NOMBRE_PERIODO_ACADEMICO) COLLATE LATIN1_GENERAL_CI_AI 
				 OR (FECHA_INICIO = @FECHA_INICIO OR FECHA_FIN = @FECHA_FIN)) --AND ES_ACTIVO = 1									
					)
			SET @RESULT = -180 --ya existe
		ELSE
		BEGIN    
			--print 'antes de la transaccion'
			BEGIN TRANSACTION T1
			BEGIN TRY
			UPDATE transaccional.periodo_academico
				SET NOMBRE_PERIODO_ACADEMICO=UPPER(@NOMBRE_PERIODO_ACADEMICO), FECHA_INICIO=@FECHA_INICIO, FECHA_FIN=@FECHA_FIN, USUARIO_MODIFICACION=@USUARIO,FECHA_MODIFICACION=GETDATE()
				WHERE ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO
			
			COMMIT TRANSACTION T1
		
			SET @RESULT = 1
			END TRY	   
			BEGIN CATCH
				IF @@ERROR<>0
				BEGIN
					ROLLBACK TRANSACTION T1	   
					SELECT -1
				END
				ELSE
				ROLLBACK TRANSACTION T1
			END CATCH
		END
	END
	
	END
SELECT @RESULT
END
GO


