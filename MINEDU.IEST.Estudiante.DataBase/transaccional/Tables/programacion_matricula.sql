CREATE TABLE [transaccional].[programacion_matricula] (
    [ID_PROGRAMACION_MATRICULA]            [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [ID_TIPO_MATRICULA]                    [dbo].[ID]           NOT NULL,
    [FECHA_INICIO]                         [dbo].[FECHA]        NULL,
    [FECHA_FIN]                            [dbo].[FECHA]        NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    [CERRADO]                              BIT                  DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PROGRAMACION_MATRICULA] PRIMARY KEY NONCLUSTERED ([ID_PROGRAMACION_MATRICULA] ASC),
    CONSTRAINT [FK_PROGRAMA_FK_PERIOD_PERIODOS] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION])
);

