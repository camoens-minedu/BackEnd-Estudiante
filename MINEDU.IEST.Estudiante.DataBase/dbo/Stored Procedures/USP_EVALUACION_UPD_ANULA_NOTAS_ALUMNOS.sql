/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/02/2021
LLAMADO POR			:
DESCRIPCION			:	Anula las notas de los estudiantes de una programación de clases
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 05/02/2021		JCHAVEZ
--  TEST:  
--			USP_EVALUACION_UPD_ANULA_NOTAS_ALUMNOS 306, 1235,62179,'70557821'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_UPD_ANULA_NOTAS_ALUMNOS]
(
	@ID_INSTITUCION							INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@ID_PROGRAMACION_CLASE					INT,
	@USUARIO								VARCHAR(20)
)
AS
BEGIN

	DECLARE @MSG_TRANS VARCHAR(MAX)
	DECLARE @fechaActual date
	set @fechaActual = GETDATE()

	BEGIN TRY

		BEGIN TRAN TransactSQL
			
			UPDATE ed SET ed.ES_ACTIVO=0,ed.USUARIO_MODIFICACION=@USUARIO,ed.FECHA_MODIFICACION=GETDATE()
			FROM transaccional.evaluacion e
			INNER JOIN transaccional.evaluacion_detalle ed ON ed.ID_EVALUACION = e.ID_EVALUACION
			INNER JOIN transaccional.programacion_clase pc ON pc.ID_PROGRAMACION_CLASE = e.ID_PROGRAMACION_CLASE
			WHERE e.ES_ACTIVO=1 AND ed.ES_ACTIVO=1 AND pc.ES_ACTIVO=1
			AND e.ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE

			UPDATE e SET e.ES_ACTIVO=0,e.CIERRE_PROGRAMACION=234,e.USUARIO_MODIFICACION=@USUARIO,e.FECHA_MODIFICACION=GETDATE()
			FROM transaccional.evaluacion e
			--INNER JOIN transaccional.evaluacion_detalle ed ON ed.ID_EVALUACION = e.ID_EVALUACION
			INNER JOIN transaccional.programacion_clase pc ON pc.ID_PROGRAMACION_CLASE = e.ID_PROGRAMACION_CLASE
			WHERE e.ES_ACTIVO=1 AND pc.ES_ACTIVO=1
			AND e.ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE
		
			COMMIT TRANSACTION TransactSQL
						SELECT @@ROWCOUNT AS Value

		END TRY

		BEGIN CATCH
			ROLLBACK TRAN TransactSQL
			PRINT ERROR_MESSAGE()
			SELECT 
				0 as Value
		END CATCH

END