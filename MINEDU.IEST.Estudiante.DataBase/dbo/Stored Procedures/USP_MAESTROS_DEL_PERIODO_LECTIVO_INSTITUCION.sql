/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un periodo lectivo institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--											SE MODIFICA EL RESULTADO DEL RETORNO
--  TEST:  
--			USP_MAESTROS_DEL_PERIODO_LECTIVO_INSTITUCION 1106, 5493, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_DEL_PERIODO_LECTIVO_INSTITUCION]
(
	@ID_INSTITUCION					INT,
	@ID_PERIODO_LECTIVO_INSTITUCION INT,
	@USUARIO VARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @PERIODO INT, @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	SELECT @ID_INSTITUCION_CONSULTA = ID_INSTITUCION from transaccional.periodos_lectivos_por_institucion WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
	SET @PERIODO = (SELECT TOP 1 ID_PERIODO_LECTIVO FROM transaccional.periodos_lectivos_por_institucion 
					WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND ES_ACTIVO=1)

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
		SET @RESULT = -362		
	ELSE  IF EXISTS (SELECT TOP 1 mestu.ID_MATRICULA_ESTUDIANTE FROM transaccional.matricula_estudiante mestu 
            WHERE mestu.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION 
			AND mestu.ES_ACTIVO=1 
			)
			OR EXISTS(SELECT TOP 1 padmp.ID_PROCESO_ADMISION_PERIODO  FROM transaccional.proceso_admision_periodo padmp 
			where padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND padmp.ES_ACTIVO=1
			)			
			OR EXISTS(SELECT TOP 1 ID_PERSONAL_INSTITUCION FROM maestro.personal_institucion WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND ES_ACTIVO=1)			
			  SET @RESULT = -162		
	ELSE
	BEGIN

		UPDATE transaccional.periodos_lectivos_por_institucion
		SET ES_ACTIVO=1, 
		   USUARIO_MODIFICACION=@USUARIO,
		   ESTADO = 6,
		   FECHA_MODIFICACION=getdate()
		WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION
		AND ES_ACTIVO=1

		SET @RESULT =1  
	END
	SELECT @RESULT
END
GO


