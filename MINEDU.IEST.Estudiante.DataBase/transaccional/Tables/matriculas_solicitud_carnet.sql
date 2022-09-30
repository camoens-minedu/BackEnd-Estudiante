CREATE TABLE [transaccional].[matriculas_solicitud_carnet] (
    [ID_MATRICULAS_SOLICITUD_CARNET] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_SOLICITUD_CARNET]            [dbo].[ID]           NULL,
    [ID_MATRICULA_ESTUDIANTE]        [dbo].[ID]           NULL,
    [NRO_RD]                         VARCHAR (50)         NOT NULL,
    [ARCHIVO_RD]                     VARCHAR (50)         NOT NULL,
    [ARCHIVO_RUTA]                   VARCHAR (255)        NOT NULL,
    [ES_ACTIVO]                      BIT                  NOT NULL,
    [ESTADO]                         INT                  NOT NULL,
    [USUARIO_CREACION]               VARCHAR (20)         NOT NULL,
    [FECHA_CREACION]                 [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]           VARCHAR (20)         NULL,
    [FECHA_MODIFICACION]             [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_MATRICULAS_SOLICITUD_CARNET] PRIMARY KEY NONCLUSTERED ([ID_MATRICULAS_SOLICITUD_CARNET] ASC),
    FOREIGN KEY ([ID_MATRICULA_ESTUDIANTE]) REFERENCES [transaccional].[matricula_estudiante] ([ID_MATRICULA_ESTUDIANTE]),
    FOREIGN KEY ([ID_SOLICITUD_CARNET]) REFERENCES [transaccional].[solicitud_carnet] ([ID_SOLICITUD_CARNET])
);

