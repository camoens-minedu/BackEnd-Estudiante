CREATE TABLE [maestro].[tipos_modalidad_por_institucion] (
    [ID_TIPOS_MODALIDAD_POR_INSTITUCION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_TIPO_MODALIDAD]                  [dbo].[ID]           NOT NULL,
    [ID_INSTITUCION]                     [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                          [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                             [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                   [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                     [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]               [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                 [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_TIPOS_MODALIDAD_POR_INSTITU] PRIMARY KEY NONCLUSTERED ([ID_TIPOS_MODALIDAD_POR_INSTITUCION] ASC),
    CONSTRAINT [FK_TIPOS_MO_RELATIONS_TIPO_MOD] FOREIGN KEY ([ID_TIPO_MODALIDAD]) REFERENCES [maestro].[tipo_modalidad] ([ID_TIPO_MODALIDAD])
);

