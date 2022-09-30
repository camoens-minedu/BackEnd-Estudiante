CREATE TABLE [transaccional].[traslado_estudiante_detalle] (
    [ID_TRASLADO_ESTUDIANTE_DETALLE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_TRASLADO_ESTUDIANTE]         [dbo].[ID]           NOT NULL,
    [ID_INSTITUCION]                 [dbo].[ID]           NOT NULL,
    [FECHA]                          [dbo].[FECHA]        NULL,
    [ES_ACTIVO]                      [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                         [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]               [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                 [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]           [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]             [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_TRASLADO_ESTUDIANTE_DETALLE] PRIMARY KEY NONCLUSTERED ([ID_TRASLADO_ESTUDIANTE_DETALLE] ASC),
    CONSTRAINT [FK_TRASLADO_RELATIONS_TRASLADO] FOREIGN KEY ([ID_TRASLADO_ESTUDIANTE]) REFERENCES [transaccional].[traslado_estudiante] ([ID_TRASLADO_ESTUDIANTE])
);

