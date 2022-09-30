CREATE TABLE [transaccional].[pago_institucion] (
    [ID_PAGO_INSTITUCION]                  [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_INSTITUCION]                       [dbo].[ID]           NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [TIPO_PAGO]                            [dbo].[ID]           NOT NULL,
    [ID_SEDE_INSTITUCION]                  [dbo].[ID]           NULL,
    [ID_CARRERA]                           [dbo].[ID]           NULL,
    [VALOR]                                [dbo].[DECIMAL_DOS]  NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_PAGO_INSTITUCION] PRIMARY KEY NONCLUSTERED ([ID_PAGO_INSTITUCION] ASC)
);

