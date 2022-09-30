-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		12/11/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	REGISTRA EN LA TABLA CARGA EL REGISTRO DE NUESTRA CARGA MASIVA

--  TEST:			EXEC USP_ARCHIVO_INS_CARGA 1,895, 'CARGA_DOCENTE_13112018_0851.xlsm','20078244'
--  MODIFICACIÓN:	Se incluye el filtro por @ID_PERIODOS_LECTIVOS_POR_INSTITUCION y se excluyen parámetros internos.
--					26/12/2018 - MALVA
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ARCHIVO_INS_CARGA]
(
	@ID_TIPO_CARGA INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT, 
	@NOMBRE_ARCHIVO VARCHAR(100),
	@USUARIO_CREACION VARCHAR(20)	
)
AS
BEGIN 

	BEGIN TRANSACTION T1
	BEGIN TRY		
		BEGIN --> INICIO: TRANSACCION 		
		
			BEGIN --> Declaracion de Variables 
				
				DECLARE @IDENTITY_ID_CARGA INT;

			END

			BEGIN --> Insertar Tabla cabecera 
			--PRINT '';

				INSERT INTO archivo.carga
				(
					ID_TIPO_CARGA
					,ID_PERIODOS_LECTIVOS_POR_INSTITUCION
					,NOMBRE_ARCHIVO
					,FECHA_CARGA
					,ES_BORRADO
					,FECHA_CREACION
					,USUARIO_CREACION
					,ESTADO
					,TOTAL_CORRECTOS
					,TOTAL_INCORRECTOS					
				)
				VALUES
				(
					@ID_TIPO_CARGA
					,@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
					,@NOMBRE_ARCHIVO
					,GETDATE()
					,0 
					,GETDATE()
					,@USUARIO_CREACION
					,0
					,0
					,0
				)
			
			END

			BEGIN --> Obtener 
				PRINT '' 
				SET @IDENTITY_ID_CARGA = (SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]);  			
			END

		END --> FIN: TRANSACCION 		
	
	COMMIT TRANSACTION T1

		SELECT CAST(1 AS bit) AS Success, @IDENTITY_ID_CARGA AS Value

	END TRY	   
	BEGIN CATCH
		IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION T1

			BEGIN
				SELECT 
					cast(0 AS bit)	as Success,					
					'0'				as Value
			END

			--//DESCOMENTAR PARA VER EL ERROR DETALLADO 
			--Select ERROR DETALLADO
			--SELECT ERROR_NUMBER() AS errNumber , ERROR_SEVERITY() AS errSeverity  , ERROR_STATE() AS errState , ERROR_PROCEDURE() AS errProcedure , ERROR_LINE() AS errLine , ERROR_MESSAGE() AS errMessage
			
		END
	END CATCH

END
GO


