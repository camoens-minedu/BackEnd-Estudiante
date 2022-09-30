CREATE TABLE [transaccional].[promocion_institucion_estudiante] (
    [ID_PROMOCION_INSTITUCION_ESTUDIANTE] INT          IDENTITY (1, 1) NOT NULL,
    [ID_INSTITUCION]                      INT          NOT NULL,
    [TIPO_PROMOCION]                      INT          NOT NULL,
    [TIPO_VERSION]                        INT          NOT NULL,
    [ID_TIPO_UNIDAD_DIDACTICA]            INT          NOT NULL,
    [CRITERIO]                            INT          NOT NULL,
    [VALOR]                               INT          NOT NULL,
    [ES_ACTIVO]                           BIT          NOT NULL,
    [ESTADO]                              INT          NOT NULL,
    [USUARIO_CREACION]                    VARCHAR (20) NOT NULL,
    [FECHA_CREACION]                      DATETIME     NOT NULL,
    [USUARIO_MODIFICACION]                VARCHAR (20) NULL,
    [FECHA_MODIFICACION]                  DATETIME     NULL
);

