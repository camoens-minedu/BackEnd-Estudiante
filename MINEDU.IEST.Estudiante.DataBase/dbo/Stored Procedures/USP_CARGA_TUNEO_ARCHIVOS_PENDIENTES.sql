-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		21/11/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	Obtiene las cabeceras de los archivos de carga por TIPO_CARGA

--  TEST:			EXEC USP_CARGA_TUNEO_ARCHIVOS_PENDIENTES 1

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_CARGA_TUNEO_ARCHIVOS_PENDIENTES]
	@ID_TIPO_CARGA int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		c.ID_CARGA,
		c.NOMBRE_ARCHIVO NombreArchivo,
		c.USUARIO_CREACION,
		c.FECHA_CREACION
	FROM archivo.carga c WITH (NOLOCK)
	WHERE
		c.ID_TIPO_CARGA = @ID_TIPO_CARGA
		AND c.ESTADO = 0 -- Pendientes
		AND c.ES_BORRADO = 0;
END
GO


