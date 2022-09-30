CREATE TABLE [maestro].[periodo_lectivo] (
    [ID_PERIODO_LECTIVO]     [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [CODIGO_PERIODO_LECTIVO] [dbo].[CODIGO_LARGO]  NULL,
    [ID_TIPO_OPCION]         [dbo].[ID]            NOT NULL,
    [FECHA_INICIO]           [dbo].[FECHA]         NOT NULL,
    [FECHA_FIN]              [dbo].[FECHA]         NOT NULL,
    [ANIO]                   [dbo].[NUMERO_ENTERO] NOT NULL,
    [ES_ASIGNADO]            [dbo].[BOOLEANO]      NULL,
    [ESTADO]                 [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]       [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]         [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]   [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]     [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_PERIODO_LECTIVO] PRIMARY KEY NONCLUSTERED ([ID_PERIODO_LECTIVO] ASC)
);

