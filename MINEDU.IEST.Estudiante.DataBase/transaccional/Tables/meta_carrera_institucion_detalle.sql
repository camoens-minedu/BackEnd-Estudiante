CREATE TABLE [transaccional].[meta_carrera_institucion_detalle] (
    [ID_META_CARRERA_INSTITUCION_DETALLE]  [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_META_CARRERA_INSTITUCION]          [dbo].[ID]            NOT NULL,
    [ID_SEDE_INSTITUCION]                  [dbo].[ID]            NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]            NOT NULL,
    [META_SEDE]                            [dbo].[NUMERO_ENTERO] NULL,
    [META_ALCANZADA]                       [dbo].[NUMERO_ENTERO] NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_META_CARRERA_INSTITUCION_DE] PRIMARY KEY NONCLUSTERED ([ID_META_CARRERA_INSTITUCION_DETALLE] ASC),
    CONSTRAINT [FK_META_CAR_RELATIONS_META_CAR] FOREIGN KEY ([ID_META_CARRERA_INSTITUCION]) REFERENCES [transaccional].[meta_carrera_institucion] ([ID_META_CARRERA_INSTITUCION]),
    CONSTRAINT [FK_META_CAR_RELATIONS_PERIODOS] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]),
    CONSTRAINT [FK_META_CAR_RELATIONS_SEDE_INS] FOREIGN KEY ([ID_SEDE_INSTITUCION]) REFERENCES [maestro].[sede_institucion] ([ID_SEDE_INSTITUCION])
);

