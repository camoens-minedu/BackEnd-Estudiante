CREATE TABLE [transaccional].[examen_admision_sede] (
    [ID_EXAMEN_ADMISION_SEDE]     [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_SEDE_INSTITUCION]         [dbo].[ID]           NOT NULL,
    [ID_PROCESO_ADMISION_PERIODO] [dbo].[ID]           NOT NULL,
    [FECHA_EVALUACION]            [dbo].[FECHA]        NULL,
    [HORA_EVALUACION]             [dbo].[HORA_STRING]  NULL,
    [ES_ACTIVO]                   [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                      [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]            [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]              [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]        [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]          [dbo].[FECHA_TIEMPO] NULL,
    [ID_MODALIDAD]                [dbo].[ID_ENUMERADO] NOT NULL,
    [TIEMPO_EVALUACION]           [dbo].[HORA_STRING]  NULL,
    CONSTRAINT [PK_EXAMEN_ADMISION_SEDE] PRIMARY KEY NONCLUSTERED ([ID_EXAMEN_ADMISION_SEDE] ASC),
    CONSTRAINT [FK_EXAMEN_A_FK_SEDE_I_SEDE_INS] FOREIGN KEY ([ID_SEDE_INSTITUCION]) REFERENCES [maestro].[sede_institucion] ([ID_SEDE_INSTITUCION]),
    CONSTRAINT [FK_EXAMEN_A_RELATIONS_PROCESO_] FOREIGN KEY ([ID_PROCESO_ADMISION_PERIODO]) REFERENCES [transaccional].[proceso_admision_periodo] ([ID_PROCESO_ADMISION_PERIODO])
);

