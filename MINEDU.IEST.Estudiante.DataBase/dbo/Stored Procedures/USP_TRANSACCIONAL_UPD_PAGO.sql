-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:		LUIS ESPINOZA
--  CREACION:		28/02/2021
--  BASE DE DATOS:	DB_REGIA
--  DESCRIPCION:	ACTUALIZACION DE LA INFORMACION DE PAGO

--  TEST:

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_UPD_PAGO]
(
    @ID_PAGO_INSTITUCION	int,
	@ID_INSTITUCION  int,
    @TIPO_PAGO				int = 0,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	int = 0,
	@ID_SEDE_INSTITUCION	int = 0,
	@ID_CARRERA		int = 0,
    @VALOR		   decimal = 0,
    @ES_ACTIVO		   bit = 1,
    @ESTADO			   smallint = 118,
    @USUARIO_MODIFICACION	   nvarchar(20)
)
AS
DECLARE @RESULT INT

--IF EXISTS(SELECT TOP 1 ID_AULA FROM [maestro].[aula] 
--WHERE NOMBRE_AULA COLLATE LATIN1_GENERAL_CI_AI = UPPER(@NUMERO_AULA) COLLATE LATIN1_GENERAL_CI_AI AND ID_AULA <> @ID_AULA AND ES_ACTIVO=1 
--AND CATEGORIA_AULA=@CATEGORIA_AULA AND ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION)
--	SET @RESULT = -180
--ELSE
IF EXISTS(SELECT TOP 1 [ID_PAGO_INSTITUCION] FROM [transaccional].[pago_institucion] (nolock)
WHERE TIPO_PAGO  = @TIPO_PAGO 
	AND ID_PAGO_INSTITUCION <> @ID_PAGO_INSTITUCION
	AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION  
	AND ID_INSTITUCION = @ID_INSTITUCION 
	AND ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION 
	AND ID_CARRERA = @ID_CARRERA 	
	AND ES_ACTIVO=1)	 
	SET @RESULT = -180

ELSE
BEGIN
    UPDATE [transaccional].[pago_institucion]
	  SET 
		 [ID_SEDE_INSTITUCION]		= @ID_SEDE_INSTITUCION  
		,[TIPO_PAGO]				= @TIPO_PAGO		 
		,[ID_CARRERA]				= @ID_CARRERA		 
		,[VALOR]					= @VALOR	
		,[FECHA_MODIFICACION]		= GETDATE()   
		,[USUARIO_MODIFICACION]		= @USUARIO_MODIFICACION 
	WHERE 
		  [ID_PAGO_INSTITUCION]		= @ID_PAGO_INSTITUCION
		  AND ES_ACTIVO = 1		      

	    SET @RESULT = 1
END
SELECT @RESULT










/****** Object:  StoredProcedure [dbo].[USP_TRANSACCIONAL_DEL_PAGO]    Script Date: 28/02/2021 20:26:58 ******/
SET ANSI_NULLS ON