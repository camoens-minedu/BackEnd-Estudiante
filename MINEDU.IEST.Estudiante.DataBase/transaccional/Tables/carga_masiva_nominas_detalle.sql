CREATE TABLE [transaccional].[carga_masiva_nominas_detalle] (
    [ID_CARGA_MASIVA_NOMINA_DETALLE] [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_CARGA_MASIVA_NOMINA]         [dbo].[ID]            NOT NULL,
    [ID_CARGA_MASIVA_PERSONA]        [dbo].[ID]            NOT NULL,
    [NOMBRE_UNIDAD_DIDACTICA]        [dbo].[NOMBRE_LARGO]  NOT NULL,
    [NOTA]                           [dbo].[DECIMAL_DOS]   NULL,
    [ES_ACTIVO]                      [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                         [dbo].[NUMERO_ENTERO] NOT NULL,
    [USUARIO_CREACION]               [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                 [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]           [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]             [dbo].[FECHA_TIEMPO]  NULL,
    PRIMARY KEY CLUSTERED ([ID_CARGA_MASIVA_NOMINA_DETALLE] ASC),
    CONSTRAINT [FK_CARGA_MASIVA_NOMINAS_DETALLE_CARGA_MASIVA_NOMINAS] FOREIGN KEY ([ID_CARGA_MASIVA_NOMINA]) REFERENCES [transaccional].[carga_masiva_nominas] ([ID_CARGA_MASIVA_NOMINA]),
    CONSTRAINT [FK_CARGA_MASIVA_NOMINAS_DETALLE_CARGA_MASIVA_PERSONA] FOREIGN KEY ([ID_CARGA_MASIVA_PERSONA]) REFERENCES [transaccional].[carga_masiva_nominas_persona] ([ID_CARGA_MASIVA_PERSONA])
);




GO
CREATE NONCLUSTERED INDEX [IX_CargaMasivaActas_NombreUnidadDidactica]
    ON [transaccional].[carga_masiva_nominas_detalle]([NOMBRE_UNIDAD_DIDACTICA] ASC);

