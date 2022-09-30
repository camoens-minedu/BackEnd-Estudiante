-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		06/06/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	ELIMINA LA CONFIGURACION DE EXPORTACION DE DATOS

--  TEST:			
/*
EXEC USP_TRANSACCIONAL_DEL_OBJETOS_EXPORTADOR 5, N'20078244'
*/
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_DEL_OBJETOS_EXPORTADOR]
(
    @ID_EXPORTADOR_DATOS_CONFIGURACION INT,
    @USUARIO_MODIFICACION nvarchar(20)
)
AS

BEGIN

	BEGIN	--> UPDATE TABLA CABECERA: transaccional.exportador_datos_configuracion 
	PRINT ''
		UPDATE transaccional.exportador_datos_configuracion
			SET      
				ES_ACTIVO = 0
				,USUARIO_MODIFICACION = @USUARIO_MODIFICACION
				,FECHA_MODIFICACION = GETDATE()
			WHERE 
			ID_EXPORTADOR_DATOS_CONFIGURACION = @ID_EXPORTADOR_DATOS_CONFIGURACION
	END

	BEGIN	--> UPDATE TABLE CABECERA DETALLE: transaccional.exportador_datos_configuracion_detalle 
	PRINT ''
		UPDATE transaccional.exportador_datos_configuracion_detalle
			SET 
				ES_ACTIVO = 0
				,USUARIO_MODIFICACION = @USUARIO_MODIFICACION
				,FECHA_MODIFICACION = GETDATE()
			WHERE 
			ID_EXPORTADOR_DATOS_CONFIGURACION = @ID_EXPORTADOR_DATOS_CONFIGURACION 
	END		   	      

SELECT 1
END
GO


