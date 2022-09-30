CREATE TABLE [transaccional].[evaluacion_extraordinaria] (
    [ID_EVALUACION_EXTRAORDINARIA]         [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_ESTUDIANTE_INSTITUCION]            [dbo].[ID]           NULL,
    [ARCHIVO_RD]                           VARCHAR (50)         NOT NULL,
    [ARCHIVO_RUTA]                         VARCHAR (255)        NOT NULL,
    [ES_ACTIVO]                            BIT                  NOT NULL,
    [ESTADO]                               INT                  NOT NULL,
    [USUARIO_CREACION]                     VARCHAR (20)         NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                 VARCHAR (20)         NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO] NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] INT                  NOT NULL,
    [ID_TIPO_EVALUACION]                   INT                  NULL,
    CONSTRAINT [PK_EVALUACION_EXTRAORDINARIA] PRIMARY KEY NONCLUSTERED ([ID_EVALUACION_EXTRAORDINARIA] ASC),
    FOREIGN KEY ([ID_ESTUDIANTE_INSTITUCION]) REFERENCES [transaccional].[estudiante_institucion] ([ID_ESTUDIANTE_INSTITUCION])
);



