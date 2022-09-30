/**********************************************************************************************************
AUTOR				:	Luis Espinoza
FECHA DE CREACION	:	12/03/2021
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro de pago por institucion 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_INS_PAGO]
(    
    @ID_INSTITUCION  int,
    @TIPO_PAGO				int = 0,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	int = 0,
	@ID_SEDE_INSTITUCION	int = 0,
	@ID_CARRERA		int = 0,
    @VALOR		   decimal = 0,
    @ES_ACTIVO		   bit = 1,
    @ESTADO			   smallint = 118,
    @USUARIO_CREACION	   nvarchar(20)
)
AS
DECLARE @RESULT INT
--IF EXISTS(SELECT TOP 1 [ID_PAGO_INSTITUCION] FROM [transaccional].[pago_institucion]
--WHERE TIPO_PAGO COLLATE LATIN1_GENERAL_CI_AI = UPPER(@NUMERO_AULA) COLLATE LATIN1_GENERAL_CI_AI  AND ES_ACTIVO=1 AND CATEGORIA_AULA=@CATEGORIA_AULA AND ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION)
IF EXISTS(SELECT TOP 1 [ID_PAGO_INSTITUCION] FROM [transaccional].[pago_institucion] (nolock)
WHERE TIPO_PAGO  = @TIPO_PAGO 
	AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION  
	AND ID_INSTITUCION = @ID_INSTITUCION 
	AND ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION 
	AND ID_CARRERA = @ID_CARRERA 	
	AND ES_ACTIVO=1)	 
	SET @RESULT = -180
ELSE
BEGIN


INSERT INTO [transaccional].[pago_institucion]
           ([ID_INSTITUCION]
		   ,[ID_PERIODOS_LECTIVOS_POR_INSTITUCION]
           ,[TIPO_PAGO]
           ,[ID_SEDE_INSTITUCION]
		   ,[ID_CARRERA]
           ,[VALOR]
           ,[ES_ACTIVO]
           ,[ESTADO]
           ,[FECHA_CREACION]
           ,[USUARIO_CREACION]
		 )
     VALUES
           (@ID_INSTITUCION 
		  ,@ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
		  ,@TIPO_PAGO
		  ,@ID_SEDE_INSTITUCION	  
		  ,@ID_CARRERA
		  ,@VALOR		  
		  ,@ES_ACTIVO		  
		  ,@ESTADO			  
		  ,GETDATE()
		  ,@USUARIO_CREACION	  
		  )

	SET @RESULT = 1
END
SELECT @RESULT














/****** Object:  StoredProcedure [dbo].[USP_TRANSACCIONAL_UPD_PAGO]    Script Date: 28/02/2021 20:25:16 ******/
SET ANSI_NULLS ON