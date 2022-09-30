CREATE TABLE [transaccional].[proceso_admision_periodo] (
    [ID_PROCESO_ADMISION_PERIODO]          [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [NOMBRE_PROCESO_ADMISION]              [dbo].[NOMBRE_LARGO] NOT NULL,
    [FECHA_INICIO]                         [dbo].[FECHA]        NULL,
    [FECHA_FIN]                            [dbo].[FECHA]        NULL,
    [MODALIDADES]                          [dbo].[CODIGO_LARGO] NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_PROCESO_ADMISION_PERIODO] PRIMARY KEY NONCLUSTERED ([ID_PROCESO_ADMISION_PERIODO] ASC),
    CONSTRAINT [FK_PROCESO__RELATIONS_PERIODOS] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION])
);

