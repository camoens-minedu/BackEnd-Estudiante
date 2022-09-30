CREATE TABLE [transaccional].[traslado_estudiante] (
    [ID_TRASLADO_ESTUDIANTE]          [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_ESTUDIANTE_INSTITUCION]       INT                  CONSTRAINT [DF__traslado___ID_ES__012DFE44] DEFAULT ('') NOT NULL,
    [ID_SITUACION_ACADEMICA_ORIGEN]   [dbo].[ID]           NOT NULL,
    [ID_SITUACION_ACADEMICA_DESTINO]  [dbo].[ID]           NOT NULL,
    [ID_TIPO_TRASLADO]                [dbo].[ID]           NOT NULL,
    [ID_LIBERACION_ESTUDIANTE]        [dbo].[ID]           CONSTRAINT [DF__traslado___ID_LI__07A5F1A9] DEFAULT ('0') NOT NULL,
    [FECHA_INICIO]                    [dbo].[FECHA]        NULL,
    [FECHA_FIN]                       [dbo].[FECHA]        NULL,
    [ES_ACTIVO]                       [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                          [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                  [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]            [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]              [dbo].[FECHA_TIEMPO] NULL,
    [ID_TIPO_SOLICITUD]               INT                  NULL,
    [ES_CONVALIDACION_EXONERADA]      BIT                  NULL,
    [ID_ESTUDIANTE_INSTITUCION_NUEVO] [dbo].[ID]           NULL,
    CONSTRAINT [PK_TRASLADO_ESTUDIANTE] PRIMARY KEY NONCLUSTERED ([ID_TRASLADO_ESTUDIANTE] ASC)
);

