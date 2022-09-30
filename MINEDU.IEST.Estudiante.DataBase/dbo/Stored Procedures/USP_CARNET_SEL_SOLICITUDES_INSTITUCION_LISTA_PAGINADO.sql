/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	17/05/2022
LLAMADO POR			:
DESCRIPCION			:	Obtiene los registros de las solicitudes de la institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

TEST:			
	USP_CARNET_SEL_SOLICITUDES_INSTITUCION_LISTA_PAGINADO 1911,'',0
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_CARNET_SEL_SOLICITUDES_INSTITUCION_LISTA_PAGINADO] 
( 
	@ID_INSTITUCION			                INT,
	@ID_PERIODO_LECTIVO_INSTITUCION			INT,
	@STATUS			                        INT,
	@NRO_SOLICITUD			                INT,
	@Pagina					                int = 1,
	@Registros				                int = 10

	--DECLARE @ID_INSTITUCION			                INT=1911
	--DECLARE @ID_PERIODO_LECTIVO_INSTITUCION			INT=4154
	--DECLARE @STATUS			                        INT=0
	--DECLARE @NRO_SOLICITUD			                INT=0
	--DECLARE @Pagina					                int = 1
	--DECLARE @Registros				                int = 10
)  
AS  
BEGIN  
	SET NOCOUNT ON;
	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1;  
	   
	   	WITH    tempPaginado AS
	(	   
		SELECT 
		ID_SOLICITUD_CARNET,
		NRO_SOLICITUD, 
		ESTADO_ACTUAL,
		OBSERVACIONES,
		ROW_NUMBER() OVER ( ORDER BY scarnet.NRO_SOLICITUD,scarnet.ESTADO_ACTUAL) AS Row,
		Total = COUNT(1) OVER ( )  
		FROM transaccional.solicitud_carnet scarnet INNER JOIN transaccional.periodos_lectivos_por_institucion plectivo
		ON scarnet.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION

		WHERE 
				((ESTADO_ACTUAL = @STATUS) OR @STATUS=0)
				
				AND (scarnet.NRO_SOLICITUD = @NRO_SOLICITUD OR @NRO_SOLICITUD=0)
				AND scarnet.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
				AND scarnet.ES_ACTIVO =1 


	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END