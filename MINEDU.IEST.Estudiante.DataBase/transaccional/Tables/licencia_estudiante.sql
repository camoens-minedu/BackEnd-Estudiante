CREATE TABLE [transaccional].[licencia_estudiante] (
    [ID_LICENCIA_ESTUDIANTE]               [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_ESTUDIANTE_INSTITUCION]            [dbo].[ID]           NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [ID_TIPO_LICENCIA]                     [dbo].[ID]           NOT NULL,
    [ID_TIEMPO_PERIODO_LICENCIA]           INT                  NULL,
    [FECHA_INICIO]                         [dbo].[FECHA]        NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    [ARCHIVO_RD]                           VARCHAR (50)         DEFAULT ('ARCHIVO_RD') NOT NULL,
    [ARCHIVO_RUTA]                         VARCHAR (255)        DEFAULT ('ARCHIVO_RUTA') NOT NULL,
    CONSTRAINT [PK_LICENCIA_ESTUDIANTE] PRIMARY KEY NONCLUSTERED ([ID_LICENCIA_ESTUDIANTE] ASC)
);

