CREATE TABLE [transaccional].[liberacion_estudiante] (
    [ID_LIBERACION_ESTUDIANTE]             INT           IDENTITY (1, 1) NOT NULL,
    [ID_ESTUDIANTE_INSTITUCION]            INT           NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] INT           NOT NULL,
    [ES_ACTIVO]                            INT           NOT NULL,
    [ESTADO]                               INT           CONSTRAINT [DF__liberacio__ESTAD__1223801C] DEFAULT ((1)) NOT NULL,
    [USUARIO_CREACION]                     VARCHAR (20)  NOT NULL,
    [FECHA_CREACION]                       DATETIME      NOT NULL,
    [USUARIO_MODIFICACION]                 VARCHAR (20)  NULL,
    [FECHA_MODIFICACION]                   DATETIME      NULL,
    [NRO_RD]                               VARCHAR (50)  DEFAULT ('NULL') NULL,
    [ARCHIVO_RD]                           VARCHAR (50)  DEFAULT ('NULL') NULL,
    [ARCHIVO_RUTA]                         VARCHAR (255) DEFAULT ('NULL') NULL,
    CONSTRAINT [PK__liberaci__5E5B0866F987A876] PRIMARY KEY CLUSTERED ([ID_LIBERACION_ESTUDIANTE] ASC),
    CONSTRAINT [FK_liberacion_estudiante_ID_ESTUDIANTE_INSTITUCION] FOREIGN KEY ([ID_ESTUDIANTE_INSTITUCION]) REFERENCES [transaccional].[estudiante_institucion] ([ID_ESTUDIANTE_INSTITUCION]),
    CONSTRAINT [FK_liberacion_estudiante_ID_PERIODOS_LECTIVOS_POR_INSTITUCION] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION])
);

