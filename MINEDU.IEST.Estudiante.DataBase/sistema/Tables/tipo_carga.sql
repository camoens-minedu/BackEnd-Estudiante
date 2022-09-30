CREATE TABLE [sistema].[tipo_carga] (
    [ID_TIPO_CARGA]          INT          IDENTITY (1, 1) NOT NULL,
    [CODIGO_TIPO_CARGA]      INT          NOT NULL,
    [DESCRIPCION_TIPO_CARGA] VARCHAR (50) NULL,
    [ID_GRUPO_PERSONA]       INT          NULL,
    [ES_BORRADO]             BIT          NOT NULL,
    [FECHA_CREACION]         DATETIME     NOT NULL,
    [USUARIO_CREACION]       VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_tipo_carga] PRIMARY KEY CLUSTERED ([ID_TIPO_CARGA] ASC)
);

