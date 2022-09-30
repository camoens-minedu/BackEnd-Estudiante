﻿-- USE db_regia_2
-- CIERRE_PROGRAMACION:  1 ->CERRADO //  0 -> ABIERTO
-- USP_EVALUACION_SEL_CIERRE_PERIODO_LECTIVO_PAGINADO 5520

CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_CIERRE_PERIODO_LECTIVO_PAGINADO](
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@Pagina									int = 1,
	@Registros								int = 1000

	--DECLARE @ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT= 1667
	--DECLARE @Pagina									int = 1
	--DECLARE @Registros								int = 1000

)
AS  
BEGIN  
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
	SET @hasta = ( @Pagina * @Registros ) + 1;  
	
		
		;WITH TEMP01 AS (
			SELECT
			DISTINCT 
				ID_PERIODO_ACADEMICO,ID_PERIODOS_LECTIVOS_POR_INSTITUCION,NOMBRE_PERIODO_ACADEMICO
			FROM  transaccional.periodo_academico 
			WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
			AND ES_ACTIVO=1
		
		), TEMP02 AS (
			SELECT 
			DISTINCT 
			A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
			A.ID_PERIODO_ACADEMICO,
			A.NOMBRE_PERIODO_ACADEMICO				AS PeriodoAcademico,
			B.ESTADO								as ESTADO_pc,
			CASE ISNULL(B.ESTADO,0) 
					WHEN 1 THEN 'ABIERTO'
					WHEN 0 THEN 'CERRADO'
					END 									AS estado
			FROM transaccional.periodo_academico A
			INNER JOIN transaccional.programacion_clase B	ON A.ID_PERIODO_ACADEMICO=B.ID_PERIODO_ACADEMICO AND A.ES_ACTIVO=1 AND B.ES_ACTIVO=1
			--LEFT JOIN transaccional.evaluacion C			ON B.ID_PROGRAMACION_CLASE=C.ID_PROGRAMACION_CLASE AND C.ES_ACTIVO=1
			INNER JOIN transaccional.evaluacion C			ON B.ID_PROGRAMACION_CLASE=C.ID_PROGRAMACION_CLASE AND C.ES_ACTIVO=1
			WHERE 
			A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOS_LECTIVOS_POR_INSTITUCION --895--@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
		-- @ID_PERIODOS_LECTIVOS_POR_INSTITUCION		
		), tempPaginado AS (
			SELECT 
			A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AS IdPeriodosLectivosInstitucion,
			A.ID_PERIODO_ACADEMICO IdPeriodoAcademico,
			A.NOMBRE_PERIODO_ACADEMICO AS PeriodoAcademico,
			B.ESTADO_pc,
			ISNULL(B.estado,'ABIERTO') AS estado,
			ROW_NUMBER() OVER ( ORDER BY A.ID_PERIODO_ACADEMICO) AS Row,
			Total = count(1) OVER ()			
			FROM TEMP01 A
			LEFT JOIN TEMP02 B ON A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=B.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND A.ID_PERIODO_ACADEMICO=B.ID_PERIODO_ACADEMICO		 
		 )
		 SELECT  *    FROM    tempPaginado T    
		 WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)

END
GO

