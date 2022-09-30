CREATE TABLE [transaccional].[retiro_estudiante] (
    [ID_RETIRO_ESTUDIANTE]                 [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_ESTUDIANTE_INSTITUCION]            [dbo].[ID]           NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [ID_MOTIVO]                            [dbo].[ID_ENUMERADO] NOT NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_RETIRO_ESTUDIANTE] PRIMARY KEY CLUSTERED ([ID_RETIRO_ESTUDIANTE] ASC),
    CONSTRAINT [FK_RETIRO_FK_ESTUDIANTE] FOREIGN KEY ([ID_ESTUDIANTE_INSTITUCION]) REFERENCES [transaccional].[estudiante_institucion] ([ID_ESTUDIANTE_INSTITUCION]),
    CONSTRAINT [FK_RETIRO_FK_PERIODOS] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION])
);

