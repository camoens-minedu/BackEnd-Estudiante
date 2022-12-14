CREATE TABLE [maestro].[turnos_por_institucion] (
    [ID_TURNOS_POR_INSTITUCION] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_TURNO_EQUIVALENCIA]     [dbo].[ID]           NOT NULL,
    [ID_INSTITUCION]            [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]                 [dbo].[BOOLEANO]     NULL,
    [ESTADO]                    [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]          [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]            [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]      [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]        [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_TURNOS_POR_INSTITUCION] PRIMARY KEY NONCLUSTERED ([ID_TURNOS_POR_INSTITUCION] ASC),
    CONSTRAINT [FK_TURNOS_P_RELATIONS_TURNO_EQ] FOREIGN KEY ([ID_TURNO_EQUIVALENCIA]) REFERENCES [maestro].[turno_equivalencia] ([ID_TURNO_EQUIVALENCIA])
);


GO
CREATE NONCLUSTERED INDEX [IDX_TURNOS_POR_INSTITUCION1]
    ON [maestro].[turnos_por_institucion]([ID_TURNOS_POR_INSTITUCION] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_TURNO_EQUIVALENCIA]);

