--/************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Inserta el registro del cronograma de metas de atención
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		USP_MAESTROS_INS_CRONOGRAMA_META 
--/*
--	1.0			26/12/2019		MALVA          MODIFICACIÓN PARA EVALUAR SI YA EXISTE EL CRONOGRAMA.
--*/
--*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_INS_CRONOGRAMA_META]
(
	@ID_PERIODO_LECTIVO_INSTITUCION INT,
	@FECHA_INICIO DATETIME,
	@FECHA_FIN	DATETIME,
	@USUARIO	VARCHAR(20)
)
AS
DECLARE @RESULT  INT
IF EXISTS (	SELECT TOP 1 cma.ID_CRONOGRAMA_META_ATENCION  FROM maestro.cronograma_meta_atencion cma 
			INNER JOIN transaccional.periodos_lectivos_por_institucion plpi ON cma.ID_PERIODO_LECTIVO = plpi.ID_PERIODO_LECTIVO 
			AND cma.ESTADO=1 AND plpi.ES_ACTIVO=1
			WHERE plpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION =@ID_PERIODO_LECTIVO_INSTITUCION)
BEGIN

SET @RESULT = -180

END
ELSE
BEGIN

DECLARE @NOMBRE_CRONOGRAMA_META VARCHAR(100)
SET @NOMBRE_CRONOGRAMA_META =	(SELECT ISNULL((SELECT 'CRONOGRAMA DE META DE ATENCIÓN ' + CONVERT(VARCHAR,PL.CODIGO_PERIODO_LECTIVO)
								FROM transaccional.periodos_lectivos_por_institucion PLI INNER JOIN maestro.periodo_lectivo PL ON PL.ID_PERIODO_LECTIVO = PLI.ID_PERIODO_LECTIVO 
								WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION),''))
INSERT INTO maestro.cronograma_meta_atencion(ID_PERIODO_LECTIVO,NOMBRE_CRONOGRAMA_META,FECHA_INICIO,FECHA_FIN,ESTADO,USUARIO_CREACION,FECHA_CREACION)
VALUES(
	(SELECT ID_PERIODO_LECTIVO FROM transaccional.periodos_lectivos_por_institucion WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION),
	@NOMBRE_CRONOGRAMA_META,
	@FECHA_INICIO,
	@FECHA_FIN,
	1,
	@USUARIO,
	GETDATE()
)
SET @RESULT = CONVERT(INT,@@IDENTITY)
END
SELECT @RESULT
GO


