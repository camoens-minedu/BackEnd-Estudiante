CREATE TABLE [transaccional].[evaluacion_extraordinaria_detalle] (
    [ID_EVALUACION_EXTRAORDINARIA_DETALLE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_EVALUACION_EXTRAORDINARIA]         [dbo].[ID]           NULL,
    [ID_UNIDAD_DIDACTICA]                  [dbo].[ID]           NULL,
    [NOTA]                                 DECIMAL (10, 2)      NULL,
    [ES_ACTIVO]                            BIT                  NOT NULL,
    [ESTADO]                               INT                  NOT NULL,
    [USUARIO_CREACION]                     VARCHAR (20)         NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 VARCHAR (20)         NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_EVALUACION_EXTRAORDINARIA_DETALLE] PRIMARY KEY NONCLUSTERED ([ID_EVALUACION_EXTRAORDINARIA_DETALLE] ASC),
    FOREIGN KEY ([ID_EVALUACION_EXTRAORDINARIA]) REFERENCES [transaccional].[evaluacion_extraordinaria] ([ID_EVALUACION_EXTRAORDINARIA]),
    FOREIGN KEY ([ID_UNIDAD_DIDACTICA]) REFERENCES [transaccional].[unidad_didactica] ([ID_UNIDAD_DIDACTICA])
);



