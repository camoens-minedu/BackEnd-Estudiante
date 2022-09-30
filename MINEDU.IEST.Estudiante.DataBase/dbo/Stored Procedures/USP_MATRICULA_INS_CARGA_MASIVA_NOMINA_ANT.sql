-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			JUAN TOVAR Y.
--  CREACION:		06/03/2021
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	CREACION CARGA MASIVA NOMINA
-----------------------------------------------------------------------------------------------------------
--	VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_MATRICULA_INS_CARGA_MASIVA_NOMINA_ANT]
(	
	@QUERY_EXCEL NVARCHAR(MAX),	
	--//
	@ID_INSTITUCION			INT,	
    @USUARIO_CREACION		NVARCHAR(20)	
)
AS
DECLARE @RESULT INT
BEGIN TRY
	BEGIN TRAN InsertarPlanEstudios
	
	Begin --> DECLARACION DE VARIABLES 
		DECLARE @RESPUETA_MENSAJE	NVARCHAR(MAX);
		DECLARE @NOMBRE_TABLA_TEMPORAL VARCHAR(10) = '#tmp';
		--*************************************
		--*************************************
		DECLARE @ID_CARGA_MASIVA_NOMINAS_CABECERA INT;			
		DECLARE @CARRERA VARCHAR(400);
		DECLARE @PERIODO_ACADEMICO VARCHAR(400);
		DECLARE @CICLO VARCHAR(400);
		DECLARE @NOMBRE_SEDE VARCHAR(400);
		DECLARE @TURNO VARCHAR(400);
		DECLARE @PLAN_ESTUDIO VARCHAR(400);
		DECLARE @SECCION VARCHAR(400);
		DECLARE @CANTIDAD_ALUMNOS VARCHAR(400);		
		--*************************************
		DECLARE @PERIODO_LECTIVO VARCHAR(400);
		DECLARE @DRE_GRE VARCHAR(400);
		DECLARE @NOMBRE_IEST VARCHAR(400);
		DECLARE @DEPARTAMENTO VARCHAR(400);
		DECLARE @PROVINCIA VARCHAR(400);
		DECLARE @DISTRITO VARCHAR(400);
		DECLARE @CENTRO_POBLADO VARCHAR(400);
		DECLARE @NIVEL_FORMATIVO VARCHAR(400);
		DECLARE @DIRECCION_IESTP VARCHAR(400);
		DECLARE @NUMERO_CODIGO_MODULAR VARCHAR(400);
		DECLARE @TIPO_GESTION VARCHAR(400);
		--*************************************
		DECLARE @UNIDAD_DIDACTICA_1 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_2 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_3 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_4 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_5 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_6 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_7 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_8 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_9 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_10 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_11 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_12 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_13 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_14 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_15 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_16 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_17 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_18 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_19 VARCHAR(400);
		DECLARE @UNIDAD_DIDACTICA_20 VARCHAR(400);
	End	

	Begin --> DECLARACION DE VARIABLES DE TABLA 
		DECLARE @Carga_masiva_nominas_cabecera_tmp TABLE (ID_CARGA_MASIVA_NOMINAS_CABECERA INT)
	End
		
	Begin --> PROCESANDO INSERT INTO POR SEGURIDAD 	
		SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'[INICIO]','INSERT INTO ' + @NOMBRE_TABLA_TEMPORAL + ' VALUES ('));
		SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'','INSERT INTO'));
		SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'[FIN]',')'));
	End
		
	Begin --> CREAR TABLA TEMPORAL 
		CREATE TABLE
		#tmp
		( 		
			A NVARCHAR(400),
			B NVARCHAR(400),
			C NVARCHAR(400),
			D NVARCHAR(400),
			E NVARCHAR(400),
			F NVARCHAR(400),
			G NVARCHAR(400),
			H NVARCHAR(400),
			I NVARCHAR(400),
			J NVARCHAR(400),
			K NVARCHAR(400),
			L NVARCHAR(400),
			M NVARCHAR(400),
			N NVARCHAR(400),
			O NVARCHAR(400),
			P NVARCHAR(400),
			Q NVARCHAR(400),
			R NVARCHAR(400),
			S NVARCHAR(400),
			T NVARCHAR(400),
			U NVARCHAR(400),
			V NVARCHAR(400),
			W NVARCHAR(400),
			X NVARCHAR(400),
			Y NVARCHAR(400),
			Z NVARCHAR(400),
			AA NVARCHAR(400),

			rowIndex NVARCHAR(400)	
		)
	End
		
	Begin --> INSERTAR EXCEL A TABLA TEMPORAL 
		--IF 1 = 0 SELECT 1 --Para que no se caiga el Begin End
		EXECUTE (@QUERY_EXCEL);
	End
	
	Begin --> CONSULTAR TABLA TEMPORAL SI ESTA LLENA 
		--SELECT * FROM #tmp
		IF 1 = 0 SELECT 1 --Para que no se caiga el Begin End
	End

	Begin --> OBTENER DATOS CABECERA 
		SET @CARRERA = (SELECT G FROM #tmp WHERE rowIndex = '8')		
		SET @PERIODO_ACADEMICO = (SELECT G FROM #tmp WHERE rowIndex = '10')
		SET @CICLO = (SELECT G FROM #tmp WHERE rowIndex = '11')
		SET @NOMBRE_SEDE = (SELECT C FROM #tmp WHERE rowIndex = '12')
		SET @TURNO = (SELECT G FROM #tmp WHERE rowIndex = '12')
		SET @PLAN_ESTUDIO = (SELECT M FROM #tmp WHERE rowIndex = '12')
		SET @SECCION = (SELECT M FROM #tmp WHERE rowIndex = '13')		
		--*************************************
		SET @PERIODO_LECTIVO = (SELECT G FROM #tmp WHERE rowIndex = '5')
		SET @DRE_GRE = (SELECT C FROM #tmp WHERE rowIndex = '7')
		SET @NOMBRE_IEST = (SELECT G FROM #tmp WHERE rowIndex = '7')
		SET @DEPARTAMENTO = (SELECT C FROM #tmp WHERE rowIndex = '8')
		SET @PROVINCIA = (SELECT C FROM #tmp WHERE rowIndex = '9')
		SET @DISTRITO = (SELECT C FROM #tmp WHERE rowIndex = '10')
		SET @CENTRO_POBLADO = (SELECT C FROM #tmp WHERE rowIndex = '11')
		SET @NIVEL_FORMATIVO = (SELECT G FROM #tmp WHERE rowIndex = '9')
		SET @DIRECCION_IESTP = (SELECT C FROM #tmp WHERE rowIndex = '13')
		SET @NUMERO_CODIGO_MODULAR = (SELECT C FROM #tmp WHERE rowIndex = '14')
		SET @TIPO_GESTION = (SELECT J FROM #tmp WHERE rowIndex = '14')
	End

	IF EXISTS (SELECT TOP 1 ID_CARGA_MASIVA_NOMINAS_CABECERA FROM transaccional.carga_masiva_nominas_cabecera 
			   WHERE CARRERA = @CARRERA AND CICLO = @CICLO AND TURNO = @TURNO AND NOMBRE_SEDE = @NOMBRE_SEDE AND NOMBRE_IEST = @NOMBRE_IEST AND PERIODO_ACADEMICO = @PERIODO_ACADEMICO AND PERIODO_LECTIVO = @PERIODO_LECTIVO AND ES_ACTIVO=1)
		
		SET @RESULT= -180
		
	ELSE
	BEGIN


				Begin --> OBTENER UNIDADES DIDACTICAS 
		SELECT
		@UNIDAD_DIDACTICA_1  = H,
		@UNIDAD_DIDACTICA_2  = I,
		@UNIDAD_DIDACTICA_3  = J,
		@UNIDAD_DIDACTICA_4  = K,
		@UNIDAD_DIDACTICA_5  = L,
		@UNIDAD_DIDACTICA_6  = M,
		@UNIDAD_DIDACTICA_7  = N,
		@UNIDAD_DIDACTICA_8  = O,
		@UNIDAD_DIDACTICA_9  = P,
		@UNIDAD_DIDACTICA_10 = Q,
		@UNIDAD_DIDACTICA_11 = R,
		@UNIDAD_DIDACTICA_12 = S,
		@UNIDAD_DIDACTICA_13 = T,
		@UNIDAD_DIDACTICA_14 = U,
		@UNIDAD_DIDACTICA_15 = V,
		@UNIDAD_DIDACTICA_16 = W,
		@UNIDAD_DIDACTICA_17 = X,
		@UNIDAD_DIDACTICA_18 = Y,
		@UNIDAD_DIDACTICA_19 = Z,
		@UNIDAD_DIDACTICA_20 = AA
		FROM #tmp
		WHERE rowIndex = 17		
	End

				Begin --> OBTENER CANTIDAD DE MATRICULADOS 
		SET @CANTIDAD_ALUMNOS = (SELECT COUNT(*) FROM #tmp WHERE rowIndex > 17 AND A <> '' AND B <> '' AND C <> '' AND E <> '' AND F <> '' AND G <> '');
	End
	
	--*******************************************************************************************************************************************************************************************************************	

				Begin --> INSERTAR CABECERA 

		INSERT INTO transaccional.carga_masiva_nominas_cabecera 
		(									
			CARRERA,
			PERIODO_ACADEMICO,
			CICLO,
			NOMBRE_SEDE,
			TURNO,
			PLAN_ESTUDIO,
			SECCION,
			CANTIDAD_ALUMNOS,	

			PERIODO_LECTIVO,
			DRE_GRE,
			NOMBRE_IEST,
			DEPARTAMENTO,
			PROVINCIA,
			DISTRITO,
			CENTRO_POBLADO,
			NIVEL_FORMATIVO,
			DIRECCION_IESTP,
			NUMERO_CODIGO_MODULAR,
			TIPO_GESTION,

			ES_ACTIVO,
			ESTADO,
			USUARIO_CREACION,
			FECHA_CREACION,									
			FECHA_MATRICULA									
		)

		OUTPUT INSERTED.ID_CARGA_MASIVA_NOMINAS_CABECERA INTO @Carga_masiva_nominas_cabecera_tmp(ID_CARGA_MASIVA_NOMINAS_CABECERA)

		VALUES
		(									
			@CARRERA,
			@PERIODO_ACADEMICO,
			@CICLO,
			@NOMBRE_SEDE,
			@TURNO,
			@PLAN_ESTUDIO,
			@SECCION,
			@CANTIDAD_ALUMNOS,	

			@PERIODO_LECTIVO,
			@DRE_GRE,
			@NOMBRE_IEST,
			@DEPARTAMENTO,
			@PROVINCIA,
			@DISTRITO,
			@CENTRO_POBLADO,
			@NIVEL_FORMATIVO,
			@DIRECCION_IESTP,
			@NUMERO_CODIGO_MODULAR,
			@TIPO_GESTION,

			1,
			1,
			@USUARIO_CREACION,
			GETDATE(),									
			GETDATE()									
		)

	End	

				Begin --> REGISTRAR ID NUEVO REGISTRO 
		SET @ID_CARGA_MASIVA_NOMINAS_CABECERA = (SELECT ID_CARGA_MASIVA_NOMINAS_CABECERA as 'ID_CARGA_MASIVA_NOMINAS_CABECERA recien registrado' FROM @Carga_masiva_nominas_cabecera_tmp);		
	End

				Begin --> INSERTAR DETALLES 
		INSERT INTO transaccional.carga_masiva_nominas_cabecera_detalle
		SELECT
			@ID_CARGA_MASIVA_NOMINAS_CABECERA,
			A,B,C,E,F,G,			
			CASE WHEN H <> '' THEN @UNIDAD_DIDACTICA_1 Else ''	END,
			CASE WHEN I <> '' THEN @UNIDAD_DIDACTICA_2 Else ''	END,
			CASE WHEN J <> '' THEN @UNIDAD_DIDACTICA_3 Else ''	END,
			CASE WHEN K <> '' THEN @UNIDAD_DIDACTICA_4 Else ''	END,
			CASE WHEN L <> '' THEN @UNIDAD_DIDACTICA_5 Else ''	END,
			CASE WHEN M <> '' THEN @UNIDAD_DIDACTICA_6 Else ''	END,
			CASE WHEN N <> '' THEN @UNIDAD_DIDACTICA_7 Else ''	END,
			CASE WHEN O <> '' THEN @UNIDAD_DIDACTICA_8 Else ''	END,
			CASE WHEN P <> '' THEN @UNIDAD_DIDACTICA_9 Else ''	END,
			CASE WHEN Q <> '' THEN @UNIDAD_DIDACTICA_10 Else ''	END,
			CASE WHEN R <> '' THEN @UNIDAD_DIDACTICA_11 Else ''	END,
			CASE WHEN S <> '' THEN @UNIDAD_DIDACTICA_12 Else ''	END,
			CASE WHEN T <> '' THEN @UNIDAD_DIDACTICA_13 Else ''	END,
			CASE WHEN U <> '' THEN @UNIDAD_DIDACTICA_14 Else ''	END,
			CASE WHEN V <> '' THEN @UNIDAD_DIDACTICA_15 Else ''	END,
			CASE WHEN W <> '' THEN @UNIDAD_DIDACTICA_16 Else ''	END,
			CASE WHEN X <> '' THEN @UNIDAD_DIDACTICA_17 Else ''	END,
			CASE WHEN Y <> '' THEN @UNIDAD_DIDACTICA_18 Else ''	END,
			CASE WHEN Z <> '' THEN @UNIDAD_DIDACTICA_19 Else ''	END,
			CASE WHEN AA <> '' THEN @UNIDAD_DIDACTICA_20 Else '' END,
			'1',
			'1',
			@USUARIO_CREACION,
			GETDATE(),
			NULL,
			NULL			 
		FROM #tmp WHERE rowIndex > 17 AND A <> '' AND B <> '' AND C <> '' AND E <> '' AND F <> '' AND G <> '' ORDER BY rowIndex ASC;
	End

	--*******************************************************************************************************************************************************************************************************************
	
	SET @RESULT= 1
	END

	Begin --> ELIMINAR TABLA TEMPORAL 
		DROP TABLE #tmp
		--IF 1 = 0 SELECT 1 --Para que no se caiga el Begin End
	End
		
	Begin --> RESPUESTA FINAL 
	
		IF @RESULT = 1 
			BEGIN

			SET @RESPUETA_MENSAJE = 'El archivo excel se registró correctamente.'
			
			--if @RESPUETA_MENSAJE ='' 			
			--set @RESPUETA_MENSAJE = 'El archivo excel se registró correctamente. No se encontraron observaciones.'			
										
			SELECT 
				EstadoProceso = '1'
				,Mensajes = @RESPUETA_MENSAJE																											


			--//VISOR DE MENSAJES SOLO PARA PRUEBA DESCOMENTAR.
			--SELECT SplitData AS 'Lista de Mensajes'  FROM dbo.UFN_SPLIT(@RESPUETA_MENSAJE,'|');
        END
		ELSE
		BEGIN

			SET @RESPUETA_MENSAJE = 'La nómina no se puede registrar porque ya existe en el sistema.'								
			SELECT 
				EstadoProceso = '3'
				,Mensajes = @RESPUETA_MENSAJE

		END
	End

	COMMIT TRAN InsertarPlanEstudios
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

	ROLLBACK TRAN InsertarPlanEstudios

	End

END CATCH