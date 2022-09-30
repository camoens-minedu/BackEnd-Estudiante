CREATE TABLE [transaccional].[unidad_didactica] (
    [ID_UNIDAD_DIDACTICA]          [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_MODULO]                    [dbo].[ID]            NOT NULL,
    [ID_SEMESTRE_ACADEMICO]        [dbo].[ID_ENUMERADO]  NULL,
    [ID_TIPO_UNIDAD_DIDACTICA]     INT                   NULL,
    [CODIGO_UNIDAD_DIDACTICA]      [dbo].[CODIGO_LARGO]  NULL,
    [NOMBRE_UNIDAD_DIDACTICA]      [dbo].[NOMBRE_LARGO]  NULL,
    [DESCRIPCION]                  [dbo].[DESCRIPCION]   NULL,
    [PERIODO_ACADEMICO_I]          DECIMAL (5, 1)        NULL,
    [PERIODO_ACADEMICO_II]         DECIMAL (5, 1)        NULL,
    [PERIODO_ACADEMICO_III]        DECIMAL (5, 1)        NULL,
    [PERIODO_ACADEMICO_IV]         DECIMAL (5, 1)        NULL,
    [PERIODO_ACADEMICO_V]          DECIMAL (5, 1)        NULL,
    [PERIODO_ACADEMICO_VI]         DECIMAL (5, 1)        NULL,
    [TEORICO_PRACTICO_HORAS_UD]    DECIMAL (5, 1)        NULL,
    [PRACTICO_HORAS_UD]            DECIMAL (5, 1)        NULL,
    [HORAS]                        DECIMAL (5, 1)        NULL,
    [TEORICO_PRACTICO_CREDITOS_UD] DECIMAL (5, 1)        NULL,
    [PRACTICO_CREDITOS_UD]         DECIMAL (5, 1)        NULL,
    [CREDITOS]                     DECIMAL (5, 1)        NULL,
    [CREDITOS_ME]                  [dbo].[NUMERO_ENTERO] NULL,
    [ES_ACTIVO]                    [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                       [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]             [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]               [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]         [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]           [dbo].[FECHA_TIEMPO]  NULL,
    [PERIODO_ACADEMICO_VII]        DECIMAL (5, 1)        NULL,
    [PERIODO_ACADEMICO_VIII]       DECIMAL (5, 1)        NULL,
    CONSTRAINT [PK_UNIDAD_DIDACTICA] PRIMARY KEY NONCLUSTERED ([ID_UNIDAD_DIDACTICA] ASC),
    CONSTRAINT [FK_UNID_FK_UNID_TIP] FOREIGN KEY ([ID_TIPO_UNIDAD_DIDACTICA]) REFERENCES [maestro].[tipo_unidad_didactica] ([ID_TIPO_UNIDAD_DIDACTICA]),
    CONSTRAINT [FK_UNIDAD_D_FK_MODULO_MODULO] FOREIGN KEY ([ID_MODULO]) REFERENCES [transaccional].[modulo] ([ID_MODULO])
);


GO
CREATE NONCLUSTERED INDEX [IDX_UNIDAD_DIDACTICA3]
    ON [transaccional].[unidad_didactica]([ID_UNIDAD_DIDACTICA] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_MODULO], [ID_SEMESTRE_ACADEMICO]);


GO
CREATE NONCLUSTERED INDEX [IDX_UNIDAD_DIDACTICA2]
    ON [transaccional].[unidad_didactica]([ID_MODULO] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_UNIDAD_DIDACTICA], [ID_SEMESTRE_ACADEMICO], [NOMBRE_UNIDAD_DIDACTICA]);


GO
CREATE NONCLUSTERED INDEX [IDX_UNIDAD_DIDACTICA1]
    ON [transaccional].[unidad_didactica]([ID_SEMESTRE_ACADEMICO] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_UNIDAD_DIDACTICA], [ID_MODULO], [NOMBRE_UNIDAD_DIDACTICA]);

