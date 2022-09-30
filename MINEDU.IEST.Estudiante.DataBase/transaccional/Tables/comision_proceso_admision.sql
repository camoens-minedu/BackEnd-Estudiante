CREATE TABLE [transaccional].[comision_proceso_admision] (
    [ID_COMISION_PROCESO_ADMISION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PERSONAL_INSTITUCION]      [dbo].[ID]           NOT NULL,
    [ID_PROCESO_ADMISION_PERIODO]  [dbo].[ID]           NOT NULL,
    [ID_CARGO]                     [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                    [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                       [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]             [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]               [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]         [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]           [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_COMISION_PROCESO_ADMISION] PRIMARY KEY NONCLUSTERED ([ID_COMISION_PROCESO_ADMISION] ASC),
    CONSTRAINT [FK_COMISION_FK_PERSON_PERSONAL] FOREIGN KEY ([ID_PERSONAL_INSTITUCION]) REFERENCES [maestro].[personal_institucion] ([ID_PERSONAL_INSTITUCION]),
    CONSTRAINT [FK_COMISION_RELATIONS_PROCESO_] FOREIGN KEY ([ID_PROCESO_ADMISION_PERIODO]) REFERENCES [transaccional].[proceso_admision_periodo] ([ID_PROCESO_ADMISION_PERIODO])
);

