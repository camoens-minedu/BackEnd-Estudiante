/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro del programa de estudio de una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_INS_PROGRAMA_ESTUDIO]
(  
@ID_INSTITUCION INT, 
@SEDES VARCHAR(150),
@ESTADOSPROGRAMA VARCHAR(150),
@ID_CARRERA INT,
@ID_TIPO_ITINERARIO smallint,
@NOMBRE_CARRERA VARCHAR(150),
@ID_NIVEL_FORMACION int,
@CODIGO_CATALOGO VARCHAR(16),
@ES_ACTIVO BIT=1,  
@ESTADO      smallint=1,  --118?
@USUARIO VARCHAR(20)
)  
AS 


DECLARE @RESULT INT
IF EXISTS(select TOP 1 ID_CARRERAS_POR_INSTITUCION from transaccional.carreras_por_institucion tci 
where ID_INSTITUCION=@ID_INSTITUCION and ID_CARRERA=@ID_CARRERA AND tci.ES_ACTIVO=1 and ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO
)
 SET @RESULT = -180  
 ELSE 
 BEGIN  
	BEGIN TRANSACTION T1
	BEGIN TRY
	
--*************************************************************************************************************************************************************************
	--> SE COMENTO PORQUE YA NO SE USA EN CATALOGO POR FAVOR VALIDAR POR FORMULARIO (Aun no se a cambiado por la vista) --reemplazoPorVista
	--IF (@ID_CARRERA=0) --no se obtuvo de catálogo
	--	BEGIN

			
	--		SET @ID_CARRERA= (	SELECT top 1 MC.ID_CARRERA FROM maestro.carrera MC
	--							INNER JOIN transaccional.carreras_por_institucion TCXI ON MC.ID_CARRERA= TCXI.ID_CARRERA AND TCXI.ES_ACTIVO=1
	--							AND TCXI.ID_INSTITUCION =@ID_INSTITUCION
	--							WHERE UPPER( CODIGO_CARRERA)=UPPER(@CODIGO_CATALOGO)
	--						  )
			
	--		IF @ID_CARRERA IS NULL
	--		BEGIN
	--					INSERT INTO maestro.carrera (CODIGO_CARRERA, NOMBRE_CARRERA,ID_NIVEL_FORMACION,ES_CATALOGO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
	--					VALUES (@CODIGO_CATALOGO,@NOMBRE_CARRERA, @ID_NIVEL_FORMACION,0,1,@USUARIO,GETDATE())
	--					SELECT @ID_CARRERA=@@IDENTITY
	--		END
	--		ELSE
	--		BEGIN
				
	--			RAISERROR('CODIGO DE CATALOGO EXISTE',12,-1) WITH SETERROR			

	--		END
	--	END
--*************************************************************************************************************************************************************************
			DECLARE @CADENA VARCHAR(150)
			DECLARE @CADENA_ESTPROG VARCHAR(150)
			DECLARE @ID_SEDE_INSTITUCION INT
			DECLARE @ID_CARRERAS_POR_INSTITUCION INT
			DECLARE @ID_ESTADO_PROGRAMA INT
	
			SET @CADENA =@SEDES
			SET @CADENA_ESTPROG=@ESTADOSPROGRAMA			
			
			--insertar carreras_por_institucion
			INSERT INTO transaccional.carreras_por_institucion (ID_INSTITUCION, ID_CARRERA, ID_TIPO_ITINERARIO, ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION)
			VALUES (@ID_INSTITUCION, @ID_CARRERA,@ID_TIPO_ITINERARIO, @ES_ACTIVO,@ESTADO, @USUARIO, GETDATE() )	
			SELECT @ID_CARRERAS_POR_INSTITUCION = @@IDENTITY

			WHILE (@CADENA <>'')
			BEGIN  
				SET @ID_SEDE_INSTITUCION= CONVERT (INT, SUBSTRING(@CADENA,0,CHARINDEX(',',@CADENA)))
				SET @ID_ESTADO_PROGRAMA= CONVERT (INT, SUBSTRING(@CADENA_ESTPROG,0,CHARINDEX(',',@CADENA_ESTPROG)))
								
				INSERT INTO transaccional.carreras_por_institucion_detalle
						(ID_CARRERAS_POR_INSTITUCION, 
						ID_SEDE_INSTITUCION,
						ID_ESTADO_PROGRAMA,
						ES_ACTIVO,
						ESTADO,
						USUARIO_CREACION,
						FECHA_CREACION)
				VALUES (@ID_CARRERAS_POR_INSTITUCION,
						@ID_SEDE_INSTITUCION,
						@ID_ESTADO_PROGRAMA, 
						@ES_ACTIVO, 
						@ESTADO, 
						@USUARIO, 
						GETDATE()) 		
				SET @CADENA =REPLACE(@CADENA, CONVERT(VARCHAR(100),@ID_SEDE_INSTITUCION ) + ',','') 

				--SET @CADENA_ESTPROG =REPLACE(@CADENA_ESTPROG, CONVERT(VARCHAR(100),@ID_ESTADO_PROGRAMA ) + ',','') 
				SET @CADENA_ESTPROG =STUFF(@CADENA_ESTPROG,1, LEN(CONVERT(VARCHAR(100),@ID_ESTADO_PROGRAMA ) + ','),'')  --porque los estados no son únicos
			END  

			COMMIT TRANSACTION T1
			SET @RESULT = 1
	END TRY
	BEGIN CATCH	
		IF @@ERROR = 50000
		BEGIN
			PRINT ERROR_MESSAGE()
			ROLLBACK TRANSACTION T1	 			  
			SET @RESULT = -223
		END
		ELSE	
			IF @@ERROR<>0
			BEGIN
			   
			   ROLLBACK TRANSACTION T1	   			   
			   SET @RESULT = -1
			
			END
	END CATCH

END  
SELECT @RESULT
GO


