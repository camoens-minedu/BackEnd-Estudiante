CREATE TABLE [transaccional].[sesion_programacion_clase] (
    [ID_SESION_PROGRAMACION_CLASE] [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_PROGRAMACION_CLASE]        [dbo].[ID]            NOT NULL,
    [ID_AULA]                      [dbo].[ID]            NOT NULL,
    [DIA]                          [dbo].[NUMERO_ENTERO] NULL,
    [HORA_INICIO]                  [dbo].[HORA_STRING]   NULL,
    [HORA_FIN]                     [dbo].[HORA_STRING]   NULL,
    [ES_ACTIVO]                    [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                       [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]             [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]               [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]         [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]           [dbo].[FECHA_TIEMPO]  NULL,
    [ID_TIPO_CLASE]                [dbo].[ID_ENUMERADO]  NOT NULL,
    [ID_PERSONAL_INSTITUCION]      INT                   DEFAULT (NULL) NULL,
    [ID_DOCENTE_CLASE]             INT                   DEFAULT (NULL) NULL,
    CONSTRAINT [PK_SESION_PROGRAMACION_CLASE] PRIMARY KEY NONCLUSTERED ([ID_SESION_PROGRAMACION_CLASE] ASC),
    CONSTRAINT [FK_SESION_P_FK_AULA_S_AULA] FOREIGN KEY ([ID_AULA]) REFERENCES [maestro].[aula] ([ID_AULA]),
    CONSTRAINT [FK_SESION_P_FK_PROGRA_PROGRAMA] FOREIGN KEY ([ID_PROGRAMACION_CLASE]) REFERENCES [transaccional].[programacion_clase] ([ID_PROGRAMACION_CLASE])
);



