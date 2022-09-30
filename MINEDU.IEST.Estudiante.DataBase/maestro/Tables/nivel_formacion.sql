CREATE TABLE [maestro].[nivel_formacion] (
    [ID_NIVEL_FORMACION]          [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [NOMBRE_NIVEL_FORMACION]      [dbo].[NOMBRE_CORTO]  NOT NULL,
    [DESCRIPCION_NIVEL_FORMACION] [dbo].[DESCRIPCION]   NULL,
    [SEMESTRES_ACADEMICOS]        [dbo].[NUMERO_ENTERO] NOT NULL,
    [CREDITOS]                    [dbo].[NUMERO_ENTERO] NOT NULL,
    [HORAS]                       [dbo].[NUMERO_ENTERO] NOT NULL,
    [ESTADO]                      [dbo].[ESTADO]        NOT NULL,
    [CODIGO_TIPO]                 INT                   NOT NULL,
    [USUARIO_CREACION]            [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]              [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]        [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]          [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_NIVEL_FORMACION] PRIMARY KEY NONCLUSTERED ([ID_NIVEL_FORMACION] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_NIVEL_FORMACION1]
    ON [maestro].[nivel_formacion]([CODIGO_TIPO] ASC)
    INCLUDE([SEMESTRES_ACADEMICOS]);

