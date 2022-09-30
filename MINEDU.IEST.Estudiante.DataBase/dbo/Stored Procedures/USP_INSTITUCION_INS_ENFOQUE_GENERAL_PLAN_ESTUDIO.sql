-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		29/10/2018
--  ACTUALIZACION:	13/11/2018
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	REGISTRA ENFOQUE A TODOS LOS PLANES MENOS: MODULAR/PRESENCIAL/DUAL y ALTERNANCIA
--															   Y MODULAR/SEMIPRESENCIAL/PRESENCIAL - VIRTUAL (ACTUALIZADO 28/05/2019)

--  TEST:			EXEC USP_INSTITUCION_INS_ENFOQUE_GENERAL_PLAN_ESTUDIO 218, 1, 1, "44322246"

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_INSTITUCION_INS_ENFOQUE_GENERAL_PLAN_ESTUDIO]
(	
	@ID_PLAN_ESTUDIO	INT,
	@ES_ACTIVO			BIT,
	@ESTADO				SMALLINT,
	@USUARIO_CREACION	VARCHAR(20)	
)
AS
BEGIN

	BEGIN TRANSACTION T1
	BEGIN TRY
		
		BEGIN --> INICIO: TRANSACCION 

			BEGIN --> DECLARACION DE VARIABLES 
				DECLARE @EXISTE_ENFOQUE_POR_PLAN_ESTUDIOS INT = 1;					--//SI ES 1 >= EXISTE: NO REGISTRAR Y 0 = NO EXISTE: REGISTRA
				DECLARE @ID_ENFOQUES_POR_PLAN_ESTUDIO_NUEVO INT;				
				DECLARE @ID_ENFOQUES_POR_PLAN_ESTUDIO_ENCONTRADO INT;				
				DECLARE @MODULAR_PRESENCIAL_DUAL			INT = 2					--//Extraido de la base de dato tbl: sistema.enumerado ID_TIPO_ENUMERADO = 37 y tbl: maestro.enfoque
				DECLARE @MODULAR_PRESENCIAL_ALTERNANCIA		INT = 3					--//Extraido de la base de dato tbl: sistema.enumerado ID_TIPO_ENUMERADO = 37 y tbl: maestro.enfoque
				DECLARE @MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL	INT = 4					--//Extraido de la base de dato tbl: sistema.enumerado ID_TIPO_ENUMERADO = 37 y tbl: maestro.enfoque

			END

			BEGIN --> VALIDA SI EXISTE EL PLAN DE ESTUDIOS EN LA TABLA: transaccional.enfoques_por_plan_estudio 
				SET @EXISTE_ENFOQUE_POR_PLAN_ESTUDIOS = (SELECT COUNT(epp.ID_ENFOQUES_POR_PLAN_ESTUDIO) FROM transaccional.enfoques_por_plan_estudio epp WHERE epp.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO);				
			END

			BEGIN --> VALIDA SI EXISTE EL PLAN DE ESTUDIOS EN LA TABLA: transaccional.enfoques_por_plan_estudio POR ITINERARIO MODULAR QUE NO SEA PRESENCIAL_DUAL, PRESENCIAL_ALTERNANCIA, SEMI_PRESENCIAL_VIRTUAL

				IF @EXISTE_ENFOQUE_POR_PLAN_ESTUDIOS = 1
				BEGIN

					Begin --> Obtiene el ID_ENFOQUES_POR_PLAN_ESTUDIO
						SET @ID_ENFOQUES_POR_PLAN_ESTUDIO_ENCONTRADO = (
																		SELECT 																			
																			epp.ID_ENFOQUES_POR_PLAN_ESTUDIO
																		FROM transaccional.enfoques_por_plan_estudio epp 
																		WHERE epp.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
																		AND NOT epp.ID_ENFOQUE IN (@MODULAR_PRESENCIAL_DUAL,@MODULAR_PRESENCIAL_ALTERNANCIA,@MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL)
																		);
					End
				
				END

			END

			BEGIN --> REGISTRO DEL PLAN DE ESTUDIO POR ENFOQUE EN LA TABLA: transaccional.enfoques_por_plan_estudio 
				IF @EXISTE_ENFOQUE_POR_PLAN_ESTUDIOS = 0 
				BEGIN					
					INSERT INTO transaccional.enfoques_por_plan_estudio
					(
					ID_PLAN_ESTUDIO			
					,ES_ACTIVO,	ESTADO, USUARIO_CREACION, FECHA_CREACION			
					)
					VALUES
					(
					@ID_PLAN_ESTUDIO			
					,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
					)
		
					SELECT @ID_ENFOQUES_POR_PLAN_ESTUDIO_NUEVO = SCOPE_IDENTITY(); 					
				END
			END

			BEGIN --> REGISTRO UNIDADES DIDACTICAS POR ENFOQUE EN LA TABLA: transaccional.unidades_didacticas_por_enfoque 

				IF @EXISTE_ENFOQUE_POR_PLAN_ESTUDIOS = 0
				BEGIN

					INSERT INTO transaccional.unidades_didacticas_por_enfoque
					(
					ID_ENFOQUES_POR_PLAN_ESTUDIO
					,ID_UNIDAD_DIDACTICA
					,ES_ACTIVO,	ESTADO,	USUARIO_CREACION,	FECHA_CREACION
					)
					SELECT 
						@ID_ENFOQUES_POR_PLAN_ESTUDIO_NUEVO as ID_ENFOQUES_POR_PLAN_ESTUDIO
						,ID_UNIDAD_DIDACTICA
						,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
						--,'-->' AS '-->',* 
					FROM 
						transaccional.unidad_didactica ud				
					WHERE 
						ud.ID_MODULO IN (SELECT m.ID_MODULO FROM transaccional.modulo m WHERE m.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO )
					ORDER BY ud.ID_UNIDAD_DIDACTICA ASC
				END

			END

			BEGIN --> REGISTRO UNIDADES DIDACTICAS POR ENFOQUE EN LA TABLA: transaccional.unidades_didacticas_por_enfoque POR ITINERARIO MODULAR QUE NO SEA PRESENCIAL_DUAL, PRESENCIAL_ALTERNANCIA, SEMI_PRESENCIAL_VIRTUAL

				IF @EXISTE_ENFOQUE_POR_PLAN_ESTUDIOS = 1 AND @ID_ENFOQUES_POR_PLAN_ESTUDIO_ENCONTRADO IS NOT NULL 
				BEGIN

					INSERT INTO transaccional.unidades_didacticas_por_enfoque
					(
					ID_ENFOQUES_POR_PLAN_ESTUDIO
					,ID_UNIDAD_DIDACTICA
					,ES_ACTIVO,	ESTADO,	USUARIO_CREACION,	FECHA_CREACION
					)
					SELECT 
						@ID_ENFOQUES_POR_PLAN_ESTUDIO_ENCONTRADO as ID_ENFOQUES_POR_PLAN_ESTUDIO
						,ID_UNIDAD_DIDACTICA
						,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
						--,'-->' AS '-->',* 
					FROM 
						transaccional.unidad_didactica ud				
					WHERE 
						ud.ID_MODULO IN (SELECT m.ID_MODULO FROM transaccional.modulo m WHERE m.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO )
					ORDER BY ud.ID_UNIDAD_DIDACTICA ASC					

				END			
			
			END

		END --> FIN: TRANSACCION 		
	
	COMMIT TRANSACTION T1
		SELECT cast(1 AS bit) as Success,@@ROWCOUNT AS Value
	END TRY	   
	BEGIN CATCH
		IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION T1
			SELECT cast(0 AS bit) as Success,-1 AS Value

			--//DESCOMENTAR PARA VER EL ERROR DETALLADO 
			--Select ERROR DETALLADO
			SELECT ERROR_NUMBER() AS errNumber , ERROR_SEVERITY() AS errSeverity  , ERROR_STATE() AS errState , ERROR_PROCEDURE() AS errProcedure , ERROR_LINE() AS errLine , ERROR_MESSAGE() AS errMessage
			--		

		END
	END CATCH

END
GO


