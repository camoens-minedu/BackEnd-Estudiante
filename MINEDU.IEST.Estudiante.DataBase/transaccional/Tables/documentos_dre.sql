CREATE TABLE [transaccional].[documentos_dre] (
    [ID_DOCUMENTOS_DRE]     [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_PROGRAMACION_CLASE] [dbo].[ID]            NULL,
    [ID_CLASE_HISTORICA]    [dbo].[ID]            NULL,
    [CODIGO_TIPO_ENUMERADO] [dbo].[NUMERO_ENTERO] NOT NULL,
    [DESCARGADO]            [dbo].[BOOLEANO]      NULL,
    [SUBIDO]                [dbo].[BOOLEANO]      NULL,
    [VERIFICADO]            [dbo].[BOOLEANO]      NULL,
    [USUARIO_CREACION]      [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]        [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]  [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]    [dbo].[FECHA_TIEMPO]  NULL,
    [ESTADO]                BIT                   NULL,
    CONSTRAINT [PK_DOCUMENTOS_DRE] PRIMARY KEY NONCLUSTERED ([ID_DOCUMENTOS_DRE] ASC)
);

