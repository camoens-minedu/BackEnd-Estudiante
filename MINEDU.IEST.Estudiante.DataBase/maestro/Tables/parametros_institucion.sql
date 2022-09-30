CREATE TABLE [maestro].[parametros_institucion] (
    [ID_PARAMETROS_INSTITUCION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_INSTITUCION]            [dbo].[ID]           NOT NULL,
    [NOMBRE_PARAMETRO]          [dbo].[NOMBRE_CORTO] NOT NULL,
    [VALOR_PARAMETRO]           [dbo].[CODIGO_LARGO] NOT NULL,
    [ESTADO]                    [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]          [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]            [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]      [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]        [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_PARAMETROS_INSTITUCION] PRIMARY KEY NONCLUSTERED ([ID_PARAMETROS_INSTITUCION] ASC)
);

