CREATE TABLE [sistema].[registro_errores] (
    [ID_ERROR]         [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_INSTITUCION]   INT                  NULL,
    [ERROR_MENSAJE]    VARCHAR (255)        NULL,
    [STACK_TRACE]      VARCHAR (3000)       NULL,
    [USUARIO_CREACION] [dbo].[USUARIO]      NULL,
    [FECHA_CREACION]   [dbo].[FECHA_TIEMPO] NULL
);

