CREATE TABLE [transaccional].[carga_masiva_nominas_persona] (
    [ID_CARGA_MASIVA_PERSONA] [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_TIPO_DOCUMENTO]       [dbo].[ID]            NOT NULL,
    [NUMERO_DOCUMENTO]        [dbo].[CODIGO_LARGO]  NOT NULL,
    [NOMBRE_COMPLETO]         [dbo].[NOMBRE_LARGO]  NOT NULL,
    [SEXO]                    [dbo].[ID]            NOT NULL,
    [EDAD]                    [dbo].[NUMERO_ENTERO] NOT NULL,
    [TIENE_DISCAPACIDAD]      [dbo].[BOOLEANO]      NOT NULL,
    [ES_ACTIVO]               [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                  [dbo].[NUMERO_ENTERO] NOT NULL,
    [USUARIO_CREACION]        [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]          [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]    [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]      [dbo].[FECHA_TIEMPO]  NULL,
    PRIMARY KEY CLUSTERED ([ID_CARGA_MASIVA_PERSONA] ASC)
);

