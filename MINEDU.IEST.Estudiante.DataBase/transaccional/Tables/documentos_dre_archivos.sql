CREATE TABLE [transaccional].[documentos_dre_archivos] (
    [ID_DOCUMENTOS_DRE_ARCHIVOS] INT           IDENTITY (1, 1) NOT NULL,
    [ID_DOCUMENTOS_DRE]          INT           NOT NULL,
    [NOMBRE_DOCUMENTO]           VARCHAR (MAX) NULL,
    [NOMBRE_ARCHIVO]             VARCHAR (MAX) NULL,
    [RUTA_ARCHIVO]               VARCHAR (MAX) NULL,
    [ESTADO]                     INT           DEFAULT ((1)) NOT NULL,
    [USUARIO_CREACION]           INT           NOT NULL,
    [FECHA_CREACION]             DATETIME      NOT NULL,
    [USUARIO_MODIFICACION]       INT           NULL,
    [FECHA_MODIFICACION]         DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([ID_DOCUMENTOS_DRE_ARCHIVOS] ASC),
    FOREIGN KEY ([ID_DOCUMENTOS_DRE]) REFERENCES [transaccional].[documentos_dre] ([ID_DOCUMENTOS_DRE])
);

