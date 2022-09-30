CREATE TABLE [maestro].[unidad_competencia] (
    [ID_UNIDAD_COMPETENCIA]          [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_ACTIVIDAD_ECONOMICA]         [dbo].[ID]           NULL,
    [CODIGO_UNIDAD_COMPETENCIA]      [dbo].[CODIGO_CORTO] NULL,
    [NOMBRE_UNIDAD_COMPETENCIA]      NVARCHAR (MAX)       NULL,
    [DESCRIPCION_UNIDAD_COMPETENCIA] [dbo].[DESCRIPCION]  NULL,
    [ES_ACTIVO]                      [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                         [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]               [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                 [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]           [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]             [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_UNIDAD_COMPETENCIA] PRIMARY KEY NONCLUSTERED ([ID_UNIDAD_COMPETENCIA] ASC),
    CONSTRAINT [FK_UNIDAD_C_RELATIONS_ACTIVIDA] FOREIGN KEY ([ID_ACTIVIDAD_ECONOMICA]) REFERENCES [maestro].[actividad_economica] ([ID_ACTIVIDAD_ECONOMICA])
);

