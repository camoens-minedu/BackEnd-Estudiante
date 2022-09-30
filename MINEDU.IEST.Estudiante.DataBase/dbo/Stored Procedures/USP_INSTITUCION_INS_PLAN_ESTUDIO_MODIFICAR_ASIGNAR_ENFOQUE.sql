-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		04/10/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	MODIFICAR UNIDADES DIDACTICAS POR ENFOQUE

--  TEST:			EXEC USP_INSTITUCION_INS_PLAN_ESTUDIO_MODIFICAR_ASIGNAR_ENFOQUE 968, N'411,412,413', 1, 1, N'**FECHO1876**'	

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_INSTITUCION_INS_PLAN_ESTUDIO_MODIFICAR_ASIGNAR_ENFOQUE]
(    
	@ID_PLAN_ESTUDIO					INT,
	@UNIDADES_DIDACTICAS_POR_ENFOQUE	NVARCHAR(MAX),
	--//
    @ES_ACTIVO							BIT,						
    @ESTADO								SMALLINT,				
    @USUARIO_MODIFICACION				NVARCHAR(20)
)
AS

BEGIN	

	BEGIN TRANSACTION T1 

	BEGIN TRY
		
		BEGIN --> INICIO: TRANSACCION 

			Begin --> DECLARACION DE VARIABLES 

				
				DECLARE @ID_ENFOQUES_POR_PLAN_ESTUDIO					INT
				DECLARE @ID_ENFOQUE										INT

				DECLARE	@PRACTICO_HORAS_UD								DECIMAL(5, 1)
				DECLARE	@CREDITOS										DECIMAL(5, 1)
				DECLARE @MODULAR_PRESENCIAL_DUAL						INT = 2					--//Extraido de la base de dato tbl: sistema.enumerado ID_TIPO_ENUMERADO = 37 y tbl: maestro.enfoque
				DECLARE @MODULAR_PRESENCIAL_ALTERNANCIA					INT = 3					--//Extraido de la base de dato tbl: sistema.enumerado ID_TIPO_ENUMERADO = 37 y tbl: maestro.enfoque
				DECLARE @MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL		INT = 4					--//Extraido de la base de dato tbl: sistema.enumerado ID_TIPO_ENUMERADO = 37 y tbl: maestro.enfoque
				DECLARE @DELIMITADOR_UNIDADES_DIDACTICAS_POR_ENFOQUE	VARCHAR(1)	= ','	

			End

			Begin --> OBTENER ID ENFOQUE POR PLAN DE ESTUDIOS / ID ENFOQUE 

				SET @ID_ENFOQUES_POR_PLAN_ESTUDIO = (	
							SELECT																		
								epe.ID_ENFOQUES_POR_PLAN_ESTUDIO
							FROM
										transaccional.plan_estudio pe
							INNER JOIN	transaccional.enfoques_por_plan_estudio epe	ON pe.ID_PLAN_ESTUDIO = epe.ID_PLAN_ESTUDIO																	
							WHERE
								pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
							)

				SET @ID_ENFOQUE = (	
							SELECT																		
								epe.ID_ENFOQUE
							FROM
										transaccional.plan_estudio pe
							INNER JOIN	transaccional.enfoques_por_plan_estudio epe	ON pe.ID_PLAN_ESTUDIO = epe.ID_PLAN_ESTUDIO																	
							WHERE
								pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
							)
			End
	
			Begin --> ELIMINAR TODO EL CONTENIDO DE LAS COLUMNAS: HORAS_EMPRESA, CREDITOS_VIRTUALES DE TABLA: transaccional.unidades_didacticas_por_enfoque 

				IF @ID_ENFOQUES_POR_PLAN_ESTUDIO > 0 
					Begin 

						UPDATE transaccional.unidades_didacticas_por_enfoque
						   SET 
							 HORAS_EMPRESA = NULL
							,CREDITOS_VIRTUALES = NULL
							,USUARIO_MODIFICACION = NULL
							,FECHA_MODIFICACION = NULL
						 WHERE 
 							ID_ENFOQUES_POR_PLAN_ESTUDIO = @ID_ENFOQUES_POR_PLAN_ESTUDIO

					End	

				--//PRUEBA
				--SELECT * FROM transaccional.unidades_didacticas_por_enfoque WHERE ID_ENFOQUES_POR_PLAN_ESTUDIO = @ID_ENFOQUES_POR_PLAN_ESTUDIO
			End
	
			Begin --> OBTENER LISTA DE ID A MODIFICAR MEDIANTE FUNCION: dbo.UFN_SPLIT 

				SELECT Id = SplitData INTO #TempIdUnidadesDidacticasPorEnfoque 
				FROM dbo.UFN_SPLIT(@UNIDADES_DIDACTICAS_POR_ENFOQUE,@DELIMITADOR_UNIDADES_DIDACTICAS_POR_ENFOQUE);
		
				--//Pruebas
				--SELECT * FROM #TempIdUnidadesDidacticasPorEnfoque;		
			End
	
			Begin --> PROCESO DE INGRESO DE DATOS 
	
				DECLARE @Id INT
							
				WHILE (SELECT COUNT(*) FROM #TempIdUnidadesDidacticasPorEnfoque) > 0 
				Begin								
					SELECT TOP 1 @Id = Id FROM #TempIdUnidadesDidacticasPorEnfoque
			
						Begin --> Proceso que se realizara al iterar 
						
							Begin --> Obtener PracticoHorasUd / Creditos 
								SELECT						
									@PRACTICO_HORAS_UD = ud.PRACTICO_HORAS_UD,
									@CREDITOS = ud.CREDITOS
								FROM 
									transaccional.unidades_didacticas_por_enfoque ude
									INNER JOIN transaccional.unidad_didactica ud				ON ude.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA
								WHERE
									ude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = @Id
							End

							Begin --> Insertar HORAS_EMPRESA cuando es MODULAR_PRESENCIAL_DUAL o MODULAR_PRESENCIAL_ALTERNANCIA 

								--SELECT 
								--CONVERT(VARCHAR,@MODULAR_PRESENCIAL_DUAL) AS '@MODULAR_PRESENCIAL_DUAL' 
								--,CONVERT(VARCHAR,@ID_ENFOQUE) AS '@ID_ENFOQUE'
								--,CONVERT(VARCHAR,@MODULAR_PRESENCIAL_ALTERNANCIA) AS '@MODULAR_PRESENCIAL_ALTERNANCIA'
								--,CONVERT(VARCHAR,@ID_ENFOQUE) AS '@ID_ENFOQUE'


								IF @MODULAR_PRESENCIAL_DUAL = @ID_ENFOQUE OR @MODULAR_PRESENCIAL_ALTERNANCIA = @ID_ENFOQUE
									Begin 
						
										UPDATE transaccional.unidades_didacticas_por_enfoque
										SET 
											HORAS_EMPRESA = @PRACTICO_HORAS_UD									
											,ES_ACTIVO = @ES_ACTIVO
											,ESTADO = @ESTADO
											,USUARIO_MODIFICACION = @USUARIO_MODIFICACION
											,FECHA_MODIFICACION = GETDATE()
										WHERE 
 											ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = @Id
								
									End
							End

							Begin --> Insertar CREDITOS_VIRTUALES cuando es MODULAR_SEMI_PRESENCIAL_VIRTUAL 

								--SELECT 
								--CONVERT(VARCHAR,@MODULAR_SEMI_PRESENCIAL_VIRTUAL) AS '@MODULAR_SEMI_PRESENCIAL_VIRTUAL' 
								--,CONVERT(VARCHAR,@ID_ENFOQUE) AS '@ID_ENFOQUE'						

								IF @MODULAR_SEMI_PRESENCIAL_PRESENCIAL_VIRTUAL = @ID_ENFOQUE
									Begin 

										UPDATE transaccional.unidades_didacticas_por_enfoque
										SET 									
											CREDITOS_VIRTUALES = @CREDITOS
											,ES_ACTIVO = @ES_ACTIVO
											,ESTADO = @ESTADO
											,USUARIO_MODIFICACION = @USUARIO_MODIFICACION
											,FECHA_MODIFICACION = GETDATE()
										WHERE 
 											ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = @Id						

									End
							End

							--//Pruebas
							--SELECT @Id AS 'Id', CONVERT(VARCHAR,@PRACTICO_HORAS_UD) AS '@PRACTICO_HORAS_UD', CONVERT(VARCHAR,@CREDITOS) AS '@CREDITOS';
							--//
					
						End 
							
					DELETE #TempIdUnidadesDidacticasPorEnfoque WHERE Id = @Id
				End

				--//PRUEBA
				--SELECT * FROM transaccional.unidades_didacticas_por_enfoque WHERE ID_ENFOQUES_POR_PLAN_ESTUDIO = @ID_ENFOQUES_POR_PLAN_ESTUDIO		

				DROP TABLE #TempIdUnidadesDidacticasPorEnfoque;
	
			End

		END --> FIN: TRANSACCION
	
	COMMIT TRANSACTION T1 --> SI ES CORRECTO ACCION A REALIZAR

		Begin --> RESULTADO IGUAL A 1 

			--SELECT cast(1 AS bit) as Success,@@ROWCOUNT AS Value			
			SELECT 1	
		End

	END TRY
		   
	BEGIN CATCH --> SI SE PRODUCE UN ERROR ACCION A REALIZAR

		IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION T1
			
			Begin --> RESULTADO ERROR IGUAL A 0 

				--//DESCOMENTAR PARA VER EL ERROR DETALLADO 			
				--SELECT ERROR_NUMBER() AS errNumber , ERROR_SEVERITY() AS errSeverity  , ERROR_STATE() AS errState , ERROR_PROCEDURE() AS errProcedure , ERROR_LINE() AS errLine , ERROR_MESSAGE() AS errMessage

				--SELECT cast(0 AS bit) as Success,-1 AS Value							
				SELECT 0	
			End

		END

	END CATCH

END
GO


