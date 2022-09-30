CREATE TABLE [transaccional].[unidad_competencias_por_modulo] (
    [ID_UNIDAD_COMPETENCIAS_POR_MODULO] [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_MODULO]                         [dbo].[ID]            NOT NULL,
    [ID_UNIDAD_COMPETENCIA]             [dbo].[ID]            NOT NULL,
    [ORDEN_VISUALIZACION]               [dbo].[NUMERO_ENTERO] NULL,
    [ES_ACTIVO]                         [dbo].[BOOLEANO]      NULL,
    [ESTADO]                            [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                  [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                    [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]              [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_UNIDAD_COMPETENCIAS_POR_MOD] PRIMARY KEY NONCLUSTERED ([ID_UNIDAD_COMPETENCIAS_POR_MODULO] ASC),
    CONSTRAINT [FK_UNIDAD_C_RELATIONS_MODULO] FOREIGN KEY ([ID_MODULO]) REFERENCES [transaccional].[modulo] ([ID_MODULO]),
    CONSTRAINT [FK_UNIDAD_COMP_MOD_FK_UNIDAD_COMP] FOREIGN KEY ([ID_UNIDAD_COMPETENCIA]) REFERENCES [maestro].[unidad_competencia] ([ID_UNIDAD_COMPETENCIA])
);

