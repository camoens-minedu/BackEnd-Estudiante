-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		30/05/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	OBTIENE LAS COLUMNAS DEL OBJETO PARA PODER ASIGNAR A LA EXPORTACION

--  TEST:			
/*
EXEC	USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR_COLUMNAS_LISTA_PAGINADO @ID_INSTITUCION			= 0, 
		@ID_EXPORTADOR_DATOS_CONFIGURACION	= 0,							@ID_EXPORTADOR_DATOS	= 3,	
		@ESTADO_CONSULTA					= N'',
		@Pagina								= 1,							@Registros				= 10
*/
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR_COLUMNAS_LISTA_PAGINADO] 
( 
	@ID_INSTITUCION							INT,
	@ID_EXPORTADOR_DATOS_CONFIGURACION		INT,
	@ID_EXPORTADOR_DATOS					INT,
	@ESTADO_CONSULTA						INT,	
	@Pagina									int = 1,						
	@Registros								int = 10
)  
AS

----------NUEVO
--DECLARE @ID_INSTITUCION							INT				=1911
--DECLARE @ID_EXPORTADOR_DATOS_CONFIGURACION		INT				=0
--DECLARE @ID_EXPORTADOR_DATOS					INT				=3
--DECLARE @ESTADO_CONSULTA						INT				=0
--DECLARE @Pagina									int				=1
--DECLARE @Registros								int				=10


----------MODIFICAR
--DECLARE @ID_INSTITUCION							INT				=1911
--DECLARE @ID_EXPORTADOR_DATOS_CONFIGURACION		INT				=1
--DECLARE @ID_EXPORTADOR_DATOS					INT				=3
--DECLARE @ESTADO_CONSULTA						INT				=1
--DECLARE @Pagina									int				=1
--DECLARE @Registros								int				=10

  
BEGIN  
	SET NOCOUNT ON;

	SET @Registros = 1000;

	DECLARE @desde INT , @hasta INT;

BEGIN --> CUANDO ES NUEVO
	IF @ESTADO_CONSULTA = 0
	BEGIN
	PRINT 'ENTRO 0'

		SET @desde = ( @Pagina - 1 ) * @Registros;
		SET @hasta = ( @Pagina * @Registros ) + 1;  

		WITH    tempPaginado AS
		(	   		
			SELECT
					-- 
					IdExportadorDatosDetalleEDD					= edd.ID_EXPORTADOR_DATOS_DETALLE,
					IdExportadorDatosEDD						= edd.ID_EXPORTADOR_DATOS,
					NombreColumnaObjetoEDD						= edd.NOMBRE_COLUMNA_OBJETO,
					AliasColumnaObjetoEDD						= edd.ALIAS_COLUMNA_OBJETO,				
					EsActivoEDD									= edd.ES_ACTIVO,
					EstadoEDD									= edd.ESTADO,
					--UsuarioCreacionEDD							= edd.USUARIO_CREACION,
					--FechaCreacionEDD							= edd.FECHA_CREACION,
					--UsuarioModificacionEDD						= edd.USUARIO_MODIFICACION,
					--FechaModificacionEDD						= edd.FECHA_MODIFICACION,

					--***************************************************************************************************

					--IdExportadorDatosConfiguracionEDC			= edc.ID_EXPORTADOR_DATOS_CONFIGURACION,
					--IdExportadorDatosEDC						= edc.ID_EXPORTADOR_DATOS,
					--IdInstitucionEDC							= ISNULL(edc.ID_INSTITUCION,0),
					--NombreConfiguracionEDC						= edc.NOMBRE_CONFIGURACION,
					--EsActivoEDC									= edc.ES_ACTIVO,
					--EstadoEDC									= edc.ESTADO,
					--UsuarioCreacionEDC							= edc.USUARIO_CREACION,
					--FechaCreacionEDC							= edc.FECHA_CREACION,
					--UsuarioModificacionEDC						= edc.USUARIO_MODIFICACION,
					--FechaModificacionEDC						= edc.FECHA_MODIFICACION,

					--***************************************************************************************************
				
					--IdExportadorDatosConfiguracionDetalleEDCD	= edcd.ID_EXPORTADOR_DATOS_CONFIGURACION_DETALLE,
					--IdExportadorDatosConfiguracionEDCD			= edcd.ID_EXPORTADOR_DATOS_CONFIGURACION,
					--IdExportadorDatosDetalleEDCD				= edcd.ID_EXPORTADOR_DATOS_DETALLE,
					MostrarColumnaAExportarEDCD					= CAST(0 AS BIT),
					OrdenColumnaAExportarEDCD					= CAST(ROW_NUMBER() OVER ( ORDER BY	edd.ID_EXPORTADOR_DATOS_DETALLE) AS INT),
					EsActivoEDCD								= CAST(1 AS BIT),
					EstadoEDCD									= 1,
					--UsuarioCreacionEDCD							= edcd.USUARIO_CREACION,
					--FechaCreacionEDCD							= edcd.FECHA_CREACION,
					--UsuarioModificacionEDCD						= edcd.USUARIO_MODIFICACION,
					--FechaModificacionEDCD						= edcd.FECHA_MODIFICACION,

					--***************************************************************************************************

					ROW_NUMBER() OVER ( ORDER BY	edd.ID_EXPORTADOR_DATOS_DETALLE) AS Row,
					Total = COUNT(1) OVER ( )
			FROM 
				transaccional.exportador_datos_detalle edd
				--INNER JOIN transaccional.exportador_datos_configuracion edc				ON edd.ID_EXPORTADOR_DATOS = edc.ID_EXPORTADOR_DATOS				
			WHERE 
				1 = 1
				AND edd.ID_EXPORTADOR_DATOS = @ID_EXPORTADOR_DATOS

				--NO OLVIDAR PONER ACA ABAJO ESACTIVO/ESTADO DE TODAS LAS TABLAS
				AND edd.ES_ACTIVO = 1 AND edd.ESTADO = 1
				--AND edc.ES_ACTIVO = 1 AND edc.ESTADO = 1
				--AND edcd.ES_ACTIVO = 1 AND edcd.ESTADO = 1
		)
		SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 

	END
END

BEGIN --> CUANDO ES MODIFICADO
	IF @ESTADO_CONSULTA = 1
	BEGIN
	PRINT ''
	
		SET @desde = ( @Pagina - 1 ) * @Registros;
		SET @hasta = ( @Pagina * @Registros ) + 1;  

		WITH    tempPaginado AS
		(	   		
			SELECT 
					-- 
					IdExportadorDatosDetalleEDD					= edd.ID_EXPORTADOR_DATOS_DETALLE,
					IdExportadorDatosEDD						= edd.ID_EXPORTADOR_DATOS,
					NombreColumnaObjetoEDD						= edd.NOMBRE_COLUMNA_OBJETO,
					AliasColumnaObjetoEDD						= edd.ALIAS_COLUMNA_OBJETO,				
					EsActivoEDD									= edd.ES_ACTIVO,
					EstadoEDD									= edd.ESTADO,
					--UsuarioCreacionEDD							= edd.USUARIO_CREACION,
					--FechaCreacionEDD							= edd.FECHA_CREACION,
					--UsuarioModificacionEDD						= edd.USUARIO_MODIFICACION,
					--FechaModificacionEDD						= edd.FECHA_MODIFICACION,

					--***************************************************************************************************

					--IdExportadorDatosConfiguracionEDC			= edc.ID_EXPORTADOR_DATOS_CONFIGURACION,
					--IdExportadorDatosEDC						= edc.ID_EXPORTADOR_DATOS,
					IdInstitucionEDC							= ISNULL(edc.ID_INSTITUCION,0),
					--NombreConfiguracionEDC						= edc.NOMBRE_CONFIGURACION,
					--EsActivoEDC									= edc.ES_ACTIVO,
					--EstadoEDC									= edc.ESTADO,
					--UsuarioCreacionEDC							= edc.USUARIO_CREACION,
					--FechaCreacionEDC							= edc.FECHA_CREACION,
					--UsuarioModificacionEDC						= edc.USUARIO_MODIFICACION,
					--FechaModificacionEDC						= edc.FECHA_MODIFICACION,

					--***************************************************************************************************
				
					--IdExportadorDatosConfiguracionDetalleEDCD	= edcd.ID_EXPORTADOR_DATOS_CONFIGURACION_DETALLE,
					--IdExportadorDatosConfiguracionEDCD			= edcd.ID_EXPORTADOR_DATOS_CONFIGURACION,
					--IdExportadorDatosDetalleEDCD				= edcd.ID_EXPORTADOR_DATOS_DETALLE,
					MostrarColumnaAExportarEDCD					= ISNULL(edcd.MOSTRAR_COLUMNA_A_EXPORTAR,0),
					OrdenColumnaAExportarEDCD					= ISNULL(edcd.ORDEN_COLUMNA_A_EXPORTAR,ROW_NUMBER() OVER ( ORDER BY	edd.ALIAS_COLUMNA_OBJETO)),
					EsActivoEDCD								= edcd.ES_ACTIVO,
					EstadoEDCD									= edcd.ESTADO,
					--UsuarioCreacionEDCD							= edcd.USUARIO_CREACION,
					--FechaCreacionEDCD							= edcd.FECHA_CREACION,
					--UsuarioModificacionEDCD						= edcd.USUARIO_MODIFICACION,
					--FechaModificacionEDCD						= edcd.FECHA_MODIFICACION,

					--***************************************************************************************************
					
					ROW_NUMBER() OVER ( ORDER BY edcd.ORDEN_COLUMNA_A_EXPORTAR) AS Row,
					Total = COUNT(1) OVER ( )
			FROM
				transaccional.exportador_datos_configuracion edc
				INNER JOIN transaccional.exportador_datos_configuracion_detalle edcd ON edc.ID_EXPORTADOR_DATOS_CONFIGURACION = edcd.ID_EXPORTADOR_DATOS_CONFIGURACION
				INNER JOIN transaccional.exportador_datos_detalle edd ON edcd.ID_EXPORTADOR_DATOS_DETALLE = edd.ID_EXPORTADOR_DATOS_DETALLE				
			WHERE 
				1 = 1

				AND edc.ID_EXPORTADOR_DATOS_CONFIGURACION = @ID_EXPORTADOR_DATOS_CONFIGURACION

				--AND edd.ID_EXPORTADOR_DATOS = CASE WHEN @ID_EXPORTADOR_DATOS IS NULL OR LEN(@ID_EXPORTADOR_DATOS) = 0 THEN edd.ID_EXPORTADOR_DATOS ELSE @ID_EXPORTADOR_DATOS END
				--NO OLVIDAR PONER ACA ABAJO ESACTIVO/ESTADO DE TODAS LAS TABLAS
				AND edd.ES_ACTIVO = 1 AND edd.ESTADO = 1
				--AND edc.ES_ACTIVO = 1 AND edc.ESTADO = 1
				--AND edcd.ES_ACTIVO = 1 AND edcd.ESTADO = 1				
		)
		SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 


	END
END


END
GO


