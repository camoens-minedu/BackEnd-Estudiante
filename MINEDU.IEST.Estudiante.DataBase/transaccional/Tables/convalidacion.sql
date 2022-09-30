CREATE TABLE [transaccional].[convalidacion] (
    [ID_CONVALIDACION]                     [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [ID_ESTUDIANTE_INSTITUCION]            [dbo].[ID]           NOT NULL,
    [ID_TRASLADO_ESTUDIANTE]               [dbo].[ID]           NULL,
    [ID_TIPO_CONVALIDACION]                [dbo].[ID]           NOT NULL,
    [ARCHIVO_CONVALIDACION]                [dbo].[NOMBRE_CORTO] NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    [NRO_RD]                               VARCHAR (50)         NOT NULL,
    [ARCHIVO_RD]                           VARCHAR (50)         DEFAULT ('NULL') NOT NULL,
    [ARCHIVO_RUTA]                         VARCHAR (255)        DEFAULT ('NULL') NOT NULL,
    CONSTRAINT [PK_CONVALIDACION] PRIMARY KEY NONCLUSTERED ([ID_CONVALIDACION] ASC)
);

