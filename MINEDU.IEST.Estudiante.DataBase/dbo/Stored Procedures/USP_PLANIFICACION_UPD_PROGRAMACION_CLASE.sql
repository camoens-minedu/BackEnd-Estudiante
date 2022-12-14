/********************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Actualiza los datos de una clase.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			01/10/2018		JTOVAR          CREACIÓN
2.0			22/12/2021		JTOVAR			Se agregó campo IdDocenteClase

TEST:			
	USP_PLANIFICACION_UPD_PROGRAMACION_CLASE 3842
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_PLANIFICACION_UPD_PROGRAMACION_CLASE]
(  
	@ID_PROGRAMACION_CLASE		INT,
	@ID_PERIODO_ACADEMICO		INT,
	@ID_TURNOS_POR_INSTITUCION	INT, --?
	@ID_SECCION					smallint,  --?
	@ID_PERSONAL_INSTITUCION	int,
	@ID_PERSONAL_INSTITUCION_SECUNDARIO INT=0,
	@ID_SEDE_INSTITUCION		INT,
	@VACANTE					int,
	@IDS_UDS_ENFOQUE			varchar(max),
	@SESIONES					varchar(max), --117,10:15-12:15|122,11:20-12:00
	@NOMBRE_CLASE				VARCHAR(50),
	@USUARIO					VARCHAR(20)
)  
AS 

DECLARE @RESULT VARCHAR(MAX),
@UDS VARCHAR(MAX),
@Dia INT, 
@HoraInicio VARCHAR(5), 
@HoraFin VARCHAR(5),
@Traslape BIT =0
 BEGIN  
		SELECT @UDS =  COALESCE(@UDS + ',', '')+  UD.NOMBRE_UNIDAD_DIDACTICA + ' [' + SplitData +  ']' FROM dbo.UFN_SPLIT(@IDS_UDS_ENFOQUE, '|')
		INNER JOIN transaccional.unidades_didacticas_por_programacion_clase UDXPC ON UDXPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= SplitData AND UDXPC.ES_ACTIVO=1
		INNER JOIN transaccional.programacion_clase PC ON PC.ID_PROGRAMACION_CLASE= UDXPC.ID_PROGRAMACION_CLASE AND PC.ES_ACTIVO=1
		INNER JOIN transaccional.unidades_didacticas_por_enfoque UDXE ON UDXE.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE= UDXPC.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE AND UDXE.ES_ACTIVO=1
		INNER JOIN transaccional.unidad_didactica UD ON UD.ID_UNIDAD_DIDACTICA= UDXE.ID_UNIDAD_DIDACTICA AND UD.ES_ACTIVO=1
		WHERE PC.ID_SECCION=@ID_SECCION AND PC.ID_TURNOS_POR_INSTITUCION=@ID_TURNOS_POR_INSTITUCION AND PC.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION AND PC.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO
		GROUP BY UD.NOMBRE_UNIDAD_DIDACTICA, SplitData
 IF @UDS IS NOT NULL
 BEGIN
	SET @RESULT = @UDS

 END
 ELSE 
 BEGIN

 DECLARE sesiones_cursor CURSOR FOR   
		select 
		SUBSTRING(SplitData, 0,CHARINDEX(',',SplitData)) Dia,
		SUBSTRING(SplitData,CHARINDEX(',',SplitData) +  1,CHARINDEX('-',SplitData) -CHARINDEX(',',SplitData) -1 ) HoraInicio, 
		SUBSTRING (SplitData, CHARINDEX('-', SplitData) +1, len(SplitData)-CHARINDEX('-', SplitData)) HoraFin
		from dbo.UFN_SPLIT(@SESIONES, '|')

		OPEN sesiones_cursor  

		FETCH NEXT FROM sesiones_cursor 
		INTO	@Dia ,@HoraInicio, @HoraFin
		WHILE @@FETCH_STATUS = 0 
		BEGIN  			

				SELECT SPC.ID_SESION_PROGRAMACION_CLASE, DIA, SPC.HORA_INICIO, SPC.HORA_FIN INTO #TempSesionProgramacion 
				FROM	transaccional.sesion_programacion_clase SPC
						INNER JOIN transaccional.programacion_clase PC ON SPC.ID_PROGRAMACION_CLASE= PC.ID_PROGRAMACION_CLASE 
						AND SPC.ES_ACTIVO=1 AND PC.ES_ACTIVO=1
				WHERE	PC.ID_PERSONAL_INSTITUCION=@ID_PERSONAL_INSTITUCION AND PC.ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO
				AND PC.ID_PROGRAMACION_CLASE <> @ID_PROGRAMACION_CLASE AND @ID_PERSONAL_INSTITUCION != -1

				DECLARE @ID INT =0
				DECLARE @ID_SESION_PROGRAMACION_CLASE_TEMP INT =0
				DECLARE @DIA_TEMP INT
				DECLARE @HORA_INICIO_TEMP VARCHAR(5)
				DECLARE @HORA_FIN_TEMP VARCHAR(5)
			
				DECLARE @TotalSesiones INT = 0
				SET @TotalSesiones= ( SELECT COUNT(1) FROM #TempSesionProgramacion)
				WHILE @ID <@TotalSesiones AND @Traslape = 0
				BEGIN
					SET @ID_SESION_PROGRAMACION_CLASE_TEMP =(SELECT TOP 1 ID_SESION_PROGRAMACION_CLASE FROM #TempSesionProgramacion order by 1 ASC )

					SELECT 
							@DIA_TEMP= DIA,
							@HORA_INICIO_TEMP= HORA_INICIO,
							@HORA_FIN_TEMP = HORA_FIN
					FROM #TempSesionProgramacion where ID_SESION_PROGRAMACION_CLASE = @ID_SESION_PROGRAMACION_CLASE_TEMP

					IF @Dia = @DIA_TEMP AND CONVERT(TIME, @HoraInicio) BETWEEN CONVERT(TIME, @HORA_INICIO_TEMP) AND CONVERT(TIME, @HORA_FIN_TEMP) SET @Traslape = 1
					IF @Dia = @DIA_TEMP AND CONVERT(TIME, @HoraFin) BETWEEN CONVERT(TIME, @HORA_INICIO_TEMP) AND CONVERT(TIME, @HORA_FIN_TEMP)  SET @Traslape =1 
					--IF @DIA = @DIA_TEMP AND @FECHA_INICIO < @FechaMin and @ID_MODALIDAD_ACTUAL <> @ModalidadMin SET @Traslape=1

					DELETE FROM #TempSesionProgramacion where ID_SESION_PROGRAMACION_CLASE = @ID_SESION_PROGRAMACION_CLASE_TEMP
				SET @ID = @ID+1
				END
				PRINT @Traslape
				DROP TABLE #TempSesionProgramacion
		FETCH NEXT FROM sesiones_cursor
		INTO	@Dia ,@HoraInicio, @HoraFin
		END 
		CLOSE sesiones_cursor;
		DEALLOCATE sesiones_cursor;   
		IF @Traslape = 1
		BEGIN
					SET @RESULT = '-279'
		END
		ELSE
		BEGIN

		          IF EXISTS (SELECT TOP 1 eva.ID_EVALUACION FROM transaccional.evaluacion eva INNER JOIN transaccional.programacion_clase pc
				             ON eva.ID_PROGRAMACION_CLASE = pc.ID_PROGRAMACION_CLASE WHERE eva.ID_PROGRAMACION_CLASE = @ID_PROGRAMACION_CLASE AND eva.ES_ACTIVO=1 and pc.ES_ACTIVO=1
							 and eva.CIERRE_PROGRAMACION = 235) -- valida si el periodo de clase esta cerrado
		          BEGIN
					SET @RESULT = -308
					END
					ELSE
					BEGIN

						UPDATE transaccional.programacion_clase
						SET ID_PERSONAL_INSTITUCION =@ID_PERSONAL_INSTITUCION,
										ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO,														
										VACANTE_CLASE = @VACANTE,							
										USUARIO_MODIFICACION= @USUARIO,
										FECHA_MODIFICACION=GETDATE(),
										ID_TURNOS_POR_INSTITUCION=@ID_TURNOS_POR_INSTITUCION,
										ID_SECCION=@ID_SECCION,
										NOMBRE_CLASE = @NOMBRE_CLASE, 
										ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION,
										ID_PERSONAL_INSTITUCION_SECUNDARIO=@ID_PERSONAL_INSTITUCION_SECUNDARIO
										WHERE ID_PROGRAMACION_CLASE=@ID_PROGRAMACION_CLASE
	
						SET @RESULT = 1
					END






		--	UPDATE transaccional.programacion_clase
		--	SET ID_PERSONAL_INSTITUCION =@ID_PERSONAL_INSTITUCION,
		--					ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO,														
		--					VACANTE_CLASE = @VACANTE,							
		--					USUARIO_MODIFICACION= @USUARIO,
		--					FECHA_MODIFICACION=GETDATE(),
		--					ID_TURNOS_POR_INSTITUCION=@ID_TURNOS_POR_INSTITUCION,
		--					ID_SECCION=@ID_SECCION,
		--					NOMBRE_CLASE = @NOMBRE_CLASE, 
		--					ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION
		--					WHERE ID_PROGRAMACION_CLASE=@ID_PROGRAMACION_CLASE
	
		--	SET @RESULT = 1
		END
 END
END
SELECT @RESULT
GO


