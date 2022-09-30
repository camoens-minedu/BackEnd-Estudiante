CREATE TABLE [transaccional].[pre_requisitos_por_unidad_didactica] (
    [ID_PRE_REQUISITOS_POR_UNIDAD_DIDACTICA] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_UNIDAD_DIDACTICA]                    [dbo].[ID]           NOT NULL,
    [ID_UNIDAD_DIDACTICA_PRE_REQUISITO]      [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                              [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                                 [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                       [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                         [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                   [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                     [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_PRE_REQUISITOS_POR_UNIDAD_D] PRIMARY KEY NONCLUSTERED ([ID_PRE_REQUISITOS_POR_UNIDAD_DIDACTICA] ASC),
    CONSTRAINT [FK_UNIDAD_DIDACTICA_PRE_REQUISITOS_POR_UD] FOREIGN KEY ([ID_UNIDAD_DIDACTICA]) REFERENCES [transaccional].[unidad_didactica] ([ID_UNIDAD_DIDACTICA]),
    CONSTRAINT [FK_UNIDAD_DIDACTICA_PRE_REQUISITOS_POR_UD_2] FOREIGN KEY ([ID_UNIDAD_DIDACTICA_PRE_REQUISITO]) REFERENCES [transaccional].[unidad_didactica] ([ID_UNIDAD_DIDACTICA])
);

