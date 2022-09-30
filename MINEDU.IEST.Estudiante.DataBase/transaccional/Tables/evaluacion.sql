CREATE TABLE [transaccional].[evaluacion] (
    [ID_EVALUACION]         [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PROGRAMACION_CLASE] [dbo].[ID]           NULL,
    [FECHA_NOTA]            [dbo].[FECHA]        NULL,
    [ES_ACTIVO]             [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                [dbo].[ESTADO]       NOT NULL,
    [CIERRE_PROGRAMACION]   INT                  NULL,
    [USUARIO_CREACION]      [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]        [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]  [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]    [dbo].[FECHA_TIEMPO] NULL,
    [ID_CARRERA]            INT                  NULL,
    [ID_UNIDAD_DIDACTICA]   INT                  NULL,
    CONSTRAINT [PK_EVALUACION] PRIMARY KEY NONCLUSTERED ([ID_EVALUACION] ASC),
    CONSTRAINT [FK_EVALUACI_RELATIONS_PROGRAMA] FOREIGN KEY ([ID_PROGRAMACION_CLASE]) REFERENCES [transaccional].[programacion_clase] ([ID_PROGRAMACION_CLASE])
);




GO



GO
CREATE NONCLUSTERED INDEX [IDX_EVALUACION1]
    ON [transaccional].[evaluacion]([ID_PROGRAMACION_CLASE] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_EVALUACION]);

