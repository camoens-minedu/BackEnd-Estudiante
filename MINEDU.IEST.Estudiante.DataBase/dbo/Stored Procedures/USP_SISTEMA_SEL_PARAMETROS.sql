/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	24/08/2021
LLAMADO POR			:
DESCRIPCION			:	Listalos registros de la tabla PARAMETRO en el SISTEMA
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
  TEST:			
		USP_SISTEMA_SEL_PARAMETROS '',1,10
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_PARAMETROS]
(
     @PARAMETRO VARCHAR(50),
	--@VALOR INT,
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
		ID_PARAMETRO                                       IdParametro,
		CODIGO_PARAMETRO                                   Codigo,
		NOMBRE_PARAMETRO                                   Nombre,
		VALOR_PARAMETRO                                    Valor,
		ESTADO                                             Estado,
		
		ROW_NUMBER() OVER ( ORDER BY ID_PARAMETRO) AS Row,
		Total = COUNT(1) OVER (  )
		FROM sistema.parametro 
		WHERE
		UPPER(NOMBRE_PARAMETRO) LIKE '%' + UPPER(ISNULL(@PARAMETRO,'')) + '%' AND		
		--VALOR_PARAMETRO = CASE WHEN @VALOR IS NULL	OR	LEN(@VALOR) = 0		OR @VALOR = ''	THEN ESTADO	ELSE @VALOR	END AND
		ESTADO = 1
	)
	SELECT  *
    FROM    tempPaginado T   WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END