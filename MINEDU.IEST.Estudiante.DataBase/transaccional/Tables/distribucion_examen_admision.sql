CREATE TABLE [transaccional].[distribucion_examen_admision] (
    [ID_DISTRIBUCION_EXAMEN_ADMISION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_EVALUADOR_ADMISION_MODALIDAD] [dbo].[ID]           NOT NULL,
    [ID_EXAMEN_ADMISION_SEDE]         [dbo].[ID]           NOT NULL,
    [ID_AULA]                         [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                       [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                          [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                  [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]            [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]              [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_DISTRIBUCION_EXAMEN_ADMISIO] PRIMARY KEY NONCLUSTERED ([ID_DISTRIBUCION_EXAMEN_ADMISION] ASC),
    CONSTRAINT [FK_DISTRIBU_RELATIONS_AULA] FOREIGN KEY ([ID_AULA]) REFERENCES [maestro].[aula] ([ID_AULA]),
    CONSTRAINT [FK_DISTRIBU_RELATIONS_EVALUADO] FOREIGN KEY ([ID_EVALUADOR_ADMISION_MODALIDAD]) REFERENCES [transaccional].[evaluador_admision_modalidad] ([ID_EVALUADOR_ADMISION_MODALIDAD]),
    CONSTRAINT [FK_DISTRIBU_RELATIONS_EXAMEN_A] FOREIGN KEY ([ID_EXAMEN_ADMISION_SEDE]) REFERENCES [transaccional].[examen_admision_sede] ([ID_EXAMEN_ADMISION_SEDE])
);

