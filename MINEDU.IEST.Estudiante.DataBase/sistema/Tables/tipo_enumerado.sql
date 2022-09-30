CREATE TABLE [sistema].[tipo_enumerado] (
    [ID_TIPO_ENUMERADO]          [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [CODIGO_TIPO_ENUMERADO]      [dbo].[NUMERO_ENTERO] NOT NULL,
    [DESCRIPCION_TIPO_ENUMERADO] [dbo].[NOMBRE_LARGO]  NULL,
    [ES_EDITABLE]                [dbo].[BOOLEANO]      NULL,
    [ESTADO]                     [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]           [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]             [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]       [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]         [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_TIPO_ENUMERADO] PRIMARY KEY NONCLUSTERED ([ID_TIPO_ENUMERADO] ASC)
);

