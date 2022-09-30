CREATE TABLE [sistema].[enumerado_historico] (
    [ID_ENUMERADO_HISTORICO]           [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_INSTITUCION]                   [dbo].[ID]            NULL,
    [CODIGO_GRUPO_ENUMERADO_HISTORICO] [dbo].[ID]            NOT NULL,
    [CODIGO_ENUMERADO_HISTORICO_PADRE] [dbo].[NUMERO_ENTERO] NULL,
    [VALOR_ENUMERADO_HISTORICO]        [dbo].[NOMBRE_LARGO]  NULL,
    [ESTADO_ENUMERADO_HISTORICO]       [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                 [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                   [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]             [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]               [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_ENUMERADO_HISTORICO] PRIMARY KEY NONCLUSTERED ([ID_ENUMERADO_HISTORICO] ASC),
    FOREIGN KEY ([CODIGO_ENUMERADO_HISTORICO_PADRE]) REFERENCES [sistema].[enumerado_historico] ([ID_ENUMERADO_HISTORICO])
);

