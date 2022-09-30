CREATE TABLE [maestro].[requisitos_por_tipo_modalidad] (
    [ID_REQUISITOS_POR_TIPO_MODALIDAD]   [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_TIPOS_MODALIDAD_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [ID_REQUISITO]                       [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                          [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                             [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                   [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                     [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]               [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                 [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_REQUISITOS_POR_TIPO_MODALID] PRIMARY KEY NONCLUSTERED ([ID_REQUISITOS_POR_TIPO_MODALIDAD] ASC),
    CONSTRAINT [FK_REQUISIT_RELATIONS_TIPOS_MO] FOREIGN KEY ([ID_TIPOS_MODALIDAD_POR_INSTITUCION]) REFERENCES [maestro].[tipos_modalidad_por_institucion] ([ID_TIPOS_MODALIDAD_POR_INSTITUCION]),
    CONSTRAINT [FK_REQUISITO_REQUISITOS_POR_TIPO_MODALIDAD] FOREIGN KEY ([ID_REQUISITO]) REFERENCES [maestro].[requisito] ([ID_REQUISITO])
);

