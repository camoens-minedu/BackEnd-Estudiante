CREATE TABLE [transaccional].[log_carga] (
    [ID_LOG_CARGA]          [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_DET_ARCHIVO]        [dbo].[ID]            NOT NULL,
    [NRO_REGISTRO_EXCEL]    [dbo].[NUMERO_ENTERO] NULL,
    [MENSAJE]               VARCHAR (500)         NULL,
    [ES_VIGENTE]            [dbo].[ESTADO]        NULL,
    [FECHA_INICIO_VIGENCIA] [dbo].[FECHA_TIEMPO]  NULL,
    [FECHA_FIN_VIGENCIA]    [dbo].[FECHA_TIEMPO]  NULL,
    [FECHA_CREACION]        [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_CREACION]      [dbo].[USUARIO]       NOT NULL,
    [FECHA_MODIFICACION]    [dbo].[FECHA_TIEMPO]  NULL,
    [USUARIO_MODIFICACION]  [dbo].[USUARIO]       NULL,
    [ES_BORRADO]            [dbo].[ESTADO]        NOT NULL,
    CONSTRAINT [PK_log_carga] PRIMARY KEY CLUSTERED ([ID_LOG_CARGA] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_log_carga_carga_detalle] FOREIGN KEY ([ID_DET_ARCHIVO]) REFERENCES [archivo].[carga_detalle] ([ID_DET_ARCHIVO])
);

