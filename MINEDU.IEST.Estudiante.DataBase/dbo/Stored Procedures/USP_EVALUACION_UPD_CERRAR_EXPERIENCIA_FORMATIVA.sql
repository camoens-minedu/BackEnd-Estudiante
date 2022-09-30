/**********************************************************************************************************
AUTOR				:	Luis Espinoza
FECHA DE CREACION	:	05/03/2021
LLAMADO POR			:
DESCRIPCION			:	Cierra el registro de unidad didactica tipo experiencia formativa
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/03/2021		LESPINOZA			Creación
--  TEST:			
/*

*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_UPD_CERRAR_EXPERIENCIA_FORMATIVA](
	@ID_EVALUACION_EXPERIENCIA_FORMATIVA	INT = 1, 
	@ID_MATRICULA_ESTUDIANTE				INT, 
	@CIERRE_EVALUACION						INT, 
	@USUARIO								VARCHAR(20)	
)
AS  
BEGIN
	DECLARE @RESULT INT
	DECLARE @EVALUACION_EXPERIENCIA INT = 0

	SET @EVALUACION_EXPERIENCIA = (SELECT COUNT(*) 
										FROM transaccional.evaluacion_experiencia_formativa 
											WHERE ID_EVALUACION_EXPERIENCIA_FORMATIVA = @ID_EVALUACION_EXPERIENCIA_FORMATIVA AND 
												ID_MATRICULA_ESTUDIANTE = @ID_MATRICULA_ESTUDIANTE AND ESTADO = 1)	 
	
	IF @EVALUACION_EXPERIENCIA > 0
	BEGIN 
		UPDATE	transaccional.evaluacion_experiencia_formativa
		SET		
				CIERRE_EVALUACION=@CIERRE_EVALUACION,	
				USUARIO_MODIFICACION=@USUARIO,
				FECHA_MODIFICACION=GETDATE()
		FROM	transaccional.evaluacion_experiencia_formativa a
		WHERE 
			a.ID_EVALUACION_EXPERIENCIA_FORMATIVA = @ID_EVALUACION_EXPERIENCIA_FORMATIVA
			AND a.ID_MATRICULA_ESTUDIANTE = @ID_MATRICULA_ESTUDIANTE
			AND a.ES_ACTIVO=1 AND a.ESTADO=1
		
		set @RESULT = @@rowcount
	END
	ELSE
	BEGIN 
		SET @RESULT = 2
	END

	SELECT @RESULT	
	
END