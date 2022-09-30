CREATE PROCEDURE [dbo].[USP_CARGA_MASIVA_VAL_ESTUDIANTE_INSTITUCION]
(
    @ID_CARGA INT,
    @ID_PERSONA_INSTITUCION INT,
    @ID_ESTUDIANTE_INSTITUCION INT,
    @ID_TIPO_DOCUMENTO INT,
    @NUMERO_DOCUMENTO_PERSONA VARCHAR(16),
    @NOMBRE_PERSONA VARCHAR(50),
    @APELLIDO_PATERNO_PERSONA VARCHAR(40),
    @APELLIDO_MATERNO_PERSONA VARCHAR(40),
    @SEXO_PERSONA INT,
    @ID_LENGUA_MATERNA INT,
    @FECHA_NACIMIENTO_PERSONA DATETIME,
    @ES_DISCAPACITADO INT,
    @PAIS_NACIMIENTO INT,
    @UBIGEO_NACIMIENTO VARCHAR(6),
    @ID_TIPO_DOCUMENTO_APODERADO INT,
    @NUMERO_DOCUMENTO_APODERADO VARCHAR(16),
    @NOMBRE_APODERADO VARCHAR(50),
    @APELLIDO_APODERADO VARCHAR(150),
    @ID_TIPO_PARENTESCO INT,
    @ID_INSTITUCION INT,
    @ESTADO_CIVIL INT,
    @PAIS_PERSONA INT,
    @UBIGEO_PERSONA VARCHAR(6),
    @DIRECCION_PERSONA VARCHAR(255),
    @TELEFONO VARCHAR(15),
    @CELULAR VARCHAR(15),
    @CORREO VARCHAR(100),
    @ID_TIPO_DISCAPACIDAD INT,
    @ID_INSTITUCION_BASICA INT,
    @ANIO_EGRESO INT,
    --@CODIGO_POSTULANTE				VARCHAR(16),
    @CODIGO_ESTUDIANTE VARCHAR(16),
    @ID_TIPO_INSTITUCION_BASICA INT,
    @CODIGO_MODULAR VARCHAR(7),
    @NOMBRE_IE_BASICA VARCHAR(150),
    @ID_NIVEL_IE_BASICA INT,
    @ID_TIPO_GESTION_IE_BASICA INT,
    @ID_PAIS_BASICA INT,
    @UBIGEO_IE_BASICA VARCHAR(6),
    @DIRECCION_IE_BASICA VARCHAR(255),
    @ARCHIVO_FOTO VARCHAR(50),
    @ARCHIVO_RUTA VARCHAR(255),

    --@ID_CARRERAS_POR_INSTITUCION_DETALLE	INT,
    @ID_SEDE_INSTITUCION INT,
    @ID_CARRERA INT,
    @ID_TIPO_ITINERARIO INT,
    @ID_TURNOS_POR_INSTITUCION INT,
    @ID_SEMESTRE_ACADEMICO INT,
    @ID_TIPO_ESTUDIANTE INT,
    @ID_PERIODO_LECTIVO_INSTITUCION INT,
    @USUARIO VARCHAR(20)
)
AS
DECLARE @RESULT INT,
        @ID_TURNO INT;

SET @ID_TURNO =
(
    SELECT mte.ID_TURNO
    FROM maestro.turnos_por_institucion mti
        INNER JOIN maestro.turno_equivalencia mte
            ON mti.ID_TURNO_EQUIVALENCIA = mte.ID_TURNO_EQUIVALENCIA
               AND mti.ES_ACTIVO = 1
    WHERE mti.ID_TURNOS_POR_INSTITUCION = @ID_TURNOS_POR_INSTITUCION
);

BEGIN --> Validar con SIAGIE
    --NUEVOS
    DECLARE @APROBADO INT = 1; --> Aprobado
    DECLARE @NIVEL CHAR(2) = 'F0'; --> Secundaria
    DECLARE @GRADO CHAR(2) = '14'; --> 5to Año
    DECLARE @VALIDAR_EXISTE INT; -- EXISTE = 1 / NO EXISTE = 0
    DECLARE @VALIDAR_REQUITOS INT; -- GRABAR = 1 / NO GRABAR = 0
    DECLARE @ID_TIPO_DOCUMENTO_SIAGIE INT; --> Tipo de documento SIAGIE

    --Variables de carga
    DECLARE @ID_DET_ARCHIVO INT;
    DECLARE @ID_SEXO INT;
    DECLARE @ID_PERSONA INT;

    --Cambio de valor tipo de documento
    IF @ID_TIPO_DOCUMENTO = 26
    BEGIN
        SET @ID_TIPO_DOCUMENTO_SIAGIE = 2;
    END; --> SIAGIE: Documento Nacional de Identidad = 2
    IF @ID_TIPO_DOCUMENTO = 27
    BEGIN
        SET @ID_TIPO_DOCUMENTO_SIAGIE = 6;
    END; --> SIAGIE: Carnet de Extranjería = 6
    IF @ID_TIPO_DOCUMENTO = 28
    BEGIN
        SET @ID_TIPO_DOCUMENTO_SIAGIE = 5;
    END; --> SIAGIE: Pasaporte = 5
    IF @ID_TIPO_DOCUMENTO = 317
    BEGIN
        SET @ID_TIPO_DOCUMENTO_SIAGIE = 9;
    END; --> SIAGIE: Otro = 9

    --Valida antes de crear mi tabla temporal
    IF (OBJECT_ID('tempdb.dbo.#tmpVista', 'U')) IS NOT NULL
        DROP TABLE #tmpVista;

    --Inserta los datos devueltos en una tabla temporal
    SELECT *
    INTO #tmpVista
    FROM db_auxiliar.dbo.UVW_REGIA_ESTUDIANTE_ULT_ANIO
    WHERE DNI = @NUMERO_DOCUMENTO_PERSONA
          AND TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO_SIAGIE;

    SET @VALIDAR_EXISTE =
    (
        SELECT COUNT(TIPO_DOCUMENTO) FROM #tmpVista
    );

    SET @VALIDAR_REQUITOS =
    (
        SELECT TOP 1
               COUNT(TIPO_DOCUMENTO)
        FROM #tmpVista
        WHERE DNI = @NUMERO_DOCUMENTO_PERSONA
              AND TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO_SIAGIE
              AND PROMOVIDO = @APROBADO
              AND ID_NIVEL = @NIVEL
              AND ID_GRADO = @GRADO
    );
END;

IF @VALIDAR_EXISTE = 1
   AND @VALIDAR_REQUITOS = 0
BEGIN
    --Solo se puede registrar estudiantes que hayan culminado el nivel secundario.
    --SET @RESULT = -284;

    --Seteo de valores que antes venian como parámetros
    SET @ID_PERSONA = 0;

    --Verificar que valores vienen de sexo_persona
    SET @ID_SEXO = CASE
                       WHEN @SEXO_PERSONA = 1 THEN
                           35
                       WHEN @SEXO_PERSONA = 2 THEN
                           36
                   END;

    EXEC @ID_DET_ARCHIVO = USP_ARCHIVO_INS_CARGA_DETALLE @ID_CARGA,
                                                         @ID_TIPO_DOCUMENTO,
                                                         @NUMERO_DOCUMENTO_PERSONA,
                                                         @APELLIDO_PATERNO_PERSONA,
                                                         @APELLIDO_MATERNO_PERSONA,
                                                         @NOMBRE_PERSONA,
                                                         @SEXO_PERSONA,
                                                         @FECHA_NACIMIENTO_PERSONA,
                                                         @ES_DISCAPACITADO,
                                                         @ID_TIPO_DISCAPACIDAD,
                                                         NULL, --@ASIGNACIONES_UNIDADES_DIDACTICAS,
                                                         @UBIGEO_NACIMIENTO,
                                                         NULL, --@UBIGEO_RESIDENCIA,
                                                         @ESTADO_CIVIL,
                                                         @PAIS_NACIMIENTO,
                                                         @PAIS_PERSONA,
                                                         @DIRECCION_PERSONA,
                                                         0,
                                                         0,
                                                         @USUARIO;

    INSERT INTO transaccional.log_carga
    (
        ID_DET_ARCHIVO,
        NRO_REGISTRO_EXCEL,
        MENSAJE,
        FECHA_CREACION,
        USUARIO_CREACION,
        ES_BORRADO
    )
    VALUES
    (@ID_DET_ARCHIVO, 9 /*@ITEM_REGISTRO_EXCEL*/, 'Solo se puede registrar estudiantes que hayan culminado el nivel secundario.', GETDATE(), @USUARIO, 0);
END;
ELSE
BEGIN
    IF EXISTS
    (
        SELECT TOP 1
               tei.ID_ESTUDIANTE_INSTITUCION
        FROM maestro.persona mp
            INNER JOIN maestro.persona_institucion mpi
                ON mp.ID_PERSONA = mpi.ID_PERSONA
            INNER JOIN transaccional.estudiante_institucion tei
                ON tei.ID_PERSONA_INSTITUCION = mpi.ID_PERSONA_INSTITUCION
                   AND tei.ES_ACTIVO = 1
            INNER JOIN transaccional.carreras_por_institucion_detalle tcid
                ON tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE = tei.ID_CARRERAS_POR_INSTITUCION_DETALLE
                   AND tcid.ES_ACTIVO = 1
            INNER JOIN transaccional.carreras_por_institucion tci
                ON tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION
                   AND tci.ES_ACTIVO = 1
            INNER JOIN maestro.turnos_por_institucion mtxi
                ON mtxi.ID_TURNOS_POR_INSTITUCION = tei.ID_TURNOS_POR_INSTITUCION
                   AND mtxi.ES_ACTIVO = 1
            INNER JOIN maestro.turno_equivalencia mte
                ON mte.ID_TURNO_EQUIVALENCIA = mtxi.ID_TURNO_EQUIVALENCIA
        WHERE mp.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO
              AND mp.NUMERO_DOCUMENTO_PERSONA = @NUMERO_DOCUMENTO_PERSONA
              AND tci.ID_CARRERA = @ID_CARRERA
              AND mte.ID_TURNO = @ID_TURNO
              AND mpi.ID_INSTITUCION <> @ID_INSTITUCION
    )
		--
        --SET @RESULT = -233;

		 INSERT INTO transaccional.log_carga
		(
			ID_DET_ARCHIVO,
			NRO_REGISTRO_EXCEL,
			MENSAJE,
			FECHA_CREACION,
			USUARIO_CREACION,
			ES_BORRADO
		)
		VALUES
		(@ID_DET_ARCHIVO, 9 /*@ITEM_REGISTRO_EXCEL*/,
		 'No se puede registrar el estudiante, porque ya existe con ese programa de estudios y turno en otra institución.', GETDATE(), @USUARIO, 0);
    ELSE
    BEGIN
        DECLARE @ID_CARRERAS_POR_INSTITUCION_DETALLE INT = 0;
        BEGIN TRY
            BEGIN TRANSACTION T1;
            SET @RESULT = 0;
            --GRABO LA INSTITUCION BASICA		
            IF @ID_INSTITUCION_BASICA = 0
            BEGIN
                IF NOT EXISTS
                (
                    SELECT TOP 1
                           ID_INSTITUCION_BASICA
                    FROM maestro.institucion_basica (NOLOCK)
                    WHERE ID_TIPO_INSTITUCION_BASICA = @ID_TIPO_INSTITUCION_BASICA
                          AND
                          (
                              CODIGO_MODULAR_IE_BASICA = @CODIGO_MODULAR
                              OR
                              (
                                  @CODIGO_MODULAR = ''
                                  AND NOMBRE_IE_BASICA = @NOMBRE_IE_BASICA
                              )
                          )
                          AND ID_PAIS = @ID_PAIS_BASICA
                          AND ID_NIVEL_IE_BASICA = @ID_NIVEL_IE_BASICA
                          AND ID_TIPO_GESTION_IE_BASICA = @ID_TIPO_GESTION_IE_BASICA
                )
                BEGIN
                    INSERT INTO maestro.institucion_basica
                    (
                        ID_TIPO_INSTITUCION_BASICA,
                        CODIGO_MODULAR_IE_BASICA,
                        NOMBRE_IE_BASICA,
                        ID_NIVEL_IE_BASICA,
                        ID_TIPO_GESTION_IE_BASICA,
                        DIRECCION_IE_BASICA,
                        ID_PAIS,
                        UBIGEO_IE_BASICA,
                        ESTADO,
                        USUARIO_CREACION,
                        FECHA_CREACION
                    )
                    VALUES
                    (@ID_TIPO_INSTITUCION_BASICA, @CODIGO_MODULAR, @NOMBRE_IE_BASICA, @ID_NIVEL_IE_BASICA,
                     @ID_TIPO_GESTION_IE_BASICA, @DIRECCION_IE_BASICA, @ID_PAIS_BASICA,
                     RIGHT(REPLICATE('0', 6) + @UBIGEO_IE_BASICA, 6), 1, @USUARIO, GETDATE());

                    SET @ID_INSTITUCION_BASICA = CONVERT(INT, @@IDENTITY);
                END;
                ELSE
                BEGIN
                    SET @ID_INSTITUCION_BASICA =
                    (
                        SELECT TOP 1
                               ID_INSTITUCION_BASICA
                        FROM maestro.institucion_basica (NOLOCK)
                        WHERE ID_TIPO_INSTITUCION_BASICA = @ID_TIPO_INSTITUCION_BASICA
                              AND
                              (
                                  CODIGO_MODULAR_IE_BASICA = @CODIGO_MODULAR
                                  OR
                                  (
                                      @CODIGO_MODULAR = ''
                                      AND NOMBRE_IE_BASICA = @NOMBRE_IE_BASICA
                                  )
                              )
                              AND ID_PAIS = @ID_PAIS_BASICA
                              AND ID_NIVEL_IE_BASICA = @ID_NIVEL_IE_BASICA
                              AND ID_TIPO_GESTION_IE_BASICA = @ID_TIPO_GESTION_IE_BASICA
                    );

                    UPDATE maestro.institucion_basica
                    SET NOMBRE_IE_BASICA = @NOMBRE_IE_BASICA,
                        ID_NIVEL_IE_BASICA = @ID_NIVEL_IE_BASICA,
                        ID_TIPO_GESTION_IE_BASICA = @ID_TIPO_GESTION_IE_BASICA,
                        DIRECCION_IE_BASICA = @DIRECCION_IE_BASICA,
                        UBIGEO_IE_BASICA = RIGHT(REPLICATE('0', 6) + @UBIGEO_IE_BASICA, 6),
                        USUARIO_MODIFICACION = @USUARIO,
                        FECHA_MODIFICACION = GETDATE()
                    WHERE ID_INSTITUCION_BASICA = @ID_INSTITUCION_BASICA;
                END;
            END;
            ELSE
            BEGIN
                UPDATE maestro.institucion_basica
                SET ID_TIPO_INSTITUCION_BASICA = @ID_TIPO_INSTITUCION_BASICA,
                    CODIGO_MODULAR_IE_BASICA = @CODIGO_MODULAR,
                    NOMBRE_IE_BASICA = @NOMBRE_IE_BASICA,
                    ID_NIVEL_IE_BASICA = @ID_NIVEL_IE_BASICA,
                    ID_TIPO_GESTION_IE_BASICA = @ID_TIPO_GESTION_IE_BASICA,
                    DIRECCION_IE_BASICA = @DIRECCION_IE_BASICA,
                    UBIGEO_IE_BASICA = RIGHT(REPLICATE('0', 6) + @UBIGEO_IE_BASICA, 6),
                    USUARIO_MODIFICACION = @USUARIO,
                    FECHA_MODIFICACION = GETDATE()
                WHERE ID_INSTITUCION_BASICA = @ID_INSTITUCION_BASICA;
            END;

            IF @ID_PERSONA = 0
                SET @ID_PERSONA =
            (
                SELECT ID_PERSONA
                FROM maestro.persona (NOLOCK)
                WHERE ESTADO = 1
                      AND ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO
                      AND NUMERO_DOCUMENTO_PERSONA = @NUMERO_DOCUMENTO_PERSONA
            )   ;

            IF @ID_PERSONA IS NULL
            BEGIN
                INSERT INTO maestro.persona
                (
                    ID_TIPO_DOCUMENTO,
                    NUMERO_DOCUMENTO_PERSONA,
                    NOMBRE_PERSONA,
                    APELLIDO_PATERNO_PERSONA,
                    APELLIDO_MATERNO_PERSONA,
                    FECHA_NACIMIENTO_PERSONA,
                    SEXO_PERSONA,
                    ID_LENGUA_MATERNA,
                    ES_DISCAPACITADO,
                    UBIGEO_NACIMIENTO,
                    PAIS_NACIMIENTO,
                    ESTADO,
                    USUARIO_CREACION,
                    FECHA_CREACION
                )
                VALUES
                (@ID_TIPO_DOCUMENTO, @NUMERO_DOCUMENTO_PERSONA, @NOMBRE_PERSONA, @APELLIDO_PATERNO_PERSONA,
                 @APELLIDO_MATERNO_PERSONA, @FECHA_NACIMIENTO_PERSONA, @SEXO_PERSONA, @ID_LENGUA_MATERNA,
                 @ES_DISCAPACITADO, RIGHT(REPLICATE('0', 6) + @UBIGEO_NACIMIENTO, 6), @PAIS_NACIMIENTO, 1, @USUARIO,
                 GETDATE());

                SET @ID_PERSONA = CONVERT(INT, @@IDENTITY);
            END;
            ELSE
            BEGIN
                IF @ID_TIPO_DOCUMENTO <> 26
                BEGIN
                    UPDATE maestro.persona
                    SET NOMBRE_PERSONA = @NOMBRE_PERSONA,
                        APELLIDO_PATERNO_PERSONA = @APELLIDO_PATERNO_PERSONA,
                        APELLIDO_MATERNO_PERSONA = @APELLIDO_MATERNO_PERSONA,
                        SEXO_PERSONA = @SEXO_PERSONA,
                        FECHA_NACIMIENTO_PERSONA = @FECHA_NACIMIENTO_PERSONA,
                        ID_LENGUA_MATERNA = @ID_LENGUA_MATERNA,
                        ES_DISCAPACITADO = @ES_DISCAPACITADO,
                        PAIS_NACIMIENTO = @PAIS_NACIMIENTO,
                        UBIGEO_NACIMIENTO = RIGHT(REPLICATE('0', 6) + @UBIGEO_NACIMIENTO, 6)
                    WHERE ID_PERSONA = @ID_PERSONA;
                END;
                ELSE
                BEGIN
                    UPDATE maestro.persona
                    SET ID_LENGUA_MATERNA = @ID_LENGUA_MATERNA,
                        ES_DISCAPACITADO = @ES_DISCAPACITADO
                    WHERE ID_PERSONA = @ID_PERSONA;
                END;
            END;
            --END

            --IF @ID_PERSONA_INSTITUCION = 0
            --BEGIN
            IF NOT EXISTS
            (
                SELECT TOP 1
                       ID_PERSONA_INSTITUCION
                FROM maestro.persona_institucion (NOLOCK)
                WHERE ESTADO = 1
                      AND ID_PERSONA = @ID_PERSONA
                      AND ID_INSTITUCION = @ID_INSTITUCION
            )
            BEGIN
                INSERT INTO maestro.persona_institucion
                (
                    ID_PERSONA,
                    ESTADO_CIVIL,
                    PAIS_PERSONA,
                    UBIGEO_PERSONA,
                    DIRECCION_PERSONA,
                    TELEFONO,
                    CELULAR,
                    CORREO,
                    ID_TIPO_DISCAPACIDAD,
                    ID_GRADO_PROFESIONAL,
                    ID_INSTITUCION,
                    NIVEL_EDUCATIVO,
                    ESTADO,
                    USUARIO_CREACION,
                    FECHA_CREACION
                )
                VALUES
                (@ID_PERSONA, @ESTADO_CIVIL, @PAIS_PERSONA, RIGHT(REPLICATE('0', 6) + @UBIGEO_PERSONA, 6),
                 @DIRECCION_PERSONA, @TELEFONO, @CELULAR, @CORREO, @ID_TIPO_DISCAPACIDAD, 0, @ID_INSTITUCION, 0, 1,
                 @USUARIO, GETDATE());
                SET @ID_PERSONA_INSTITUCION = CONVERT(INT, @@IDENTITY);
            END;
            ELSE
            BEGIN
                UPDATE maestro.persona_institucion
                SET ESTADO_CIVIL = @ESTADO_CIVIL,
                    PAIS_PERSONA = @PAIS_PERSONA,
                    UBIGEO_PERSONA = RIGHT(REPLICATE('0', 6) + @UBIGEO_PERSONA, 6),
                    DIRECCION_PERSONA = @DIRECCION_PERSONA,
                    TELEFONO = @TELEFONO,
                    CELULAR = @CELULAR,
                    CORREO = @CORREO,
                    ID_TIPO_DISCAPACIDAD = @ID_TIPO_DISCAPACIDAD,
                    ESTADO = 1,
                    USUARIO_MODIFICACION = @USUARIO,
                    FECHA_MODIFICACION = GETDATE()
                WHERE ID_PERSONA_INSTITUCION = @ID_PERSONA_INSTITUCION;
            END;
            --END
            --ELSE
            --BEGIN
            --	UPDATE maestro.persona_institucion
            --	SET ESTADO_CIVIL = @ESTADO_CIVIL,
            --		PAIS_PERSONA = @PAIS_PERSONA,
            --		UBIGEO_PERSONA = RIGHT(REPLICATE('0',6) + @UBIGEO_PERSONA,6),
            --		DIRECCION_PERSONA = @DIRECCION_PERSONA,
            --		TELEFONO = @TELEFONO,
            --		CELULAR = @CELULAR,
            --		CORREO = @CORREO,
            --		ID_TIPO_DISCAPACIDAD = @ID_TIPO_DISCAPACIDAD,
            --		ESTADO = 1,
            --		USUARIO_MODIFICACION = @USUARIO,
            --		FECHA_MODIFICACION = GETDATE()
            --	WHERE ID_PERSONA_INSTITUCION = @ID_PERSONA_INSTITUCION
            --END

            IF @ID_ESTUDIANTE_INSTITUCION = 0
            BEGIN
                IF NOT EXISTS
                (
                    SELECT TOP 1
                           ID_ESTUDIANTE_INSTITUCION
                    FROM transaccional.estudiante_institucion
                    WHERE ES_ACTIVO = 1
                          AND ID_PERSONA_INSTITUCION = @ID_PERSONA_INSTITUCION
                --AND CODIGO_ESTUDIANTE = @CODIGO_ESTUDIANTE
                )
                BEGIN
                    SET @ID_CARRERAS_POR_INSTITUCION_DETALLE =
                    (
                        SELECT CXID.ID_CARRERAS_POR_INSTITUCION_DETALLE
                        FROM transaccional.carreras_por_institucion_detalle CXID
                            INNER JOIN transaccional.carreras_por_institucion CXI
                                ON CXI.ID_CARRERAS_POR_INSTITUCION = CXID.ID_CARRERAS_POR_INSTITUCION
                                   AND CXI.ES_ACTIVO = 1
                        WHERE CXID.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION
                              AND CXID.ES_ACTIVO = 1
                              AND CXI.ID_CARRERA = @ID_CARRERA
                              AND CXI.ID_TIPO_ITINERARIO = @ID_TIPO_ITINERARIO
                    );
                    INSERT INTO transaccional.estudiante_institucion
                    (
                        ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
                        ID_PERSONA_INSTITUCION,
                        ID_INSTITUCION_BASICA,
                        ID_CARRERAS_POR_INSTITUCION_DETALLE,
                        ID_TURNOS_POR_INSTITUCION,
                        ID_SEMESTRE_ACADEMICO,
                        ID_TIPO_ESTUDIANTE,
                        --CODIGO_POSTULANTE,
                        CODIGO_ESTUDIANTE,
                        ID_TIPO_DOCUMENTO_APODERADO,
                        NUMERO_DOCUMENTO_APODERADO,
                        NOMBRE_APODERADO,
                        APELLIDO_APODERADO,
                        ID_TIPO_PARENTESCO,
                        ANIO_EGRESO,
                        ARCHIVO_FOTO,
                        ARCHIVO_RUTA,
                        ES_ACTIVO,
                        ESTADO,
                        USUARIO_CREACION,
                        FECHA_CREACION
                    )
                    VALUES
                    (   @ID_PERIODO_LECTIVO_INSTITUCION, @ID_PERSONA_INSTITUCION, @ID_INSTITUCION_BASICA,
                        @ID_CARRERAS_POR_INSTITUCION_DETALLE, @ID_TURNOS_POR_INSTITUCION, @ID_SEMESTRE_ACADEMICO,
                        @ID_TIPO_ESTUDIANTE,
                        --@CODIGO_POSTULANTE,
                        @CODIGO_ESTUDIANTE, @ID_TIPO_DOCUMENTO_APODERADO, @NUMERO_DOCUMENTO_APODERADO,
                        @NOMBRE_APODERADO, @APELLIDO_APODERADO, @ID_TIPO_PARENTESCO, CASE
                                                                                         WHEN @ANIO_EGRESO = 0 THEN
                                                                                             NULL
                                                                                         ELSE
                                                                                             @ANIO_EGRESO
                                                                                     END, @ARCHIVO_FOTO, @ARCHIVO_RUTA,
                        1, 1, @USUARIO, GETDATE());
                    SET @ID_ESTUDIANTE_INSTITUCION = CONVERT(INT, @@IDENTITY);

                END;
                ELSE
                BEGIN
					--El estudiante ya ha sido registrado.
                    --RAISERROR('ERROR DE INSERCION', 12, -1) WITH SETERROR;
					INSERT INTO transaccional.log_carga
					(
						ID_DET_ARCHIVO,
						NRO_REGISTRO_EXCEL,
						MENSAJE,
						FECHA_CREACION,
						USUARIO_CREACION,
						ES_BORRADO
					)
					VALUES
					(@ID_DET_ARCHIVO, 9 /*@ITEM_REGISTRO_EXCEL*/,
					 'El estudiante ya ha sido registrado.', GETDATE(), @USUARIO, 0);
                END;
            END;


            COMMIT TRANSACTION T1;
            SET @RESULT = 1;
        END TRY
        BEGIN CATCH
            IF @@ERROR = 50000
            BEGIN
                ROLLBACK TRANSACTION T1;
                SET @RESULT = -180;
                PRINT ERROR_MESSAGE();
            END;
            ELSE IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRANSACTION T1;
                SET @RESULT = -1;
            END;
            ELSE
            BEGIN
                ROLLBACK TRANSACTION T1;
                SET @RESULT = -2;
                PRINT ERROR_MESSAGE();
            END;
        END CATCH;
    END;
END;

SELECT @RESULT;
GO


