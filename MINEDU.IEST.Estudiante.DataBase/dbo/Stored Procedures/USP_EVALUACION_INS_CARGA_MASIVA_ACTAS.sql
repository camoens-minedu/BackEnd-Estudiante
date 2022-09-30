/*********************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	06/03/2021
LLAMADO POR			:
DESCRIPCION			:	CREACION CARGA MASIVA ACTAS
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			06/03/2021		JTOVAR         CREACIÓN

TEST:			
	USP_EVALUACION_INS_CARGA_MASIVA_ACTAS 3,
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_INS_CARGA_MASIVA_ACTAS]
(	
	@ID_CARGA_MASIVA_NOMINA INT,
	@QUERY_EXCEL NVARCHAR(MAX),
    @USUARIO_CREACION NVARCHAR(20)	
)
AS
BEGIN
DECLARE @RESULT INT

	BEGIN TRY
		BEGIN TRAN InsertarCargaMasivaActas
	
		--> DECLARACION DE VARIABLES 
		DECLARE @RESPUETA_MENSAJE	NVARCHAR(MAX);
		DECLARE @NOMBRE_TABLA_TEMPORAL VARCHAR(100) = '#tmpCargaMasivaActaDetalle';
		DECLARE @FECHA_ACTUAL DATETIME = GETDATE();
		DECLARE @ID_CARGA_MASIVA_PERSONA INT;
		
		--> PROCESANDO INSERT INTO POR SEGURIDAD 	
		SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'[INICIO]','INSERT INTO ' + @NOMBRE_TABLA_TEMPORAL + ' VALUES ('));
		SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'','INSERT INTO'));
		SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'[FIN]',')'));
		
		BEGIN --> CREAR TABLA TEMPORAL 
			CREATE TABLE #tmpCargaMasivaActaDetalle
			( 	
				NRO INT,
				ID_TIPO_DOCUMENTO INT,
				NUMERO_DOCUMENTO VARCHAR(20),
				NOMBRE_UNIDAD_DIDACTICA VARCHAR(150),
				NOTA VARCHAR(3)
			)
		END
		PRINT 'Llenar tabla #tmpCargaMasivaActaDetalle'
		EXECUTE (@QUERY_EXCEL);

		IF EXISTS (SELECT TOP 1 ID_CARGA_MASIVA_ACTA FROM transaccional.carga_masiva_actas WHERE ID_CARGA_MASIVA_NOMINA = @ID_CARGA_MASIVA_NOMINA AND ES_ACTIVO=1)
			SET @RESULT= -180
		ELSE IF NOT EXISTS (SELECT TOP 1 ID_CARGA_MASIVA_NOMINA FROM transaccional.carga_masiva_nominas WHERE ID_CARGA_MASIVA_NOMINA = @ID_CARGA_MASIVA_NOMINA AND ES_ACTIVO=1)
			SET @RESULT= -384
		ELSE
		BEGIN
			BEGIN
				PRINT 'INSERT transaccional.carga_masiva_actas'
				INSERT INTO transaccional.carga_masiva_actas
						( ID_CARGA_MASIVA_NOMINA ,
						  ES_ACTIVO ,
						  ESTADO ,
						  USUARIO_CREACION ,
						  FECHA_CREACION
						)
				VALUES  ( @ID_CARGA_MASIVA_NOMINA ,
						  1 ,
						  1 , 
						  @USUARIO_CREACION,
						  @FECHA_ACTUAL
						)

				PRINT 'UPDATE transaccional.carga_masiva_nominas_detalle'
				BEGIN
					DECLARE @I INT = 1
					DECLARE @CANT INT = (SELECT COUNT(1) FROM #tmpCargaMasivaActaDetalle)
					DECLARE @ID_TIPO_DOCUMENTO INT, @NUMERO_DOCUMENTO VARCHAR(20), @NOMBRE_UNIDAD_DIDACTICA VARCHAR(150), @NOTA VARCHAR(3) 

					WHILE(@I <= @CANT)
					BEGIN
						PRINT 'Insertar detalle: Obteniendo ID_TIPO_DOCUMENTO,NUMERO_DOCUMENTO'
						SELECT @ID_TIPO_DOCUMENTO = ID_TIPO_DOCUMENTO, @NUMERO_DOCUMENTO = NUMERO_DOCUMENTO, @NOMBRE_UNIDAD_DIDACTICA = NOMBRE_UNIDAD_DIDACTICA, @NOTA = NOTA
						FROM #tmpCargaMasivaActaDetalle WHERE NRO = @I

						PRINT CAST(@ID_TIPO_DOCUMENTO AS VARCHAR(20)) + ' - ' + CAST(@NUMERO_DOCUMENTO AS VARCHAR(20)) + ' - ' + @NOMBRE_UNIDAD_DIDACTICA

						-->OBTENER PERSONA
						SET @ID_CARGA_MASIVA_PERSONA = (SELECT TOP 1 ID_CARGA_MASIVA_PERSONA FROM transaccional.carga_masiva_nominas_persona 
														WHERE ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO AND NUMERO_DOCUMENTO = @NUMERO_DOCUMENTO AND ES_ACTIVO = 1)
					
						PRINT CAST(@ID_CARGA_MASIVA_PERSONA AS VARCHAR(20))

						-->ACTUALIZA NOTA
						PRINT 'UPDATE transaccional.carga_masiva_nominas_detalle'

						UPDATE cmnd SET cmnd.NOTA = (CASE @NOTA WHEN '' THEN 99 ELSE @NOTA END) --@NOTA
						FROM transaccional.carga_masiva_nominas_detalle cmnd
						WHERE ES_ACTIVO = 1
							AND ID_CARGA_MASIVA_NOMINA = @ID_CARGA_MASIVA_NOMINA 
							AND ID_CARGA_MASIVA_PERSONA = @ID_CARGA_MASIVA_PERSONA
							AND UPPER(NOMBRE_UNIDAD_DIDACTICA) = UPPER(@NOMBRE_UNIDAD_DIDACTICA)
				
						SET @I = @I + 1;
					END
				END
			END
	
			SET @RESULT= 1
		END

		BEGIN --> ELIMINAR TABLA TEMPORAL 
			DROP TABLE #tmpCargaMasivaActaDetalle
		END
		
		BEGIN --> RESPUESTA FINAL 
	
			IF @RESULT = 1 
			BEGIN

				SET @RESPUETA_MENSAJE = 'El archivo excel se registró correctamente.'										
				SELECT EstadoProceso = '1' ,Mensajes = @RESPUETA_MENSAJE																											
			END
			ELSE IF @RESULT = -384
			BEGIN
				SET @RESPUETA_MENSAJE = 'No se pudo realizar la carga. No se encontró la nómina correspondiente. Verifique la información.'								
				SELECT EstadoProceso = '2', Mensajes = @RESPUETA_MENSAJE

			END
			ELSE  IF @RESULT = -180
			BEGIN
				SET @RESPUETA_MENSAJE = 'El acta no se puede registrar porque ya existe en el sistema.'								
				SELECT EstadoProceso = '3', Mensajes = @RESPUETA_MENSAJE

			END
		END
   
		COMMIT TRAN InsertarCargaMasivaActas
	END	TRY
	BEGIN CATCH
	
		Begin --> RESPUESTA EN EL CASO DE QUE SE GENERE ERROR 

		SELECT 
			EstadoProceso = '0'
			,Mensajes = @RESPUETA_MENSAJE
			--,LineaError = @LINEA_ERROR

			--PRUEBAS
			,ERROR_MESSAGE() AS 'ERROR_MESSAGE'
			,CAST(ERROR_LINE() AS VARCHAR(100)) AS 'ERROR_LINE'

			--,INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO			= @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO
			--,INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO	= @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO
			--,INDEX_REGISTRADOS_CONSOLIDADOS_CERO			= @INDEX_REGISTRADOS_CONSOLIDADOS_CERO

			,CAST(ERROR_NUMBER() AS VARCHAR(MAX)) AS 'ERROR_NUMBER'
			,CAST( ERROR_SEVERITY() AS VARCHAR(MAX)) AS 'ERROR_SEVERITY'
			,CAST(ERROR_STATE() AS VARCHAR(MAX))AS 'ERROR_STATE'
			,ERROR_PROCEDURE() AS 'ERROR_PROCEDURE'
			--,ERROR_LINE() AS 'ERROR_LINE'
			--,ERROR_MESSAGE() AS 'ERROR_MESSAGE' 

		ROLLBACK TRAN InsertarCargaMasivaActas

		End

	END CATCH
END