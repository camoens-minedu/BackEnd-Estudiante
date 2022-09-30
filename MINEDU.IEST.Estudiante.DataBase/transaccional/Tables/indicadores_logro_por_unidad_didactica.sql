CREATE TABLE [transaccional].[indicadores_logro_por_unidad_didactica] (
    [ID_INDICADORES_LOGRO_POR_UNIDAD_DIDACTICA] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_UNIDAD_DIDACTICA]                       [dbo].[ID]           NOT NULL,
    [ID_INDICADORES_LOGRO_POR_CAPACIDAD]        [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                                 [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                                    [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                          [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                            [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                      [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                        [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_INDICADORES_LOGRO_POR_UNIDA] PRIMARY KEY NONCLUSTERED ([ID_INDICADORES_LOGRO_POR_UNIDAD_DIDACTICA] ASC),
    CONSTRAINT [FK_INDICADO_FK_INDICA_INDICADO] FOREIGN KEY ([ID_INDICADORES_LOGRO_POR_CAPACIDAD]) REFERENCES [transaccional].[indicadores_logro_por_capacidad] ([ID_INDICADORES_LOGRO_POR_CAPACIDAD]),
    CONSTRAINT [FK_INDICADO_FK_UNIDAD_UNIDAD_D] FOREIGN KEY ([ID_UNIDAD_DIDACTICA]) REFERENCES [transaccional].[unidad_didactica] ([ID_UNIDAD_DIDACTICA])
);

