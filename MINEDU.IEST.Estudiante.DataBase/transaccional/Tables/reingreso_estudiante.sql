CREATE TABLE [transaccional].[reingreso_estudiante] (
    [ID_REINGRESO_ESTUDIANTE]              [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_LICENCIA_ESTUDIANTE]               [dbo].[ID]           NULL,
    [ID_RESERVA_MATRICULA]                 [dbo].[ID]           NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [FECHA_FIN]                            [dbo].[FECHA]        NULL,
    [TIEMPO_LICENCIA]                      VARCHAR (50)         CONSTRAINT [DF__reingreso__TIEMP__72DFDEED] DEFAULT ('') NOT NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_REINGRESO_ESTUDIANTE] PRIMARY KEY NONCLUSTERED ([ID_REINGRESO_ESTUDIANTE] ASC),
    CONSTRAINT [FK_REINGRESO_FK_LICENCIA] FOREIGN KEY ([ID_LICENCIA_ESTUDIANTE]) REFERENCES [transaccional].[licencia_estudiante] ([ID_LICENCIA_ESTUDIANTE]),
    CONSTRAINT [FK_REINGRESO_FK_RESERVA] FOREIGN KEY ([ID_RESERVA_MATRICULA]) REFERENCES [transaccional].[reserva_matricula] ([ID_RESERVA_MATRICULA])
);

