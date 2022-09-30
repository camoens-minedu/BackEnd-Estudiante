﻿CREATE TABLE [transaccional].[postulantes_por_modalidad] (
    [ID_POSTULANTES_POR_MODALIDAD]        [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_MODALIDADES_POR_PROCESO_ADMISION] [dbo].[ID]            NOT NULL,
    [ID_TIPOS_MODALIDAD_POR_INSTITUCION]  [dbo].[ID]            NOT NULL,
    [ID_EXAMEN_ADMISION_SEDE]             [dbo].[ID]            NOT NULL,
    [ID_PERSONA_INSTITUCION]              [dbo].[ID]            NOT NULL,
    [ID_INSTITUCION_BASICA]               [dbo].[ID]            NOT NULL,
    [CODIGO_POSTULANTE]                   [dbo].[CODIGO_LARGO]  NULL,
    [_CODIGO_ESTUDIANTE]                  [dbo].[CODIGO_LARGO]  NULL,
    [ANIO_EGRESO]                         [dbo].[NUMERO_ENTERO] NULL,
    [ID_TIPO_DOCUMENTO_APODERADO]         [dbo].[ID_ENUMERADO]  NOT NULL,
    [NUMERO_DOCUMENTO_APODERADO]          [dbo].[CODIGO_LARGO]  NULL,
    [NOMBRE_APODERADO]                    [dbo].[NOMBRE_CORTO]  NULL,
    [APELLIDO_APODERADO]                  [dbo].[NOMBRE_LARGO]  NULL,
    [ID_TIPO_PARENTEZCO]                  [dbo].[ID_ENUMERADO]  NOT NULL,
    [ID_TIPO_PAGO]                        [dbo].[ID_ENUMERADO]  NOT NULL,
    [NUMERO_COMPROBANTE]                  [dbo].[CODIGO_LARGO]  NULL,
    [MONTO_PAGO]                          [dbo].[DECIMAL_DOS]   NULL,
    [MOTIVO_EXONERACION]                  [dbo].[DESCRIPCION]   NULL,
    [ES_ACTIVO]                           [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                              [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                    [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                      [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]                [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                  [dbo].[FECHA_TIEMPO]  NULL,
    [ARCHIVO_FOTO]                        VARCHAR (50)          NULL,
    [ARCHIVO_RUTA]                        VARCHAR (255)         NULL,
    [ARCHIVO_COMPROBANTE]                 VARCHAR (50)          NULL,
    [ARCHIVO_COMPROBANTE_RUTA]            VARCHAR (255)         NULL,
    CONSTRAINT [PK_POSTULANTES_POR_MODALIDAD] PRIMARY KEY NONCLUSTERED ([ID_POSTULANTES_POR_MODALIDAD] ASC),
    CONSTRAINT [FK_POSTULAN_FK_MODALI_MODALIDA] FOREIGN KEY ([ID_MODALIDADES_POR_PROCESO_ADMISION]) REFERENCES [transaccional].[modalidades_por_proceso_admision] ([ID_MODALIDADES_POR_PROCESO_ADMISION]),
    CONSTRAINT [FK_POSTULAN_PERSONA_I_PERSONA_] FOREIGN KEY ([ID_PERSONA_INSTITUCION]) REFERENCES [maestro].[persona_institucion] ([ID_PERSONA_INSTITUCION]),
    CONSTRAINT [FK_POSTULAN_RELATIONS_EXAMEN_A] FOREIGN KEY ([ID_EXAMEN_ADMISION_SEDE]) REFERENCES [transaccional].[examen_admision_sede] ([ID_EXAMEN_ADMISION_SEDE]),
    CONSTRAINT [FK_POSTULAN_RELATIONS_INSTITUC] FOREIGN KEY ([ID_INSTITUCION_BASICA]) REFERENCES [maestro].[institucion_basica] ([ID_INSTITUCION_BASICA]),
    CONSTRAINT [FK_POSTULAN_RELATIONS_TIPOS_MO] FOREIGN KEY ([ID_TIPOS_MODALIDAD_POR_INSTITUCION]) REFERENCES [maestro].[tipos_modalidad_por_institucion] ([ID_TIPOS_MODALIDAD_POR_INSTITUCION])
);


GO
CREATE NONCLUSTERED INDEX [IDX_POSTULANTES_POR_MODALIDAD1]
    ON [transaccional].[postulantes_por_modalidad]([ID_POSTULANTES_POR_MODALIDAD] ASC, [ID_MODALIDADES_POR_PROCESO_ADMISION] ASC, [ID_TIPOS_MODALIDAD_POR_INSTITUCION] ASC, [ID_EXAMEN_ADMISION_SEDE] ASC, [ID_PERSONA_INSTITUCION] ASC, [ID_INSTITUCION_BASICA] ASC, [ID_TIPO_DOCUMENTO_APODERADO] ASC, [NUMERO_DOCUMENTO_APODERADO] ASC, [ID_TIPO_PARENTEZCO] ASC, [ES_ACTIVO] ASC, [ESTADO] ASC)
    INCLUDE([ANIO_EGRESO], [ID_TIPO_PAGO], [MONTO_PAGO], [MOTIVO_EXONERACION], [ARCHIVO_FOTO]);
