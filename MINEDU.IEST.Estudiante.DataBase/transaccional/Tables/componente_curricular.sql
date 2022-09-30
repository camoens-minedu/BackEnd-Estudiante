CREATE TABLE [transaccional].[componente_curricular] (
    [ID_COMPONENTE_CURRICULAR] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_MODULO]                [dbo].[ID]           NOT NULL,
    [ID_TIPO_COMPONENTE]       [dbo].[ID]           NOT NULL,
    [CODIGO_COMPONENTE]        [dbo].[CODIGO_LARGO] NULL,
    [NOMBRE_COMPONENTE]        [dbo].[NOMBRE_LARGO] NOT NULL,
    [DESCRIPCION]              [dbo].[DESCRIPCION]  NULL,
    [ES_ACTIVO]                [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                   [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]         [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]           [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]     [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]       [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_COMPONENTE_CURRICULAR] PRIMARY KEY NONCLUSTERED ([ID_COMPONENTE_CURRICULAR] ASC),
    CONSTRAINT [FK_COMPONEN_FK_MODULO_MODULO] FOREIGN KEY ([ID_MODULO]) REFERENCES [transaccional].[modulo] ([ID_MODULO])
);

