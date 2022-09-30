CREATE TABLE [transaccional].[cierre_periodo_clases] (
    [ID_CIERRE_PERIODO_CLASES] INT      IDENTITY (1, 1) NOT NULL,
    [ID_PERIODO_ACADEMICO]     INT      NOT NULL,
    [ES_ACTIVO]                BIT      NOT NULL,
    [ESTADO]                   INT      DEFAULT ((0)) NOT NULL,
    [USUARIO_CREACION]         INT      NULL,
    [FECHA_CREACION]           DATETIME NULL,
    [USUARIO_MODFICACION]      INT      NULL,
    [FECHA_MODIFICACION]       DATETIME NULL,
    PRIMARY KEY CLUSTERED ([ID_CIERRE_PERIODO_CLASES] ASC),
    FOREIGN KEY ([ID_PERIODO_ACADEMICO]) REFERENCES [transaccional].[periodo_academico] ([ID_PERIODO_ACADEMICO])
);

