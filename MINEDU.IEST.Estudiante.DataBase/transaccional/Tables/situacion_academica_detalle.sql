CREATE TABLE [transaccional].[situacion_academica_detalle] (
    [ID_SITUACION_ACADEMICA_DETALLE]    [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_SITUACION_ACADEMICA_ESTUDIANTE] [dbo].[ID]           NOT NULL,
    [ID_UNIDAD_DIDACTICA]               [dbo].[ID]           NOT NULL,
    [NOTA]                              [dbo].[DECIMAL_DOS]  NULL,
    [ES_ACTIVO]                         [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                            [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                  [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                    [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]              [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_SITUACION_ACADEMICA_DETALLE] PRIMARY KEY NONCLUSTERED ([ID_SITUACION_ACADEMICA_DETALLE] ASC),
    CONSTRAINT [FK_SITUACIO_FK_SITUAC_SITUACIO] FOREIGN KEY ([ID_SITUACION_ACADEMICA_ESTUDIANTE]) REFERENCES [transaccional].[situacion_academica_estudiante] ([ID_SITUACION_ACADEMICA_ESTUDIANTE]),
    CONSTRAINT [FK_SITUACIO_FK_UNIDAD_UNIDAD_D] FOREIGN KEY ([ID_UNIDAD_DIDACTICA]) REFERENCES [transaccional].[unidad_didactica] ([ID_UNIDAD_DIDACTICA])
);

