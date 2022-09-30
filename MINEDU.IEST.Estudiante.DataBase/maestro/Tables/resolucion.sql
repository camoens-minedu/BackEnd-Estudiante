CREATE TABLE [maestro].[resolucion] (
    [ID_RESOLUCION]        [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [NUMERO_RESOLUCION]    [dbo].[NOMBRE_CORTO] NULL,
    [ARCHIVO_RESOLUCION]   [dbo].[NOMBRE_CORTO] NULL,
    [ID_TIPO_RESOLUCION]   [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION] [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_RESOLUCION] PRIMARY KEY NONCLUSTERED ([ID_RESOLUCION] ASC)
);

