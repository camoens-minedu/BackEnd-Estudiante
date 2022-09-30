﻿/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2017
LLAMADO POR			:
DESCRIPCION			:	Obtener las opciones registradas en la postulanción de una persona
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2018		JTOVAR			Creación
1.1			17/03/2021		JCHAVEZ			Modificación, se agregó actualización del ID_CARRERA
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_UPD_PROGRAMA_ESTUDIO]
(  
@ID_INSTITUCION INT,
@ID_CARRERAS_POR_INSTITUCION INT,
@ID_TIPO_ITINERARIO smallint,
@ID_CARRERA INT,
@CODIGO_CARRERA varchar(16),
@NOMBRE_CARRERA varchar(150),
@ID_NIVEL_FORMACION INT,
@SEDES varchar(100),
@ESTADOSPROGRAMA VARCHAR(100),
@USUARIO VARCHAR(20)

	--DECLARE @ID_INSTITUCION INT=1911
	--DECLARE @ID_CARRERAS_POR_INSTITUCION INT=1169
	--DECLARE @ID_TIPO_ITINERARIO smallint=101
	--DECLARE @ID_CARRERA INT=1303
	--DECLARE @CODIGO_CARRERA varchar(16)='611035'
	--DECLARE @NOMBRE_CARRERA varchar(150)='AGROPECUARIA'
	--DECLARE @ID_NIVEL_FORMACION INT=7
	--DECLARE @SEDES varchar(100)='1942'
	--DECLARE @ESTADOSPROGRAMA VARCHAR(100)='102'
	--DECLARE @USUARIO VARCHAR(20)='42122536'
)  
AS
BEGIN
	DECLARE @RESULT INT
	--por ahora se evaluará el tipo de itinerario
	IF EXISTS(	select TOP 1 ID_CARRERAS_POR_INSTITUCION from transaccional.carreras_por_institucion tci 
				where ID_INSTITUCION=@ID_INSTITUCION and ID_CARRERA=@ID_CARRERA AND tci.ES_ACTIVO=1 
				and ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO and ID_CARRERAS_POR_INSTITUCION <>@ID_CARRERAS_POR_INSTITUCION
	)
		SET @RESULT = -180  
	ELSE IF EXISTS (SELECT ID_PLAN_ESTUDIO FROM transaccional.plan_estudio WHERE ID_CARRERAS_POR_INSTITUCION = @ID_CARRERAS_POR_INSTITUCION
		AND ID_TIPO_ITINERARIO<> @ID_TIPO_ITINERARIO)
			SET @RESULT = -298
	ELSE
	BEGIN  
		BEGIN TRANSACTION T1
		BEGIN TRY
	
			--IF EXISTS (SELECT top 1 ID_CARRERA FROM maestro.carrera WHERE UPPER( CODIGO_CARRERA)=UPPER(@CODIGO_CARRERA) AND ID_CARRERA<>@ID_CARRERA)
			--		RAISERROR('CODIGO DE CATALOGO EXISTE',12,-1) WITH SETERROR

			DECLARE @ID_CARRERA_ANT INT = (SELECT ID_CARRERA FROM transaccional.carreras_por_institucion where ID_CARRERAS_POR_INSTITUCION=@ID_CARRERAS_POR_INSTITUCION)

			UPDATE tci set tci.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO, tci.USUARIO_MODIFICACION= @USUARIO, tci.FECHA_MODIFICACION=GETDATE()
			,tci.ID_CARRERA=@ID_CARRERA
			from transaccional.carreras_por_institucion tci
			where ID_CARRERAS_POR_INSTITUCION=@ID_CARRERAS_POR_INSTITUCION

			UPDATE e SET e.ID_CARRERA = @ID_CARRERA,e.USUARIO_MODIFICACION=@USUARIO,e.FECHA_MODIFICACION=GETDATE()
			FROM transaccional.evaluacion e
			INNER JOIN transaccional.programacion_clase pc ON e.ID_PROGRAMACION_CLASE=pc.ID_PROGRAMACION_CLASE
			INNER JOIN maestro.sede_institucion si ON pc.ID_SEDE_INSTITUCION=si.ID_SEDE_INSTITUCION
			WHERE si.ID_INSTITUCION = @ID_INSTITUCION AND e.ID_CARRERA = @ID_CARRERA_ANT
			AND e.ES_ACTIVO=1 AND pc.ES_ACTIVO=1 AND si.ES_ACTIVO=1
			
			--UPDATE 	mc 
			--SET		mc.NOMBRE_CARRERA = @NOMBRE_CARRERA,
			--		mc.CODIGO_CARRERA =@CODIGO_CARRERA,
			--		mc.ID_NIVEL_FORMACION =@ID_NIVEL_FORMACION
			--FROM maestro.carrera mc 
			--WHERE mc.ID_CARRERA = @ID_CARRERA AND mc.ES_CATALOGO=0

			DECLARE @CADENA VARCHAR(150)
			DECLARE @CADENA_ESTPROG VARCHAR(150)
			DECLARE @ID_SEDE_INSTITUCION INT
			DECLARE @ID_ESTADO_PROGRAMA INT
			DECLARE @ID_CARRERAS_POR_INSTITUCION_DETALLE INT
			SET @CADENA =@SEDES
			SET @CADENA_ESTPROG=@ESTADOSPROGRAMA	

			UPDATE transaccional.carreras_por_institucion_detalle 
			SET ES_ACTIVO=0 WHERE ID_CARRERAS_POR_INSTITUCION = @ID_CARRERAS_POR_INSTITUCION

			WHILE (@CADENA <>'')
			BEGIN 
				SET @ID_SEDE_INSTITUCION= CONVERT (INT, SUBSTRING(@CADENA,0,CHARINDEX(',',@CADENA)))
				SET @ID_ESTADO_PROGRAMA= CONVERT (INT, SUBSTRING(@CADENA_ESTPROG,0,CHARINDEX(',',@CADENA_ESTPROG)))

				IF EXISTS(SELECT ID_CARRERAS_POR_INSTITUCION_DETALLE FROM transaccional.carreras_por_institucion_detalle  
				WHERE ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION AND ID_CARRERAS_POR_INSTITUCION =@ID_CARRERAS_POR_INSTITUCION)
				BEGIN
					SELECT @ID_CARRERAS_POR_INSTITUCION_DETALLE=ID_CARRERAS_POR_INSTITUCION_DETALLE FROM transaccional.carreras_por_institucion_detalle  
					WHERE ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION AND ID_CARRERAS_POR_INSTITUCION =@ID_CARRERAS_POR_INSTITUCION

					UPDATE transaccional.carreras_por_institucion_detalle 
					SET ID_ESTADO_PROGRAMA= @ID_ESTADO_PROGRAMA, ES_ACTIVO=1
					WHERE ID_CARRERAS_POR_INSTITUCION_DETALLE=@ID_CARRERAS_POR_INSTITUCION_DETALLE
				END
				ELSE
				BEGIN
					INSERT INTO transaccional.carreras_por_institucion_detalle 
					(ID_CARRERAS_POR_INSTITUCION,
					ID_SEDE_INSTITUCION,
					ID_ESTADO_PROGRAMA,
					ES_ACTIVO,
					ESTADO,
					USUARIO_CREACION,
					FECHA_CREACION
					)VALUES 
					(
					@ID_CARRERAS_POR_INSTITUCION,
					@ID_SEDE_INSTITUCION,
					@ID_ESTADO_PROGRAMA,
					1,
					1,
					@USUARIO,
					GETDATE()
					)
				END

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
END
GO

