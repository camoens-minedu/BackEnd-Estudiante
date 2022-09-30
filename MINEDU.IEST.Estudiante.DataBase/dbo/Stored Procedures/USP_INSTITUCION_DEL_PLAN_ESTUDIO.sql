/**********************************************************************************************************
AUTOR				:	FERNANDO RAMOS C.
FECHA DE CREACION	:	20/08/2018
LLAMADO POR			:
DESCRIPCION			:	ELIMINA EL PLAN DE ESTUDIO CARGADO DEL EXCEL
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 05/09/2019		MALVA			ELIMINACIÓN LÓGICA DE LOS REGISTROS EN LAS TABLAS INVOLUCRADAS.
--	1.1		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--	2.0		 30/11/2021		JCHAVEZ			SE AGREGAN VALIDACIONES DE METAS, POSTULANTES Y ESTUDIANTES PREVIO A LA ELIMINACIÓN
--  TEST:  
--			EXEC USP_INSTITUCION_DEL_PLAN_ESTUDIO 1106,218, "44322246"
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_DEL_PLAN_ESTUDIO]
(	
	@ID_INSTITUCION		INT,
	@ID_PLAN_ESTUDIO	INT,
	@USUARIO			VARCHAR(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	 DECLARE @ID_INSTITUCION_CONSULTA INT = 0

		SELECT @ID_INSTITUCION_CONSULTA = cxi.ID_INSTITUCION 
		FROM transaccional.plan_estudio pe
		INNER JOIN transaccional.carreras_por_institucion cxi ON cxi.ID_CARRERAS_POR_INSTITUCION =  pe.ID_CARRERAS_POR_INSTITUCION  AND pe.ES_ACTIVO=1 AND cxi.ES_ACTIVO=1
		WHERE pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO

		IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA 
		BEGIN
				SELECT 
						cast(0 AS bit)	as Success,										
						'1'	as Value,
						'El registro seleccionado no corresponde a la institución.' as Message
		END
		ELSE IF EXISTS (select TOP 1 ID_SITUACION_ACADEMICA_ESTUDIANTE from transaccional.situacion_academica_estudiante where ID_PLAN_ESTUDIO =@ID_PLAN_ESTUDIO and ES_ACTIVO=1)
		OR EXISTS (SELECT TOP 1 ID_META_CARRERA_INSTITUCION FROM transaccional.meta_carrera_institucion WHERE ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO and ES_ACTIVO = 1) --versión 2.0
		OR EXISTS (SELECT TOP 1 ID_ESTUDIANTE_INSTITUCION FROM transaccional.estudiante_institucion WHERE ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO and ES_ACTIVO = 1) --versión 2.0
		OR EXISTS (select top 1 pc.ID_PROGRAMACION_CLASE from transaccional.programacion_clase pc 
		inner join transaccional.unidades_didacticas_por_programacion_clase udxpc on pc.ID_PROGRAMACION_CLASE= udxpc.ID_PROGRAMACION_CLASE and pc.ES_ACTIVO=1 and udxpc.ES_ACTIVO=1
		inner join transaccional.unidades_didacticas_por_enfoque udxe on udxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= udxpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE and udxe.ES_ACTIVO=1
		inner join transaccional.enfoques_por_plan_estudio expe on expe.ID_ENFOQUES_POR_PLAN_ESTUDIO= udxe.ID_ENFOQUES_POR_PLAN_ESTUDIO and expe.ES_ACTIVO=1
		where expe.ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO
		)
		BEGIN
				SELECT 
							cast(0 AS bit)	as Success,										
							'1'	as Value,
							'No se puede eliminar el plan de estudio porque ya se encuentra en uso.' as Message
		END
		ELSE
		BEGIN 

			BEGIN TRANSACTION T1
			BEGIN TRY
		
				BEGIN --> INICIO: TRANSACCION 

						Begin --> DECLARACION DE VARIABLES
				
							DECLARE @ID_ENFOQUES_POR_PLAN_ESTUDIO						INT
							--DECLARE @CANTIDAD_DE_UNIDAD_DIDACTICA_POR_ENFOQUE_USADAS	INT	

						End					
				
						Begin --> ELIMINAR: UNIDADES DIDACTICAS POR ENFOQUE
				
							Begin --> OBTENER ID ENFOQUE POR PLAN DE ESTUDIOS

								SET @ID_ENFOQUES_POR_PLAN_ESTUDIO = (	
																	SELECT																		
																		epe.ID_ENFOQUES_POR_PLAN_ESTUDIO
																	FROM									
																		transaccional.enfoques_por_plan_estudio epe
																	WHERE
																		epe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
																	)

								--SET @CANTIDAD_DE_UNIDAD_DIDACTICA_POR_ENFOQUE_USADAS = (
								--														SELECT 
								--															COUNT(ude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE) 
								--														FROM 
								--															transaccional.unidades_didacticas_por_enfoque ude 
								--														WHERE
								--															(ude.HORAS_EMPRESA IS NOT NULL OR ude.CREDITOS_VIRTUALES IS NOT NULL)
								--															AND ude.ID_ENFOQUES_POR_PLAN_ESTUDIO = @ID_ENFOQUES_POR_PLAN_ESTUDIO									
								--														)

								--IF @CANTIDAD_DE_UNIDAD_DIDACTICA_POR_ENFOQUE_USADAS = 0
								--Begin
						
									Begin --> ELIMINAR DATOS DE LA TABLA: unidades_didacticas_por_enfoque 
										UPDATE  
											transaccional.unidades_didacticas_por_enfoque
											SET ES_ACTIVO=0,
											FECHA_MODIFICACION=GETDATE(),
											USUARIO_MODIFICACION=@USUARIO									
										WHERE 
											ID_ENFOQUES_POR_PLAN_ESTUDIO = @ID_ENFOQUES_POR_PLAN_ESTUDIO
									End

									Begin --> ELIMINAR DATOS DE LA TABLA: enfoques_por_plan_estudio 
										UPDATE								
											transaccional.enfoques_por_plan_estudio
											SET ES_ACTIVO=0,
											FECHA_MODIFICACION=GETDATE(),
											USUARIO_MODIFICACION=@USUARIO
										WHERE 
											ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
									End

								--End
							End							

						End							

						Begin --> ELIMINAR: UNIDAD_COMPETENCIAS_POR_MODULO / UNIDAD_COMPETENCIA 
					
							SELECT * INTO --> Creacion de tabla temporal de: transaccional.unidad_competencias_por_modulo 
								#unidad_competencias_por_modulo 
							FROM 
								transaccional.unidad_competencias_por_modulo
							WHERE 
								ID_MODULO IN (SELECT m.ID_MODULO FROM transaccional.modulo m WHERE m.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO)					
											
							UPDATE  --> UNIDAD_COMPETENCIAS_POR_MODULO 					
								transaccional.unidad_competencias_por_modulo
								SET ES_ACTIVO=0,
								FECHA_MODIFICACION=GETDATE(),
								USUARIO_MODIFICACION=@USUARIO
							WHERE 
								ID_MODULO IN (SELECT m.ID_MODULO FROM transaccional.modulo m WHERE m.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO)
											
							UPDATE--> UNIDAD_COMPETENCIA 					
								maestro.unidad_competencia
								SET ES_ACTIVO =0,
								FECHA_MODIFICACION=GETDATE(),
								USUARIO_MODIFICACION=@USUARIO
							WHERE 
								ID_UNIDAD_COMPETENCIA IN (SELECT ID_UNIDAD_COMPETENCIA FROM #unidad_competencias_por_modulo)
				
							DROP TABLE #unidad_competencias_por_modulo

						End

						Begin --> ELIMINAR: UNIDAD_DIDACTICA_DETALLE 
					
							UPDATE 					
							transaccional.unidad_didactica_detalle
							SET ES_ACTIVO=0,
							FECHA_MODIFICACION=GETDATE(),
							USUARIO_MODIFICACION=@USUARIO
							WHERE
								ID_UNIDAD_DIDACTICA IN (
														SELECT 
															udd.ID_UNIDAD_DIDACTICA													
														FROM transaccional.plan_estudio pe
															INNER JOIN transaccional.modulo m ON pe.ID_PLAN_ESTUDIO = m.ID_PLAN_ESTUDIO
															INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
															INNER JOIN transaccional.unidad_didactica_detalle udd ON ud.ID_UNIDAD_DIDACTICA = udd.ID_UNIDAD_DIDACTICA
														WHERE 
															pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
														)
				
						End

						Begin --> ELIMINAR: UNIDAD DIDACTICA 
					
							UPDATE
							transaccional.unidad_didactica
							SET ES_ACTIVO=0	,
								FECHA_MODIFICACION=GETDATE(),
								USUARIO_MODIFICACION=@USUARIO	
							WHERE 
								ID_MODULO IN (SELECT m.ID_MODULO FROM transaccional.modulo m WHERE m.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO)
					
						End

						Begin --> ELIMINAR: MODULO 
					
							UPDATE					
								transaccional.modulo
								SET ES_ACTIVO=0,
								FECHA_MODIFICACION=GETDATE(),
								USUARIO_MODIFICACION=@USUARIO
							WHERE
								ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
					
						End

						Begin --> ELIMINAR: ENFOQUES_POR_PLAN_ESTUDIO 
				
							UPDATE						
								transaccional.enfoques_por_plan_estudio
								SET ES_ACTIVO=0,
								FECHA_MODIFICACION=GETDATE(),
								USUARIO_MODIFICACION=@USUARIO
							WHERE
								ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO				
						End

						Begin --> ELIMINAR: PLAN_ESTUDIO_DETALLE 
					
							UPDATE					
								transaccional.plan_estudio_detalle
								SET ES_ACTIVO=0,
								FECHA_MODIFICACION=GETDATE(),
								USUARIO_MODIFICACION=@USUARIO
							WHERE 
								ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO

						End

						Begin --> ELIMINAR: PLAN_ESTUDIO 
					
							UPDATE							
								transaccional.plan_estudio
								SET ES_ACTIVO=0,
								FECHA_MODIFICACION=GETDATE(),
								USUARIO_MODIFICACION=@USUARIO
							WHERE
								ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO

						End

				END --> FIN: TRANSACCION 		
	
			COMMIT TRANSACTION T1
				SELECT cast(1 AS bit) as Success,@@ROWCOUNT AS Value
			END TRY	   
			BEGIN CATCH
				IF @@ERROR<>0
				BEGIN
					ROLLBACK TRANSACTION T1

					PRINT ERROR_MESSAGE()
					IF	ERROR_NUMBER() = 547	--> The %ls statement conflicted with the %ls constraint "%.*ls". The conflict occurred in database "%.*ls", table "%.*ls"%ls%.*ls%ls.
					BEGIN
						SELECT 
							cast(0 AS bit)	as Success,										
							ERROR_NUMBER()	as Value,
							'No se puede eliminar el plan de estudio porque ya se encuentra en uso.' as Message
					END
					ELSE						--> Caso contrario le envio Value = 0 para que muestre mensaje de error generico.
					BEGIN
						SELECT 
							cast(0 AS bit)	as Success,					
							'0'				as Value
					END

					--SELECT 
					--	cast(0 AS bit) as Success,
					--	-1 AS Value,
					--	ERROR_MESSAGE() as Message,
					--	ERROR_NUMBER() as Value

					--//DESCOMENTAR PARA VER EL ERROR DETALLADO 
					--Select ERROR DETALLADO
					--SELECT ERROR_NUMBER() AS errNumber , ERROR_SEVERITY() AS errSeverity  , ERROR_STATE() AS errState , ERROR_PROCEDURE() AS errProcedure , ERROR_LINE() AS errLine , ERROR_MESSAGE() AS errMessage
					--		

				END
			END CATCH

		END

END
GO


