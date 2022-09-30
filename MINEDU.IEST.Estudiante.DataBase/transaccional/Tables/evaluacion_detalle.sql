CREATE TABLE [transaccional].[evaluacion_detalle] (
    [ID_EVALUACION_DETALLE]   [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_EVALUACION]           [dbo].[ID]           NOT NULL,
    [ID_MATRICULA_ESTUDIANTE] [dbo].[ID]           NOT NULL,
    [NOTA]                    [dbo].[DECIMAL_DOS]  NULL,
    [ES_ACTIVO]               [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                  [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]        [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]          [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]    [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]      [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_EVALUACION_DETALLE] PRIMARY KEY NONCLUSTERED ([ID_EVALUACION_DETALLE] ASC),
    CONSTRAINT [FK_EVALU_DET_FK_MATR_EST] FOREIGN KEY ([ID_MATRICULA_ESTUDIANTE]) REFERENCES [transaccional].[matricula_estudiante] ([ID_MATRICULA_ESTUDIANTE]),
    CONSTRAINT [FK_EVALUACI_RELATIONS_EVALUACI] FOREIGN KEY ([ID_EVALUACION]) REFERENCES [transaccional].[evaluacion] ([ID_EVALUACION])
);




GO



GO
CREATE NONCLUSTERED INDEX [IDX_EVALUACION_DETALLE1]
    ON [transaccional].[evaluacion_detalle]([ID_MATRICULA_ESTUDIANTE] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_EVALUACION]);

