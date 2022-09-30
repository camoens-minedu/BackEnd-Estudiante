CREATE TABLE [maestro].[carrera_profesional] (
    [ID_CARRERA_PROFESIONAL]          [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [NOMBRE_CARRERA_PROFESIONAL]      [dbo].[DESCRIPCION]  NOT NULL,
    [DESCRIPCION_CARRERA_PROFESIONAL] [dbo].[DESCRIPCION]  NULL,
    [ESTADO]                          [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                  [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]            [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]              [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_CARRERA_PROFESIONAL] PRIMARY KEY NONCLUSTERED ([ID_CARRERA_PROFESIONAL] ASC)
);

