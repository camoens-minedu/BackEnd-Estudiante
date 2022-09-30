CREATE TABLE [maestro].[tipo_unidad_didactica] (
    [ID_TIPO_UNIDAD_DIDACTICA] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [NOMBRE_TIPO_UNIDAD]       [dbo].[NOMBRE_CORTO] NOT NULL,
    [ESTADO]                   [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]         [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]           [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]     [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]       [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_TIPO_UNIDAD_DIDACTICA] PRIMARY KEY NONCLUSTERED ([ID_TIPO_UNIDAD_DIDACTICA] ASC)
);

