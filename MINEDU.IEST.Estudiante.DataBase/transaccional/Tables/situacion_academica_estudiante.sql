CREATE TABLE [transaccional].[situacion_academica_estudiante] (
    [ID_SITUACION_ACADEMICA_ESTUDIANTE]    [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [ID_SEDE_INSTITUCION]                  [dbo].[ID]           NOT NULL,
    [ID_PLAN_ESTUDIO]                      [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_SITUACION_ACADEMICA_ESTUDIA] PRIMARY KEY NONCLUSTERED ([ID_SITUACION_ACADEMICA_ESTUDIANTE] ASC),
    CONSTRAINT [FK_SITUACIO_FK_PLAN_E_PLAN_EST] FOREIGN KEY ([ID_PLAN_ESTUDIO]) REFERENCES [transaccional].[plan_estudio] ([ID_PLAN_ESTUDIO]),
    CONSTRAINT [FK_SITUACION_ACADEMICA_EST_SEDE_INST] FOREIGN KEY ([ID_SEDE_INSTITUCION]) REFERENCES [maestro].[sede_institucion] ([ID_SEDE_INSTITUCION])
);

