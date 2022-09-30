CREATE TABLE [transaccional].[periodos_lectivos_por_institucion] (
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PERIODO_LECTIVO]                   [dbo].[ID]           NOT NULL,
    [ID_INSTITUCION]                       [dbo].[ID]           NOT NULL,
    [NOMBRE_PERIODO_LECTIVO_INSTITUCION]   [dbo].[NOMBRE_CORTO] NULL,
    [FECHA_INICIO_INSTITUCION]             [dbo].[FECHA]        NULL,
    [FECHA_FIN_INSTITUCION]                [dbo].[FECHA]        NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_PERIODOS_LECTIVOS_POR_INSTI] PRIMARY KEY NONCLUSTERED ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION] ASC),
    CONSTRAINT [FK_PERIODOS_RELATIONS_PERIODO_] FOREIGN KEY ([ID_PERIODO_LECTIVO]) REFERENCES [maestro].[periodo_lectivo] ([ID_PERIODO_LECTIVO])
);

