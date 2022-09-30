CREATE TABLE [sistema].[parametro] (
    [ID_PARAMETRO]         [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [CODIGO_PARAMETRO]     [dbo].[NUMERO_ENTERO] NULL,
    [NOMBRE_PARAMETRO]     [dbo].[NOMBRE_LARGO]  NULL,
    [VALOR_PARAMETRO]      [dbo].[CODIGO_CORTO]  NULL,
    [DESCRIPCION]          [dbo].[DESCRIPCION]   NULL,
    [ESTADO]               [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]     [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]       [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION] [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]   [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_PARAMETRO] PRIMARY KEY NONCLUSTERED ([ID_PARAMETRO] ASC)
);



