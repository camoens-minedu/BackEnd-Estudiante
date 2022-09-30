CREATE TABLE [transaccional].[programacion_clase] (
    [ID_PROGRAMACION_CLASE]              [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_PERSONAL_INSTITUCION]            [dbo].[ID]            NOT NULL,
    [ID_SEDE_INSTITUCION]                [dbo].[ID]            NOT NULL,
    [ID_PERIODO_ACADEMICO]               [dbo].[ID]            NOT NULL,
    [ID_TURNOS_POR_INSTITUCION]          [dbo].[ID]            NOT NULL,
    [ID_SECCION]                         [dbo].[ID_ENUMERADO]  NOT NULL,
    [ID_EVALUACION]                      [dbo].[ID]            NULL,
    [CODIGO_CLASE]                       [dbo].[CODIGO_CORTO]  NULL,
    [NOMBRE_CLASE]                       [dbo].[NOMBRE_CORTO]  NOT NULL,
    [VACANTE_CLASE]                      [dbo].[NUMERO_ENTERO] NULL,
    [ES_ACTIVO]                          [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                             [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                   [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                     [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]               [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                 [dbo].[FECHA_TIEMPO]  NULL,
    [ID_PERSONAL_INSTITUCION_SECUNDARIO] INT                   DEFAULT (NULL) NULL,
    CONSTRAINT [PK_PROGRAMACION_CLASE] PRIMARY KEY NONCLUSTERED ([ID_PROGRAMACION_CLASE] ASC),
    CONSTRAINT [FK_PROG_CLASE_FK_SED_INST_ID] FOREIGN KEY ([ID_SEDE_INSTITUCION]) REFERENCES [maestro].[sede_institucion] ([ID_SEDE_INSTITUCION]),
    CONSTRAINT [FK_PROGRAMA_RELATIONS_EVALUACI] FOREIGN KEY ([ID_EVALUACION]) REFERENCES [transaccional].[evaluacion] ([ID_EVALUACION]),
    CONSTRAINT [FK_PROGRAMA_RELATIONS_PERIODO_] FOREIGN KEY ([ID_PERIODO_ACADEMICO]) REFERENCES [transaccional].[periodo_academico] ([ID_PERIODO_ACADEMICO]),
    CONSTRAINT [FK_PROGRAMACION_FK_TURNOS_INSTITUCION] FOREIGN KEY ([ID_TURNOS_POR_INSTITUCION]) REFERENCES [maestro].[turnos_por_institucion] ([ID_TURNOS_POR_INSTITUCION])
);




GO
CREATE NONCLUSTERED INDEX [IDX_PROGRAMACION_CLASE1]
    ON [transaccional].[programacion_clase]([ID_PROGRAMACION_CLASE] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_PERIODO_ACADEMICO], [ID_TURNOS_POR_INSTITUCION], [ID_SECCION], [ID_PERSONAL_INSTITUCION], [ID_SEDE_INSTITUCION]);

