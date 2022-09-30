CREATE TABLE [transaccional].[indicadores_logro] (
    [ID_INDICADORES_LOGRO]   [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_UNIDAD_COMPETENCIA]  [dbo].[ID]           NULL,
    [NOMBRE_INDICADOR_LOGRO] NVARCHAR (MAX)       NULL,
    [ES_ACTIVO]              BIT                  NOT NULL,
    [ESTADO]                 INT                  NOT NULL,
    [USUARIO_CREACION]       VARCHAR (20)         NOT NULL,
    [FECHA_CREACION]         [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]   VARCHAR (20)         NULL,
    [FECHA_MODIFICACION]     [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_INDICADORES_LOGRO] PRIMARY KEY NONCLUSTERED ([ID_INDICADORES_LOGRO] ASC),
    FOREIGN KEY ([ID_UNIDAD_COMPETENCIA]) REFERENCES [transaccional].[modulo_unidad_competencia] ([ID_UNIDAD_COMPETENCIA])
);



