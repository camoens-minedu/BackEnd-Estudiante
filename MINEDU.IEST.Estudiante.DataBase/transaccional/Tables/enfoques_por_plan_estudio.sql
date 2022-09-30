CREATE TABLE [transaccional].[enfoques_por_plan_estudio] (
    [ID_ENFOQUES_POR_PLAN_ESTUDIO] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PLAN_ESTUDIO]              [dbo].[ID]           NOT NULL,
    [ID_ENFOQUE]                   [dbo].[ID]           NULL,
    [ES_ACTIVO]                    [dbo].[BOOLEANO]     NULL,
    [ESTADO]                       [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]             [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]               [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]         [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]           [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_ENFOQUES_POR_PLAN_ESTUDIO] PRIMARY KEY NONCLUSTERED ([ID_ENFOQUES_POR_PLAN_ESTUDIO] ASC),
    CONSTRAINT [FK_ENFOQUES_FK_PLAN_E_PLAN_EST] FOREIGN KEY ([ID_PLAN_ESTUDIO]) REFERENCES [transaccional].[plan_estudio] ([ID_PLAN_ESTUDIO]),
    CONSTRAINT [FK_ENFOQUES_RELATIONS_ENFOQUE] FOREIGN KEY ([ID_ENFOQUE]) REFERENCES [maestro].[enfoque] ([ID_ENFOQUE])
);

