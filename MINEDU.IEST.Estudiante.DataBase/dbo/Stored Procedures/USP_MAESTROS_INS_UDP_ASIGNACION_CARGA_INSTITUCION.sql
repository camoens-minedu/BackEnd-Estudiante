/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Inserta o actualiza la asignación de carga masiva para una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		05/04/2021		JCHAVEZ			Creación
--  TEST:  
--			dbo.USP_MAESTROS_INS_UDP_ASIGNACION_CARGA_INSTITUCION '1911',1,'70557821'
**********************************************************************************************************/
CREATE PROCEDURE dbo.USP_MAESTROS_INS_UDP_ASIGNACION_CARGA_INSTITUCION (
	@ID_INSTITUCION INT,
    @ASIGNAR_DESASIGNAR BIT,
    @USUARIO VARCHAR(8)
)
AS
BEGIN
	DECLARE @RESULT INT

	BEGIN TRY
	BEGIN TRANSACTION T1
		IF EXISTS(SELECT ID_ASIGNACION_INSTITUCION_CARGA FROM transaccional.asignación_institucion_carga WHERE ID_INSTITUCION = @ID_INSTITUCION)
		BEGIN
			UPDATE transaccional.asignación_institucion_carga
			SET 
			ES_ACTIVO = 1,
			ESTADO = @ASIGNAR_DESASIGNAR,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
			WHERE ID_INSTITUCION = @ID_INSTITUCION
        END
        ELSE BEGIN
			INSERT INTO transaccional.asignación_institucion_carga (ID_INSTITUCION,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
			VALUES(
				@ID_INSTITUCION,
				1,
				@ASIGNAR_DESASIGNAR,
				@USUARIO,
				GETDATE()
				);
        END

	COMMIT TRANSACTION T1
	SET @RESULT = 1
	END TRY
	BEGIN CATCH
		IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION T1
			SELECT @@ERROR
			SET @RESULT = -1
		END
	END CATCH

	SELECT @RESULT
END