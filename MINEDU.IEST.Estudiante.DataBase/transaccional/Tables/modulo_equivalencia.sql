CREATE TABLE [transaccional].[modulo_equivalencia] (
    [ID_MODULO_EQUIVALENCIA] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PLAN_ESTUDIO]        [dbo].[ID]           NULL,
    [ID_TIPO_MODULO]         [dbo].[ID]           NULL,
    [NOMBRE_MODULO]          NVARCHAR (MAX)       NULL,
    [NUMERO_MODULO]          NVARCHAR (MAX)       NULL,
    [TOTHORAS]               DECIMAL (5, 1)       NULL,
    [TOTCREDITOS]            DECIMAL (5, 1)       NULL,
    [ES_ACTIVO]              BIT                  NOT NULL,
    [ESTADO]                 INT                  NOT NULL,
    [USUARIO_CREACION]       VARCHAR (20)         NOT NULL,
    [FECHA_CREACION]         [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]   VARCHAR (20)         NULL,
    [FECHA_MODIFICACION]     [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_MODULO_EQUIVALENCIA] PRIMARY KEY NONCLUSTERED ([ID_MODULO_EQUIVALENCIA] ASC),
    FOREIGN KEY ([ID_PLAN_ESTUDIO]) REFERENCES [transaccional].[plan_estudio] ([ID_PLAN_ESTUDIO])
);

