CREATE TABLE [maestro].[requisito] (
    [ID_REQUISITO]          [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PROCESO]            [dbo].[ID]           NOT NULL,
    [NOMBRE_REQUISITO]      [dbo].[NOMBRE_LARGO] NOT NULL,
    [DESCRIPCION_REQUISITO] [dbo].[DESCRIPCION]  NULL,
    [ESTADO]                [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]      [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]        [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]  [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]    [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_REQUISITO] PRIMARY KEY NONCLUSTERED ([ID_REQUISITO] ASC)
);

