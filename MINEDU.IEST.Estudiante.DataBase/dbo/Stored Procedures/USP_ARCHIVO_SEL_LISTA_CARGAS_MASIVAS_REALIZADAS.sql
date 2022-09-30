-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		15/11/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	REALIZAR LA BUSQUEDA DE CARGAS REALIZADAS MEDIANTE CARGA MASIVA 

--  TEST:			EXEC USP_ARCHIVO_SEL_LISTA_CARGAS_MASIVAS_REALIZADAS 895, 1, 10
--	MODIFICACIÓN:	Se añade el parámetro ID_PERIODO_LECTIVO_INSTITUCION, para poder reconocer la procedencia de la carga.
--					Se añade el parámetro ID_TIPO_CARGA para que el SP sea más general 26/12/2018 - MALVA.
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ARCHIVO_SEL_LISTA_CARGAS_MASIVAS_REALIZADAS]
(
	@ID_PERIODO_LECTIVO_INSTITUCION		int, 
	@ID_TIPO_CARGA						INT,
	@Pagina								int = 1,
	@Registros							int = 10
)
AS
BEGIN
	SET NOCOUNT ON;


	Begin --> DECLARACION DE VARIABLES
			
		--DECLARE @TIPO_CARGA_EVALUACION INT = 1;					--//Obtenido de la tabla: SELECT * FROM sistema.tipo_carga
				
		DECLARE @desde INT , @hasta INT;
		SET @desde = ( @Pagina - 1 ) * @Registros;
		SET @hasta = ( @Pagina * @Registros ) + 1;

	End

	Begin --> MOSTRAR EN GRILLA
	
		WITH    tempPaginado AS
		(	   
				SELECT
					 IdCarga = cr.ID_CARGA
					,NombreArchivo = cr.NOMBRE_ARCHIVO
					,FechaCarga = cr.FECHA_CREACION                            
					,TotalCorrectos = cr.TOTAL_CORRECTOS
					,TotalIncorrectos = cr.TOTAL_INCORRECTOS
					,TotalRegistros = cr.TOTAL_CORRECTOS + cr.TOTAL_INCORRECTOS
					,Mensaje = cr.MENSAJE
					,Estado = cr.ESTADO
					,ROW_NUMBER() OVER ( ORDER BY cr.ID_CARGA DESC) AS Row
					,Total					= COUNT(1) OVER ( )				
				FROM
					archivo.carga cr
				WHERE 1 = 1					
					AND cr.ES_BORRADO = 0
					AND cr.ID_TIPO_CARGA = @ID_TIPO_CARGA
					AND cr.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION				
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


