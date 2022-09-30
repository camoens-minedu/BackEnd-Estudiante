CREATE TABLE [transaccional].[resoluciones_por_periodo_lectivo_institucion] (
    [ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_RESOLUCION]                                   [dbo].[ID]           NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION]            [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                                       [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                                          [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                                [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                                  [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                            [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                              [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_RESOLUCIONES_POR_PERIODO_LE] PRIMARY KEY NONCLUSTERED ([ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION] ASC),
    CONSTRAINT [FK_RESOLUCI_RELATIONS_PERIODOS] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]),
    CONSTRAINT [FK_RESOLUCI_RELATIONS_RESOLUCI] FOREIGN KEY ([ID_RESOLUCION]) REFERENCES [maestro].[resolucion] ([ID_RESOLUCION])
);

