CREATE TABLE [transaccional].[evaluador_admision_modalidad] (
    [ID_EVALUADOR_ADMISION_MODALIDAD]     [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_MODALIDADES_POR_PROCESO_ADMISION] [dbo].[ID]           NOT NULL,
    [ID_PERSONAL_INSTITUCION]             [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                           [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                              [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                    [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                      [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                  [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_EVALUADOR_ADMISION_MODALIDA] PRIMARY KEY NONCLUSTERED ([ID_EVALUADOR_ADMISION_MODALIDAD] ASC),
    CONSTRAINT [FK_EVALUADO_RELATIONS_MODALIDA] FOREIGN KEY ([ID_MODALIDADES_POR_PROCESO_ADMISION]) REFERENCES [transaccional].[modalidades_por_proceso_admision] ([ID_MODALIDADES_POR_PROCESO_ADMISION]),
    CONSTRAINT [FK_EVALUADO_RELATIONS_PERSONAL] FOREIGN KEY ([ID_PERSONAL_INSTITUCION]) REFERENCES [maestro].[personal_institucion] ([ID_PERSONAL_INSTITUCION])
);

