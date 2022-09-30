/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina el registro de periodo académico
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--/*
--	1.0		31/01/2020		MALVA          SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--*/
--  TEST:		USP_TRANSACCIONAL_DEL_PERIODO_ACADEMICO 1106, 59, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_DEL_PERIODO_ACADEMICO]
(
	@ID_INSTITUCION					INT, 
    @ID_PERIODO_ACADEMICO			INT,        
    @USUARIO						nvarchar(20)
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	SELECT @ID_INSTITUCION_CONSULTA = plxi.ID_INSTITUCION FROM transaccional.periodo_academico pa
	INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	AND pa.ES_ACTIVO=1 AND plxi.ES_ACTIVO=1
	WHERE pa.ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362
	ELSE IF (EXISTS (select TOP 1 ID_MATRICULA_ESTUDIANTE from transaccional.matricula_estudiante WHERE ID_PERIODO_ACADEMICO= @ID_PERIODO_ACADEMICO and ES_ACTIVO=1))
			OR EXISTS(select TOP 1 ID_PROGRAMACION_CLASE from transaccional.programacion_clase WHERE ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO  and ES_ACTIVO=1)
		SET @RESULT = -162
	ELSE
	BEGIN
		UPDATE transaccional.periodo_academico
		   SET 
			   [ES_ACTIVO]	= 0 
			  ,[FECHA_MODIFICACION]	  = GETDATE()   
			  ,[USUARIO_MODIFICACION]	  = @USUARIO
		 WHERE 
			   [ID_PERIODO_ACADEMICO]			  = @ID_PERIODO_ACADEMICO		      

		SET @RESULT =  @@ROWCOUNT
	END
	SELECT @RESULT
END
GO


