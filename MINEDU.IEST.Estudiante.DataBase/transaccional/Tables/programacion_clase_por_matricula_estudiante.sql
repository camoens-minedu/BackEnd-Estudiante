CREATE TABLE [transaccional].[programacion_clase_por_matricula_estudiante] (
    [ID_PROGRAMACION_CLASE_POR_MATRICULA_ESTUDIANTE] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_PROGRAMACION_CLASE]                          [dbo].[ID]           NOT NULL,
    [ID_MATRICULA_ESTUDIANTE]                        [dbo].[ID]           NOT NULL,
    [ID_ESTADO_UNIDAD_DIDACTICA]                     [dbo].[ID_ENUMERADO] NOT NULL,
    [ES_ACTIVO]                                      [dbo].[BOOLEANO]     NOT NULL,
    [ESTADO]                                         [dbo].[ESTADO]       NOT NULL,
    [USUARIO_CREACION]                               [dbo].[USUARIO]      NOT NULL,
    [FECHA_CREACION]                                 [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                           [dbo].[USUARIO]      NULL,
    [FECHA_MODIFICACION]                             [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_PROGRAMACION_CLASE_POR_MATRICULA_ESTUDIANTE] PRIMARY KEY NONCLUSTERED ([ID_PROGRAMACION_CLASE_POR_MATRICULA_ESTUDIANTE] ASC),
    CONSTRAINT [FK_PROG_CLAS_POR_MATR_EST_FK_MATR_EST] FOREIGN KEY ([ID_MATRICULA_ESTUDIANTE]) REFERENCES [transaccional].[matricula_estudiante] ([ID_MATRICULA_ESTUDIANTE]),
    CONSTRAINT [FK_PROG_CLAS_POR_MATR_EST_FK_PROG_CLASE] FOREIGN KEY ([ID_PROGRAMACION_CLASE]) REFERENCES [transaccional].[programacion_clase] ([ID_PROGRAMACION_CLASE])
);


GO
CREATE NONCLUSTERED INDEX [IDX_PROGRAMACION_CLASE_MATR_EST1]
    ON [transaccional].[programacion_clase_por_matricula_estudiante]([ID_MATRICULA_ESTUDIANTE] ASC, [ES_ACTIVO] ASC)
    INCLUDE([ID_PROGRAMACION_CLASE]);

