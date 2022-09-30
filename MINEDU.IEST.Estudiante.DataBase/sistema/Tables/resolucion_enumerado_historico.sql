CREATE TABLE [sistema].[resolucion_enumerado_historico] (
    [ID_RESOLUCION_ENUMERADO_HISTORICO] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_ENUMERADO_HISTORICO]            [dbo].[ID]           NOT NULL,
    [NRO_RD]                            [dbo].[NOMBRE_LARGO] NULL,
    [ARCHIVO_RD]                        [dbo].[NOMBRE_LARGO] NULL,
    [ARCHIVO_RUTA]                      [dbo].[NOMBRE_LARGO] NULL,
    [USUARIO_CREACION]                  [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                    [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]              [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                [dbo].[FECHA_TIEMPO] NULL,
    [ESTADO]                            BIT                  NULL,
    CONSTRAINT [PK_RESOLUCION_ENUMERADO_HISTORICO] PRIMARY KEY NONCLUSTERED ([ID_RESOLUCION_ENUMERADO_HISTORICO] ASC)
);

