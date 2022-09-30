CREATE TABLE [transaccional].[resultados_por_postulante] (
    [ID_RESULTADOS_POR_POSTULANTE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_POSTULANTES_POR_MODALIDAD] [dbo].[ID]           NOT NULL,
    [ID_OPCIONES_POR_POSTULANTE]   [dbo].[ID]           NULL,
    [NOTA_RESULTADO]               [dbo].[DECIMAL_DOS]  NULL,
    [ES_ACTIVO]                    [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                       [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]             [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]               [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]         [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]           [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_RESULTADOS_POR_POSTULANTE] PRIMARY KEY NONCLUSTERED ([ID_RESULTADOS_POR_POSTULANTE] ASC),
    CONSTRAINT [FK_RESULT_POST_FK_OPCION_POST] FOREIGN KEY ([ID_OPCIONES_POR_POSTULANTE]) REFERENCES [transaccional].[opciones_por_postulante] ([ID_OPCIONES_POR_POSTULANTE]),
    CONSTRAINT [FK_RESULTAD_RELATIONS_POSTULAN] FOREIGN KEY ([ID_POSTULANTES_POR_MODALIDAD]) REFERENCES [transaccional].[postulantes_por_modalidad] ([ID_POSTULANTES_POR_MODALIDAD])
);

