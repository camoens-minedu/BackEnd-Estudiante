CREATE TABLE [maestro].[enfoque] (
    [ID_ENFOQUE]           [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_MODALIDAD_ESTUDIO] [dbo].[ID_ENUMERADO] NOT NULL,
    [NOMBRE_ENFOQUE]       [dbo].[NOMBRE_CORTO] NOT NULL,
    [ESTADO]               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION] [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_ENFOQUE] PRIMARY KEY NONCLUSTERED ([ID_ENFOQUE] ASC)
);

