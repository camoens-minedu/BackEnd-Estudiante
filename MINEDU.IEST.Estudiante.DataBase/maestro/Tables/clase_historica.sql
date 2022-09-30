CREATE TABLE [maestro].[clase_historica] (
    [ID_CLASE_HISTORICA]         [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_INSTITUCION]             [dbo].[ID]           NOT NULL,
    [ID_SEDE_INSTITUCION]        [dbo].[ID]           NOT NULL,
    [ID_PERIODO_LECTIVO]         [dbo].[ID]           NOT NULL,
    [PROGRAMA_ESTUDIO]           [dbo].[ID]           NULL,
    [PROGRAMA_ESTUDIO_HISTORICO] [dbo].[ID]           NULL,
    [PLAN_ESTUDIO]               [dbo].[ID]           NOT NULL,
    [CICLO]                      [dbo].[ID]           NOT NULL,
    [SECCION]                    [dbo].[ID]           NOT NULL,
    [TURNO]                      [dbo].[ID]           NOT NULL,
    [NIVEL_FORMATIVO]            [dbo].[ID]           NOT NULL,
    [USUARIO_CREACION]           [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]             [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]       [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]         [dbo].[FECHA_TIEMPO] NULL,
    [ESTADO]                     BIT                  NULL,
    CONSTRAINT [PK_CLASE_HISTORICA] PRIMARY KEY NONCLUSTERED ([ID_CLASE_HISTORICA] ASC)
);

