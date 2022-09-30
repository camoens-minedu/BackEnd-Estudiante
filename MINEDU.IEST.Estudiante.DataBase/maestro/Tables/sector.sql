CREATE TABLE [maestro].[sector] (
    [ID_SECTOR]            [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [CODIGO_SECTOR]        [dbo].[CODIGO_CORTO] NOT NULL,
    [NOMBRE_SECTOR]        [dbo].[NOMBRE_CORTO] NOT NULL,
    [DESCRIPCION_SECTOR]   [dbo].[DESCRIPCION]  NULL,
    [ESTADO]               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION] [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_SECTOR] PRIMARY KEY NONCLUSTERED ([ID_SECTOR] ASC)
);

