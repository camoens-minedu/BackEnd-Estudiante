CREATE TABLE [transaccional].[carga_masiva_actas] (
    [ID_CARGA_MASIVA_ACTA]   [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_CARGA_MASIVA_NOMINA] [dbo].[ID]            NOT NULL,
    [ES_ACTIVO]              [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                 [dbo].[NUMERO_ENTERO] NOT NULL,
    [USUARIO_CREACION]       [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]         [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]   [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]     [dbo].[FECHA_TIEMPO]  NULL,
    PRIMARY KEY CLUSTERED ([ID_CARGA_MASIVA_ACTA] ASC),
    CONSTRAINT [FK_CARGA_MASIVA_NOMINAS_ACTAS_CARGA_MASIVA_NOMINAS] FOREIGN KEY ([ID_CARGA_MASIVA_NOMINA]) REFERENCES [transaccional].[carga_masiva_nominas] ([ID_CARGA_MASIVA_NOMINA])
);

