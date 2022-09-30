/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de estudiantes por periodo lectivo institucion.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 06/01/2020		MALVA           MODIFICACIÓN SE OBTIENEN LAS COLUMNAS TipoPlanEstudios,IdPlanEstudios y PlanEstudios. 
--	1.1		 07/01/2020		MALVA           MODIFICACIÓN SE AÑADE PARÁMETRO @ID_PLAN_ESTUDIO.
--  1.2		 18/06/2020		MALVA			OBTENCIÓN DE LA COLUMNA Condicion, modificación de columna. Adición parámetro @ID_ESTUDIANTE_INSTITUCION.
--  TEST:			
/*
	USP_MATRICULA_SEL_ESTUDIANTE_PAGINADO 3574, 0, '', '', 0, 0, 0, 0, 262, 0
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_ESTUDIANTE]
(  
	@ID_INSTITUCION					INT,
	@ID_TIPO_DOCUMENTO				INT,
	@NUMERO_DOCUMENTO_PERSONA		VARCHAR(16),
	@ESTUDIANTE						VARCHAR(150),
	@ID_SEDE_INSTITUCION			INT,	
	@ID_CARRERA						INT,
	@ID_TIPO_ITINERARIO				INT,
	@ID_TURNOS_POR_INSTITUCION		INT,
	@ID_PERIODO_LECTIVO_INSTITUCION	INT,
	@ID_PLAN_ESTUDIO				INT,  
	@Pagina							int = 1,
	@Registros						int = 10,
	@ID_ESTUDIANTE_INSTITUCION		INT = 0
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE @ESTADO_EN_TRASLADO INT =333, @ESTADO_TRASLADADO INT = 334, @ESTADO_EN_CONVALIDACION INT = 200
 DECLARE @TABLA table(ID_UNIDAD_DIDACTICA int, NOMBRE_UNIDAD_DIDACTICA varchar(max), NOTA int)
 
--BEGIN TRY
--DROP TABLE #DBRecovery
--DROP TABLE #DBRecovery1
--DROP TABLE #DBRecovery2
--END TRY
--SELECT 
--m.ID_MODULO,
--m.NOMBRE_MODULO

--FROM transaccional.estudiante_institucion eins INNER JOIN transaccional.carreras_por_institucion_detalle cinsd
--ON eins.ID_CARRERAS_POR_INSTITUCION_DETALLE = cinsd.ID_CARRERAS_POR_INSTITUCION_DETALLE INNER JOIN transaccional.carreras_por_institucion cins
--ON cinsd.ID_CARRERAS_POR_INSTITUCION = cins.ID_CARRERAS_POR_INSTITUCION INNER JOIN transaccional.plan_estudio pestudio
--ON cins.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION INNER JOIN transaccional.modulo m
--ON pestudio.ID_PLAN_ESTUDIO = m.ID_PLAN_ESTUDIO

--WHERE eins.ES_ACTIVO=1 AND cinsd.ES_ACTIVO=1 AND cins.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1 AND m.ES_ACTIVO=1 AND eins.ID_ESTUDIANTE_INSTITUCION=136834 AND cins.ID_CARRERAS_POR_INSTITUCION=2799
		--insert into @TABLA(ID_UNIDAD_DIDACTICA,NOMBRE_UNIDAD_DIDACTICA,NOTA)  
		SELECT 
		ud.ID_UNIDAD_DIDACTICA,
		ud.NOMBRE_UNIDAD_DIDACTICA,
		edet.NOTA,
		CASE 
         when edet.NOTA > 13 then 'Aprobado'
          else 'Desaprobado'
       end ESTADO
	   INTO #DBRecovery
		FROM transaccional.estudiante_institucion eins INNER JOIN transaccional.matricula_estudiante mestu
		ON eins.ID_ESTUDIANTE_INSTITUCION = mestu.ID_ESTUDIANTE_INSTITUCION 
		INNER JOIN transaccional.programacion_clase_por_matricula_estudiante pmestu
		ON mestu.ID_MATRICULA_ESTUDIANTE = pmestu.ID_MATRICULA_ESTUDIANTE 
		INNER JOIN transaccional.programacion_clase pclase
		ON pmestu.ID_PROGRAMACION_CLASE = pclase.ID_PROGRAMACION_CLASE 
		INNER JOIN transaccional.unidades_didacticas_por_programacion_clase udppclase
		ON pclase.ID_PROGRAMACION_CLASE = udppclase.ID_PROGRAMACION_CLASE 
		INNER JOIN transaccional.unidades_didacticas_por_enfoque udoe
		ON udppclase.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = udoe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE 
		INNER JOIN transaccional.unidad_didactica ud
		ON udoe.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA 
		INNER JOIN transaccional.evaluacion e
		ON pclase.ID_PROGRAMACION_CLASE = e.ID_PROGRAMACION_CLASE 
		INNER JOIN transaccional.evaluacion_detalle edet
		ON mestu.ID_MATRICULA_ESTUDIANTE = edet.ID_MATRICULA_ESTUDIANTE
		INNER JOIN transaccional.evaluacion eva
		ON edet.ID_EVALUACION = eva.ID_EVALUACION
		INNER JOIN transaccional.modulo m
		ON ud.ID_MODULO = m.ID_MODULO

		WHERE eins.ID_ESTUDIANTE_INSTITUCION=136834 AND m.ID_MODULO=27288 AND eins.ES_ACTIVO=1 AND mestu.ES_ACTIVO=1 
		AND pmestu.ES_ACTIVO=1 AND pclase.ES_ACTIVO=1 AND udppclase.ES_ACTIVO=1 AND udoe.ES_ACTIVO=1
		AND ud.ES_ACTIVO=1 AND e.ES_ACTIVO=1 AND edet.ES_ACTIVO=1 
		
		DECLARE @COUNT INT = (SELECT COUNT(*) FROM #DBRecovery)
			/*ver que unidades tiene el modulo*/
		SELECT ID_UNIDAD_DIDACTICA
		 INTO #DBRecovery1
		FROM transaccional.unidad_didactica 
		where ID_MODULO=27288
		SELECT ID_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA
		 INTO #DBRecovery2
		FROM transaccional.unidad_didactica_modulo_equivalencia 
		where ID_MODULO=27288

		DECLARE @COUNT1 INT = (SELECT COUNT(*) FROM #DBRecovery1)
		DECLARE @COUNT2 INT = (SELECT COUNT(*) FROM #DBRecovery2)


		IF (@COUNT = @COUNT1 + @COUNT2)
		BEGIN
		SELECT * FROM #DBRecovery

		PRINT 1
		END
		ELSE
		BEGIN
		SELECT * FROM #DBRecovery
		PRINT 2

		END

		--WHILE @COUNT > 0
		--BEGIN

		----DECLARE @ID_UNIDAD_DIDACTICA INT = (SELECT TOP(1) ID_UNIDAD_DIDACTICA FROM @TABLA ORDER BY ID_UNIDAD_DIDACTICA)


		--END


	


		END  

--******************************************************************************
--51. USP_MATRICULA_RPT_NOMINA_MATRICULA.sql