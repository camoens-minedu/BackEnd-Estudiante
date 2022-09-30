CREATE TABLE [transaccional].[periodo_academico] (
    [ID_PERIODO_ACADEMICO]                 [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [NOMBRE_PERIODO_ACADEMICO]             [dbo].[NOMBRE_CORTO] NULL,
    [FECHA_INICIO]                         [dbo].[FECHA]        NULL,
    [FECHA_FIN]                            [dbo].[FECHA]        NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_PERIODO_ACADEMICO] PRIMARY KEY NONCLUSTERED ([ID_PERIODO_ACADEMICO] ASC),
    CONSTRAINT [FK_PERIODO__RELATIONS_PERIODOS] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION])
);


GO
CREATE NONCLUSTERED INDEX [IDX_PERIODO_ACADEMICO2]
    ON [transaccional].[periodo_academico]([ID_PERIODOS_LECTIVOS_POR_INSTITUCION] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_PERIODO_ACADEMICO], [NOMBRE_PERIODO_ACADEMICO], [FECHA_INICIO], [FECHA_FIN]);


GO
CREATE NONCLUSTERED INDEX [IDX_PERIODO_ACADEMICO1]
    ON [transaccional].[periodo_academico]([ID_PERIODOS_LECTIVOS_POR_INSTITUCION] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_PERIODO_ACADEMICO], [NOMBRE_PERIODO_ACADEMICO]);

