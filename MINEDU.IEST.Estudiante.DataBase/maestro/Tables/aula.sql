CREATE TABLE [maestro].[aula] (
    [ID_AULA]              [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_SEDE_INSTITUCION]  [dbo].[ID]            NOT NULL,
    [ID_PISO]              [dbo].[ID_ENUMERADO]  NOT NULL,
    [NOMBRE_AULA]          [dbo].[NOMBRE_CORTO]  NULL,
    [CATEGORIA_AULA]       [dbo].[ID]            NOT NULL,
    [AFORO_AULA]           [dbo].[NUMERO_ENTERO] NOT NULL,
    [UBICACION_AULA]       [dbo].[NOMBRE_LARGO]  NULL,
    [OBSERVACION_AULA]     [dbo].[DESCRIPCION]   NULL,
    [ES_ACTIVO]            [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]               [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]     [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]       [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION] [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]   [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_AULA] PRIMARY KEY NONCLUSTERED ([ID_AULA] ASC),
    CONSTRAINT [FK_AULA_FK_SEDE_I_SEDE_INS] FOREIGN KEY ([ID_SEDE_INSTITUCION]) REFERENCES [maestro].[sede_institucion] ([ID_SEDE_INSTITUCION])
);

