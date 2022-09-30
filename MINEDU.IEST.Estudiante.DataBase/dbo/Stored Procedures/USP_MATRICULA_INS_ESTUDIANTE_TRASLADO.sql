﻿
/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta traslado de ingreso.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		MALVA			CREACIÓN
1.1			07/02/2022		JCHAVEZ			Se agregó parámetro @ES_CONVALIDACION_EXONERADA

TEST:		
	USP_MATRICULA_INS_ESTUDIANTE_TRASLADO 443,1209,26,1243,142,453,1071,442,6,101,'42122536'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_INS_ESTUDIANTE_TRASLADO]
(
    @ID_INSTITUCION					INT,
	@ID_PERIODO_LECTIVO_INSTITUCION	INT,
	@ID_TIPO_DOCUMENTO              INT,
	@ID_PERSONA             		INT,
	@ID_TIPO_TRASLADO				INT,
	@ID_INSTITUCION_ORIGEN			INT,
	@ID_CARRERA_ORIGEN				INT,
	@ID_SEDE_INSTITUTO_DESTINO      INT,
	@ID_CARRERA_DESTINO				INT,
	@ID_TIPO_ITINERARIO             INT,
	@ID_PLAN_ESTUDIO_DESTINO        INT,
	@ES_CONVALIDACION_EXONERADA		BIT=0,
	@ID_TURNO_INSTITUCION			INT=0,
	@ID_SEMESTRE_ACADEMICO			INT=0,
	@USUARIO					    VARCHAR(20)
)
AS
BEGIN
	DECLARE @ID_LIBERACION_ESTUDIANTE INT
	DECLARE @ID_SITUACION_ACADEMICA_ORIGEN INT
	DECLARE @ID_SITUACION_ACADEMICA_DESTINO INT
	DECLARE @ID_PLAN_ESTUDIO_ORIGEN INT 
	--DECLARE @ID_PLAN_ESTUDIO_DESTINO INT 
	DECLARE @ID_ESTUDIANTE_INSTITUCION INT
	DECLARE @ID_SEDE_INSTITUCION_ORIGEN INT
	DECLARE @ID_PERIODO_LECTIVO_INSTITUCION_ORIGEN INT
	DECLARE @ID_MATRICULA_ESTUDIANTE INT,
			@ID_LICENCIA_ESTUDIANTE INT,
			@ID_RESERVA_MATRICULA	INT,
			@ID_TRASLADO_INTERNO	INT= 141, 
			@ID_TRASLADO_EXTERNO	INT =142, 
			@ID_LIBERACION_ESTUDIANTE_PROPIO INT,
			@RESULT INT,
			@ID_TIPO_ITINERARIO_ORIGEN	INT,
			@ESTADO_EN_TRASLADO INT = 333
	
	--SELECT einstitucion.ID_ESTUDIANTE_INSTITUCION FROM maestro.persona persona INNER JOIN maestro.persona_institucion pinstitucion
	--									ON persona.ID_PERSONA = pinstitucion.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einstitucion
	--									ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION
	--									WHERE einstitucion.ES_ACTIVO=1 AND pinstitucion.ID_INSTITUCION = 394 AND persona.ID_PERSONA=1242 AND persona.ID_TIPO_DOCUMENTO=27

	--									SELECT ID_LIBERACION_ESTUDIANTE FROM transaccional.liberacion_estudiante where ID_ESTUDIANTE_INSTITUCION = 146 AND ES_ACTIVO=1

	--SET @ID_ESTUDIANTE_INSTITUCION = (SELECT einstitucion.ID_ESTUDIANTE_INSTITUCION FROM maestro.persona persona INNER JOIN maestro.persona_institucion pinstitucion
	--								ON persona.ID_PERSONA = pinstitucion.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einstitucion
	--								ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION
	--								WHERE einstitucion.ES_ACTIVO=1 AND pinstitucion.ID_INSTITUCION = @ID_INSTITUCION_ORIGEN AND persona.ID_PERSONA=@ID_PERSONA 
	--								AND persona.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO)

				
	SELECT 
		@ID_ESTUDIANTE_INSTITUCION = EI.ID_ESTUDIANTE_INSTITUCION,
		@ID_SEDE_INSTITUCION_ORIGEN = CID.ID_SEDE_INSTITUCION, 
		@ID_TIPO_ITINERARIO_ORIGEN = CI.ID_TIPO_ITINERARIO, 
		@ID_PLAN_ESTUDIO_ORIGEN = EI.ID_PLAN_ESTUDIO 
	FROM 
	maestro.persona_institucion PEI 
	INNER JOIN transaccional.estudiante_institucion EI ON EI.ID_PERSONA_INSTITUCION = PEI.ID_PERSONA_INSTITUCION AND EI.ES_ACTIVO=1
	INNER JOIN transaccional.carreras_por_institucion_detalle CID ON CID.ID_CARRERAS_POR_INSTITUCION_DETALLE = EI.ID_CARRERAS_POR_INSTITUCION_DETALLE AND CID.ES_ACTIVO=1
	INNER JOIN transaccional.carreras_por_institucion CI ON CI.ID_CARRERAS_POR_INSTITUCION= CID.ID_CARRERAS_POR_INSTITUCION AND CI.ES_ACTIVO=1		
	WHERE PEI.ID_INSTITUCION =@ID_INSTITUCION_ORIGEN  AND CI.ID_CARRERA = @ID_CARRERA_ORIGEN AND PEI.ID_PERSONA=@ID_PERSONA


	SET @ID_LIBERACION_ESTUDIANTE = (SELECT ID_LIBERACION_ESTUDIANTE FROM transaccional.liberacion_estudiante where ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION 										
									AND ES_ACTIVO=1 )  --ORIGEN

	set @ID_LIBERACION_ESTUDIANTE_PROPIO = (SELECT ID_LIBERACION_ESTUDIANTE FROM transaccional.liberacion_estudiante where ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION 										
									AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
									AND ES_ACTIVO=1 )

		
	SET @ID_PERIODO_LECTIVO_INSTITUCION_ORIGEN = CASE WHEN @ID_TIPO_TRASLADO= @ID_TRASLADO_EXTERNO THEN
												(SELECT ID_PERIODOS_LECTIVOS_POR_INSTITUCION FROM transaccional.liberacion_estudiante WHERE ID_LIBERACION_ESTUDIANTE=@ID_LIBERACION_ESTUDIANTE AND ES_ACTIVO=1)
												ELSE
												@ID_PERIODO_LECTIVO_INSTITUCION
												END
	--SET @ID_SEDE_INSTITUCION_ORIGEN = (SELECT ID_SEDE_INSTITUCION FROM maestro.persona persona INNER JOIN maestro.persona_institucion pinstitucion
	--							ON persona.ID_PERSONA = pinstitucion.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einstitucion 
	--							ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION and einstitucion.ES_ACTIVO=1 INNER JOIN transaccional.carreras_por_institucion_detalle cpdet
	--							ON einstitucion.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpdet.ID_CARRERAS_POR_INSTITUCION_DETALLE INNER JOIN transaccional.carreras_por_institucion cpinst
	--							ON cpdet.ID_CARRERAS_POR_INSTITUCION = cpinst.ID_CARRERAS_POR_INSTITUCION
	--							WHERE persona.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO AND persona.ID_PERSONA = @ID_PERSONA AND cpinst.ID_INSTITUCION = @ID_INSTITUCION_ORIGEN)


							

	--SET @ID_TIPO_ITINERARIO_ORIGEN = ( select TOP 1 cxi.ID_TIPO_ITINERARIO from transaccional.estudiante_institucion ei
	--								inner join transaccional.carreras_por_institucion_detalle cxid on ei.ID_CARRERAS_POR_INSTITUCION_DETALLE = cxid.ID_CARRERAS_POR_INSTITUCION_DETALLE
	--								 and cxid.ES_ACTIVO=1
	--								inner join transaccional.carreras_por_institucion cxi on cxi.ID_CARRERAS_POR_INSTITUCION= cxid.ID_CARRERAS_POR_INSTITUCION and cxi.ES_ACTIVO=1
	--								where ei.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION)

	--SET @ID_PLAN_ESTUDIO_ORIGEN = (SELECT pestudio.ID_PLAN_ESTUDIO FROM db_auxiliar.dbo.UVW_CARRERA carrera INNER JOIN transaccional.carreras_por_institucion cpinsti
	--								ON carrera.ID_CARRERA = cpinsti.ID_CARRERA INNER JOIN transaccional.plan_estudio pestudio
	--								ON cpinsti.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION INNER JOIN sistema.enumerado enu
	--								ON cpinsti.ID_TIPO_ITINERARIO = enu.ID_ENUMERADO
	--								WHERE cpinsti.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1 AND  
	--								carrera.ID_CARRERA = @ID_CARRERA_ORIGEN AND cpinsti.ID_INSTITUCION = @ID_INSTITUCION_ORIGEN AND enu.ID_ENUMERADO= @ID_TIPO_ITINERARIO_ORIGEN)

	--SET @ID_PLAN_ESTUDIO_DESTINO = (SELECT pestudio.ID_PLAN_ESTUDIO FROM db_auxiliar.dbo.UVW_CARRERA carrera INNER JOIN transaccional.carreras_por_institucion cpinsti
	--								ON carrera.ID_CARRERA = cpinsti.ID_CARRERA INNER JOIN transaccional.plan_estudio pestudio
	--								ON cpinsti.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION INNER JOIN sistema.enumerado enu
	--								ON cpinsti.ID_TIPO_ITINERARIO = enu.ID_ENUMERADO
	--								WHERE cpinsti.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1 AND  
	--								carrera.ID_CARRERA = @ID_CARRERA_DESTINO AND cpinsti.ID_INSTITUCION = @ID_INSTITUCION AND enu.ID_ENUMERADO=@ID_TIPO_ITINERARIO)

	

	SET @ID_MATRICULA_ESTUDIANTE = (SELECT ID_MATRICULA_ESTUDIANTE FROM transaccional.matricula_estudiante WHERE ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION
	AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION AND ES_ACTIVO=1)
		
	SET @ID_LICENCIA_ESTUDIANTE = (SELECT  ID_LICENCIA_ESTUDIANTE FROM transaccional.licencia_estudiante WHERE ID_ESTUDIANTE_INSTITUCION= @ID_ESTUDIANTE_INSTITUCION 
								AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION AND ES_ACTIVO=1
								AND ID_LICENCIA_ESTUDIANTE NOT IN (SELECT ID_LICENCIA_ESTUDIANTE FROM transaccional.reingreso_estudiante WHERE ES_ACTIVO=1
																	AND ID_LICENCIA_ESTUDIANTE IS NOT NULL))

	SET @ID_RESERVA_MATRICULA = (SELECT ID_RESERVA_MATRICULA FROM transaccional.reserva_matricula WHERE ID_ESTUDIANTE_INSTITUCION= @ID_ESTUDIANTE_INSTITUCION 
								AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION AND ES_ACTIVO=1
								AND ID_RESERVA_MATRICULA NOT IN (SELECT ID_RESERVA_MATRICULA FROM transaccional.reingreso_estudiante WHERE ES_ACTIVO=1
																AND ID_RESERVA_MATRICULA IS NOT NULL))
		
	IF (@ID_PLAN_ESTUDIO_ORIGEN IS NULL) OR (@ID_PLAN_ESTUDIO_DESTINO IS NULL)
	BEGIN
			SET @RESULT = -213
	END
	ELSE IF (@ID_LIBERACION_ESTUDIANTE_PROPIO IS NOT NULL)
			SET @RESULT = -217
	ELSE IF (@ID_MATRICULA_ESTUDIANTE IS NOT NULL)
			SET  @RESULT =-207  --Matriculado
	ELSE IF (@ID_LICENCIA_ESTUDIANTE IS NOT NULL)
			SET @RESULT= -266
	ELSE IF (@ID_RESERVA_MATRICULA IS NOT NULL)
			SET @RESULT= -267
	ELSE IF (@ID_PLAN_ESTUDIO_ORIGEN = @ID_PLAN_ESTUDIO_DESTINO AND @ID_SEDE_INSTITUCION_ORIGEN = @ID_SEDE_INSTITUTO_DESTINO)
			SET @RESULT= -317
	ELSE
	BEGIN	
	PRINT '@ID_PERIODO_LECTIVO_INSTITUCION: ' + CONVERT (VARCHAR(10),@ID_PERIODO_LECTIVO_INSTITUCION) + ', ' +
		'@ID_SEDE_INSTITUCION_ORIGEN: ' + CONVERT (VARCHAR(10),@ID_SEDE_INSTITUCION_ORIGEN) + ', ' +
		'@ID_PLAN_ESTUDIO_ORIGEN: ' + CONVERT (VARCHAR(10),@ID_PLAN_ESTUDIO_ORIGEN) +
		'@ID_ESTUDIANTE_INSTITUCION: ' + CONVERT (VARCHAR(10),@ID_ESTUDIANTE_INSTITUCION)
		IF EXISTS(SELECT TOP 1 ID_SITUACION_ACADEMICA_ESTUDIANTE FROM [transaccional].[situacion_academica_estudiante] SAE 
					INNER JOIN transaccional.traslado_estudiante  TE ON SAE.ID_SITUACION_ACADEMICA_ESTUDIANTE= TE.ID_SITUACION_ACADEMICA_ORIGEN 
					AND TE.ES_ACTIVO=1 AND SAE.ES_ACTIVO=1
					WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION_ORIGEN AND 
					ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION_ORIGEN AND ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO_ORIGEN AND 
					TE.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION
				 )
		BEGIN
			SET @RESULT = -180 -- YA SE ENCUENTRA REGISTRADO
		END
		ELSE IF EXISTS(SELECT TOP 1 ID_ESTUDIANTE_INSTITUCION 
						FROM transaccional.estudiante_institucion ei
						INNER JOIN maestro.persona_institucion pins ON pins.ID_PERSONA_INSTITUCION = ei.ID_PERSONA_INSTITUCION
						WHERE pins.ID_INSTITUCION=@ID_INSTITUCION AND pins.ID_PERSONA=@ID_PERSONA AND ei.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO_DESTINO 
							AND ei.ES_ACTIVO=1 AND pins.ESTADO=1)
		BEGIN
			SET @RESULT = -401 -- YA SE ENCUENTRA REGISTRADO CON ESE PLAN
        END
		ELSE
		BEGIN
				BEGIN TRY
				BEGIN TRANSACTION T1
				SET @RESULT =0							
				INSERT transaccional.situacion_academica_estudiante(ID_PERIODOS_LECTIVOS_POR_INSTITUCION,ID_SEDE_INSTITUCION,ID_PLAN_ESTUDIO,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION) 
				VALUES(@ID_PERIODO_LECTIVO_INSTITUCION_ORIGEN,@ID_SEDE_INSTITUCION_ORIGEN,@ID_PLAN_ESTUDIO_ORIGEN,1,1,@USUARIO,GETDATE());
	
				SET @ID_SITUACION_ACADEMICA_ORIGEN = @@IDENTITY;

				INSERT transaccional.situacion_academica_estudiante(ID_PERIODOS_LECTIVOS_POR_INSTITUCION,ID_SEDE_INSTITUCION,ID_PLAN_ESTUDIO,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION) 
				VALUES(@ID_PERIODO_LECTIVO_INSTITUCION,@ID_SEDE_INSTITUTO_DESTINO,@ID_PLAN_ESTUDIO_DESTINO,1,1,@USUARIO,GETDATE());
	
				SET @ID_SITUACION_ACADEMICA_DESTINO = @@IDENTITY;
	
				INSERT transaccional.traslado_estudiante(ID_ESTUDIANTE_INSTITUCION,ID_SITUACION_ACADEMICA_ORIGEN,ID_SITUACION_ACADEMICA_DESTINO,ID_TIPO_TRASLADO,ID_LIBERACION_ESTUDIANTE,FECHA_INICIO,ES_CONVALIDACION_EXONERADA,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION) 
				VALUES(@ID_ESTUDIANTE_INSTITUCION,@ID_SITUACION_ACADEMICA_ORIGEN,@ID_SITUACION_ACADEMICA_DESTINO,@ID_TIPO_TRASLADO,ISNULL(@ID_LIBERACION_ESTUDIANTE,0),GETDATE(),@ES_CONVALIDACION_EXONERADA,1,143,@USUARIO,GETDATE());
	
				DECLARE @ID_TRASLADO_ESTUDIANTE INT
				SET @ID_TRASLADO_ESTUDIANTE = @@IDENTITY;

				INSERT transaccional.traslado_estudiante_detalle(ID_TRASLADO_ESTUDIANTE,ID_INSTITUCION,FECHA,ES_ACTIVO,ESTADO,USUARIO_CREACION,FECHA_CREACION) 
				VALUES(@ID_TRASLADO_ESTUDIANTE,@ID_INSTITUCION,GETDATE(),1,1,@USUARIO,GETDATE());

				UPDATE transaccional.estudiante_institucion
				SET ESTADO = @ESTADO_EN_TRASLADO,
				ES_ACTIVO = (CASE @ES_CONVALIDACION_EXONERADA WHEN 1 THEN 0 ELSE 1 END),
				USUARIO_MODIFICACION= @USUARIO,
				FECHA_MODIFICACION= GETDATE()
				WHERE ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION

				IF (@ES_CONVALIDACION_EXONERADA = 1) --SI NO TIENE CONVALIDACION SE REGISTRA AL ESTUDIANTE
				BEGIN
					DECLARE @ID_PERSONA_INSTITUCION INT, @ID_ESTUDIANTE_INSTITUCION_NUEVO INT

					IF NOT EXISTS(SELECT TOP 1 ID_PERSONA_INSTITUCION FROM maestro.persona_institucion WHERE ID_PERSONA=@ID_PERSONA AND ID_INSTITUCION = @ID_INSTITUCION_ORIGEN AND ESTADO = 1)
					BEGIN
						INSERT INTO maestro.persona_institucion
						(	ID_PERSONA, ID_INSTITUCION, ESTADO_CIVIL, PAIS_PERSONA, UBIGEO_PERSONA, DIRECCION_PERSONA,
							TELEFONO,CELULAR,CORREO,ID_TIPO_DISCAPACIDAD, ID_GRADO_PROFESIONAL,
							OCUPACION_PERSONA, TITULO_PROFESIONAL, ID_CARRERA_PROFESIONAL, INSTITUCION_PROFESIONAL, 
							ANIO_INICIO, ANIO_FIN, NIVEL_EDUCATIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
						)
						SELECT	
							ID_PERSONA, @ID_INSTITUCION, ESTADO_CIVIL, PAIS_PERSONA, UBIGEO_PERSONA, DIRECCION_PERSONA,
							TELEFONO,CELULAR,CORREO,ID_TIPO_DISCAPACIDAD, ID_GRADO_PROFESIONAL,
							OCUPACION_PERSONA, TITULO_PROFESIONAL, ID_CARRERA_PROFESIONAL, INSTITUCION_PROFESIONAL, 
							ANIO_INICIO, ANIO_FIN, NIVEL_EDUCATIVO, ESTADO, @USUARIO, GETDATE()
						FROM maestro.persona_institucion 
						WHERE ID_PERSONA=@ID_PERSONA AND ID_INSTITUCION = @ID_INSTITUCION_ORIGEN
					
						SET @ID_PERSONA_INSTITUCION = (SELECT CONVERT(INT,@@IDENTITY))
					END
					ELSE
                    BEGIN
						SET @ID_PERSONA_INSTITUCION = (SELECT TOP 1 ID_PERSONA_INSTITUCION FROM maestro.persona_institucion WHERE ID_PERSONA=@ID_PERSONA AND ID_INSTITUCION = @ID_INSTITUCION_ORIGEN AND ESTADO = 1)
                    END
                    
					INSERT INTO transaccional.estudiante_institucion
					(	ID_PERSONA_INSTITUCION, 
						ID_INSTITUCION_BASICA, 
						ID_CARRERAS_POR_INSTITUCION_DETALLE,
						ID_TURNOS_POR_INSTITUCION, 
						ID_SEMESTRE_ACADEMICO, 
						ID_TIPO_ESTUDIANTE,
						ANIO_EGRESO,
						ID_TIPO_DOCUMENTO_APODERADO,
						ID_TIPO_PARENTESCO,
						NUMERO_DOCUMENTO_APODERADO,
						NOMBRE_APODERADO,
						APELLIDO_APODERADO, 
						ARCHIVO_FOTO,
						ARCHIVO_RUTA,
						ES_ACTIVO,
						ESTADO,
						USUARIO_CREACION,
						FECHA_CREACION,
						ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
						ID_PLAN_ESTUDIO
					)
					select 
						@ID_PERSONA_INSTITUCION,
						ID_INSTITUCION_BASICA,
						(		SELECT TCID.ID_CARRERAS_POR_INSTITUCION_DETALLE 
								FROM transaccional.traslado_estudiante TTE
									INNER JOIN transaccional.situacion_academica_estudiante TSAE	ON	TTE.ID_SITUACION_ACADEMICA_DESTINO = TSAE.ID_SITUACION_ACADEMICA_ESTUDIANTE
									INNER JOIN transaccional.plan_estudio TPE						ON	TPE.ID_PLAN_ESTUDIO=TSAE.ID_PLAN_ESTUDIO AND TPE.ES_ACTIVO=1
									INNER JOIN transaccional.carreras_por_institucion_detalle TCID	ON 	TCID.ID_CARRERAS_POR_INSTITUCION= TPE.ID_CARRERAS_POR_INSTITUCION AND TCID.ES_ACTIVO=1
									AND TCID.ID_SEDE_INSTITUCION=TSAE.ID_SEDE_INSTITUCION
									AND TSAE.ES_ACTIVO=1 AND TTE.ES_ACTIVO=1
								WHERE TTE.ID_TRASLADO_ESTUDIANTE=@ID_TRASLADO_ESTUDIANTE
						) ID_CARRERAS_POR_INSTITUCION_DETALLE,				
						@ID_TURNO_INSTITUCION,
						@ID_SEMESTRE_ACADEMICO, 
						190,
						ANIO_EGRESO, 
						ID_TIPO_DOCUMENTO_APODERADO,
						ID_TIPO_PARENTESCO,
						NUMERO_DOCUMENTO_APODERADO,
						NOMBRE_APODERADO,
						APELLIDO_APODERADO, 
						ARCHIVO_FOTO,
						ARCHIVO_RUTA, 
						1,
						1, 
						@USUARIO,
						GETDATE(),
						@ID_PERIODO_LECTIVO_INSTITUCION,
						(		SELECT TPE.ID_PLAN_ESTUDIO
								FROM transaccional.traslado_estudiante TTE
									INNER JOIN transaccional.situacion_academica_estudiante TSAE	ON	TTE.ID_SITUACION_ACADEMICA_DESTINO = TSAE.ID_SITUACION_ACADEMICA_ESTUDIANTE
									INNER JOIN transaccional.plan_estudio TPE						ON	TPE.ID_PLAN_ESTUDIO=TSAE.ID_PLAN_ESTUDIO AND TPE.ES_ACTIVO=1
									INNER JOIN transaccional.carreras_por_institucion_detalle TCID	ON 	TCID.ID_CARRERAS_POR_INSTITUCION= TPE.ID_CARRERAS_POR_INSTITUCION AND TCID.ES_ACTIVO=1
									AND TCID.ID_SEDE_INSTITUCION=TSAE.ID_SEDE_INSTITUCION
									AND TSAE.ES_ACTIVO=1 AND TTE.ES_ACTIVO=1
								WHERE TTE.ID_TRASLADO_ESTUDIANTE=@ID_TRASLADO_ESTUDIANTE
						) ID_PLAN_ESTUDIO
					from transaccional.estudiante_institucion
					WHERE ID_ESTUDIANTE_INSTITUCION= @ID_ESTUDIANTE_INSTITUCION 
					
					SET @ID_ESTUDIANTE_INSTITUCION_NUEVO = (SELECT CONVERT(INT,@@IDENTITY))

					UPDATE transaccional.traslado_estudiante 
					SET ID_ESTUDIANTE_INSTITUCION_NUEVO = @ID_ESTUDIANTE_INSTITUCION_NUEVO 
					WHERE ID_TRASLADO_ESTUDIANTE = @ID_TRASLADO_ESTUDIANTE
				END

				COMMIT TRANSACTION T1	
				SET @RESULT = 1			
				END TRY
				BEGIN CATCH
					IF @@ERROR = 50000
					BEGIN
						ROLLBACK TRANSACTION T1	   
						SET @RESULT = -180  --???
					END
					ELSE
						IF @@ERROR <> 0
						BEGIN
							ROLLBACK TRANSACTION T1	   
							SET @RESULT = -1
						END
						ELSE
						BEGIN
							ROLLBACK TRANSACTION T1	   
							SET @RESULT = -2
							PRINT ERROR_MESSAGE()
						END
				END CATCH
		END		
	END		
	SELECT @RESULT
END
GO

