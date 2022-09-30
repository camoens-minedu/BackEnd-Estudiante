CREATE TABLE [transaccional].[meta_carrera_institucion] (
    [ID_META_CARRERA_INSTITUCION]                     [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_TURNOS_POR_INSTITUCION]                       [dbo].[ID]            NOT NULL,
    [ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION] [dbo].[ID]            NULL,
    [ID_CARRERAS_POR_INSTITUCION]                     [dbo].[ID]            NOT NULL,
    [ANIO]                                            [dbo].[ID]            NOT NULL,
    [META]                                            [dbo].[NUMERO_ENTERO] NULL,
    [ES_ACTIVO]                                       [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                                          [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                                [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                                  [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]                            [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                              [dbo].[FECHA_TIEMPO]  NULL,
    [ID_PLAN_ESTUDIO]                                 INT                   NULL,
    CONSTRAINT [PK_META_CARRERA_INSTITUCION] PRIMARY KEY NONCLUSTERED ([ID_META_CARRERA_INSTITUCION] ASC),
    CONSTRAINT [FK_CARRERAS_POR_INSTITUCION_META_CARRERA_INSTITUCION] FOREIGN KEY ([ID_CARRERAS_POR_INSTITUCION]) REFERENCES [transaccional].[carreras_por_institucion] ([ID_CARRERAS_POR_INSTITUCION]),
    CONSTRAINT [FK_META_CAR_FK_PLAN_ESTUDIO] FOREIGN KEY ([ID_PLAN_ESTUDIO]) REFERENCES [transaccional].[plan_estudio] ([ID_PLAN_ESTUDIO]),
    CONSTRAINT [FK_META_CAR_RELATIONS_RESOLUCI] FOREIGN KEY ([ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION]) REFERENCES [transaccional].[resoluciones_por_periodo_lectivo_institucion] ([ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION]),
    CONSTRAINT [FK_META_CAR_RELATIONS_TURNOS_P] FOREIGN KEY ([ID_TURNOS_POR_INSTITUCION]) REFERENCES [maestro].[turnos_por_institucion] ([ID_TURNOS_POR_INSTITUCION])
);

