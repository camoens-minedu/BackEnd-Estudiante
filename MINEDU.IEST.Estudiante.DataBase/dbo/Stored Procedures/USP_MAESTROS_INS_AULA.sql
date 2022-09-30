/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro de aula en el maestro
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/

CREATE PROCEDURE [dbo].[USP_MAESTROS_INS_AULA]
(    
    @ID_SEDE_INSTITUCION  int,
    @NUMERO_AULA		   nchar(10),
    @CATEGORIA_AULA	   smallint,
    @AFORO_AULA		   smallint,
    @PISO_AULA		   smallint = 0,
    @UBICACION_AULA	   nvarchar(100) = '',
    @OBSERVACION_AULA	   nvarchar(500) = '',
    @ES_ACTIVO		   bit = 1,
    @ESTADO			   smallint = 118,
    @USUARIO_CREACION	   nvarchar(20)
)
AS
DECLARE @RESULT INT
IF EXISTS(SELECT TOP 1 [ID_AULA] FROM [maestro].[aula]
WHERE NOMBRE_AULA COLLATE LATIN1_GENERAL_CI_AI = UPPER(@NUMERO_AULA) COLLATE LATIN1_GENERAL_CI_AI  AND ES_ACTIVO=1 AND CATEGORIA_AULA=@CATEGORIA_AULA AND ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION)
	SET @RESULT = -180
ELSE
BEGIN

INSERT INTO [maestro].[aula]
           ([ID_SEDE_INSTITUCION]
           ,[NOMBRE_AULA]
           ,[CATEGORIA_AULA]
           ,[AFORO_AULA]
           ,[ID_PISO]
           ,[UBICACION_AULA]
           ,[OBSERVACION_AULA]
           ,[ES_ACTIVO]
           ,[ESTADO]
           ,[FECHA_CREACION]
           ,[USUARIO_CREACION]
		 )

     VALUES
           (@ID_SEDE_INSTITUCION 
		  ,UPPER(@NUMERO_AULA)		  
		  ,@CATEGORIA_AULA	  
		  ,@AFORO_AULA		  
		  ,@PISO_AULA		  
		  ,@UBICACION_AULA	  
		  ,@OBSERVACION_AULA	  
		  ,@ES_ACTIVO		  
		  ,@ESTADO			  
		  ,GETDATE()
		  ,@USUARIO_CREACION	  
		  )

	SET @RESULT = 1
END
SELECT @RESULT
GO


