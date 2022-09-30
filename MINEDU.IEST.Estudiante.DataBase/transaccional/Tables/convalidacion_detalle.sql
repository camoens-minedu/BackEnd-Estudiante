CREATE TABLE [transaccional].[convalidacion_detalle] (
    [ID_CONVALIDACION_DETALLE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_CONVALIDACION]         [dbo].[ID]           NOT NULL,
    [ID_UNIDAD_DIDACTICA]      [dbo].[ID]           NOT NULL,
    [NOTA]                     [dbo].[DECIMAL_DOS]  NOT NULL,
    [ES_ACTIVO]                [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                   [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]         [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]           [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]     [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]       [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_CONVALIDACION_DETALLE] PRIMARY KEY NONCLUSTERED ([ID_CONVALIDACION_DETALLE] ASC),
    CONSTRAINT [FK_CONVALID_RELATIONS_CONVALID] FOREIGN KEY ([ID_CONVALIDACION]) REFERENCES [transaccional].[convalidacion] ([ID_CONVALIDACION]),
    CONSTRAINT [FK_CONVALID_RELATIONS_UNIDAD_D] FOREIGN KEY ([ID_UNIDAD_DIDACTICA]) REFERENCES [transaccional].[unidad_didactica] ([ID_UNIDAD_DIDACTICA])
);

