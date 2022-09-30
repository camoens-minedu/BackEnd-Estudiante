CREATE TABLE [transaccional].[estudiante_institucion] (
    [ID_ESTUDIANTE_INSTITUCION]            [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_PERSONA_INSTITUCION]               [dbo].[ID]            NOT NULL,
    [ID_INSTITUCION_BASICA]                [dbo].[ID]            NULL,
    [ID_CARRERAS_POR_INSTITUCION_DETALLE]  [dbo].[ID]            NOT NULL,
    [ID_TURNOS_POR_INSTITUCION]            [dbo].[ID]            NOT NULL,
    [ID_SEMESTRE_ACADEMICO]                [dbo].[ID_ENUMERADO]  NOT NULL,
    [ID_TIPO_ESTUDIANTE]                   [dbo].[ID_ENUMERADO]  NOT NULL,
    [CODIGO_ESTUDIANTE]                    [dbo].[CODIGO_LARGO]  NULL,
    [ANIO_EGRESO]                          [dbo].[NUMERO_ENTERO] NULL,
    [ID_TIPO_DOCUMENTO_APODERADO]          [dbo].[ID_ENUMERADO]  NOT NULL,
    [ID_TIPO_PARENTESCO]                   [dbo].[ID_ENUMERADO]  NOT NULL,
    [NUMERO_DOCUMENTO_APODERADO]           [dbo].[CODIGO_LARGO]  NULL,
    [NOMBRE_APODERADO]                     [dbo].[NOMBRE_CORTO]  NULL,
    [APELLIDO_APODERADO]                   [dbo].[NOMBRE_LARGO]  NULL,
    [ARCHIVO_FOTO]                         [dbo].[NOMBRE_CORTO]  NULL,
    [ARCHIVO_RUTA]                         [dbo].[DESCRIPCION]   NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO]  NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]            NOT NULL,
    [ID_PLAN_ESTUDIO]                      INT                   NULL,
    CONSTRAINT [PK_ESTUDIANTE_INSTITUCION] PRIMARY KEY NONCLUSTERED ([ID_ESTUDIANTE_INSTITUCION] ASC),
    CONSTRAINT [FK_EST_INST_FK_PERI_LECT_INS] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]),
    CONSTRAINT [FK_ESTUDIAN_FK_CARR_POR_INSTIT_DET_ID] FOREIGN KEY ([ID_CARRERAS_POR_INSTITUCION_DETALLE]) REFERENCES [transaccional].[carreras_por_institucion_detalle] ([ID_CARRERAS_POR_INSTITUCION_DETALLE]),
    CONSTRAINT [FK_ESTUDIAN_FK_INSTIT_BASICA_ID] FOREIGN KEY ([ID_INSTITUCION_BASICA]) REFERENCES [maestro].[institucion_basica] ([ID_INSTITUCION_BASICA]),
    CONSTRAINT [FK_ESTUDIAN_FK_PERSONA_INST_ID] FOREIGN KEY ([ID_PERSONA_INSTITUCION]) REFERENCES [maestro].[persona_institucion] ([ID_PERSONA_INSTITUCION]),
    CONSTRAINT [FK_ESTUDIAN_FK_PLAN_ESTUDIO_ID] FOREIGN KEY ([ID_PLAN_ESTUDIO]) REFERENCES [transaccional].[plan_estudio] ([ID_PLAN_ESTUDIO]),
    CONSTRAINT [FK_ESTUDIAN_FK_TURN_POR_INSTIT_ID] FOREIGN KEY ([ID_TURNOS_POR_INSTITUCION]) REFERENCES [maestro].[turnos_por_institucion] ([ID_TURNOS_POR_INSTITUCION])
);


GO
CREATE NONCLUSTERED INDEX [IDX_ESTUDIANTE_INSTITUCION1]
    ON [transaccional].[estudiante_institucion]([ES_ACTIVO] ASC)
    INCLUDE([ID_ESTUDIANTE_INSTITUCION], [ID_PERSONA_INSTITUCION], [ID_CARRERAS_POR_INSTITUCION_DETALLE], [ID_TURNOS_POR_INSTITUCION]);

