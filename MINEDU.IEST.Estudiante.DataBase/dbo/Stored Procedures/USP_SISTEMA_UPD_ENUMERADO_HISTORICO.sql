/**********************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	15/11/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro correspondiente al Enumerado Historico
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_UPD_ENUMERADO_HISTORICO]
(
	@CODIGO_ENUMERADO_HISTORICO int,
	@CODIGO_ENUMERADO_HISTORICO_PADRE int,
	@ID_RESOLUCION_ENUMERADO_HISTORICO int,
    @VALOR_ENUMERADO_HISTORICO nvarchar(150),
	@ESTADO_ENUMERADO_HISTORICO int,
	@NRO_RD nvarchar(150),
	@ARCHIVO_RD nvarchar(150),
	@ARCHIVO_RUTA nvarchar(150),
    @USUARIO	 nvarchar(20)
)
AS

DECLARE @RESULT int

BEGIN
	IF @CODIGO_ENUMERADO_HISTORICO_PADRE = 9
			BEGIN
			--Actualiza EnumeradoHistorico-Carrera
				BEGIN TRANSACTION T1
				BEGIN TRY
					UPDATE sistema.enumerado_historico
					SET VALOR_ENUMERADO_HISTORICO = UPPER(@VALOR_ENUMERADO_HISTORICO),
						ESTADO_ENUMERADO_HISTORICO = @ESTADO_ENUMERADO_HISTORICO,
						USUARIO_MODIFICACION = @USUARIO,
						FECHA_MODIFICACION = GETDATE()
					WHERE ID_ENUMERADO_HISTORICO = @CODIGO_ENUMERADO_HISTORICO

					UPDATE sistema.resolucion_enumerado_historico
					SET NRO_RD = @NRO_RD,
						ARCHIVO_RD = @ARCHIVO_RD,
						ARCHIVO_RUTA = @ARCHIVO_RUTA,
						USUARIO_MODIFICACION = @USUARIO,
						FECHA_MODIFICACION = GETDATE()
					WHERE ID_RESOLUCION_ENUMERADO_HISTORICO = @ID_RESOLUCION_ENUMERADO_HISTORICO

				COMMIT TRANSACTION T1
					SET @RESULT = 1
				END TRY
	   
				BEGIN CATCH
					IF @@ERROR<>0
					BEGIN
						ROLLBACK TRANSACTION T1	   
						SET @RESULT =-1
						PRINT ERROR_MESSAGE()
					END
				END CATCH
			END
	ELSE
			BEGIN
		--Actualiza EnumeradoHistorico
				UPDATE sistema.enumerado_historico
				SET VALOR_ENUMERADO_HISTORICO = UPPER(@VALOR_ENUMERADO_HISTORICO),
					ESTADO_ENUMERADO_HISTORICO = @ESTADO_ENUMERADO_HISTORICO,
					USUARIO_MODIFICACION = @USUARIO,
					FECHA_MODIFICACION = GETDATE()
				WHERE ID_ENUMERADO_HISTORICO = @CODIGO_ENUMERADO_HISTORICO
				SET @RESULT = 1
			END
	SELECT @RESULT
END

--***********************************************************************************
--98. USP_TRANSACCIONAL_DEL_ARCHIVO_DRE_HISTORICO.sql