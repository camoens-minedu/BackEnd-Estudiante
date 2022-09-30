/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2018
LLAMADO POR			:
DESCRIPCION			:	Realizar el cierre del periodo lectivo
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2018		JTOVAR			Creación
1.1			30/03/2021		JCHAVEZ			Modificación, se agregó validación de programación de clases activos
1.2			07/01/2022		JCHAVEZ			Modificación en creación de tabla #temporal01 para mostrar evaluaciones que no tienen detalle
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_CIERRE_EVALUACION_POR_PERIODO_LECTIVO](  
 @ID_INSTITUCION INT,  
 @ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT,  
 @ID_PERIODO_ACADEMICO INT,  
 @USUARIO VARCHAR(20)  
  
 --DECLARE @ID_INSTITUCION INT=2371  
 --DECLARE @ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT=818  
 --DECLARE @ID_PERIODO_ACADEMICO INT=396  
 --DECLARE @USUARIO VARCHAR(20)='42122536'  
 )  
AS  
BEGIN  
  
	DECLARE @RESULT INT  
	BEGIN --> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS   
		IF (OBJECT_ID('tempdb.dbo.#temporal00','U')) IS NOT NULL DROP TABLE #temporal00  
		IF (OBJECT_ID('tempdb.dbo.#temporal01','U')) IS NOT NULL DROP TABLE #temporal01  
		IF (OBJECT_ID('tempdb.dbo.#temporal02','U')) IS NOT NULL DROP TABLE #temporal02  
		----  
	END  
	BEGIN  
  
		DECLARE @CANTIDAD_CLASES_A_EVALUAR INT , @CANTIDAD_CLASES_EVALUADAS INT 
 
		SET @CANTIDAD_CLASES_A_EVALUAR = (
			SELECT COUNT( DISTINCT PCXME.ID_PROGRAMACION_CLASE)  
			FROM transaccional.programacion_clase_por_matricula_estudiante PCXME   
			INNER JOIN transaccional.matricula_estudiante ME ON ME.ID_MATRICULA_ESTUDIANTE= PCXME.ID_MATRICULA_ESTUDIANTE INNER JOIN transaccional.programacion_clase pclase ON PCXME.ID_PROGRAMACION_CLASE = pclase.ID_PROGRAMACION_CLASE   
			AND pclase.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO  
			AND ME.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION  
			AND PCXME.ES_ACTIVO=1 AND ME.ES_ACTIVO=1 AND pclase.ES_ACTIVO = 1
			)  
	END  
  
	BEGIN --> OBTENER CANTIDAD DE ALUMNOS MATRICULAS EN UN PROGRAMA DE CLASE  
		PRINT ''  
  
		DECLARE @CANTIDAD_ALUMNOS_MATRICULADOS INT = 0  
  
		SET @CANTIDAD_ALUMNOS_MATRICULADOS = (  
			SELECT COUNT(pc.ID_PROGRAMACION_CLASE)   
			FROM transaccional.programacion_clase pc   
			INNER JOIN transaccional.programacion_clase_por_matricula_estudiante cpme ON pc.ID_PROGRAMACION_CLASE = cpme.ID_PROGRAMACION_CLASE  
			WHERE 1 = 1  
			AND pc.ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO   
			AND pc.ES_ACTIVO = 1   
			AND cpme.ES_ACTIVO = 1  
			)  
	END
  
	BEGIN --> OBTIENE LA PROGRAMACION POR PERIODO LECTIVO  
	PRINT ''  
		SELECT   
			A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,  
			A.ID_PERIODO_ACADEMICO,  
			A.NOMBRE_PERIODO_ACADEMICO,  
			D.ID_INSTITUCION,  
			B.ID_SEDE_INSTITUCION,     
			B.ESTADO--,      
		INTO #temporal00  
		FROM transaccional.periodo_academico A  
		   INNER JOIN transaccional.programacion_clase B ON A.ID_PERIODO_ACADEMICO=B.ID_PERIODO_ACADEMICO AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1  
		   INNER JOIN maestro.sede_institucion D   ON B.ID_SEDE_INSTITUCION=D.ID_SEDE_INSTITUCION  AND D.ES_ACTIVO=1   
		WHERE  
		   A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION   
		   AND A.ID_PERIODO_ACADEMICO=  @ID_PERIODO_ACADEMICO  
		   AND ID_INSTITUCION= @ID_INSTITUCION   
	END  
   
	BEGIN --> OBTIENE LA EVALUACIONES POR PERIODO LECTIVO  
	
		SELECT  
		   A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,  
		   A.ID_PERIODO_ACADEMICO,  
		   A.NOMBRE_PERIODO_ACADEMICO,  
		   D.ID_INSTITUCION,  
		   B.ID_SEDE_INSTITUCION,  
		   C.ID_PROGRAMACION_CLASE,   
		   B.ESTADO,   
		   ISNULL(CIERRE_PROGRAMACION,0) AS CIERRE_PROGRAMACION  
		INTO #temporal01  
		FROM transaccional.periodo_academico A  
		   INNER JOIN transaccional.programacion_clase B ON A.ID_PERIODO_ACADEMICO=B.ID_PERIODO_ACADEMICO AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1     
		   INNER JOIN transaccional.evaluacion C   ON B.ID_PROGRAMACION_CLASE=C.ID_PROGRAMACION_CLASE AND C.ES_ACTIVO=1 --JTOVAR        
		   --INNER JOIN transaccional.evaluacion_detalle ED ON ED.ID_EVALUACION = C.ID_EVALUACION AND ED.ES_ACTIVO=1
		   LEFT JOIN transaccional.evaluacion_detalle ED ON ED.ID_EVALUACION = C.ID_EVALUACION AND ED.ES_ACTIVO=1 --versión 1.2
		   INNER JOIN maestro.sede_institucion D   ON B.ID_SEDE_INSTITUCION=D.ID_SEDE_INSTITUCION  AND D.ES_ACTIVO=1   
		WHERE  
			A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION   
			AND A.ID_PERIODO_ACADEMICO=  @ID_PERIODO_ACADEMICO  
			AND ID_INSTITUCION= @ID_INSTITUCION    
	END  
  
	BEGIN --> OBTIENE LAS PROMOCIONES POR INSTITUCION  
  
		SELECT   
			piest.ID_INSTITUCION,  
			piest.ID_PROMOCION_INSTITUCION_ESTUDIANTE          IdPromocionInstitucionEstudiante,  
			enu.ID_ENUMERADO                                   IdTipoPromocion,  
			enu.VALOR_ENUMERADO                                TipoPromocion,  
			enumerado.ID_ENUMERADO                             IdVersionItinerario,  
			enumerado.VALOR_ENUMERADO                          VersionItinerario,  
			tud.ID_TIPO_UNIDAD_DIDACTICA                       IdTipoUnidadDidactica,  
			tud.NOMBRE_TIPO_UNIDAD                             TipoUD,  
			enumera.ID_ENUMERADO                               IdCriterio,  
			enumera.VALOR_ENUMERADO                            Criterio,  
			piest.VALOR                                        VALOR  
		INTO #temporal02      
		FROM transaccional.promocion_institucion_estudiante piest INNER JOIN sistema.enumerado enu  
		ON piest.TIPO_PROMOCION = enu.ID_ENUMERADO INNER JOIN sistema.enumerado enumerado  
		ON piest.TIPO_VERSION = enumerado.ID_ENUMERADO INNER JOIN maestro.tipo_unidad_didactica tud  
		ON piest.ID_TIPO_UNIDAD_DIDACTICA = tud.ID_TIPO_UNIDAD_DIDACTICA INNER JOIN sistema.enumerado enumera  
		ON piest.CRITERIO = enumera.ID_ENUMERADO  
		WHERE   
			piest.ID_INSTITUCION = @ID_INSTITUCION  
			AND piest.ES_ACTIVO = 1  
			AND piest.ESTADO=1  -- rfc-13
	END  
  
	SET @CANTIDAD_CLASES_EVALUADAS  =(select count(DISTINCT(ID_PROGRAMACION_CLASE)) FROM  #temporal01)  
     
	IF NOT EXISTS(SELECT * FROM #temporal00)  
	BEGIN  
		--NO HAY PROGRAMACIONES  
		SET @RESULT = -3 --No hay programación para el periodo lectivo seleccionado  
	END  
	ELSE BEGIN      
		IF @CANTIDAD_ALUMNOS_MATRICULADOS = 0  
		BEGIN  
			PRINT ''         
			SET @RESULT = -5  
		END  
		ELSE BEGIN      
			--IF (SELECT SUM(CIERRE_PROGRAMACION) FROM #temporal01) = 0 OR EXISTS (SELECT CIERRE_PROGRAMACION FROM #temporal01 WHERE CIERRE_PROGRAMACION=234) JTOVAR  
			IF EXISTS(SELECT TOP 1 CIERRE_PROGRAMACION FROM #temporal01 WHERE CIERRE_PROGRAMACION=234) OR EXISTS (SELECT CIERRE_PROGRAMACION FROM #temporal01 WHERE CIERRE_PROGRAMACION=0) OR NOT EXISTS (SELECT CIERRE_PROGRAMACION FROM #temporal01 WHERE CIERRE_PROGRAMACION is not NULL)       
			OR @CANTIDAD_CLASES_EVALUADAS <> @CANTIDAD_CLASES_A_EVALUAR  
			BEGIN  
				SET @RESULT = -1 --Falta cerrar programación de unidades  
			END  
			ELSE  
			BEGIN  
				IF EXISTS(SELECT * FROM #temporal01 WHERE CIERRE_PROGRAMACION=1 AND ESTADO=1)  
				BEGIN           
					--YA EXISTE PROGRAMACION CERRADO  
					SET @RESULT = -2 --El periodo lectivo ya está cerrado  
				END  
				ELSE BEGIN  
					IF NOT EXISTS(SELECT * FROM #temporal02)  
					BEGIN  
						SET @RESULT = -4 --No existe registro de promoción en el instituto  
					END  
					ELSE BEGIN              
						UPDATE transaccional.programacion_clase  
						SET ESTADO=0,  
						USUARIO_MODIFICACION= @USUARIO,  
						FECHA_MODIFICACION=GETDATE()              
						FROM transaccional.periodo_academico A  
						INNER JOIN transaccional.programacion_clase B ON A.ID_PERIODO_ACADEMICO=B.ID_PERIODO_ACADEMICO  AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1  
						INNER JOIN transaccional.evaluacion C   ON B.ID_PROGRAMACION_CLASE=C.ID_PROGRAMACION_CLASE AND C.ES_ACTIVO=1  
						WHERE  
						A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION   
						AND A.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO  
						print 'actualización promoción del alumno:' + convert(varchar,@ID_INSTITUCION ) + ' - ' +  
						convert (varchar, @ID_PERIODOS_LECTIVOS_POR_INSTITUCION)   
						--STORE: ACTUALIZA PROMOCION DEL ALUMNO  
						EXEC dbo.USP_EVALUACION_UPD_PROMOCION_POR_ALUMNO @ID_INSTITUCION,@ID_PERIODOS_LECTIVOS_POR_INSTITUCION,@USUARIO  
						EXEC dbo.USP_EVALUACION_INS_PERIODOS_CLASES_CERRADOS @ID_PERIODO_ACADEMICO,@USUARIO  --jtovar  
  
						SET @RESULT = 1  
					END  
				END  
			END  
		END  
	END  
     
	SELECT @RESULT  
  
	BEGIN  --> DESCOMENTAR PARA PRUEBAS  
		PRINT ''  
		--SELECT @CANTIDAD_ALUMNOS_MATRICULADOS AS '@CANTIDAD_ALUMNOS_MATRICULADOS'  
		--SELECT * FROM #temporal00  
		--SELECT * FROM #temporal01  
		--SELECT * FROM #temporal02  
		--SELECT @RESULT AS '@RESULT'  
	END  
END
GO


