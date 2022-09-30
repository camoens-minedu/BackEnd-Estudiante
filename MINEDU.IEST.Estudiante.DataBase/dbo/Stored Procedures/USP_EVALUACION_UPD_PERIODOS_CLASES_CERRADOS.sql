/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	15/09/2020
LLAMADO POR			:
DESCRIPCION			:	Actualización de cierre del periodo de clase
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:		USP_EVALUACION_UPD_PERIODOS_CLASES_CERRADOS 274, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].USP_EVALUACION_UPD_PERIODOS_CLASES_CERRADOS
(	
	@ID_PERIODO_ACADEMICO INT, 
	@USUARIO VARCHAR(20)
)
AS
DECLARE @RESULT INT
	
		UPDATE transaccional.cierre_periodo_clases
		SET ES_ACTIVO = 0,
		FECHA_MODIFICACION = GETDATE(),
		USUARIO_MODFICACION = @USUARIO
		WHERE ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO
		AND ES_ACTIVO=1
	
		SET @RESULT = 1

SELECT @RESULT
GO


