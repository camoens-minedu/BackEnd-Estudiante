CREATE TABLE [transaccional].[exportador_datos_configuracion] (
    [ID_EXPORTADOR_DATOS_CONFIGURACION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_EXPORTADOR_DATOS]               [dbo].[ID]           NOT NULL,
    [ID_INSTITUCION]                    [dbo].[ID]           NOT NULL,
    [NOMBRE_CONFIGURACION]              VARCHAR (100)        NOT NULL,
    [ES_ACTIVO]                         [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                            [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                  [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                    [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]              [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_exportador_datos_configuracion] PRIMARY KEY CLUSTERED ([ID_EXPORTADOR_DATOS_CONFIGURACION] ASC),
    CONSTRAINT [FK_exportador_datos_configuracion_exportador_datos] FOREIGN KEY ([ID_EXPORTADOR_DATOS]) REFERENCES [transaccional].[exportador_datos] ([ID_EXPORTADOR_DATOS])
);

