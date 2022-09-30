CREATE TABLE [transaccional].[unidad_didactica_modulo_equivalencia] (
    [ID_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA] [dbo].[ID]           IDENTITY (1, 1) NOT NULL,
    [ID_MODULO_EQUIVALENCIA]                  [dbo].[ID]           NOT NULL,
    [ID_UNIDAD_DIDACTICA]                     [dbo].[ID]           NULL,
    [ES_ACTIVO]                               BIT                  NOT NULL,
    [ESTADO]                                  INT                  NOT NULL,
    [USUARIO_CREACION]                        VARCHAR (20)         NOT NULL,
    [FECHA_CREACION]                          [dbo].[FECHA_TIEMPO] NOT NULL,
    [USUARIO_MODIFICACION]                    VARCHAR (20)         NULL,
    [FECHA_MODIFICACION]                      [dbo].[FECHA_TIEMPO] NULL,
    CONSTRAINT [PK_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA] PRIMARY KEY NONCLUSTERED ([ID_UNIDAD_DIDACTICA_MODULO_EQUIVALENCIA] ASC),
    FOREIGN KEY ([ID_MODULO_EQUIVALENCIA]) REFERENCES [transaccional].[modulo_equivalencia] ([ID_MODULO_EQUIVALENCIA]),
    FOREIGN KEY ([ID_UNIDAD_DIDACTICA]) REFERENCES [transaccional].[unidad_didactica] ([ID_UNIDAD_DIDACTICA])
);



