--/**********************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Inserta un registro de resolución
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:			
--/*
--	1.0			20/11/2019		MALVA          MODIFICACIÓN PARA VALIDAR CREACIÓN DE METAS ANUALES EN EL PRIMER PERIODO LECTIVO DEL AÑO
--											   Y METAS DE AMPLIACIÓN EN EL SEGUNDO PERIODO LECTIVO.
--*/
--**********************************************************************************************************/

CREATE PROCEDURE  [dbo].[USP_MAESTROS_INS_RESOLUCION]
(    
    @ID_PERIODO_LECTIVO_INSTITUCION int,
    @NUMERO_RESOLUCION nvarchar(50) ,
    @ARCHIVO_RESOLUCION nvarchar(50),
    @ID_TIPO_RESOLUCION int,
	@ID_INSTITUCION	int,  
	@ID_CARRERAS_INSTITUCION	nvarchar(max),  
    @USUARIO nvarchar(20)

	--DECLARE @ID_PERIODO_LECTIVO_INSTITUCION int=5513
 --   DECLARE @NUMERO_RESOLUCION nvarchar(50)='50'
 --   DECLARE @ARCHIVO_RESOLUCION nvarchar(50)='Archivo_prueba - copia.pdf'
 --   DECLARE @ID_TIPO_RESOLUCION int=21
	--DECLARE @ID_INSTITUCION	int=''
	--DECLARE @ID_CARRERAS_INSTITUCION	nvarchar(max)='1201'
 --   DECLARE @USUARIO nvarchar(20)='42122536'
)
AS

DECLARE @RESULT INT,
@ID_RESOLUCION INT, 
@ANIO INT,
@ESTADO_APERTURADO INT =7,
@ID_PERIODO_LECTIVO_INSTITUCION_UNO  INT

	SET @ANIO = (SELECT mpl.ANIO FROM transaccional.periodos_lectivos_por_institucion tplxi
				INNER JOIN maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
				WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
				AND tplxi.ES_ACTIVO=1)
	SET @ID_PERIODO_LECTIVO_INSTITUCION_UNO = (	SELECT top 1 
												tplxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
												FROM transaccional.periodos_lectivos_por_institucion tplxi 
												INNER JOIN maestro.periodo_lectivo mpl on tplxi.ID_PERIODO_LECTIVO= mpl.ID_PERIODO_LECTIVO
												WHERE ID_INSTITUCION=@ID_INSTITUCION 
												AND ES_ACTIVO=1 AND mpl.ANIO=@ANIO
												AND tplxi.ESTADO =@ESTADO_APERTURADO
												ORDER BY 1 ASC )

--IF EXISTS(SELECT r.ID_RESOLUCION FROM maestro.resolucion r WHERE r.ESTADO=1 AND r.NUMERO_RESOLUCION=@NUMERO_RESOLUCION AND r.ID_TIPO_RESOLUCION=@ID_TIPO_RESOLUCION )
IF EXISTS (SELECT TOP 1 R.ID_RESOLUCION FROM transaccional.resoluciones_por_periodo_lectivo_institucion RXPLI
INNER JOIN maestro.resolucion R ON RXPLI.ID_RESOLUCION = R.ID_RESOLUCION AND RXPLI.ES_ACTIVO=1 AND R.ES_ACTIVO=1 AND R.ESTADO=1
WHERE RXPLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION AND  R.NUMERO_RESOLUCION=@NUMERO_RESOLUCION)
BEGIN 
    SET @RESULT = -180 --no se puede registrar porque ya existe en el sistema
END
ELSE IF (EXISTS(SELECT TOP 1 ID_RESOLUCION FROM maestro.resolucion WHERE ARCHIVO_RESOLUCION = @ARCHIVO_RESOLUCION AND ES_ACTIVO=1 AND ESTADO=1))
--ELSE IF (EXISTS(SELECT TOP 1 rpc.ID_RESOLUCIONES_POR_CARRERAS_POR_INSTITUCION FROM transaccional.resoluciones_por_carreras_por_institucion rpc INNER JOIN maestro.resolucion r
--                ON rpc.ID_RESOLUCION = r.ID_RESOLUCION
--                WHERE rpc.ID_CARRERAS_POR_INSTITUCION = @ID_CARRERAS_INSTITUCION AND r.ARCHIVO_RESOLUCION = @ARCHIVO_RESOLUCION AND rpc.ES_ACTIVO=1 AND r.ES_ACTIVO=1))
	SET @RESULT = -260 --no se puede registrar la resolucion porque el nombre del archivo ya esta siendo utilizado en esta institucion
ELSE IF @ID_PERIODO_LECTIVO_INSTITUCION_UNO <> @ID_PERIODO_LECTIVO_INSTITUCION and @ID_TIPO_RESOLUCION =21 -- resolución de meta anual
	SET @RESULT = -341
ELSE IF @ID_PERIODO_LECTIVO_INSTITUCION_UNO = @ID_PERIODO_LECTIVO_INSTITUCION and @ID_TIPO_RESOLUCION =22 -- resolución de ampliación de meta
	SET @RESULT = -343
ELSE
BEGIN 
	   BEGIN TRANSACTION T1
	   BEGIN TRY
		  INSERT INTO maestro.resolucion
		  (		
			 NUMERO_RESOLUCION,
			 ARCHIVO_RESOLUCION,
			 ID_TIPO_RESOLUCION,	
			 ES_ACTIVO,		 
			 ESTADO,
			 FECHA_CREACION,
			 USUARIO_CREACION
		  )
		  VALUES
		  (
			 @NUMERO_RESOLUCION,
			 @ARCHIVO_RESOLUCION,
			 @ID_TIPO_RESOLUCION,
			 1,
			 1,
			 GETDATE(),
			 @USUARIO
		  )		
		  		  		
		  SET @ID_RESOLUCION  = CONVERT(INT,@@IDENTITY)  
		  INSERT INTO transaccional.resoluciones_por_periodo_lectivo_institucion 
		  (
			ID_RESOLUCION,
			ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
			ES_ACTIVO, 
			ESTADO,
			USUARIO_CREACION, 
			FECHA_CREACION
		  )
		  VALUES 
		  (
			@ID_RESOLUCION,
			@ID_PERIODO_LECTIVO_INSTITUCION,
			1,
			1,
			@USUARIO,
			GETDATE()		  
		  )
		  
		  print 'ok'
		  EXEC [USP_ADMISION_INS_RESOLUCION_CARRERAS_INSTITUCION_MASIVO] @ID_CARRERAS_INSTITUCION,@ID_TIPO_RESOLUCION,@ID_RESOLUCION,@USUARIO

		  COMMIT TRANSACTION T1
	   SET @RESULT = 1
	   END TRY
	   
	   BEGIN CATCH
		  IF @@ERROR<>0
		  BEGIN
			 ROLLBACK TRANSACTION T1	   
			 SET @RESULT =-1
			 PRINT ERROR_MESSAGE()
		  END
	   END CATCH    
END

SELECT @RESULT
GO


