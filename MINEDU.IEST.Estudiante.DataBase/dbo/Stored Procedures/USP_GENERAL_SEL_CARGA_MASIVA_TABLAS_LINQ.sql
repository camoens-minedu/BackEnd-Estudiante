-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		20/11/2018
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	SELECT DE LAS TABLAS DEL METODO _FromXml

--  TEST:			EXEC USP_GENERAL_SEL_CARGA_MASIVA_TABLAS_LINQ 'tipo_discapacidad',0

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GENERAL_SEL_CARGA_MASIVA_TABLAS_LINQ]
(
	@TABLA VARCHAR(100),
	@CODIGO INT
)
AS
BEGIN 

		BEGIN --> TABLA: sistema.tipo_carga 

			IF	@TABLA = 'tipo_carga' 
			BEGIN
				SELECT 
				tc.ID_TIPO_CARGA
				,tc.CODIGO_TIPO_CARGA
				,tc.DESCRIPCION_TIPO_CARGA
				,tc.ID_GRUPO_PERSONA
				,tc.ES_BORRADO
				,tc.FECHA_CREACION
				,tc.USUARIO_CREACION
				FROM sistema.tipo_carga tc WHERE tc.CODIGO_TIPO_CARGA = @CODIGO AND tc.ES_BORRADO = 0 
			END

		END

		BEGIN --> TABLA: sistema.enumerado WHERE ID_TIPO_ENUMERADO = 9 (tipo_documento_identidad) 

			IF	@TABLA = 'tipo_documento_identidad' 
			BEGIN
				SELECT 
					ID_TIPO					= en.ID_ENUMERADO 
					,CODIGO_TIPO			= en.CODIGO_ENUMERADO	
					,DESCRIPCION_TIPO		= en.VALOR_ENUMERADO	
					,ESTADO					= en.ESTADO	
					,USUARIO_CREACION		= en.USUARIO_CREACION	
					,FECHA_CREACION			= en.FECHA_CREACION	
				FROM sistema.enumerado en 
				WHERE 
					en.ID_TIPO_ENUMERADO = 9 				
				AND en.CODIGO_ENUMERADO = CASE WHEN @CODIGO = 0 THEN en.CODIGO_ENUMERADO ELSE @CODIGO END
				AND en.ESTADO = 1
			END

		END

		BEGIN --> TABLA: sistema.enumerado WHERE ID_TIPO_ENUMERADO = 26 (tipo_discapacidad) 

			IF	@TABLA = 'tipo_discapacidad'
			BEGIN
				SELECT 
					ID_TIPO					= en.ID_ENUMERADO 
					,CODIGO_TIPO			= en.CODIGO_ENUMERADO	
					,DESCRIPCION_TIPO		= en.VALOR_ENUMERADO	
					,ESTADO					= en.ESTADO	
					,USUARIO_CREACION		= en.USUARIO_CREACION	
					,FECHA_CREACION			= en.FECHA_CREACION	
				FROM sistema.enumerado en 
				WHERE 
					en.ID_TIPO_ENUMERADO = 26 				
				AND en.CODIGO_ENUMERADO = CASE WHEN @CODIGO = 0 THEN en.CODIGO_ENUMERADO ELSE @CODIGO END
				AND en.ESTADO = 1
			END

		END

END


					--,en.ID_TIPO_ENUMERADO	
					--,en.ORDEN_ENUMERADO	
					--,en.ES_EDITABLE	
					--,en.USUARIO_MODIFICACION	
					--,en.FECHA_MODIFICACION 
GO


