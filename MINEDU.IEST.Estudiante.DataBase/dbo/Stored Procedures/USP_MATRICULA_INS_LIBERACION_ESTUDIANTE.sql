﻿CREATE PROCEDURE [dbo].[USP_MATRICULA_INS_LIBERACION_ESTUDIANTE]
(
	@ID_ESTUDIANTE_INSTITUCION INT,
	@ID_PERIODOLECTIVO_INSTITUCION INT,
	@NRO_RESOLUCION VARCHAR(50),
	@ARCHIVO_TRASLADO VARCHAR(50),
	@ARCHIVO_RUTA VARCHAR(255),
	@USUARIO VARCHAR(20)
)
AS

DECLARE @RESULT INT

IF EXISTS (SELECT TOP 1 ID_MATRICULA_ESTUDIANTE FROM transaccional.matricula_estudiante WHERE ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION AND ES_ACTIVO = 1)
BEGIN

SET @RESULT = -331

END
ELSE
BEGIN

IF EXISTS(SELECT TOP 1 ID_LIBERACION_ESTUDIANTE FROM [transaccional].[liberacion_estudiante]
WHERE ID_ESTUDIANTE_INSTITUCION = UPPER(@ID_ESTUDIANTE_INSTITUCION) AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOLECTIVO_INSTITUCION AND ES_ACTIVO=1)
BEGIN
	SET @RESULT = -180 -- YA SE ENCUENTRA REGISTRADO
END
ELSE IF EXISTS(select TOP 1 ed.ID_EVALUACION_DETALLE from transaccional.evaluacion_detalle ed 
inner join transaccional.matricula_estudiante me on ed.ID_MATRICULA_ESTUDIANTE= me.ID_MATRICULA_ESTUDIANTE and ed.ES_ACTIVO=1 and me.ES_ACTIVO=1
where me.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION and me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOLECTIVO_INSTITUCION
)
	SET @RESULT = -316 --el estudiante ya tiene notas registradas 
ELSE IF EXISTS (SELECT ID_ESTUDIANTE_INSTITUCION FROM transaccional.estudiante_institucion WHERE ID_ESTUDIANTE_INSTITUCION =  @ID_ESTUDIANTE_INSTITUCION AND ID_SEMESTRE_ACADEMICO = 111)
	SET @RESULT = -334 --el estudiante debe haber terminado el primer ciclo
ELSE
	BEGIN    	--print 'dentro de la transaccion'
	
	INSERT INTO [transaccional].[liberacion_estudiante]
           ([ID_ESTUDIANTE_INSTITUCION]
           ,[ID_PERIODOS_LECTIVOS_POR_INSTITUCION]
           ,[ES_ACTIVO]
		   ,[ESTADO]
		   ,[NRO_RD]
		   ,[ARCHIVO_RD]
		   ,[ARCHIVO_RUTA]
           ,[FECHA_CREACION]
           ,[USUARIO_CREACION]
		 )

     VALUES
           (@ID_ESTUDIANTE_INSTITUCION 
		  ,@ID_PERIODOLECTIVO_INSTITUCION	  
		  ,1
		  ,1
		  ,@NRO_RESOLUCION
		  ,@ARCHIVO_TRASLADO
		  ,@ARCHIVO_RUTA
		  ,GETDATE()		  
		  ,@USUARIO	  
		  )

		
	SET @RESULT = 1
END	
END

SELECT @RESULT
GO

