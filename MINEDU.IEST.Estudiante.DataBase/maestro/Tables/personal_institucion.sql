CREATE TABLE [maestro].[personal_institucion] (
    [ID_PERSONAL_INSTITUCION]              [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_PERSONA_INSTITUCION]               [dbo].[ID]            NOT NULL,
    [ID_PERIODOS_LECTIVOS_POR_INSTITUCION] [dbo].[ID]            NOT NULL,
    [CONDICION_LABORAL]                    [dbo].[ID]            NOT NULL,
    [CARGO_PERSONA]                        [dbo].[ID]            NOT NULL,
    [ID_TIPO_PERSONAL]                     [dbo].[ID]            NOT NULL,
    [ID_ROL]                               [dbo].[ID]            NOT NULL,
    [ID_PERMISO_PASSPORT]                  [dbo].[NUMERO_ENTERO] NULL,
    [ES_ACTIVO]                            [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                               [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                     [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                       [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]                 [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                   [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_PERSONAL_INSTITUCION] PRIMARY KEY NONCLUSTERED ([ID_PERSONAL_INSTITUCION] ASC),
    CONSTRAINT [FK_PERSONAL_FK_PERSON_PERSONA_] FOREIGN KEY ([ID_PERSONA_INSTITUCION]) REFERENCES [maestro].[persona_institucion] ([ID_PERSONA_INSTITUCION]),
    CONSTRAINT [FK_PERSONAL_RELATIONS_PERIODOS] FOREIGN KEY ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION]) REFERENCES [transaccional].[periodos_lectivos_por_institucion] ([ID_PERIODOS_LECTIVOS_POR_INSTITUCION])
);




GO



GO
CREATE NONCLUSTERED INDEX [IDX_PERSONAL_INSTITUCION1]
    ON [maestro].[personal_institucion]([ID_PERSONAL_INSTITUCION] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_PERSONA_INSTITUCION]);

