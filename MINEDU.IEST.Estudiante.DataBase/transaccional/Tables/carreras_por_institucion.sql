CREATE TABLE [transaccional].[carreras_por_institucion] (
    [ID_CARRERAS_POR_INSTITUCION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_INSTITUCION]              [dbo].[ID]           NOT NULL,
    [ID_CARRERA]                  [dbo].[ID]           NOT NULL,
    [ID_TIPO_ITINERARIO]          [dbo].[ID_ENUMERADO] NULL,
    [ES_ACTIVO]                   [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                      [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]            [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]              [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]        [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]          [dbo].[FECHA_TIEMPO] NULL,
    [ID_CARRERA_BK]               INT                  NULL,
    CONSTRAINT [PK_CARRERAS_POR_INSTITUCION] PRIMARY KEY NONCLUSTERED ([ID_CARRERAS_POR_INSTITUCION] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_CARRERAS_POR_INSTITUCION2]
    ON [transaccional].[carreras_por_institucion]([ID_CARRERAS_POR_INSTITUCION] ASC, [ES_ACTIVO] ASC, [ID_TIPO_ITINERARIO] ASC, [ID_CARRERA] ASC, [ID_INSTITUCION] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_CARRERAS_POR_INSTITUCION1]
    ON [transaccional].[carreras_por_institucion]([ID_CARRERA] ASC, [ES_ACTIVO] ASC, [ID_INSTITUCION] ASC)
    INCLUDE([ID_CARRERAS_POR_INSTITUCION]);

