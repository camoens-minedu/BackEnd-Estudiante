CREATE TABLE [transaccional].[solicitud_carnet] (
    [ID_SOLICITUD_CARNET]                  [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NULL,
    [NRO_SOLICITUD]                        VARCHAR (50)         NOT NULL,
    [ESTADO_ACTUAL]                        VARCHAR (50)         NOT NULL,
    [OBSERVACIONES]                        VARCHAR (255)        NOT NULL,
    [ES_ACTIVO]                            BIT                  NOT NULL,
    [ESTADO]                               INT                  NOT NULL,
    [USUARIO_CREACION]                     VARCHAR (20)         NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 VARCHAR (20)         NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_SOLICITUD_CARNET] PRIMARY KEY NONCLUSTERED ([ID_SOLICITUD_CARNET] ASC),
    FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION])
);

