CREATE TABLE [transaccional].[modulo] (
    [ID_MODULO]            [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_PLAN_ESTUDIO]      [dbo].[ID]            NOT NULL,
    [ID_TIPO_MODULO]       INT                   NULL,
    [CODIGO_MODULO]        [dbo].[CODIGO_LARGO]  NULL,
    [NOMBRE_MODULO]        NVARCHAR (MAX)        NULL,
    [HORAS_ME]             DECIMAL (5, 1)        NULL,
    [CREDITOS_ME]          [dbo].[NUMERO_ENTERO] NULL,
    [TOTAL_HORAS]          [dbo].[NUMERO_ENTERO] NULL,
    [TOTAL_HORAS_UD]       DECIMAL (5, 1)        NULL,
    [TOTAL_CREDITOS_UD]    DECIMAL (5, 1)        NULL,
    [ES_ACTIVO]            [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]               [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]     [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]       [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION] [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]   [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_MODULO] PRIMARY KEY NONCLUSTERED ([ID_MODULO] ASC),
    CONSTRAINT [FK_MODULO_FK_PLAN_E_PLAN_EST] FOREIGN KEY ([ID_PLAN_ESTUDIO]) REFERENCES [transaccional].[plan_estudio] ([ID_PLAN_ESTUDIO])
);


GO
CREATE NONCLUSTERED INDEX [IDX_MODULO2]
    ON [transaccional].[modulo]([ID_MODULO] ASC, [ID_PLAN_ESTUDIO] ASC, [ES_ACTIVO] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_MODULO1]
    ON [transaccional].[modulo]([ES_ACTIVO] ASC)
    INCLUDE([ID_MODULO], [ID_PLAN_ESTUDIO]);

