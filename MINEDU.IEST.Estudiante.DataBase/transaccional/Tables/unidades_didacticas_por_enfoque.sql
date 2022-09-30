CREATE TABLE [transaccional].[unidades_didacticas_por_enfoque] (
    [ID_UNIDADES_DIDACTICAS_POR_ENFOQUE] [dbo].[ID]            IDENTITY (1, 1) NOT NULL,
    [ID_ENFOQUES_POR_PLAN_ESTUDIO]       [dbo].[ID]            NOT NULL,
    [ID_UNIDAD_DIDACTICA]                [dbo].[ID]            NOT NULL,
    [ID_TIPO_UNIDAD_DIDACTICA]           [dbo].[ID]            NULL,
    [HORAS_EMPRESA]                      [dbo].[NUMERO_ENTERO] NULL,
    [CREDITOS_VIRTUALES]                 [dbo].[NUMERO_ENTERO] NULL,
    [ES_ACTIVO]                          [dbo].[BOOLEANO]      NOT NULL,
    [ESTADO]                             [dbo].[ESTADO]        NOT NULL,
    [USUARIO_CREACION]                   [dbo].[USUARIO]       NOT NULL,
    [FECHA_CREACION]                     [dbo].[FECHA_TIEMPO]  NOT NULL,
    [USUARIO_MODIFICACION]               [dbo].[USUARIO]       NULL,
    [FECHA_MODIFICACION]                 [dbo].[FECHA_TIEMPO]  NULL,
    CONSTRAINT [PK_UNIDADES_DIDACTICAS_POR_ENF] PRIMARY KEY NONCLUSTERED ([ID_UNIDADES_DIDACTICAS_POR_ENFOQUE] ASC),
    CONSTRAINT [FK_UNIDADES_FK_ENFOQU_ENFOQUES] FOREIGN KEY ([ID_ENFOQUES_POR_PLAN_ESTUDIO]) REFERENCES [transaccional].[enfoques_por_plan_estudio] ([ID_ENFOQUES_POR_PLAN_ESTUDIO]),
    CONSTRAINT [FK_UNIDADES_RELATIONS_TIPO_UNI] FOREIGN KEY ([ID_TIPO_UNIDAD_DIDACTICA]) REFERENCES [maestro].[tipo_unidad_didactica] ([ID_TIPO_UNIDAD_DIDACTICA]),
    CONSTRAINT [FK_UNIDADES_RELATIONS_UNIDAD_D] FOREIGN KEY ([ID_UNIDAD_DIDACTICA]) REFERENCES [transaccional].[unidad_didactica] ([ID_UNIDAD_DIDACTICA])
);


GO
CREATE NONCLUSTERED INDEX [IDX_UNIDAD_DIDACTICA_ENFOQ1]
    ON [transaccional].[unidades_didacticas_por_enfoque]([ID_UNIDAD_DIDACTICA] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_UNIDADES_DIDACTICAS_POR_ENFOQUE]);

