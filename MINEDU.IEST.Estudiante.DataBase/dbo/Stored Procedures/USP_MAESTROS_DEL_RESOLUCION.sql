
--/***************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Elimina un registro de resolución
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--	1.0			21/11/2019		MALVA          MODIFICACIÓN PARA ELIMINAR RESOLUCIÓN INCLUYENDO METAS CONFIGURADAS
--											   EN UN PERIODO DISTINTO AL QUE LE CORRESPONDE POR SU TIPO DE RESOLUCIÓN (ANUAL, AMPLIACIÓN)
--	1.1		    31/01/2020		MALVA          SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--*/
--  TEST:		USP_MAESTROS_DEL_RESOLUCION 1106, 1103, 'MALVA'
--****************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_DEL_RESOLUCION]
(
	@ID_INSTITUCION		INT, 
    @ID_RESOLUCION		INT,
    @USUARIO			nvarchar(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	DECLARE @ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION INT, @ID_PERIODO_LECTIVO_INSTITUCION INT, @ID_TIPO_RESOLUCION INT
	
	
	SELECT	@ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION = ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION,
			@ID_PERIODO_LECTIVO_INSTITUCION = ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	FROM transaccional.resoluciones_por_periodo_lectivo_institucion WHERE ID_RESOLUCION=@ID_RESOLUCION

	SELECT @ID_TIPO_RESOLUCION = ID_TIPO_RESOLUCION FROM maestro.resolucion where ID_RESOLUCION=@ID_RESOLUCION

	DECLARE @ANIO INT,@ID_PERIODO_LECTIVO_INSTITUCION_UNO INT
	SELECT	@ANIO = mpl.ANIO, @ID_INSTITUCION_CONSULTA = tplxi.ID_INSTITUCION 
			FROM transaccional.periodos_lectivos_por_institucion tplxi
				INNER JOIN maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
				WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
				AND tplxi.ES_ACTIVO=1

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
	BEGIN
		SET @RESULT = -362 GOTO FIN
	END

	SET @ID_PERIODO_LECTIVO_INSTITUCION_UNO = (	SELECT top 1 
												tplxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
												FROM transaccional.periodos_lectivos_por_institucion tplxi 
												INNER JOIN maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
												WHERE ID_INSTITUCION=@ID_INSTITUCION 
												AND ES_ACTIVO=1 AND mpl.ANIO=@ANIO
												AND tplxi.ESTADO =7
												ORDER BY 1 ASC )

	IF EXISTS(	SELECT TOP 1 mci.ID_META_CARRERA_INSTITUCION FROM transaccional.meta_carrera_institucion mci
				INNER JOIN transaccional.meta_carrera_institucion_detalle mcid on mci.ID_META_CARRERA_INSTITUCION = mcid.ID_META_CARRERA_INSTITUCION
				AND mci.ES_ACTIVO=1 and mcid.ES_ACTIVO=1 
				AND mci.ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION= @ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION)	
	BEGIN
		SET @RESULT = -194		
	END
	ELSE
	BEGIN
		IF ((@ID_PERIODO_LECTIVO_INSTITUCION_UNO=@ID_PERIODO_LECTIVO_INSTITUCION AND  @ID_TIPO_RESOLUCION =21) OR
			(@ID_PERIODO_LECTIVO_INSTITUCION_UNO <>@ID_PERIODO_LECTIVO_INSTITUCION  AND @ID_TIPO_RESOLUCION =22)) AND  
			EXISTS (SELECT TOP 1 ID_META_CARRERA_INSTITUCION FROM transaccional.meta_carrera_institucion 
					WHERE ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION=@ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION 
					AND ES_ACTIVO=1) 
			SET @RESULT = -235
		ELSE
		BEGIN	
			BEGIN TRANSACTION T1
			BEGIN TRY
	
				UPDATE transaccional.resoluciones_por_periodo_lectivo_institucion
				SET 
					   [ES_ACTIVO] =0
					  ,[FECHA_MODIFICACION] = getdate()
					  ,[USUARIO_MODIFICACION] = @USUARIO
				WHERE [ID_RESOLUCION] = @ID_RESOLUCION

				UPDATE transaccional.resoluciones_por_carreras_por_institucion
				SET 
					   [ES_ACTIVO] =0
					  ,[FECHA_MODIFICACION] = getdate()
					  ,[USUARIO_MODIFICACION] = @USUARIO
				WHERE [ID_RESOLUCION] = @ID_RESOLUCION

				UPDATE [maestro].[resolucion]
				SET 
					   ESTADO =0
					  ,[FECHA_MODIFICACION] = getdate()
					  ,[USUARIO_MODIFICACION] = @USUARIO
				WHERE [ID_RESOLUCION] = @ID_RESOLUCION
				COMMIT TRANSACTION T1
				SET @RESULT = 1
			END TRY
			BEGIN CATCH
						IF @@ERROR<>0
							BEGIN
								ROLLBACK TRANSACTION T1	   
								   SET @RESULT = -1
								   PRINT ERROR_MESSAGE()
							END
			END CATCH
		END	
	END
	FIN:
	SELECT @RESULT
END
GO


