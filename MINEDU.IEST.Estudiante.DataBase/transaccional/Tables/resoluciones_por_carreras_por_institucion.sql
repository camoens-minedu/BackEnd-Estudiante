CREATE TABLE [transaccional].[resoluciones_por_carreras_por_institucion] (
    [ID_RESOLUCIONES_POR_CARRERAS_POR_INSTITUCION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_RESOLUCION]                                [dbo].[ID]           NOT NULL,
    [ID_CARRERAS_POR_INSTITUCION]                  [dbo].[ID]           NOT NULL,
    [ID_SEDE_INSTITUCION]                          [dbo].[ID]           NULL,
    [ES_ACTIVO]                                    [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                                       [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                             [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                               [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                         [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                           [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_resoluciones_por_carreras_por_institucion] PRIMARY KEY NONCLUSTERED ([ID_RESOLUCIONES_POR_CARRERAS_POR_INSTITUCION] ASC),
    CONSTRAINT [FK_RESOL_CARR_INST_FK_CARR_INST] FOREIGN KEY ([ID_CARRERAS_POR_INSTITUCION]) REFERENCES [transaccional].[carreras_por_institucion] ([ID_CARRERAS_POR_INSTITUCION]),
    CONSTRAINT [FK_RESOL_CARR_INST_FK_RESOL] FOREIGN KEY ([ID_RESOLUCION]) REFERENCES [maestro].[resolucion] ([ID_RESOLUCION]),
    CONSTRAINT [FK_RESOL_CARR_INST_FK_SEDE_INST] FOREIGN KEY ([ID_SEDE_INSTITUCION]) REFERENCES [maestro].[sede_institucion] ([ID_SEDE_INSTITUCION])
);

