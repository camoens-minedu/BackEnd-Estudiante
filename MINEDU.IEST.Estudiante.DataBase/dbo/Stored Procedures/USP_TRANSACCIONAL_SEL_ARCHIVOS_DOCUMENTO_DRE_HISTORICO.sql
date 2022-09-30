/*************************************************************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Listado de archivos documento DRE histórico. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE	Creación

TEST:
	USP_TRANSACCIONAL_SEL_ARCHIVOS_DOCUMENTO_DRE_HISTORICO 1,1,3
**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].USP_TRANSACCIONAL_SEL_ARCHIVOS_DOCUMENTO_DRE_HISTORICO (
	@ID_DOCUMENTOS_DRE					INT,
	@Pagina							int = 1,
	@Registros						int = 3  
) AS
BEGIN  
 SET NOCOUNT ON;  
 
 DECLARE @desde INT , @hasta INT;  
 SET @desde = ( @Pagina - 1 ) * @Registros;  
    SET @hasta = ( @Pagina * @Registros ) + 1;    
  
 WITH    tempPaginado AS  
 ( 
	SELECT 
	ch.ID_INSTITUCION IdInstitucion,
	docdre_arch.ID_DOCUMENTOS_DRE_ARCHIVOS as IdDocumentosDreArchivos,
	docdre_arch.ID_DOCUMENTOS_DRE as IdDocumentosDre,
	dd.ID_CLASE_HISTORICA as IdClaseHistorica,
	docdre_arch.NOMBRE_DOCUMENTO as NombreDocumento,
	docdre_arch.NOMBRE_ARCHIVO as NombreArchivo,
	ROW_NUMBER() OVER ( ORDER BY  docdre_arch.ID_DOCUMENTOS_DRE_ARCHIVOS ASC ) AS Row,
	Total = COUNT(1) OVER ( )  
	FROM transaccional.documentos_dre_archivos as docdre_arch
	INNER JOIN transaccional.documentos_dre dd ON dd.ID_DOCUMENTOS_DRE = docdre_arch.ID_DOCUMENTOS_DRE
	INNER JOIN maestro.clase_historica ch ON ch.ID_CLASE_HISTORICA = dd.ID_CLASE_HISTORICA
	WHERE docdre_arch.ID_DOCUMENTOS_DRE = @ID_DOCUMENTOS_DRE AND docdre_arch.ESTADO = 1
		)
SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
END