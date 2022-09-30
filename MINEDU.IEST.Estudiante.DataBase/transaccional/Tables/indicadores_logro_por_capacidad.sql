CREATE TABLE [transaccional].[indicadores_logro_por_capacidad] (
    [ID_INDICADORES_LOGRO_POR_CAPACIDAD] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_CAPACIDADES_POR_COMPONENTE]      [dbo].[ID]           NOT NULL,
    [CODIGO_INDICADOR_LOGRO]             [dbo].[CODIGO_LARGO] NULL,
    [NOMBRE_INDICADOR]                   [dbo].[NOMBRE_LARGO] NOT NULL,
    [DESCRIPCION]                        [dbo].[DESCRIPCION]  NULL,
    [ES_ACTIVO]                          [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                             [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                   [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                     [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]               [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                 [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_INDICADORES_LOGRO_POR_CAPAC] PRIMARY KEY NONCLUSTERED ([ID_INDICADORES_LOGRO_POR_CAPACIDAD] ASC),
    CONSTRAINT [FK_INDICADO_FK_CAPACI_CAPACIDA] FOREIGN KEY ([ID_CAPACIDADES_POR_COMPONENTE]) REFERENCES [transaccional].[capacidades_por_componente] ([ID_CAPACIDADES_POR_COMPONENTE])
);

