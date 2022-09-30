
/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de programa de estudio institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 30/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_INSTITUCION_DEL_PROGRAMA_ESTUDIO 1106, 2750, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_DEL_PROGRAMA_ESTUDIO]  
(  
	@ID_INSTITUCION						INT,
    @ID_CARRERAS_POR_INSTITUCION        INT,          
    @USUARIO_MODIFICACION nvarchar(20)  
)  
AS  
BEGIN
DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

SELECT @ID_INSTITUCION_CONSULTA = ID_INSTITUCION FROM transaccional.carreras_por_institucion WHERE ID_CARRERAS_POR_INSTITUCION = @ID_CARRERAS_POR_INSTITUCION

IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
	SET @RESULT = -362
ELSE IF EXISTS (SELECT TOP 1 ID_META_CARRERA_INSTITUCION 
			from transaccional.meta_carrera_institucion WHERE ID_CARRERAS_POR_INSTITUCION= @ID_CARRERAS_POR_INSTITUCION and ES_ACTIVO=1)
	OR EXISTS(SELECT TOP 1 ID_PLAN_ESTUDIO 
				FROM transaccional.plan_estudio WHERE ID_CARRERAS_POR_INSTITUCION= @ID_CARRERAS_POR_INSTITUCION and ES_ACTIVO=1)
	OR EXISTS(SELECT TOP 1 ID_RESOLUCIONES_POR_CARRERAS_POR_INSTITUCION 
				FROM transaccional.resoluciones_por_carreras_por_institucion WHERE ID_CARRERAS_POR_INSTITUCION = @ID_CARRERAS_POR_INSTITUCION AND ES_ACTIVO=1)
	OR EXISTS(SELECT TOP 1 tei.ID_ESTUDIANTE_INSTITUCION 
				FROM transaccional.estudiante_institucion tei inner join transaccional.carreras_por_institucion_detalle tcxid 
				on tei.ID_CARRERAS_POR_INSTITUCION_DETALLE = tcxid.ID_CARRERAS_POR_INSTITUCION_DETALLE and tei.ES_ACTIVO=1 and tcxid.ES_ACTIVO=1
				WHERE tcxid.ID_CARRERAS_POR_INSTITUCION= @ID_CARRERAS_POR_INSTITUCION)
	SET @RESULT =  -162
ELSE
	BEGIN
		BEGIN TRANSACTION T1
		BEGIN TRY
			DECLARE @ID_CARRERA INT = 0
			UPDATE [transaccional].[carreras_por_institucion_detalle]  
			SET   
			   [ES_ACTIVO] = 0   
			  ,[FECHA_MODIFICACION]   = GETDATE()     
			  ,[USUARIO_MODIFICACION]   = @USUARIO_MODIFICACION   
			WHERE   
			[ID_CARRERAS_POR_INSTITUCION]     = @ID_CARRERAS_POR_INSTITUCION          
	
			UPDATE [transaccional].[carreras_por_institucion]  
			SET   
				   [ES_ACTIVO] = 0   
				  ,[FECHA_MODIFICACION]   = GETDATE()     
				  ,[USUARIO_MODIFICACION]   = @USUARIO_MODIFICACION   
			 WHERE   
				[ID_CARRERAS_POR_INSTITUCION]     = @ID_CARRERAS_POR_INSTITUCION            
  			 COMMIT TRANSACTION T1
				SET @RESULT = 1
		END TRY
		BEGIN CATCH
					IF @@ERROR<>0
						BEGIN
							ROLLBACK TRANSACTION T1	   
							   SET @RESULT = -1
							   PRINT ERROR_MESSAGE()
						END
		END CATCH

	END
SELECT @RESULT
END
GO


