CREATE TABLE [transaccional].[carreras_por_institucion_detalle] (
    [ID_CARRERAS_POR_INSTITUCION_DETALLE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_CARRERAS_POR_INSTITUCION]         [dbo].[ID]           NOT NULL,
    [ID_SEDE_INSTITUCION]                 [dbo].[ID]           NOT NULL,
    [ID_ESTADO_PROGRAMA]                  [dbo].[ID_ENUMERADO] NOT NULL,
    [ES_ACTIVO]                           [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                              [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                    [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                      [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                  [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_CARRERAS_POR_INSTITUCION_DETALLE] PRIMARY KEY NONCLUSTERED ([ID_CARRERAS_POR_INSTITUCION_DETALLE] ASC),
    CONSTRAINT [FK_CARR_INST_DET_FK_CARR_INST] FOREIGN KEY ([ID_CARRERAS_POR_INSTITUCION]) REFERENCES [transaccional].[carreras_por_institucion] ([ID_CARRERAS_POR_INSTITUCION]),
    CONSTRAINT [FK_CARR_INST_DET_FK_SEDE_INST] FOREIGN KEY ([ID_SEDE_INSTITUCION]) REFERENCES [maestro].[sede_institucion] ([ID_SEDE_INSTITUCION])
);


GO
CREATE NONCLUSTERED INDEX [IDX_CARRERAS_POR_INSTITUCION_DETALLE1]
    ON [transaccional].[carreras_por_institucion_detalle]([ID_CARRERAS_POR_INSTITUCION] ASC, [ID_SEDE_INSTITUCION] ASC, [ES_ACTIVO] ASC);

