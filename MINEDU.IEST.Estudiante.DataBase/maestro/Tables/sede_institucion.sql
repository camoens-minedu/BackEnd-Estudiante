CREATE TABLE [maestro].[sede_institucion] (
    [ID_SEDE_INSTITUCION]  [dbo].[ID]             IDENTITY (1, 1) NOT NULL,
    [ID_INSTITUCION]       [dbo].[ID]             NOT NULL,
    [CODIGO_SEDE]          [dbo].[CODIGO_MODULAR] NOT NULL,
    [NOMBRE_SEDE]          [dbo].[NOMBRE_LARGO]   NOT NULL,
    [CODIGO_UBIGEO_SEDE]   [dbo].[UBIGEO]         NULL,
    [DIRECCION_SEDE]       [dbo].[DIRECCION]      NULL,
    [DIRECTOR_SEDE]        [dbo].[NOMBRE_LARGO]   NULL,
    [TELEFONO_SEDE]        [dbo].[TELEFONO]       NULL,
    [CORREO_SEDE]          [dbo].[CORREO]         NULL,
    [ES_SEDE_PRINCIPAL]    [dbo].[BOOLEANO]       NOT NULL,
    [ID_TIPO_SEDE]         [dbo].[ID_ENUMERADO]   NOT NULL,
    [ES_ACTIVO]            [dbo].[BOOLEANO]       NOT NULL,
    [ESTADO]               [dbo].[ESTADO]         NOT NULL,
    [USUARIO_CREACION]     [dbo].[USUARIO]        NOT NULL,
    [FECHA_CREACION]       [dbo].[FECHA_TIEMPO]   NOT NULL,
    [USUARIO_MODIFICACION] [dbo].[USUARIO]        NULL,
    [FECHA_MODIFICACION]   [dbo].[FECHA_TIEMPO]   NULL,
    [NRO_RESOLUCION]       VARCHAR (50)           NULL,
    [ARCHIVO_RESOLUCION]   VARCHAR (100)          NULL,
    [ARCHIVO_RUTA]         VARCHAR (300)          NULL,
    CONSTRAINT [PK_SEDE_INSTITUCION] PRIMARY KEY NONCLUSTERED ([ID_SEDE_INSTITUCION] ASC)
);




GO



GO
CREATE NONCLUSTERED INDEX [IDX_SEDE_INSTITUCION1]
    ON [maestro].[sede_institucion]([ES_ACTIVO] ASC)
    INCLUDE([ID_SEDE_INSTITUCION], [ID_INSTITUCION], [NOMBRE_SEDE], [DIRECCION_SEDE], [ES_SEDE_PRINCIPAL], [ID_TIPO_SEDE]);

