/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro de un estudiante por licencia
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.1			14/05/2020		MALVA			ADICIÓN DE PARÁMETRO @ID_ESTUDIANTE_INSTITUCION. 
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_LICENCIA_ESTUDIANTE]
(
	
	@ID_PERIODOLECTIVO_INSTITUCION INT,
	@ID_LICENCIA_ESTUDIANTE INT,
	@ID_TIPO_LICENCIA INT,
    @ID_TIEMPO_LICENCIA INT,
	@ARCHIVO_RD VARCHAR(50),
    @RUTA_RD VARCHAR(255),
	@ID_ESTUDIANTE_INSTITUCION INT, 
	@USUARIO VARCHAR(20)
)
AS
BEGIN
DECLARE @RESULT INT	

	BEGIN TRY
	BEGIN TRANSACTION T1	
UPDATE transaccional.licencia_estudiante
SET ID_TIPO_LICENCIA=@ID_TIPO_LICENCIA, ID_TIEMPO_PERIODO_LICENCIA=@ID_TIEMPO_LICENCIA, USUARIO_MODIFICACION=@USUARIO, ARCHIVO_RD = @ARCHIVO_RD, ARCHIVO_RUTA = @RUTA_RD,
 FECHA_MODIFICACION=GETDATE(), ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION
WHERE ID_LICENCIA_ESTUDIANTE=@ID_LICENCIA_ESTUDIANTE AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOLECTIVO_INSTITUCION AND ES_ACTIVO=1


COMMIT TRANSACTION T1		
		SET @RESULT = 1
	END TRY
	BEGIN CATCH	
		IF @@ERROR <> 0
		BEGIN
			ROLLBACK TRANSACTION T1	   
			SET @RESULT = -1
		END
		ELSE
			ROLLBACK TRANSACTION T1	   
	END CATCH

	SELECT @RESULT


END

--*******************************************************************************
--9. USP_MATRICULA_UPD_ESTUDIANTE_INSTITUCION.sql
GO


