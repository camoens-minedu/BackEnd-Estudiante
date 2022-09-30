CREATE TABLE [maestro].[actividad_economica] (
    [ID_ACTIVIDAD_ECONOMICA]              [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_FAMILIA_PRODUCTIVA]               [dbo].[ID]            NOT NULL,
    [CODIGO_ACTIVIDAD_ECONOMICA]          [dbo].[CODIGO_CORTO]  NOT NULL,
    [CODIGO_DIVISION_ACTIVIDAD_ECONOMICA] [dbo].[NUMERO_ENTERO] NOT NULL,
    [NOMBRE_ACTIVIDAD_ECONOMICA]          [dbo].[NOMBRE_LARGO]  NOT NULL,
    [DESCRIPCION_ACTIVIDAD_ECONOMICA]     [dbo].[DESCRIPCION]   NULL,
    [ESTADO]                              [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                    [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                      [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]                [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                  [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_ACTIVIDAD_ECONOMICA] PRIMARY KEY NONCLUSTERED ([ID_ACTIVIDAD_ECONOMICA] ASC),
    CONSTRAINT [FK_ACTIVIDA_FK_FAMILI_FAMILIA_] FOREIGN KEY ([ID_FAMILIA_PRODUCTIVA]) REFERENCES [maestro].[familia_productiva] ([ID_FAMILIA_PRODUCTIVA])
);

