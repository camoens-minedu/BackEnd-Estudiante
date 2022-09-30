CREATE TABLE [transaccional].[asignación_institucion_carga] (
    [ID_ASIGNACION_INSTITUCION_CARGA] INT          IDENTITY (1, 1) NOT NULL,
    [ID_INSTITUCION]                  INT          NOT NULL,
    [ES_ACTIVO]                       INT          NOT NULL,
    [ESTADO]                          INT          NOT NULL,
    [USUARIO_CREACION]                VARCHAR (20) NOT NULL,
    [FECHA_CREACION]                  DATETIME     NOT NULL,
    [USUARIO_MODIFICACION]            VARCHAR (20) NULL,
    [FECHA_MODIFICACION]              DATETIME     NULL,
    CONSTRAINT [PK_ASIGNACION_INSTITUCION_CARGA] PRIMARY KEY NONCLUSTERED ([ID_ASIGNACION_INSTITUCION_CARGA] ASC)
);

