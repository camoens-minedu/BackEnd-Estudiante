/**********************************************************************************************************
AUTOR				:	FERNANDO RAMOS C.
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza la configuración del orden y las columnas a exportar
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

--  TEST:			
/*
EXEC	USP_TRANSACCIONAL_UDP_OBJETOS_EXPORTADOR
		@ID_EXPORTADOR_DATOS						= 3,
		@ID_INSTITUCION								= 1911,
		@ID_EXPORTADOR_DATOS_CONFIGURACION			= 4,
		@NOMBRE_CONFIGURACION						= N'NOMBRE 0854',
		@USUARIO_CREACION							= N'20078244',
		@LISTA_DATA									= N'1:1;A_ALIAS ID INSTITUCION#true|2:2;B_ALIAS ID SEDE INSTITUCION#true|3:3;C_ALIAS TIPO LOCAL#true|4:4;D_ALIAS NOMBRE REFERENCIA#true|5:5;E_ALIAS DIRECCION REFERENCIA#true|6:6;F_ALIAS ID TIPO SEDE#true|'		
*/
**********************************************************************************************************/

CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_UDP_OBJETOS_EXPORTADOR]
(
	@ID_EXPORTADOR_DATOS					INT,
	@ID_INSTITUCION							INT,
	@ID_EXPORTADOR_DATOS_CONFIGURACION		INT,
	@NOMBRE_CONFIGURACION					VARCHAR(100),
	@USUARIO_CREACION						VARCHAR(20),
	@LISTA_DATA								VARCHAR(MAX)
)
AS
BEGIN 

	BEGIN TRANSACTION T1
	BEGIN TRY		
		BEGIN --> INICIO: TRANSACCION 

			BEGIN --> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS 
			PRINT ''
				IF (OBJECT_ID('tempdb.dbo.#temp001','U')) IS NOT NULL DROP TABLE #temp001
				IF (OBJECT_ID('tempdb.dbo.#TempParaWhile','U')) IS NOT NULL DROP TABLE #TempParaWhile
			END

			BEGIN --> DECLARACION DE VARIABLES
			PRINT ''				
			END

			BEGIN --> UPDATE TABLA CABECERA: transaccional.exportador_datos_configuracion
			PRINT '';				
				UPDATE transaccional.exportador_datos_configuracion
				   SET      
					  NOMBRE_CONFIGURACION = @NOMBRE_CONFIGURACION
					  ,USUARIO_MODIFICACION = @USUARIO_CREACION
					  ,FECHA_MODIFICACION = GETDATE()
				 WHERE 
					ID_EXPORTADOR_DATOS_CONFIGURACION = @ID_EXPORTADOR_DATOS_CONFIGURACION	
			END

			BEGIN --> OBTENER LOS VALORES DE LA GRILLA
			PRINT ''
				SELECT				
				ROW_NUMBER() OVER(ORDER BY (SELECT NULL))																										AS Row,
				@ID_EXPORTADOR_DATOS_CONFIGURACION																												AS ID_EXPORTADOR_DATOS_CONFIGURACION,
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

			END

			BEGIN --> UPDATE TABLE CABECERA DETALLE: transaccional.exportador_datos_configuracion_detalle
			PRINT ''			
			
				BEGIN	--> DECLARARA VARIABLES WHILE 
					DECLARE @EXISTE_REGISTRO_A_ACTUALIZAR INT;
					DECLARE @ID_EXPORTADOR_DATOS_DETALLE INT;
					DECLARE @MOSTRAR_COLUMNA_A_EXPORTAR	BIT;
					DECLARE @ORDEN_COLUMNA_A_EXPORTAR INT;
				END			

				DECLARE @Id INT							
				SELECT Id = Row INTO #TempParaWhile FROM #temp001
							
				WHILE (SELECT COUNT(*) FROM #TempParaWhile) > 0
				Begin								
					SELECT TOP 1 @Id = Id FROM #TempParaWhile										
					BEGIN	--> OBTENER DATOS DEL REGISTRO A ACTUALIZAR
					PRINT ''
						SET @ID_EXPORTADOR_DATOS_DETALLE = (SELECT ID_EXPORTADOR_DATOS_DETALLE FROM #temp001 WHERE Row = @Id)
						SET @MOSTRAR_COLUMNA_A_EXPORTAR = (SELECT MOSTRAR_COLUMNA_A_EXPORTAR FROM #temp001 WHERE Row = @Id)
						SET @ORDEN_COLUMNA_A_EXPORTAR = (SELECT ORDEN_COLUMNA_A_EXPORTAR FROM #temp001 WHERE Row = @Id)
					END

					BEGIN	--> PREGUNTA SI EXISTE Y GUARDA EN UNA VARIABLE
					PRINT ''

						SET @EXISTE_REGISTRO_A_ACTUALIZAR = (SELECT COUNT(edcd.ID_EXPORTADOR_DATOS_CONFIGURACION_DETALLE) FROM transaccional.exportador_datos_configuracion_detalle edcd 
															 WHERE edcd.ID_EXPORTADOR_DATOS_CONFIGURACION = @ID_EXPORTADOR_DATOS_CONFIGURACION AND edcd.ID_EXPORTADOR_DATOS_DETALLE = @ID_EXPORTADOR_DATOS_DETALLE)
					END

					BEGIN	--> NO EXISTE --> ENTONCES INSERTA
					PRINT ''
					END

					BEGIN	--> EXISTE --> ENTONCES ACTUALIZA
					PRINT ''						
						IF @EXISTE_REGISTRO_A_ACTUALIZAR = 1
						BEGIN 
						PRINT ''
						
							UPDATE transaccional.exportador_datos_configuracion_detalle
								SET 
									MOSTRAR_COLUMNA_A_EXPORTAR			= @MOSTRAR_COLUMNA_A_EXPORTAR
									,ORDEN_COLUMNA_A_EXPORTAR				= @ORDEN_COLUMNA_A_EXPORTAR      
									,USUARIO_MODIFICACION					= @USUARIO_CREACION
									,FECHA_MODIFICACION					= GETDATE()
								WHERE 
								ID_EXPORTADOR_DATOS_CONFIGURACION = @ID_EXPORTADOR_DATOS_CONFIGURACION 
								AND ID_EXPORTADOR_DATOS_DETALLE = @ID_EXPORTADOR_DATOS_DETALLE												
						END

					END					
							
					DELETE #TempParaWhile WHERE Id = @Id
				End			
			END

		END --> FIN: TRANSACCION 			

	COMMIT TRANSACTION T1 
			SELECT 1 AS Success--,	@IDENTITY_NUEVO_REGISTRO AS Value
	END TRY	   
	BEGIN CATCH
		IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION T1			
			SELECT 0 AS Success
		END
	END CATCH
END
GO


