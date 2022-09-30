CREATE TABLE [transaccional].[proceso_sistema] (
    [ID_PROCESO_SISTEMA]   [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_TIPO_PROCESO]      [dbo].[ID_ENUMERADO] NOT NULL,
    [ID_REGISTRO_ASOCIADO] [dbo].[ID]           NOT NULL,
    [ES_ACTIVO]            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]       [dbo].[FECHA_TIEMPO] NOT NULL,
    CONSTRAINT [PK_proceso_sistema] PRIMARY KEY CLUSTERED ([ID_PROCESO_SISTEMA] ASC) WITH (FILLFACTOR = 90)
);

