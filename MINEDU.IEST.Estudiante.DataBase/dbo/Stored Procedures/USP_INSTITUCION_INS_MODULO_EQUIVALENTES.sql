/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	18/01/2022
LLAMADO POR			:
DESCRIPCION			:	Agrega modulo equivalentes
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
	
TEST:  
	USP_INSTITUCION_INS_MODULO_EQUIVALENTES 4048,'modulo A',0,30,1200,3000,'70557821'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_INS_MODULO_EQUIVALENTES]
(
	@ID_PLAN_ESTUDIO INT,
	@NOMBRE_MODULO VARCHAR(MAX),
    @ID_MODULO INT,
    @NUMERO_MODULO VARCHAR(150),
    @TOTHORAS DECIMAL(10,2),
    @TOTCREDITOS DECIMAL(10,2),
    @USUARIO VARCHAR(8)

)
AS
BEGIN
	DECLARE @MSG_TRANS VARCHAR(MAX)

	BEGIN TRY

	BEGIN TRAN TransactSQL

			IF (@ID_MODULO = 0)
			BEGIN
				INSERT INTO transaccional.modulo_equivalencia
						( ID_PLAN_ESTUDIO ,
						  ID_TIPO_MODULO ,
						  NOMBRE_MODULO ,
						  NUMERO_MODULO ,
						  TOTHORAS ,
						  TOTCREDITOS ,
						  ES_ACTIVO ,
						  ESTADO ,
						  USUARIO_CREACION ,
						  FECHA_CREACION 
		         
						)
				VALUES  ( @ID_PLAN_ESTUDIO , 159, UPPER(@NOMBRE_MODULO), @NUMERO_MODULO, @TOTHORAS, @TOTCREDITOS,1,1, @USUARIO, GETDATE())
		
						
			END
			ELSE 
			BEGIN
				UPDATE transaccional.modulo_equivalencia SET
					ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO , 
					ID_TIPO_MODULO = 159 , 
					NOMBRE_MODULO = UPPER(@NOMBRE_MODULO), 
					NUMERO_MODULO = @NUMERO_MODULO, 
					TOTHORAS = @TOTHORAS , 
					TOTCREDITOS = @TOTCREDITOS , 
					ES_ACTIVO = 1 , 
					ESTADO= 1 , 
					USUARIO_MODIFICACION = @USUARIO , 
					FECHA_MODIFICACION = GETDATE() 
		   			WHERE ID_MODULO_EQUIVALENCIA=@ID_MODULO
			END
	   
	COMMIT TRAN TransactSQL
	SELECT 1 AS valor

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN TransactSQL
		DECLARE @ERROR_MESSAGE VARCHAR(MAX) = ''
		SET @ERROR_MESSAGE = ERROR_MESSAGE() + ' -- '
		SELECT 'Error: ' + @ERROR_MESSAGE
		SELECT 0 AS valor
	END CATCH
END