CREATE TABLE [transaccional].[plan_estudio] (
    [ID_PLAN_ESTUDIO]             [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_CARRERAS_POR_INSTITUCION] [dbo].[ID]           NOT NULL,
    [ID_TIPO_ITINERARIO]          [dbo].[ID]           NOT NULL,
    [CODIGO_PLAN_ESTUDIOS]        [dbo].[CODIGO_LARGO] NULL,
    [NOMBRE_PLAN_ESTUDIOS]        [dbo].[NOMBRE_LARGO] NOT NULL,
    [ES_ACTIVO]                   [dbo].[BOOLEANO]     NULL,
    [ESTADO]                      [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]            [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]              [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]        [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]          [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_PLAN_ESTUDIO] PRIMARY KEY NONCLUSTERED ([ID_PLAN_ESTUDIO] ASC),
    CONSTRAINT [FK_PLAN_EST_FK_CARRER_CARRERAS] FOREIGN KEY ([ID_CARRERAS_POR_INSTITUCION]) REFERENCES [transaccional].[carreras_por_institucion] ([ID_CARRERAS_POR_INSTITUCION])
);


GO
CREATE NONCLUSTERED INDEX [IDX_PLAN_ESTUDIO1]
    ON [transaccional].[plan_estudio]([ID_CARRERAS_POR_INSTITUCION] ASC, [ES_ACTIVO] ASC, [ID_PLAN_ESTUDIO] ASC);

