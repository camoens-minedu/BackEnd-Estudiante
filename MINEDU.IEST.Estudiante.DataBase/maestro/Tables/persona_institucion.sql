CREATE TABLE [maestro].[persona_institucion] (
    [ID_PERSONA_INSTITUCION]  [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_PERSONA]              [dbo].[ID]            NOT NULL,
    [ID_INSTITUCION]          [dbo].[ID]            NOT NULL,
    [ESTADO_CIVIL]            [dbo].[ID_PEQUENO]    NOT NULL,
    [PAIS_PERSONA]            [dbo].[ID]            NOT NULL,
    [UBIGEO_PERSONA]          [dbo].[UBIGEO]        NULL,
    [DIRECCION_PERSONA]       [dbo].[DIRECCION]     NULL,
    [TELEFONO]                [dbo].[TELEFONO]      NOT NULL,
    [CELULAR]                 [dbo].[TELEFONO]      NULL,
    [CELULAR2]                [dbo].[TELEFONO]      NULL,
    [CORREO]                  [dbo].[CORREO]        NULL,
    [ID_TIPO_DISCAPACIDAD]    [dbo].[ID_ENUMERADO]  NOT NULL,
    [ID_GRADO_PROFESIONAL]    [dbo].[ID]            NOT NULL,
    [OCUPACION_PERSONA]       [dbo].[NOMBRE_LARGO]  NULL,
    [TITULO_PROFESIONAL]      [dbo].[NOMBRE_LARGO]  NULL,
    [ID_CARRERA_PROFESIONAL]  [dbo].[ID]            NULL,
    [INSTITUCION_PROFESIONAL] [dbo].[NOMBRE_LARGO]  NULL,
    [ANIO_INICIO]             [dbo].[NUMERO_ENTERO] NULL,
    [ANIO_FIN]                [dbo].[NUMERO_ENTERO] NULL,
    [NIVEL_EDUCATIVO]         [dbo].[ID_ENUMERADO]  NOT NULL,
    [ESTADO]                  [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]        [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]          [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]    [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]      [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_PERSONA_INSTITUCION] PRIMARY KEY NONCLUSTERED ([ID_PERSONA_INSTITUCION] ASC),
    CONSTRAINT [FK_PERSONA__FK_PERSON_PERSONA] FOREIGN KEY ([ID_PERSONA]) REFERENCES [maestro].[persona] ([ID_PERSONA]),
    CONSTRAINT [FK_PERSONA__RELATIONS_CARRERA_] FOREIGN KEY ([ID_CARRERA_PROFESIONAL]) REFERENCES [maestro].[carrera_profesional] ([ID_CARRERA_PROFESIONAL])
);


GO
CREATE NONCLUSTERED INDEX [IDX_PERSONA_INSTITUCION2]
    ON [maestro].[persona_institucion]([ID_PERSONA_INSTITUCION] ASC, [ID_PERSONA] ASC, [PAIS_PERSONA] ASC, [UBIGEO_PERSONA] ASC)
    INCLUDE([ESTADO_CIVIL], [DIRECCION_PERSONA], [TELEFONO], [CELULAR], [CORREO], [ID_TIPO_DISCAPACIDAD]);


GO
CREATE NONCLUSTERED INDEX [IDX_PERSONA_INSTITUCION1]
    ON [maestro].[persona_institucion]([ID_PERSONA_INSTITUCION] ASC)
    INCLUDE([ID_PERSONA]);

