/**********************************************************************************************************
AUTOR				:	MANUEL RUIZ FIESTAS
FECHA DE CREACION	:	26/06/2017
LLAMADO POR			:
DESCRIPCION			:	ACTUALIZACION DE LA INFORMACION DE AULAS
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			26/06/2017		MRUIZ			Creación
1.1			17/03/2021		JCHAVEZ			Modificación, se agregó actualización de las vacantes en las clases
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_UPD_AULA]
(
    @ID_AULA				int,
    @ID_SEDE_INSTITUCION	int,
    @NUMERO_AULA			nchar(10),
    @CATEGORIA_AULA			smallint,
    @AFORO_AULA				smallint,
	@PISO_AULA				smallint,
    @UBICACION_AULA			nvarchar(100),
    @OBSERVACION_AULA		nvarchar(500),        
    @USUARIO_MODIFICACION nvarchar(20)
)
AS
DECLARE @RESULT INT

IF EXISTS(SELECT TOP 1 ID_AULA FROM [maestro].[aula] 
WHERE NOMBRE_AULA COLLATE LATIN1_GENERAL_CI_AI = UPPER(@NUMERO_AULA) COLLATE LATIN1_GENERAL_CI_AI AND ID_AULA <> @ID_AULA AND ES_ACTIVO=1 
AND CATEGORIA_AULA=@CATEGORIA_AULA AND ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION)
	SET @RESULT = -180
ELSE
BEGIN
    UPDATE [maestro].[aula]
	  SET 
		 [ID_SEDE_INSTITUCION]		= @ID_SEDE_INSTITUCION  
		,[NOMBRE_AULA]				= UPPER(@NUMERO_AULA)		 
		,[CATEGORIA_AULA]				= @CATEGORIA_AULA		 
		,[AFORO_AULA]					= @AFORO_AULA	
		 ,[ID_PISO]					= @PISO_AULA	
		 ,[UBICACION_AULA]				= @UBICACION_AULA	
		 ,[OBSERVACION_AULA]			= @OBSERVACION_AULA		 
		,[FECHA_MODIFICACION]			= GETDATE()   
		,[USUARIO_MODIFICACION]		= @USUARIO_MODIFICACION 
	WHERE 
		  [ID_AULA]					= @ID_AULA		      

	UPDATE pc SET VACANTE_CLASE=@AFORO_AULA,USUARIO_MODIFICACION=@USUARIO_MODIFICACION,FECHA_MODIFICACION=GETDATE()
	FROM transaccional.programacion_clase pc
	INNER JOIN transaccional.sesion_programacion_clase spc ON spc.ID_PROGRAMACION_CLASE = pc.ID_PROGRAMACION_CLASE
	WHERE pc.ES_ACTIVO=1 AND spc.ES_ACTIVO=1
		AND spc.ID_AULA = @ID_AULA AND pc.ESTADO=1

	SET @RESULT = 1
END
SELECT @RESULT
GO


