-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		15/10/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	INSERTA ERRORES EN LA BASE DE DATOS

--  TEST:			EXEC SISTEMA_INS_ERRORES_APLICACION 443,3

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[SISTEMA_INS_ERRORES_APLICACION]
(   
	@ID_INSTITUCION			INT, 
    @ERROR_MENSAJE			VARCHAR(255),
	@STACK_TRACE			VARCHAR(3000),
	@USUARIO_CREACION		NVARCHAR(20)
)
AS

BEGIN	

	INSERT INTO sistema.registro_errores
		(
			ID_INSTITUCION
			,ERROR_MENSAJE
			,STACK_TRACE
			,USUARIO_CREACION
			,FECHA_CREACION
		)
	VALUES
		(
			@ID_INSTITUCION
			,@ERROR_MENSAJE
			,@STACK_TRACE
			,@USUARIO_CREACION
			,GETDATE()
		)	

END
GO


