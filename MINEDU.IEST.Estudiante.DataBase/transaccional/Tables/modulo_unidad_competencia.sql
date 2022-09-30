CREATE TABLE [transaccional].[modulo_unidad_competencia] (
    [ID_UNIDAD_COMPETENCIA]     [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_MODULO_EQUIVALENCIA]    [dbo].[ID]           NOT NULL,
    [NOMBRE_UNIDAD_COMPETENCIA] NVARCHAR (MAX)       NULL,
    [ES_ACTIVO]                 BIT                  NOT NULL,
    [ESTADO]                    INT                  NOT NULL,
    [USUARIO_CREACION]          VARCHAR (20)         NOT NULL,
    [FECHA_CREACION]            [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]      VARCHAR (20)         NULL,
    [FECHA_MODIFICACION]        [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_UNIDAD_COMPETENCIA] PRIMARY KEY NONCLUSTERED ([ID_UNIDAD_COMPETENCIA] ASC),
    FOREIGN KEY ([ID_MODULO_EQUIVALENCIA]) REFERENCES [transaccional].[modulo_equivalencia] ([ID_MODULO_EQUIVALENCIA])
);



