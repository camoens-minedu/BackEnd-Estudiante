CREATE TABLE [maestro].[cronograma_meta_atencion] (
    [ID_CRONOGRAMA_META_ATENCION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PERIODO_LECTIVO]          [dbo].[ID]           NOT NULL,
    [NOMBRE_CRONOGRAMA_META]      [dbo].[NOMBRE_LARGO] NULL,
    [FECHA_INICIO]                [dbo].[FECHA]        NULL,
    [FECHA_FIN]                   [dbo].[FECHA]        NULL,
    [ESTADO]                      [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]            [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]              [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]        [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]          [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_CRONOGRAMA_META_ATENCION] PRIMARY KEY NONCLUSTERED ([ID_CRONOGRAMA_META_ATENCION] ASC),
    CONSTRAINT [FK_CRONOGRA_RELATIONS_PERIODO_] FOREIGN KEY ([ID_PERIODO_LECTIVO]) REFERENCES [maestro].[periodo_lectivo] ([ID_PERIODO_LECTIVO])
);

