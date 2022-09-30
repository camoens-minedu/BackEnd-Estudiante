CREATE TABLE [transaccional].[evaluacion_experiencia_formativa] (
    [ID_EVALUACION_EXPERIENCIA_FORMATIVA] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_MATRICULA_ESTUDIANTE]             [dbo].[ID]           NOT NULL,
    [ID_UNIDADES_DIDACTICAS_POR_ENFOQUE]  [dbo].[ID]           NOT NULL,
    [NOTA]                                [dbo].[DECIMAL_DOS]  NULL,
    [ES_ACTIVO]                           [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                              [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                    [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                      [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                  [dbo].[FECHA_TIEMPO] NULL,
    [CIERRE_EVALUACION]                   INT                  NULL,
    PRIMARY KEY CLUSTERED ([ID_EVALUACION_EXPERIENCIA_FORMATIVA] ASC),
    CONSTRAINT [FK_EVALUACION_EF_MATRICULA_ESTUDIANTE] FOREIGN KEY ([ID_MATRICULA_ESTUDIANTE]) REFERENCES [transaccional].[matricula_estudiante] ([ID_MATRICULA_ESTUDIANTE]),
    CONSTRAINT [FK_EVALUACION_EF_UNIDAD_DIDACTICA_POR_ENFOQUE] FOREIGN KEY ([ID_UNIDADES_DIDACTICAS_POR_ENFOQUE]) REFERENCES [transaccional].[unidades_didacticas_por_enfoque] ([ID_UNIDADES_DIDACTICAS_POR_ENFOQUE])
);



