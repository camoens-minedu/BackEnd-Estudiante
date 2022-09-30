CREATE TABLE [transaccional].[unidades_didacticas_por_programacion_clase] (
    [ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_UNIDADES_DIDACTICAS_POR_ENFOQUE]            [dbo].[ID]           NOT NULL,
    [ID_PROGRAMACION_CLASE]                         [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                                     [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                                        [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                              [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                                [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                          [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                            [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_UNIDADES_DIDACTICAS_POR_PRO] PRIMARY KEY NONCLUSTERED ([ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE] ASC),
    CONSTRAINT [FK_UNIDADES_DIDACTICAS_POR_ENFOQUE_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE] FOREIGN KEY ([ID_UNIDADES_DIDACTICAS_POR_ENFOQUE]) REFERENCES [transaccional].[unidades_didacticas_por_enfoque] ([ID_UNIDADES_DIDACTICAS_POR_ENFOQUE]),
    CONSTRAINT [FK_UNIDADES_FK_PROGRA_PROGRAMA] FOREIGN KEY ([ID_PROGRAMACION_CLASE]) REFERENCES [transaccional].[programacion_clase] ([ID_PROGRAMACION_CLASE])
);


GO
CREATE NONCLUSTERED INDEX [IDX_UNIDADES_DIDACTICAS_PROG_CLAS2]
    ON [transaccional].[unidades_didacticas_por_programacion_clase]([ID_PROGRAMACION_CLASE] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_UNIDADES_DIDACTICAS_POR_ENFOQUE]);


GO
CREATE NONCLUSTERED INDEX [IDX_UNIDADES_DIDACTICAS_PROG_CLAS1]
    ON [transaccional].[unidades_didacticas_por_programacion_clase]([ID_UNIDADES_DIDACTICAS_POR_ENFOQUE] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_PROGRAMACION_CLASE]);

