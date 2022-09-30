CREATE TABLE [transaccional].[tipos_modalidad_por_proceso_admision] (
    [ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION] [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_PROCESO_ADMISION_PERIODO]             [dbo].[ID]            NOT NULL,
    [ID_TIPOS_MODALIDAD_POR_INSTITUCION]      [dbo].[ID]            NOT NULL,
    [META]                                    [dbo].[NUMERO_ENTERO] NOT NULL,
    [ID_TIPO_META]                            [dbo].[ID_ENUMERADO]  NOT NULL,
    [ES_ACTIVO]                               [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                                  [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                        [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                          [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]                    [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                      [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_TIPOS_MODALIDAD_POR_PROCESO] PRIMARY KEY NONCLUSTERED ([ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION] ASC),
    CONSTRAINT [FK_TIPOS_MO_RELATIONS_PROCESO_] FOREIGN KEY ([ID_PROCESO_ADMISION_PERIODO]) REFERENCES [transaccional].[proceso_admision_periodo] ([ID_PROCESO_ADMISION_PERIODO]),
    CONSTRAINT [FK_TIPOS_MO_RELATIONS_TIPOS_MO] FOREIGN KEY ([ID_TIPOS_MODALIDAD_POR_INSTITUCION]) REFERENCES [maestro].[tipos_modalidad_por_institucion] ([ID_TIPOS_MODALIDAD_POR_INSTITUCION])
);

