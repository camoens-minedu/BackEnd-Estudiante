CREATE TABLE [maestro].[turno_equivalencia] (
    [ID_TURNO_EQUIVALENCIA] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_TURNO]              [dbo].[ID]           NOT NULL,
    [COD_TUR]               [dbo].[ID]           NOT NULL,
    [ESTADO]                [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]      [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]        [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]  [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]    [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_TURNO_EQUIVALENCIA] PRIMARY KEY NONCLUSTERED ([ID_TURNO_EQUIVALENCIA] ASC)
);

