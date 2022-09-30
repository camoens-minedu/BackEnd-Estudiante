﻿CREATE TABLE [maestro].[persona] (
    [ID_PERSONA]               [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_TIPO_DOCUMENTO]        [dbo].[ID]           NOT NULL,
    [NUMERO_DOCUMENTO_PERSONA] [dbo].[CODIGO_LARGO] NOT NULL,
    [NOMBRE_PERSONA]           [dbo].[NOMBRE_CORTO] NOT NULL,
    [APELLIDO_PATERNO_PERSONA] [dbo].[NOMBRE_CORTO] NOT NULL,
    [APELLIDO_MATERNO_PERSONA] [dbo].[NOMBRE_CORTO] NULL,
    [FECHA_NACIMIENTO_PERSONA] [dbo].[FECHA]        NOT NULL,
    [SEXO_PERSONA]             [dbo].[ID_PEQUENO]   NOT NULL,
    [ID_LENGUA_MATERNA]        [dbo].[ID_ENUMERADO] NOT NULL,
    [ES_DISCAPACITADO]         [dbo].[BOOLEANO]     NULL,
    [UBIGEO_NACIMIENTO]        [dbo].[UBIGEO]       NULL,
    [PAIS_NACIMIENTO]          [dbo].[ID]           NOT NULL,
    [ESTADO]                   [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]         [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]           [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]     [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]       [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_PERSONA] PRIMARY KEY NONCLUSTERED ([ID_PERSONA] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IDX_PERSONA1]
    ON [maestro].[persona]([ID_PERSONA] ASC)
    INCLUDE([NOMBRE_PERSONA], [APELLIDO_PATERNO_PERSONA], [APELLIDO_MATERNO_PERSONA], [ID_TIPO_DOCUMENTO], [NUMERO_DOCUMENTO_PERSONA]);
