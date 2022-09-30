CREATE TABLE [transaccional].[reserva_matricula] (
    [ID_RESERVA_MATRICULA]                 [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_ESTUDIANTE_INSTITUCION]            [dbo].[ID]           NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [ID_MOTIVO_RESERVA]                    [dbo].[ID_ENUMERADO] NOT NULL,
    [ID_TIEMPO_PERIODO_RESERVA]            [dbo].[ID_ENUMERADO] NOT NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_RESERVA_MATRICULA] PRIMARY KEY CLUSTERED ([ID_RESERVA_MATRICULA] ASC),
    CONSTRAINT [FK_RESERVA_FK_ESTUDIANTE] FOREIGN KEY ([ID_ESTUDIANTE_INSTITUCION]) REFERENCES [transaccional].[estudiante_institucion] ([ID_ESTUDIANTE_INSTITUCION]),
    CONSTRAINT [FK_RESERVA_FK_PERIODOS] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION])
);

