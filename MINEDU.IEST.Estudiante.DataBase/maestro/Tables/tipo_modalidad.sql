CREATE TABLE [maestro].[tipo_modalidad] (
    [ID_TIPO_MODALIDAD]     [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_MODALIDAD]          [dbo].[ID]           NOT NULL,
    [NOMBRE_TIPO_MODALIDAD] [dbo].[NOMBRE_LARGO] NULL,
    [ESTADO]                [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]      [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]        [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]  [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]    [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_TIPO_MODALIDAD] PRIMARY KEY NONCLUSTERED ([ID_TIPO_MODALIDAD] ASC)
);

