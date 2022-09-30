
-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		03/05/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	INSERTA LA CONFIGURACION DEL ORDEN Y LAS COLUMNAS A EXPORTAR

--  TEST:			
/*
EXEC	[dbo].[USP_TRANSACCIONAL_INS_OBJETOS_EXPORTADOR] @ID_EXPORTADOR_DATOS	= 3,	@ID_INSTITUCION			= 1911,
@NOMBRE_CONFIGURACION	= N'Nombreconf',	@USUARIO_CREACION		= N'20078244',
@LISTA_DATA				= N'1:1;A_ALIAS ID INSTITUCION#true|2:2;B_ALIAS ID SEDE INSTITUCION#false|3:3;C_ALIAS TIPO LOCAL#true|4:4;D_ALIAS NOMBRE REFERENCIA#false|5:5;E_ALIAS DIRECCION REFERENCIA#true|6:6;F_ALIAS ID TIPO SEDE#false|'
*/
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_INS_OBJETOS_EXPORTADOR]
(
	@ID_EXPORTADOR_DATOS					INT,
	@ID_INSTITUCION							INT,
	@NOMBRE_CONFIGURACION					VARCHAR(100),
	@USUARIO_CREACION						VARCHAR(20),
	@LISTA_DATA								VARCHAR(MAX)
)
AS
BEGIN 

	BEGIN TRANSACTION T1
	BEGIN TRY		
		BEGIN --> INICIO: TRANSACCION 

			BEGIN --> PROVISIONAL BORRAR 
			PRINT ''
			--SET @LISTA_DATA = '1:1;A_ALIAS ID INSTITUCION#true|2:2;B_ALIAS ID SEDE INSTITUCION#false|3:3;C_ALIAS TIPO LOCAL#true|4:4;D_ALIAS NOMBRE REFERENCIA#false|5:5;E_ALIAS DIRECCION REFERENCIA#true|6:6;F_ALIAS ID TIPO SEDE#false|';
			END

			BEGIN --> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS 
			PRINT ''
				IF (OBJECT_ID('tempdb.dbo.#temp001','U')) IS NOT NULL DROP TABLE #temp001
			END

			BEGIN --> DECLARACION DE VARIABLES
			PRINT ''				
				DECLARE @IDENTITY_NUEVO_REGISTRO INT = 0;
			END

			BEGIN --> INSERTAR TABLA CABECERA: transaccional.exportador_datos_configuracion
			PRINT '';

				INSERT INTO transaccional.exportador_datos_configuracion
						   (
						   ID_EXPORTADOR_DATOS		   
						   ,ID_INSTITUCION
						   ,NOMBRE_CONFIGURACION           
						   ,ES_ACTIVO
						   ,ESTADO
						   ,USUARIO_CREACION
						   ,FECHA_CREACION
						   )
					 VALUES
						   (
						   @ID_EXPORTADOR_DATOS				--ID_EXPORTADOR_DATOS		   
						   ,@ID_INSTITUCION					--ID_INSTITUCION
						   ,@NOMBRE_CONFIGURACION			--NOMBRE_CONFIGURACION           
						   ,1								--ES_ACTIVO
						   ,1								--ESTADO
						   ,@USUARIO_CREACION				--USUARIO_CREACION
						   ,GETDATE()						--FECHA_CREACION						   
						   )	
						   					   			
			END

			BEGIN --> OBTENER EL ID RECIEN INSERTADO 
			PRINT '' 
				SET @IDENTITY_NUEVO_REGISTRO = (SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]);  			
			END

			BEGIN --> OBTENER LOS VALORES DE LA GRILLA
			PRINT ''
				SELECT
				@IDENTITY_NUEVO_REGISTRO																														AS ID_EXPORTADOR_DATOS_CONFIGURACION,
				SUBSTRING (SplitData,	0,				CHARINDEX(':', SplitData))																				ID_EXPORTADOR_DATOS_DETALLE,
				SUBSTRING (SplitData,					CHARINDEX('#', SplitData)+1,	LEN(SplitData)				-	CHARINDEX('#', SplitData))				MOSTRAR_COLUMNA_A_EXPORTAR,
				SUBSTRING (SplitData,					CHARINDEX(':', SplitData)+1,	CHARINDEX(';', SplitData)	-	CHARINDEX(':', SplitData)-1)			ORDEN_COLUMNA_A_EXPORTAR,
				1																																				AS ES_ACTIVO,
				1																																				AS ESTADO,
				@USUARIO_CREACION																																AS USUARIO_CREACION,
				GETDATE()																																		AS FECHA_CREACION,
				NULL																																			AS USUARIO_MODIFICACION,
				NULL																																			AS FECHA_MODIFICACION				
				INTO #temp001
				FROM dbo.UFN_SPLIT(@LISTA_DATA, '|')

				--SELECT * FROM #temp001;
			END

			BEGIN --> INSERTAR TABLE CABECERA DETALLE: transaccional.exportador_datos_configuracion_detalle
			PRINT ''
				INSERT INTO [transaccional].[exportador_datos_configuracion_detalle] 
					(					
						ID_EXPORTADOR_DATOS_CONFIGURACION, 
						ID_EXPORTADOR_DATOS_DETALLE, 
						MOSTRAR_COLUMNA_A_EXPORTAR, 
						ORDEN_COLUMNA_A_EXPORTAR, 
						ES_ACTIVO, 
						ESTADO, 
						USUARIO_CREACION, 
						FECHA_CREACION, 
						USUARIO_MODIFICACION, 
						FECHA_MODIFICACION
						) 
				SELECT 
						ID_EXPORTADOR_DATOS_CONFIGURACION, 					
						ID_EXPORTADOR_DATOS_DETALLE, 
						MOSTRAR_COLUMNA_A_EXPORTAR, 
						ORDEN_COLUMNA_A_EXPORTAR, 
						ES_ACTIVO, 
						ESTADO, 
						USUARIO_CREACION, 
						FECHA_CREACION, 
						USUARIO_MODIFICACION, 
						FECHA_MODIFICACION								
				FROM #temp001				
			END

		END --> FIN: TRANSACCION 			

	COMMIT TRANSACTION T1 
			SELECT 1 AS Success--,	@IDENTITY_NUEVO_REGISTRO AS Value
			--PRUEBA
			--SELECT @IDENTITY_NUEVO_REGISTRO AS '@IDENTITY_NUEVO_REGISTRO';
	END TRY	   
	BEGIN CATCH
		IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION T1			
			SELECT 0 AS Success--,	'0' AS Value 			
			
			--//DESCOMENTAR PARA VER EL ERROR DETALLADO 			
			--SELECT ERROR_NUMBER() AS errNumber , ERROR_SEVERITY() AS errSeverity  , ERROR_STATE() AS errState , ERROR_PROCEDURE() AS errProcedure , ERROR_LINE() AS errLine , ERROR_MESSAGE() AS errMessage;						
							
		END
	END CATCH
END
GO


