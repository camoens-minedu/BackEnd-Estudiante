CREATE TABLE [transaccional].[unidad_didactica_detalle] (
    [ID_UNIDAD_DIDACTICA_DETALLE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_UNIDAD_DIDACTICA]         [dbo].[ID]           NOT NULL,
    [CODIGO_PREDECESORA]          [dbo].[CODIGO_LARGO] NOT NULL,
    [ES_ACTIVO]                   [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                      [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]            [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]              [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]        [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]          [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_UNIDAD_DIDACTICA_DETALLE] PRIMARY KEY NONCLUSTERED ([ID_UNIDAD_DIDACTICA_DETALLE] ASC),
    CONSTRAINT [FK_UNID_DIDAC_DET_FK_UNID_DIDAC] FOREIGN KEY ([ID_UNIDAD_DIDACTICA]) REFERENCES [transaccional].[unidad_didactica] ([ID_UNIDAD_DIDACTICA])
);

