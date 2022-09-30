CREATE TABLE [transaccional].[distribucion_evaluacion_admision_detalle] (
    [ID_DISTRIBUCION_EVALUACION_ADMISION_DETALLE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_DISTRIBUCION_EXAMEN_ADMISION]             [dbo].[ID]           NOT NULL,
    [ID_POSTULANTES_POR_MODALIDAD]                [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                                   [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                                      [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                            [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                              [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                        [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                          [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_DISTRIBUCION_EVALUACION_ADM] PRIMARY KEY NONCLUSTERED ([ID_DISTRIBUCION_EVALUACION_ADMISION_DETALLE] ASC),
    CONSTRAINT [FK_DISTRIBU_RELATIONS_DISTRIBU] FOREIGN KEY ([ID_DISTRIBUCION_EXAMEN_ADMISION]) REFERENCES [transaccional].[distribucion_examen_admision] ([ID_DISTRIBUCION_EXAMEN_ADMISION]),
    CONSTRAINT [FK_DISTRIBU_RELATIONS_POSTULAN] FOREIGN KEY ([ID_POSTULANTES_POR_MODALIDAD]) REFERENCES [transaccional].[postulantes_por_modalidad] ([ID_POSTULANTES_POR_MODALIDAD])
);

