CREATE TABLE [transaccional].[capacidades_por_componente] (
    [ID_CAPACIDADES_POR_COMPONENTE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_COMPONENTE_CURRICULAR]      [dbo].[ID]           NOT NULL,
    [CODIGO_CAPACIDAD]              [dbo].[CODIGO_LARGO] NULL,
    [NOMBRE_CAPACIDAD]              [dbo].[NOMBRE_LARGO] NULL,
    [DESCRIPCION]                   [dbo].[DESCRIPCION]  NULL,
    [ES_ACTIVO]                     [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                        [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]              [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]          [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]            [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_CAPACIDADES_POR_COMPONENTE] PRIMARY KEY NONCLUSTERED ([ID_CAPACIDADES_POR_COMPONENTE] ASC),
    CONSTRAINT [FK_CAPACIDA_FK_COMPON_COMPONEN] FOREIGN KEY ([ID_COMPONENTE_CURRICULAR]) REFERENCES [transaccional].[componente_curricular] ([ID_COMPONENTE_CURRICULAR])
);

