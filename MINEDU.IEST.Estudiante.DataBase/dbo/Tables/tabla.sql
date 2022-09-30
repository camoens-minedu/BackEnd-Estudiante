CREATE TABLE [dbo].[tabla] (
    [TipoDocumento]        [dbo].[NOMBRE_LARGO]  NULL,
    [NumeroDocumento]      [dbo].[CODIGO_LARGO]  NOT NULL,
    [ApPaterno]            [dbo].[NOMBRE_CORTO]  NOT NULL,
    [ApMaterno]            [dbo].[NOMBRE_CORTO]  NULL,
    [Nombres]              [dbo].[NOMBRE_CORTO]  NOT NULL,
    [Estudiante]           VARCHAR (8000)        NULL,
    [TipoConvalidacion]    VARCHAR (150)         NULL,
    [CarreraConvalidacion] [dbo].[NOMBRE_LARGO]  NOT NULL,
    [TipoItinerario]       [dbo].[NOMBRE_LARGO]  NULL,
    [ArchivoConvalidacion] VARCHAR (50)          NULL,
    [IdPlanEstudio]        [dbo].[ID]            NOT NULL,
    [NroSemestres]         [dbo].[NUMERO_ENTERO] NOT NULL
);

