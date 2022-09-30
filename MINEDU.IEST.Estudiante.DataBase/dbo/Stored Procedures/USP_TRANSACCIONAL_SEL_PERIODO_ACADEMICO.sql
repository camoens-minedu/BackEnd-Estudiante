﻿CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_PERIODO_ACADEMICO]
(
	@ID_PERIODO_LECTIVO_INSTITUCION INT,
	@NOMBRE_PERIODO_ACADEMICO	VARCHAR(30)='',
	--@FECHA_INICIO DATETIME= NULL,
	--@FECHA_FIN DATETIME= NULL,
	@Pagina						int		=1,
	@Registros					int		=10
)AS
BEGIN
SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;

	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 
    
	WITH    tempPaginado AS
	(
	SELECT 
	ID_PERIODO_ACADEMICO            IdPeriodoAcademico,
	UPPER(NOMBRE_PERIODO_ACADEMICO)		NombrePeriodoAcademico,
	FECHA_INICIO							FechaInicio,
	FECHA_FIN								FechaFin,
	ROW_NUMBER() OVER ( ORDER BY ID_PERIODO_ACADEMICO) AS Row,			
	Total = COUNT(1) OVER ( )
	FROM 
		transaccional.periodo_academico
	WHERE 
	ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
	--AND NOMBRE_PERIODO_ACADEMICO = CASE WHEN @NOMBRE_PERIODO_ACADEMICO IS NULL OR LEN(@NOMBRE_PERIODO_ACADEMICO) = 0 OR @NOMBRE_PERIODO_ACADEMICO = '' THEN NOMBRE_PERIODO_ACADEMICO ELSE @NOMBRE_PERIODO_ACADEMICO	END
	 AND ((NOMBRE_PERIODO_ACADEMICO LIKE '%' + ISNULL(@NOMBRE_PERIODO_ACADEMICO,'') + '%' COLLATE LATIN1_GENERAL_CI_AI) OR RTRIM(LTRIM(@NOMBRE_PERIODO_ACADEMICO))='')
	AND ES_ACTIVO = 1

--NOMBRE_PERIODO_ACADEMICO = @NOMBRE_PERIODO_ACADEMICO 
--OR ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION
--AND ES_ACTIVO = 1

	)
	SELECT  *
    FROM    tempPaginado T
    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END
GO

