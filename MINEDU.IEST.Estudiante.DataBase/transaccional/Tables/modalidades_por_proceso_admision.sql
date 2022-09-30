CREATE TABLE [transaccional].[modalidades_por_proceso_admision] (
    [ID_MODALIDADES_POR_PROCESO_ADMISION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PROCESO_ADMISION_PERIODO]         [dbo].[ID]           NOT NULL,
    [ID_MODALIDAD]                        [dbo].[ID]           NOT NULL,
    [NOMBRE_MODALIDAD_PROCESO]            [dbo].[NOMBRE_CORTO] NULL,
    [FECHA_INICIO_MODALIDAD]              [dbo].[FECHA]        NULL,
    [FECHA_FIN_MODALIDAD]                 [dbo].[FECHA]        NULL,
    [FECHA_INICIO_REGSITRO]               [dbo].[FECHA]        NULL,
    [FECHA_FIN_REGISTRO]                  [dbo].[FECHA]        NULL,
    [ES_ACTIVO]                           [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                              [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                    [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                      [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                  [dbo].[FECHA_TIEMPO] NULL,
    [NOTA_MINIMA]                         DECIMAL (10, 2)      NULL,
    CONSTRAINT [PK_MODALIDADES_POR_PROCESO_ADM] PRIMARY KEY NONCLUSTERED ([ID_MODALIDADES_POR_PROCESO_ADMISION] ASC),
    CONSTRAINT [FK_MODALIDA_RELATIONS_PROCESO_] FOREIGN KEY ([ID_PROCESO_ADMISION_PERIODO]) REFERENCES [transaccional].[proceso_admision_periodo] ([ID_PROCESO_ADMISION_PERIODO])
);

