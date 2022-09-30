--/************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Listado de enumerados
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		[USP_MAESTROS_SEL_ENUMERADO] 54,'d'
--/*
--	1.0			20/12/2019		MALVA          MODIFICACIÓN PARA QUE NO SE LISTE ENUMERADOS CON ESTADO = 0
--*/
--*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_ENUMERADO] 
(
     @IdTipoEnumerado		  int,
	@Descripcion					nvarchar(50)='',
	@IdEstado					int=0,
	@Pagina						int		=1,
	@Registros					int		=10
    ) 

AS
DECLARE @desde INT , @hasta INT
SET @desde = ( @Pagina - 1 ) * @Registros;
SET @hasta = ( @Pagina * @Registros ) + 1; 

	WITH    tempPaginado AS
	(
		SELECT  
		ROW_NUMBER() OVER ( ORDER BY ID_ENUMERADO) AS Row,
			ID_ENUMERADO AS IdEnumerado,
			VALOR_ENUMERADO AS Descripcion,
			ESTADO AS IdEstado,
			(CASE WHEN ES_EDITABLE = 1 THEN cast(1 AS bit) ELSE cast(0 AS bit) END) AS EsRestringido,
			ID_TIPO_ENUMERADO IdTipoEnumerado,
			Total = COUNT(1) OVER ( ) 

		FROM sistema.enumerado  
		WHERE 
			ID_TIPO_ENUMERADO=@IdTipoEnumerado
			AND (VALOR_ENUMERADO COLLATE LATIN1_GENERAL_CI_AI LIKE '%'+ @Descripcion + '%' COLLATE LATIN1_GENERAL_CI_AI OR @Descripcion = '')
			AND ESTADO <> 0 AND (ESTADO = @IdEstado OR @IdEstado = 0)
	)
	SELECT  *,(SELECT e.VALOR_ENUMERADO FROM sistema.enumerado e WHERE e.ID_ENUMERADO=T.IdEstado) AS Estado
    FROM    tempPaginado T
    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)

	ORDER BY 1 asc
GO


