CREATE TABLE [transaccional].[carga_masiva_nominas] (
    [ID_CARGA_MASIVA_NOMINA]  [dbo].[ID]             IDENTITY (1, 1) NOT NULL,
    [NOMBRE_PERIODO_LECTIVO]  [dbo].[NOMBRE_CORTO]   NOT NULL,
    [ID_INSTITUCION]          [dbo].[ID]             NOT NULL,
    [NOMBRE_SEDE_INSTITUCION] [dbo].[NOMBRE_LARGO]   NOT NULL,
    [ID_CARRERA]              [dbo].[ID]             NULL,
    [NOMBRE_PLAN_ESTUDIO]     [dbo].[NOMBRE_LARGO]   NOT NULL,
    [ID_SEMESTRE_ACADEMICO]   [dbo].[ID]             NOT NULL,
    [ID_TURNO]                [dbo].[ID]             NOT NULL,
    [ID_SECCION]              [dbo].[ID]             NOT NULL,
    [CANTIDAD_ALUMNOS]        [dbo].[NUMERO_ENTERO]  NOT NULL,
    [ES_ACTIVO]               [dbo].[BOOLEANO]       NOT NULL,
    [ESTADO]                  [dbo].[NUMERO_ENTERO]  NOT NULL,
    [USUARIO_CREACION]        [dbo].[USUARIO]        NOT NULL,
    [FECHA_CREACION]          [dbo].[FECHA_TIEMPO]   NOT NULL,
    [USUARIO_MODIFICACION]    [dbo].[USUARIO]        NULL,
    [FECHA_MODIFICACION]      [dbo].[FECHA_TIEMPO]   NULL,
    [SECCION]                 [dbo].[NOMBRE_LARGO]   NULL,
    [CODIGO_MODULAR]          [dbo].[CODIGO_MODULAR] NULL,
    [NOMBRE_CARRERA]          VARCHAR (500)          NULL,
    [TIPO_NIVEL_FORMACION]    INT                    NULL,
    PRIMARY KEY CLUSTERED ([ID_CARGA_MASIVA_NOMINA] ASC),
    CONSTRAINT [FK_CARGA_MASIVA_NOMINAS_SEMESTRE_ACADEMICO] FOREIGN KEY ([ID_SEMESTRE_ACADEMICO]) REFERENCES [sistema].[enumerado] ([ID_ENUMERADO]),
    CONSTRAINT [FK_CARGA_MASIVA_NOMINAS_TURNO] FOREIGN KEY ([ID_TURNO]) REFERENCES [sistema].[enumerado] ([ID_ENUMERADO])
);



