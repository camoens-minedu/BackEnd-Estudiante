CREATE TABLE [transaccional].[exportador_datos_configuracion_detalle] (
    [ID_EXPORTADOR_DATOS_CONFIGURACION_DETALLE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_EXPORTADOR_DATOS_CONFIGURACION]         [dbo].[ID]           NOT NULL,
    [ID_EXPORTADOR_DATOS_DETALLE]               [dbo].[ID]           NOT NULL,
    [MOSTRAR_COLUMNA_A_EXPORTAR]                [dbo].[BOOLEANO]     NULL,
    [ORDEN_COLUMNA_A_EXPORTAR]                  INT                  NULL,
    [ES_ACTIVO]                                 [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                                    [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                          [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                            [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                      [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                        [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_exportador_datos_configuracion_detalle] PRIMARY KEY CLUSTERED ([ID_EXPORTADOR_DATOS_CONFIGURACION_DETALLE] ASC),
    CONSTRAINT [FK_exportador_datos_configuracion_detalle_exportador_datos_configuracion] FOREIGN KEY ([ID_EXPORTADOR_DATOS_CONFIGURACION]) REFERENCES [transaccional].[exportador_datos_configuracion] ([ID_EXPORTADOR_DATOS_CONFIGURACION])
);

