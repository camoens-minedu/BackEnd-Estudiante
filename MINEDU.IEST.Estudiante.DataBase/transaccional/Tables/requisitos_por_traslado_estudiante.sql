CREATE TABLE [transaccional].[requisitos_por_traslado_estudiante] (
    [ID_REQUISITOS_POR_TRASLADO_ESTUDIANTE]  [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_REQUISITOS_POR_TRASLADO_INSTITUCION] [dbo].[ID]           NOT NULL,
    [ID_TRASLADO_ESTUDIANTE]                 [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                              [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                                 [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                       [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                         [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                   [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                     [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_REQUISITOS_POR_TRASLADO_EST] PRIMARY KEY NONCLUSTERED ([ID_REQUISITOS_POR_TRASLADO_ESTUDIANTE] ASC),
    CONSTRAINT [FK_REQUISIT_RELATIONS_TRASLADO] FOREIGN KEY ([ID_TRASLADO_ESTUDIANTE]) REFERENCES [transaccional].[traslado_estudiante] ([ID_TRASLADO_ESTUDIANTE]),
    CONSTRAINT [FK_REQUISITOS_POR_TRANSALADO_INTITUCION_ESTUDIANTE] FOREIGN KEY ([ID_REQUISITOS_POR_TRASLADO_INSTITUCION]) REFERENCES [maestro].[requisitos_por_traslado_institucion] ([ID_REQUISITOS_POR_TRASLADO_INSTITUCION])
);

