/************************************************************************************************************************************
AUTOR				:	MANUEL RUIZ FIESTAS
FECHA DE CREACION	:	18/09/2017
LLAMADO POR			:
DESCRIPCION			:	Listado de periodos lectivos
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:		  USP_MAESTROS_SEL_PERIODO_LECTIVO_LISTA 290, 46
/*
	1.0			19/12/2019		MALVA			MODIFICACIÓN DE CONSULTA 
	1.1			23/03/2021		JCHAVEZ			MODIFICACION DE ORDEN
	1.1			10/09/2021		JCHAVEZ			MODIFICACIÓN PARA QUITAR DE ROLES
*/
*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PERIODO_LECTIVO_LISTA]
(
	@ID_INSTITUCION    INT,
	@ID_ROL		    INT
)
AS

DECLARE @numerologia CHAR(1)

DECLARE @ESTADO_ACTIVO_PL INT = 1

DECLARE @P int = (SELECT Count(pl.ID_PERIODO_LECTIVO) FROM maestro.periodo_lectivo pl WHERE pl.ESTADO=@ESTADO_ACTIVO_PL )
DECLARE @PLI int = (SELECT Count(pli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION) from  transaccional.periodos_lectivos_por_institucion pli WHERE 
					pli.ES_ACTIVO=1 AND  pli.ID_INSTITUCION=@ID_INSTITUCION)
					--AND pli.ESTADO IN (7,8))
SELECT @numerologia = CONVERT (CHAR, VALOR_PARAMETRO) FROM sistema.parametro WHERE NOMBRE_PARAMETRO = 'Numerologia'
PRINT @P
PRINT @PLI

declare @Tmp TABLE
(
    Value int NOT NULL,
    Text  nchar(50) NOT NULL,
    Code  int
);


IF @P=0
BEGIN
	INSERT INTO @Tmp 	(	    [Value], 	    Text,	    Code	)
	VALUES
	(	    0,	 -- Value - int
	    N'-', -- Text - nchar
	    8888	 -- Code - int
	)
END
ELSE
    IF @PLI=0
    BEGIN
	    INSERT INTO @Tmp ( [Value], 	    Text,	    Code   )
	    VALUES
	    (
		   0,	 -- Value - int
		   N'-', -- Text - nchar
		   9999	 -- Code - int
	    )
    END
    ELSE
    
    BEGIN

    --IF @ID_ROL=47 OR  @ID_ROL=46 OR @ID_ROL =48 OR @ID_ROL =49 OR @ID_ROL = 10083 OR @ID_ROL =337 --Director IEST, Especialista MINEDU, Secretario académico, Docente, Especialista Funcional, Especialista DRE
    BEGIN 
		  SELECT SplitData INTO #Consulta FROM dbo.UFN_SPLIT('7,8',',') 
				  WHERE SplitData <> (CASE WHEN 46 =49 THEN 8 ELSE 0 END)

		  INSERT INTO @Tmp ( [Value], 	    Text,	    Code   )
		   SELECT DISTINCT
				pli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	as Value,		
				CASE @numerologia
				WHEN '1' THEN CAST(pl.CODIGO_PERIODO_LECTIVO AS VARCHAR)
				WHEN 'I' THEN CAST(pl.ANIO AS VARCHAR) + '-' + dbo.UFN_CST_numero_romano(CAST(SUBSTRING(pl.CODIGO_PERIODO_LECTIVO,6,1) AS INT)) 
				WHEN 'A' THEN CAST(pl.ANIO AS VARCHAR) + '-' + dbo.UFN_CST_numero_texto(CAST(SUBSTRING(pl.CODIGO_PERIODO_LECTIVO,6,1) AS INT)) 
				ELSE CAST(pl.CODIGO_PERIODO_LECTIVO AS VARCHAR) END AS Text,
				pl.ID_PERIODO_LECTIVO as Code		    
		   FROM maestro.periodo_lectivo pl 
			   INNER JOIN transaccional.periodos_lectivos_por_institucion pli ON pl.ID_PERIODO_LECTIVO = pli.ID_PERIODO_LECTIVO			   			   
		   WHERE pli.ID_INSTITUCION = @ID_INSTITUCION	
			   AND pli.ES_ACTIVO = 1
			   AND pli.ESTADO IN (SELECT SplitData FROM #Consulta) 
    END   
END
SELECT   Value ,   Text  ,    Code FROM @Tmp
ORDER BY Text DESC, Code DESC
GO


