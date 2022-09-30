-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		18/12/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	REALIZAR LA BUSQUEDA DEL LOG DE CARGAS REALIZADAS MEDIANTE CARGA MASIVA 

--  TEST:			EXEC USP_ARCHIVO_SEL_OBTENER_LOG_CARGA 85,1, 10

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ARCHIVO_SEL_OBTENER_LOG_CARGA] 
(
	@ID_CARGA				int,
	@Pagina					int = 1,
	@Registros				int = 10
)
AS
BEGIN
	SET NOCOUNT ON;

	Begin --> DECLARACION DE VARIABLES		
				
		DECLARE @desde INT , @hasta INT;
		SET @desde = ( @Pagina - 1 ) * @Registros;
		SET @hasta = ( @Pagina * @Registros ) + 1;

	End

	Begin --> MOSTRAR EN GRILLA
	
		WITH    tempPaginado AS
		(	   
			SELECT
			IdCarga = cr.ID_CARGA
			,NroRegistro = lg.NRO_REGISTRO_EXCEL
			,Observacion = lg.MENSAJE
			,FechaCarga = lg.FECHA_CREACION
			,NOMBRES = dett.NOMBRES
			,APELLIDO_PATERNO = dett.APELLIDO_PATERNO
			,APELLIDO_MATERNO = dett.APELLIDO_MATERNO
			,ROW_NUMBER() OVER ( ORDER BY lg.NRO_REGISTRO_EXCEL) AS Row
			,Total					= COUNT(1) OVER ( )	
			FROM
				transaccional.log_carga lg
				INNER JOIN archivo.carga_detalle dett ON lg.ID_DET_ARCHIVO = dett.ID_DET_ARCHIVO
				INNER JOIN archivo.carga cr	ON dett.ID_CARGA = cr.ID_CARGA
			WHERE
				dett.ES_CORRECTO = 0
			AND cr.ID_CARGA = @ID_CARGA			
		)

		SELECT  
			*    
		FROM    
			tempPaginado T    
		WHERE   
			( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
	End
	 
END
GO


