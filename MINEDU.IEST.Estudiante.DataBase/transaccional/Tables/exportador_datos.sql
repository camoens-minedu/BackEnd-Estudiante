CREATE TABLE [transaccional].[exportador_datos] (
    [ID_EXPORTADOR_DATOS]  INT                  IDENTITY (1, 1) NOT NULL,
    [NOMBRE_BASE_DATOS]    VARCHAR (100)        NOT NULL,
    [NOMBRE_ESQUEMA]       VARCHAR (100)        NOT NULL,
    [NOMBRE_OBJETO]        VARCHAR (100)        NOT NULL,
    [ES_ACTIVO]            [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]               [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]     [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]       [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION] [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]   [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_exportador_datos] PRIMARY KEY CLUSTERED ([ID_EXPORTADOR_DATOS] ASC)
);

