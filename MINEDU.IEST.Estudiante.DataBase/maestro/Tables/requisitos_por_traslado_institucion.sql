CREATE TABLE [maestro].[requisitos_por_traslado_institucion] (
    [ID_REQUISITOS_POR_TRASLADO_INSTITUCION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_REQUISITO]                           [dbo].[ID]           NOT NULL,
    [ID_INSTITUCION]                         [dbo].[ID]           NOT NULL,
    [ESTADO]                                 [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                       [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                         [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                   [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                     [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_REQUISITOS_POR_TRASLADO_INS] PRIMARY KEY NONCLUSTERED ([ID_REQUISITOS_POR_TRASLADO_INSTITUCION] ASC),
    CONSTRAINT [FK_REQUISIT_RELATIONS_REQUISIT] FOREIGN KEY ([ID_REQUISITO]) REFERENCES [maestro].[requisito] ([ID_REQUISITO])
);

