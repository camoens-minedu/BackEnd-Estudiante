/**********************************************************************************************************
AUTOR				:	jUAN cHAVEZ
FECHA DE CREACION	:	17/02/2022
LLAMADO POR			:
DESCRIPCION			:	Inserta el registro de matrícula de unidades didacticas en evaluacion complementaria 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			17/02/2022		JCHAVEZ			CREACIÓN

TEST:			
	USP_EVALUACION_INS_UDP_MATRICULA_EVALUACION_COMPLEMENTARIA
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_INS_UDP_MATRICULA_EVALUACION_COMPLEMENTARIA]
(
	@ID_UNIDAD_DIDACTICA INT,
	@ID_EVALUACION_EXTRAORDINARIA INT,
	@ES_MATRICULADO BIT,
	@USUARIO VARCHAR(20)
)
AS
BEGIN
	DECLARE @RESULT INT, @ID_PERIODOS_LECTIVOS_INSTITUCION INT

	SELECT @ID_PERIODOS_LECTIVOS_INSTITUCION = ID_PERIODOS_LECTIVOS_POR_INSTITUCION
	FROM transaccional.evaluacion_extraordinaria 
	WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA AND ES_ACTIVO = 1

	IF EXISTS(SELECT TOP 1 pc.ID_PROGRAMACION_CLASE
					FROM transaccional.periodo_academico pa
					INNER JOIN transaccional.programacion_clase pc ON pc.ID_PERIODO_ACADEMICO = pa.ID_PERIODO_ACADEMICO AND pc.ES_ACTIVO = 1
					WHERE pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_INSTITUCION AND pa.ES_ACTIVO = 1 AND pc.ESTADO = 0)
	BEGIN
		SET @RESULT = -332 -- PERIODO SE ENCUENTRA CERRADO
    END
	ELSE IF EXISTS(	SELECT TOP 1 ID_EVALUACION_EXTRAORDINARIA_DETALLE 
					FROM transaccional.evaluacion_extraordinaria_detalle
					WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA 
					AND ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA
			)
	BEGIN
		UPDATE ee SET
			ee.ES_ACTIVO = @ES_MATRICULADO,
			ee.NOTA = NULL,
			ee.USUARIO_MODIFICACION = @USUARIO,
			ee.FECHA_MODIFICACION = GETDATE()
		FROM transaccional.evaluacion_extraordinaria_detalle ee
		WHERE ID_EVALUACION_EXTRAORDINARIA = @ID_EVALUACION_EXTRAORDINARIA 
		AND ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA

		SET @RESULT = 1
	END
	ELSE
	BEGIN    
		INSERT INTO transaccional.evaluacion_extraordinaria_detalle (ID_EVALUACION_EXTRAORDINARIA,ID_UNIDAD_DIDACTICA,NOTA,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
		VALUES (@ID_EVALUACION_EXTRAORDINARIA,@ID_UNIDAD_DIDACTICA,NULL,1,1,@USUARIO,GETDATE())

		SET @RESULT = 1
	END	
	SELECT @RESULT
END