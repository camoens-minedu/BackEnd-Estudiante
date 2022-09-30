--/*******************************************************************************************************************************************
--AUTOR				:	Mayra Alva
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Actualiza la programación de matrícula.
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:			
--/*
--	1.0			21/11/2019		MALVA           MODIFICACIÓN PARA VALIDAR SI ES QUE EL PERIODO DE CLASES O ALGUNA DE LAS CLASES SE HAN CERRADO. 
--*/
--*********************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_PROGRAMACION_MATRICULA]
(
	@ID_PROGRAMACION_MATRICULA INT,
	@FECHA_INICIO DATETIME,
	@FECHA_FIN	DATETIME,
	@ID_ROL     INT,
	@USUARIO	VARCHAR(20)

	--declare @ID_PROGRAMACION_MATRICULA INT=279
	--declare @FECHA_INICIO DATETIME='2020/08/17'
	--declare @FECHA_FIN	DATETIME='2020/08/28'
	--declare @ID_ROL     INT=84
	--declare @USUARIO	VARCHAR(20)='42122536'

)
AS
BEGIN

DECLARE @RESULT INT
DECLARE @ID_PERIODO_LECTIVO_INSTITUCION INT
SET @ID_PERIODO_LECTIVO_INSTITUCION  = (SELECT ID_PERIODOS_LECTIVOS_POR_INSTITUCION FROM transaccional.programacion_matricula where ID_PROGRAMACION_MATRICULA=@ID_PROGRAMACION_MATRICULA)

		IF EXISTS ( SELECT  TOP 1 eva.ID_EVALUACION 
			FROM transaccional.matricula_estudiante me INNER JOIN transaccional.evaluacion_detalle edet 
			ON me.ID_MATRICULA_ESTUDIANTE = edet.ID_MATRICULA_ESTUDIANTE INNER JOIN transaccional.evaluacion eva
			ON edet.ID_EVALUACION = eva.ID_EVALUACION
			INNER JOIN transaccional.programacion_clase_por_matricula_estudiante pcme on pcme.ID_MATRICULA_ESTUDIANTE = me.ID_MATRICULA_ESTUDIANTE and pcme.ES_ACTIVO=1
			INNER JOIN transaccional.programacion_clase pc on pc.ID_PROGRAMACION_CLASE = pcme.ID_PROGRAMACION_CLASE and pc.ES_ACTIVO=1 and pc.ESTADO=0 --No cerrado
			WHERE me.ID_PROGRAMACION_MATRICULA = @ID_PROGRAMACION_MATRICULA AND eva.CIERRE_PROGRAMACION = 235 and me.ES_ACTIVO=1 and edet.ES_ACTIVO=1
		)
			SET @RESULT = -306 --No se puede modificar la fecha, ya que el periodo de clase se encuentra cerrado.
		ELSE 

		IF @ID_ROL = 84 -- ROL ESPECIALSTA MINEDU
		BEGIN
			UPDATE transaccional.programacion_matricula
			SET FECHA_INICIO = @FECHA_INICIO,
				FECHA_FIN = @FECHA_FIN,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
			WHERE
				ID_PROGRAMACION_MATRICULA = @ID_PROGRAMACION_MATRICULA
			SELECT @ID_PROGRAMACION_MATRICULA
			
			SET @RESULT = 1

		END
		ELSE
		BEGIN
		IF EXISTS( SELECT TOP 1 eva.ID_EVALUACION FROM transaccional.matricula_estudiante me INNER JOIN transaccional.evaluacion_detalle edet 
						ON me.ID_MATRICULA_ESTUDIANTE = edet.ID_MATRICULA_ESTUDIANTE INNER JOIN transaccional.evaluacion eva
						ON edet.ID_EVALUACION = eva.ID_EVALUACION WHERE me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND eva.CIERRE_PROGRAMACION = 235 
						and me.ES_ACTIVO=1 and edet.ES_ACTIVO=1 and eva.ES_ACTIVO=1)
			SET @RESULT = -338 --No se puede modificar la fecha, ya que se tienen clases cerradas.
		ELSE
		BEGIN    
			--print 'antes de la transaccion'
			BEGIN TRANSACTION T1
			BEGIN TRY
				--print 'dentro de la transaccion'
			UPDATE transaccional.programacion_matricula
			SET FECHA_INICIO = @FECHA_INICIO,
				FECHA_FIN = @FECHA_FIN,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
			WHERE
				ID_PROGRAMACION_MATRICULA = @ID_PROGRAMACION_MATRICULA
			SELECT @ID_PROGRAMACION_MATRICULA
			
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


		--IF EXISTS( SELECT TOP 1 eva.ID_EVALUACION FROM transaccional.matricula_estudiante me INNER JOIN transaccional.evaluacion_detalle edet 
		--				ON me.ID_MATRICULA_ESTUDIANTE = edet.ID_MATRICULA_ESTUDIANTE INNER JOIN transaccional.evaluacion eva
		--				ON edet.ID_EVALUACION = eva.ID_EVALUACION WHERE me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND eva.CIERRE_PROGRAMACION = 235 
		--				and me.ES_ACTIVO=1 and edet.ES_ACTIVO=1 and eva.ES_ACTIVO=1)
		--	SET @RESULT = -338 --No se puede modificar la fecha, ya que se tienen clases cerradas.
		--ELSE
		--BEGIN    
		--	--print 'antes de la transaccion'
		--	BEGIN TRANSACTION T1
		--	BEGIN TRY
		--		--print 'dentro de la transaccion'
		--		UPDATE transaccional.programacion_matricula
		--	SET FECHA_INICIO = @FECHA_INICIO,
		--		FECHA_FIN = @FECHA_FIN,
		--		USUARIO_MODIFICACION = @USUARIO,
		--		FECHA_MODIFICACION = GETDATE()
		--	WHERE
		--		ID_PROGRAMACION_MATRICULA = @ID_PROGRAMACION_MATRICULA
		--	SELECT @ID_PROGRAMACION_MATRICULA
			
		--	COMMIT TRANSACTION T1
		
		--	SET @RESULT = 1
		--	END TRY	   
		--	BEGIN CATCH
		--		IF @@ERROR<>0
		--		BEGIN
		--			ROLLBACK TRANSACTION T1	   
		--			SELECT -1
		--		END
		--	END CATCH
	
		--END
		SELECT @RESULT
END
GO


