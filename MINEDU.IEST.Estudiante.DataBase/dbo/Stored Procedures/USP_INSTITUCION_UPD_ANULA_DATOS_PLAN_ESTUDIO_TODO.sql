/**********************************************************************************************************
AUTOR				:	Luis Espinoza
FECHA DE CREACION	:	24/01/2021
LLAMADO POR			:
DESCRIPCION			:	Anula un plan de estudio y sus datos relacionados: 
						estudiantes, matricula y evaluación y programación de clases 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			 24/01/2021		LESPINOZA		CREACIÓN

TEST:  
		USP_INSTITUCION_UPD_ANULA_DATOS_PLAN_ESTUDIO_TODO 306, 1235, 101,1135,3
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_UPD_ANULA_DATOS_PLAN_ESTUDIO_TODO]
(
	@ID_INSTITUCION				INT,
	@ID_PLAN_ESTUDIO			INT,	
	@USUARIO					VARCHAR(20)	
)
AS
BEGIN

	DECLARE @MSG_TRANS VARCHAR(MAX)
	DECLARE @fechaActual date
	set @fechaActual = GETDATE()

	BEGIN TRY

		BEGIN TRAN TransactSQL
			
			--EVALUACIONES
			---Anula la lista de evaluacion
			UPDATE transaccional.evaluacion
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.evaluacion t1,
			(
				SELECT DISTINCT ted.ID_EVALUACION
				from transaccional.evaluacion_detalle ted
				inner join transaccional.matricula_estudiante tmat on ted.ID_MATRICULA_ESTUDIANTE = tmat.ID_MATRICULA_ESTUDIANTE AND tmat.ES_ACTIVO = 1
				inner join transaccional.estudiante_institucion tehi on tmat.ID_ESTUDIANTE_INSTITUCION = tehi.ID_ESTUDIANTE_INSTITUCION AND tehi.ES_ACTIVO = 1
				inner join transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and plxi.ES_ACTIVO = 1
				inner join transaccional.carreras_por_institucion_detalle tcid ON tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tehi.ID_CARRERAS_POR_INSTITUCION_DETALLE 
				inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1		
				inner join transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = tehi.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO = 1
				where
					tci.ID_INSTITUCION = @ID_INSTITUCION
					AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
					AND ted.ES_ACTIVO = 1
			) tsel
			WHERE 
				t1.ID_EVALUACION = tsel.ID_EVALUACION
				and t1.ES_ACTIVO = 1

			---Anula la lista de detalle de evaluaciones
			UPDATE transaccional.evaluacion_detalle
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.evaluacion_detalle t1,
			(
				SELECT DISTINCT tmat.ID_MATRICULA_ESTUDIANTE
				from transaccional.evaluacion_detalle ted
				inner join transaccional.matricula_estudiante tmat on ted.ID_MATRICULA_ESTUDIANTE = tmat.ID_MATRICULA_ESTUDIANTE AND tmat.ES_ACTIVO = 1
				inner join transaccional.estudiante_institucion tehi on tmat.ID_ESTUDIANTE_INSTITUCION = tehi.ID_ESTUDIANTE_INSTITUCION AND tehi.ES_ACTIVO = 1
				inner join transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and plxi.ES_ACTIVO = 1
				inner join transaccional.carreras_por_institucion_detalle tcid ON tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tehi.ID_CARRERAS_POR_INSTITUCION_DETALLE AND tcid.ES_ACTIVO=1
				inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1		
				inner join transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = tehi.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO = 1
				where
					tci.ID_INSTITUCION = @ID_INSTITUCION
					AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
					AND ted.ES_ACTIVO = 1
			) tsel
			WHERE 
				t1.ID_MATRICULA_ESTUDIANTE = tsel.ID_MATRICULA_ESTUDIANTE
				and t1.ES_ACTIVO = 1	

			--MATRICULAS
			--Anula matriculas en unidades didácticas
			UPDATE transaccional.programacion_clase_por_matricula_estudiante
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.programacion_clase_por_matricula_estudiante t1,
			(
				SELECT DISTINCT tmat.ID_MATRICULA_ESTUDIANTE
				from transaccional.matricula_estudiante tmat
				inner JOIN transaccional.estudiante_institucion tehi on tmat.ID_ESTUDIANTE_INSTITUCION = tehi.ID_ESTUDIANTE_INSTITUCION AND tehi.ES_ACTIVO = 1
				inner join transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION =  tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and plxi.ES_ACTIVO = 1
				inner join transaccional.carreras_por_institucion_detalle tcid ON tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE= tehi.ID_CARRERAS_POR_INSTITUCION_DETALLE AND tcid.ES_ACTIVO=1
				inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1		
				inner join transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = tehi.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO = 1
				where
					tci.ID_INSTITUCION = @ID_INSTITUCION
					AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
					AND tmat.ES_ACTIVO = 1
			) tsel
			WHERE 
				t1.ID_MATRICULA_ESTUDIANTE = tsel.ID_MATRICULA_ESTUDIANTE
				and t1.ES_ACTIVO = 1

			---Anula la lista de matriculas
			UPDATE transaccional.matricula_estudiante
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.matricula_estudiante t1,
			(
				SELECT DISTINCT tehi.ID_ESTUDIANTE_INSTITUCION
				from transaccional.estudiante_institucion tehi
				inner join transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION =  tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and plxi.ES_ACTIVO = 1
				inner join transaccional.carreras_por_institucion_detalle tcid ON tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE= tehi.ID_CARRERAS_POR_INSTITUCION_DETALLE AND tcid.ES_ACTIVO=1
				inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1		
				inner join transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = tehi.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO = 1
				where
					tci.ID_INSTITUCION = @ID_INSTITUCION
					AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
					AND tehi.ES_ACTIVO = 1
			) tsel
			WHERE 
				t1.ID_ESTUDIANTE_INSTITUCION = tsel.ID_ESTUDIANTE_INSTITUCION
				and t1.ES_ACTIVO = 1

			--ESTUDIANTES
			---Anula la lista de estudiantes
			UPDATE transaccional.estudiante_institucion
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.estudiante_institucion t1,
			(
				SELECT DISTINCT tehi.ID_ESTUDIANTE_INSTITUCION
				from transaccional.estudiante_institucion tehi
				inner join transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION =  tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and plxi.ES_ACTIVO = 1
				inner join transaccional.carreras_por_institucion_detalle tcid ON tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE= tehi.ID_CARRERAS_POR_INSTITUCION_DETALLE AND tcid.ES_ACTIVO=1
				inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1		
				inner join transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = tehi.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO = 1
				where
					tci.ID_INSTITUCION = @ID_INSTITUCION
					AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
					AND tehi.ES_ACTIVO = 1

			) tsel
			WHERE 
				t1.ID_ESTUDIANTE_INSTITUCION = tsel.ID_ESTUDIANTE_INSTITUCION
			
			UPDATE t1
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.estudiante_institucion t1
			WHERE t1.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
				AND t1.ES_ACTIVO = 1

			UPDATE t1
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.situacion_academica_estudiante t1
			WHERE t1.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
				AND t1.ES_ACTIVO = 1

			--PROGRAMACIÓN DE CLASES
			SELECT DISTINCT tpc.ID_PROGRAMACION_CLASE INTO ##TmpProgClasesEliminar
			FROM transaccional.programacion_clase tpc
			INNER JOIN transaccional.periodo_academico tpa ON tpa.ID_PERIODO_ACADEMICO = tpc.ID_PERIODO_ACADEMICO AND tpa.ES_ACTIVO = 1
			INNER JOIN transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION =  tpa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and plxi.ES_ACTIVO = 1
			INNER JOIN transaccional.unidades_didacticas_por_programacion_clase tudpc ON tudpc.ID_PROGRAMACION_CLASE = tpc.ID_PROGRAMACION_CLASE AND tudpc.ES_ACTIVO = 1
			INNER JOIN transaccional.unidades_didacticas_por_enfoque tudxe ON tudxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND tudxe.ES_ACTIVO = 1
			INNER JOIN transaccional.unidad_didactica ud ON ud.ID_UNIDAD_DIDACTICA = tudxe.ID_UNIDAD_DIDACTICA AND ud.ES_ACTIVO = 1
			INNER JOIN transaccional.modulo m ON m.ID_MODULO = ud.ID_MODULO AND m.ES_ACTIVO = 1
			INNER JOIN transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = m.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO = 1
			WHERE
				plxi.ID_INSTITUCION = @ID_INSTITUCION
				AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
				AND tpc.ES_ACTIVO = 1

			---Anula las unidades didacticas de la programación de clases
			UPDATE transaccional.unidades_didacticas_por_programacion_clase
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.unidades_didacticas_por_programacion_clase t1,
			(
				SELECT DISTINCT tpc.ID_PROGRAMACION_CLASE
				from transaccional.programacion_clase tpc
				INNER JOIN transaccional.periodo_academico tpa ON tpa.ID_PERIODO_ACADEMICO = tpc.ID_PERIODO_ACADEMICO AND tpa.ES_ACTIVO = 1
				INNER JOIN transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION =  tpa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and plxi.ES_ACTIVO = 1
				INNER JOIN transaccional.unidades_didacticas_por_programacion_clase tudpc ON tudpc.ID_PROGRAMACION_CLASE = tpc.ID_PROGRAMACION_CLASE AND tudpc.ES_ACTIVO = 1
				INNER JOIN transaccional.unidades_didacticas_por_enfoque tudxe ON tudxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND tudxe.ES_ACTIVO = 1
				INNER JOIN transaccional.unidad_didactica ud ON ud.ID_UNIDAD_DIDACTICA = tudxe.ID_UNIDAD_DIDACTICA AND ud.ES_ACTIVO = 1
				INNER JOIN transaccional.modulo m ON m.ID_MODULO = ud.ID_MODULO AND m.ES_ACTIVO = 1
				INNER JOIN transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = m.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO = 1
				where
					plxi.ID_INSTITUCION = @ID_INSTITUCION
					AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
					AND tpc.ES_ACTIVO = 1
			) tsel
			WHERE 
				t1.ID_PROGRAMACION_CLASE = tsel.ID_PROGRAMACION_CLASE
				and t1.ES_ACTIVO = 1

			---Anula la sesion de programación de clases
			UPDATE transaccional.sesion_programacion_clase
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.sesion_programacion_clase t1,
			(
				SELECT DISTINCT tpc.ID_PROGRAMACION_CLASE
				from transaccional.programacion_clase tpc
				INNER JOIN transaccional.periodo_academico tpa ON tpa.ID_PERIODO_ACADEMICO = tpc.ID_PERIODO_ACADEMICO AND tpa.ES_ACTIVO = 1
				INNER JOIN transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION =  tpa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION and plxi.ES_ACTIVO = 1
				INNER JOIN transaccional.unidades_didacticas_por_programacion_clase tudpc ON tudpc.ID_PROGRAMACION_CLASE = tpc.ID_PROGRAMACION_CLASE AND tudpc.ES_ACTIVO = 1
				INNER JOIN transaccional.unidades_didacticas_por_enfoque tudxe ON tudxe.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND tudxe.ES_ACTIVO = 1
				INNER JOIN transaccional.unidad_didactica ud ON ud.ID_UNIDAD_DIDACTICA = tudxe.ID_UNIDAD_DIDACTICA AND ud.ES_ACTIVO = 1
				INNER JOIN transaccional.modulo m ON m.ID_MODULO = ud.ID_MODULO AND m.ES_ACTIVO = 1
				INNER JOIN transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = m.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO = 1
				where
					plxi.ID_INSTITUCION = @ID_INSTITUCION
					AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
					AND tpc.ES_ACTIVO = 1
			) tsel
			WHERE 
				t1.ID_PROGRAMACION_CLASE = tsel.ID_PROGRAMACION_CLASE
				and t1.ES_ACTIVO = 1


			---Anula la programación de clases
			UPDATE transaccional.programacion_clase
			SET ES_ACTIVO=0,ESTADO=1,
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.programacion_clase t1,
			(
				SELECT ID_PROGRAMACION_CLASE FROM ##TmpProgClasesEliminar 
			) tsel
			WHERE 
				t1.ID_PROGRAMACION_CLASE = tsel.ID_PROGRAMACION_CLASE
				and t1.ES_ACTIVO = 1
			
			DROP TABLE ##TmpProgClasesEliminar

			--POSTULANTES
			--Anula los resultados de admisión
			UPDATE rxp
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.resultados_por_postulante rxp
			INNER JOIN transaccional.postulantes_por_modalidad pxm ON pxm.ID_POSTULANTES_POR_MODALIDAD = rxp.ID_POSTULANTES_POR_MODALIDAD AND pxm.ES_ACTIVO=1
			INNER JOIN transaccional.opciones_por_postulante oxp ON oxp.ID_POSTULANTES_POR_MODALIDAD = pxm.ID_POSTULANTES_POR_MODALIDAD AND oxp.ES_ACTIVO=1
			INNER JOIN transaccional.meta_carrera_institucion_detalle mcid ON mcid.ID_META_CARRERA_INSTITUCION_DETALLE = oxp.ID_META_CARRERA_INSTITUCION_DETALLE AND mcid.ES_ACTIVO=1
			INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = mcid.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
			INNER JOIN transaccional.meta_carrera_institucion mci ON mci.ID_META_CARRERA_INSTITUCION = mcid.ID_META_CARRERA_INSTITUCION AND mci.ES_ACTIVO=1
			INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = mci.ID_PLAN_ESTUDIO
			WHERE rxp.ES_ACTIVO=1 
				AND plxi.ID_INSTITUCION = @ID_INSTITUCION
				AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO

			--Anula los postulantes
			UPDATE pxm
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.postulantes_por_modalidad pxm
			INNER JOIN transaccional.opciones_por_postulante oxp ON oxp.ID_POSTULANTES_POR_MODALIDAD = pxm.ID_POSTULANTES_POR_MODALIDAD AND oxp.ES_ACTIVO=1
			INNER JOIN transaccional.meta_carrera_institucion_detalle mcid ON mcid.ID_META_CARRERA_INSTITUCION_DETALLE = oxp.ID_META_CARRERA_INSTITUCION_DETALLE AND mcid.ES_ACTIVO=1
			INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = mcid.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
			INNER JOIN transaccional.meta_carrera_institucion mci ON mci.ID_META_CARRERA_INSTITUCION = mcid.ID_META_CARRERA_INSTITUCION AND mci.ES_ACTIVO=1
			INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = mci.ID_PLAN_ESTUDIO
			WHERE pxm.ES_ACTIVO=1 
				AND plxi.ID_INSTITUCION = @ID_INSTITUCION
				AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO

			--Anula las opciones de los postulantes
			UPDATE oxp
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.opciones_por_postulante oxp
			INNER JOIN transaccional.meta_carrera_institucion_detalle mcid ON mcid.ID_META_CARRERA_INSTITUCION_DETALLE = oxp.ID_META_CARRERA_INSTITUCION_DETALLE AND mcid.ES_ACTIVO=1
			INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = mcid.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
			INNER JOIN transaccional.meta_carrera_institucion mci ON mci.ID_META_CARRERA_INSTITUCION = mcid.ID_META_CARRERA_INSTITUCION AND mci.ES_ACTIVO=1
			INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = mci.ID_PLAN_ESTUDIO
			WHERE oxp.ES_ACTIVO=1 
				AND plxi.ID_INSTITUCION = @ID_INSTITUCION
				AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO

			--METAS DE ATENCIÓN
			--Anula el detalle de las metas
			UPDATE mcid
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.meta_carrera_institucion_detalle mcid
			INNER JOIN transaccional.meta_carrera_institucion mci ON mci.ID_META_CARRERA_INSTITUCION = mcid.ID_META_CARRERA_INSTITUCION AND mci.ES_ACTIVO=1
			INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = mci.ID_PLAN_ESTUDIO
			WHERE mcid.ES_ACTIVO=1 
				AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO

			--Anula las metas
			UPDATE mci
			SET ES_ACTIVO=0, 
				USUARIO_MODIFICACION=@USUARIO, 
				FECHA_MODIFICACION=@fechaActual
			FROM transaccional.meta_carrera_institucion mci
			INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = mci.ID_PLAN_ESTUDIO
			WHERE mci.ES_ACTIVO=1 
				AND pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO

			--PLAN DE ESTUDIO
			---Elimina el plan de estudios
			EXEC USP_INSTITUCION_DEL_PLAN_ESTUDIO @ID_INSTITUCION, @ID_PLAN_ESTUDIO, @USUARIO


			COMMIT TRANSACTION TransactSQL
						SELECT cast(1 AS bit) as Success,@@ROWCOUNT AS Value

		END TRY

		BEGIN CATCH
			ROLLBACK TRAN TransactSQL
			--DECLARE @ERROR_MESSAGE VARCHAR(MAX) = ''
			--SET @ERROR_MESSAGE = ERROR_MESSAGE() + ' -- '
			--SET @MSG_TRANS = (SELECT 'Error: ' + @ERROR_MESSAGE)
			--SELECT @MSG_TRANS
			PRINT ERROR_MESSAGE()
			SELECT 
				cast(0 AS bit)	as Success,					
				'0'				as Value
		END CATCH

END