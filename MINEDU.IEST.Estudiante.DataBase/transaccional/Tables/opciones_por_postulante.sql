CREATE TABLE [transaccional].[opciones_por_postulante] (
    [ID_OPCIONES_POR_POSTULANTE]          [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_POSTULANTES_POR_MODALIDAD]        [dbo].[ID]            NOT NULL,
    [ID_META_CARRERA_INSTITUCION_DETALLE] [dbo].[ID]            NOT NULL,
    [ORDEN]                               [dbo].[NUMERO_ENTERO] NULL,
    [ES_ACTIVO]                           [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                              [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                    [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                      [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]                [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                  [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_OPCIONES_POR_POSTULANTE] PRIMARY KEY NONCLUSTERED ([ID_OPCIONES_POR_POSTULANTE] ASC),
    CONSTRAINT [FK_OPCIONES_RELATIONS_META_CAR] FOREIGN KEY ([ID_META_CARRERA_INSTITUCION_DETALLE]) REFERENCES [transaccional].[meta_carrera_institucion_detalle] ([ID_META_CARRERA_INSTITUCION_DETALLE]),
    CONSTRAINT [FK_OPCIONES_RELATIONS_POSTULAN] FOREIGN KEY ([ID_POSTULANTES_POR_MODALIDAD]) REFERENCES [transaccional].[postulantes_por_modalidad] ([ID_POSTULANTES_POR_MODALIDAD])
);

