/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta el registro de matricula de un estudiante del tipo por licencia 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			CREACIÓN
1.1			13/05/2020		MALVA			ADICIÓN DE PARÁMETRO @ID_ESTUDIANTE_INSTITUCION, revisar existencia de licencias otros periodos. 
1.2			05/01/2022		JCHAVEZ			SE AGREGA VALIDACIÓN SI TIENE NOTA DE EXPERIENCIA FORMATIVA
--  TEST:			
/*
USP_MATRICULA_INS_LICENCIA_ESTUDIANTE 631, 5564,27,'ce0121132123',164,166,'VerRegistroMatricula_15052019021953[].pdf','\\10.1.1.74\FileSystem\Fabrica\Regia\dev\LICENCIA_ESTUDIOS\VerRegistroMatricula_15052019021953[].pdf', 'MALVA'
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_INS_LICENCIA_ESTUDIANTE]
(
	@ID_INSTITUCION INT,
	@ID_PERIODOLECTIVO_INSTITUCION INT,
	@ID_TIPO_DOCUMENTO INT,
	@NRO_DOCUMENTO VARCHAR(15),
	@ID_TIPO_LICENCIA INT,
	@ID_TIEMPO_LICENCIA INT,
	@ARCHIVO_RD VARCHAR(50),
    @RUTA_RD VARCHAR(255),
	@ID_ESTUDIANTE_INSTITUCION INT, 
	@USUARIO VARCHAR(20)
)

AS

DECLARE @RESULT INT
/*DECLARE @ESTUDIANTE_INSTITUCION INT

SET @ESTUDIANTE_INSTITUCION = (SELECT einsti.ID_ESTUDIANTE_INSTITUCION FROM maestro.persona persona JOIN maestro.persona_institucion pinsti 
ON persona.ID_PERSONA=pinsti.ID_PERSONA JOIN transaccional.estudiante_institucion einsti 
ON pinsti.ID_PERSONA_INSTITUCION=einsti.ID_PERSONA_INSTITUCION 
WHERE persona.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO AND persona.NUMERO_DOCUMENTO_PERSONA=@NRO_DOCUMENTO
AND einsti.ES_ACTIVO=1 AND pinsti.ID_INSTITUCION=@ID_INSTITUCION 
AND einsti.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIOS
)*/


--IF EXISTS(SELECT TOP 1 ID_LICENCIA_ESTUDIANTE FROM [transaccional].[licencia_estudiante]
--WHERE ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION AND ES_ACTIVO=1 AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOLECTIVO_INSTITUCION)
IF EXISTS(SELECT TOP 1 le.ID_LICENCIA_ESTUDIANTE FROM [transaccional].[licencia_estudiante] le
		LEFT join transaccional.reingreso_estudiante re on re.ID_LICENCIA_ESTUDIANTE =le.ID_LICENCIA_ESTUDIANTE and re.ES_ACTIVO=1
		WHERE ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION AND le.ES_ACTIVO=1 and re.ID_REINGRESO_ESTUDIANTE is null
)
BEGIN
	SET @RESULT = -180 -- YA SE ENCUENTRA REGISTRADO
END
ELSE
	BEGIN    	--print 'dentro de la transaccion'
	
		IF EXISTS(SELECT TOP 1 edet.NOTA FROM transaccional.matricula_estudiante me INNER JOIN transaccional.evaluacion_detalle edet 
		          ON me.ID_MATRICULA_ESTUDIANTE = edet.ID_MATRICULA_ESTUDIANTE WHERE me.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION AND 
				  me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION AND me.ES_ACTIVO = 1 AND edet.ES_ACTIVO = 1
				  AND edet.NOTA IS NOT NULL)
			SET @RESULT = -309 -- valida si tiene nota de evaluacion
		ELSE IF EXISTS(SELECT TOP 1 edet.NOTA FROM transaccional.matricula_estudiante me INNER JOIN transaccional.evaluacion_experiencia_formativa edet 
					  ON me.ID_MATRICULA_ESTUDIANTE = edet.ID_MATRICULA_ESTUDIANTE WHERE me.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION AND 
					  me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION AND me.ES_ACTIVO = 1 AND edet.ES_ACTIVO = 1
					  AND edet.NOTA IS NOT NULL)
			SET @RESULT = -309 -- valida si tiene nota de evaluacion
		ELSE
		BEGIN    
			--print 'antes de la transaccion'
			BEGIN TRANSACTION T1
			BEGIN TRY
				--print 'dentro de la transaccion'
			INSERT INTO [transaccional].[licencia_estudiante]
           ([ID_ESTUDIANTE_INSTITUCION]
           ,[ID_PERIODOS_LECTIVOS_POR_INSTITUCION]
           ,[ID_TIPO_LICENCIA]
           ,[ID_TIEMPO_PERIODO_LICENCIA]
           ,[FECHA_INICIO]
           ,[ES_ACTIVO]
           ,[ESTADO]
           ,[FECHA_CREACION]
           ,[USUARIO_CREACION]
		   ,[ARCHIVO_RD]
           ,[ARCHIVO_RUTA]
		 )

     VALUES
           (@ID_ESTUDIANTE_INSTITUCION 
		  ,@ID_PERIODOLECTIVO_INSTITUCION	  
		  ,@ID_TIPO_LICENCIA	  
		  ,@ID_TIEMPO_LICENCIA		  
		  ,GETDATE()		  
		  ,1	  
		  ,1 
		  ,GETDATE()
		  ,@USUARIO	  
		  ,@ARCHIVO_RD	  
		  ,@RUTA_RD	  
		  )
			
			COMMIT TRANSACTION T1
		
			SET @RESULT = 1
			END TRY	   
			BEGIN CATCH
				IF @@ERROR<>0
				BEGIN
					ROLLBACK TRANSACTION T1	   
					SELECT -1
				END
			END CATCH
		END
		
END	
SELECT @RESULT
GO


