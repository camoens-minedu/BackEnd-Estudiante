CREATE TABLE [transaccional].[promover_persona_institucion] (
    [ID_PROMOVER_PERSONA_INSTITUCION]        INT          IDENTITY (1, 1) NOT NULL,
    [ID_SEDE_INSTITUCION]                    INT          NULL,
    [ID_CARRERAS_POR_INSTITUCION]            INT          NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION]   INT          NULL,
    [ID_POSTULANTES_POR_MODALIDAD_RETIRADO]  INT          NULL,
    [ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO] INT          NULL,
    [MOTIVO]                                 INT          NULL,
    [ES_ACTIVO]                              BIT          NULL,
    [ESTADO]                                 INT          NULL,
    [USUARIO_CREACION]                       VARCHAR (20) NULL,
    [FECHA_CREACION]                         DATETIME     NULL,
    [USUARIO_MODIFICACION]                   VARCHAR (20) NULL,
    [FECHA_MODIFICACION]                     DATETIME     NULL,
    [ID_PLAN_ESTUDIO]                        INT          NULL,
    PRIMARY KEY CLUSTERED ([ID_PROMOVER_PERSONA_INSTITUCION] ASC),
    CONSTRAINT [FK_promover_persona_institucion_ID_CARRERAS_POR_INSTITUCION] FOREIGN KEY ([ID_CARRERAS_POR_INSTITUCION]) REFERENCES [transaccional].[carreras_por_institucion] ([ID_CARRERAS_POR_INSTITUCION]),
    CONSTRAINT [FK_promover_persona_institucion_ID_PERIODOS_LECTIVOS_POR_INSTITUCION] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]),
    CONSTRAINT [FK_promover_persona_institucion_ID_PLAN_ESTUDIO] FOREIGN KEY ([ID_PLAN_ESTUDIO]) REFERENCES [transaccional].[plan_estudio] ([ID_PLAN_ESTUDIO]),
    CONSTRAINT [FK_promover_persona_institucion_ID_SEDE_INSTITUCION] FOREIGN KEY ([ID_SEDE_INSTITUCION]) REFERENCES [maestro].[sede_institucion] ([ID_SEDE_INSTITUCION])
);

