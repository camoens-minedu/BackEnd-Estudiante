/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	24/08/2021
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro de PARAMETRO en el SISTEMA
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_INS_PARAMETROS]
(    
    @CODIGO        int,
    @NOMBRE		   VARCHAR(50),
    @VALOR	       VARCHAR(16),
    @USUARIO	   VARCHAR(20)
)
AS
DECLARE @RESULT INT
IF EXISTS(SELECT TOP 1 [ID_PARAMETRO] FROM [sistema].[parametro]
WHERE NOMBRE_PARAMETRO = UPPER(@NOMBRE) COLLATE LATIN1_GENERAL_CI_AI  AND ESTADO=1 AND CODIGO_PARAMETRO = @CODIGO)
	SET @RESULT = -180
ELSE
BEGIN

INSERT INTO [sistema].[parametro]
           ([CODIGO_PARAMETRO]
           ,[NOMBRE_PARAMETRO]
           ,[VALOR_PARAMETRO]
           ,[DESCRIPCION]
           ,[ESTADO]
           ,[USUARIO_CREACION]
           ,[FECHA_CREACION]
         )

     VALUES
           (@CODIGO 
		  ,UPPER(@NOMBRE)		  
		  ,@VALOR	  
		  ,NULL		  
		  ,1		  
		  ,@USUARIO	  
		  ,GETDATE()	  
		  )

	SET @RESULT = 1
END
SELECT @RESULT