
/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro de periodo lectivo para una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
TEST:			
	EXEC USP_MAESTROS_INS_PERIODO_LECTIVO_INSTITUCION 4,'2013-2',5,'2013-08-01','2013-12-30', 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_INS_PERIODO_LECTIVO_INSTITUCION]
(
	@ID_INSTITUCION INT,
	@ID_PERIODO_LECTIVO INT,
	@FECHA_INICIO DATE,
	@FECHA_FIN DATE,
	@USUARIO VARCHAR(20),
	@NOMBRE_PERIODO_LECTIVO_INSTITUCION VARCHAR(30),
	@DESCRIPCION VARCHAR(100)
)
AS
BEGIN
	DECLARE @ESTADO_PERIODO_LECTIVO_CREADO INT
	--@ID_SEDE_INSTITUCION INT
	--SELECT @ID_SEDE_INSTITUCION=si.ID_SEDE_INSTITUCION from maestro.sede_institucion si where si.ID_INSTITUCION=@ID_INSTITUCION and si.ES_SEDE_PRINCIPAL=1 and ES_ACTIVO=1
	--SET @ESTADO_PERIODO_LECTIVO_SIN_APERTURAR =	(SELECT ISNULL((SELECT ISNULL(ID_ENUMERADO,0) FROM sistema.enumerado WHERE ID_TIPO_ENUMERADO = 4 AND VALOR_ENUMERADO = 'SIN APERTURAR' COLLATE LATIN1_GENERAL_CI_AI),0)) -- *4 ESTADOS PERIODOS LECTIVOS
	SET @ESTADO_PERIODO_LECTIVO_CREADO =	6
	DECLARE @ID_PERIODO_LECTIVO_INSTITUCION INT
	SET @ID_PERIODO_LECTIVO_INSTITUCION =	(SELECT TOP 1 ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
												FROM transaccional.periodos_lectivos_por_institucion WHERE ES_ACTIVO = 1
												AND ESTADO = @ESTADO_PERIODO_LECTIVO_CREADO AND ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO AND ID_INSTITUCION = @ID_INSTITUCION)
	
	DECLARE @RESULT INT, @ANIO INT, @ID_TIPO_OPCION INT

	SELECT @ANIO = PL.ANIO, @ID_TIPO_OPCION = PL.ID_TIPO_OPCION FROM transaccional.periodos_lectivos_por_institucion PLXI 
	INNER JOIN maestro.periodo_lectivo PL ON PLXI.ID_PERIODO_LECTIVO = PL.ID_PERIODO_LECTIVO AND PLXI.ES_ACTIVO=1
	WHERE PLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION
	
	IF  EXISTS	(SELECT TOP 1 ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
					FROM transaccional.periodos_lectivos_por_institucion  plxi
					INNER JOIN maestro.periodo_lectivo PL ON plxi.ID_PERIODO_LECTIVO = PL.ID_PERIODO_LECTIVO
					WHERE NOMBRE_PERIODO_LECTIVO_INSTITUCION = UPPER(@NOMBRE_PERIODO_LECTIVO_INSTITUCION) AND plxi.ES_ACTIVO=1 
						AND plxi.ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO AND plxi.ESTADO <> @ESTADO_PERIODO_LECTIVO_CREADO
						AND PL.ID_TIPO_OPCION = @ID_TIPO_OPCION
						AND ID_INSTITUCION = @ID_INSTITUCION)

		SET @RESULT = -180
	ELSE IF EXISTS (SELECT TOP 1 PLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
					FROM transaccional.periodos_lectivos_por_institucion PLXI 
					INNER JOIN maestro.periodo_lectivo PL ON PLXI.ID_PERIODO_LECTIVO = PL.ID_PERIODO_LECTIVO AND PLXI.ES_ACTIVO=1
					WHERE ID_INSTITUCION = @ID_INSTITUCION
					--AND PL.ANIO = @ANIO
					AND ((@FECHA_INICIO BETWEEN PLXI.FECHA_INICIO_INSTITUCION AND PLXI.FECHA_FIN_INSTITUCION)
						OR (@FECHA_FIN BETWEEN PLXI.FECHA_INICIO_INSTITUCION AND PLXI.FECHA_FIN_INSTITUCION))
					AND PLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION <> @ID_PERIODO_LECTIVO_INSTITUCION AND PLXI.ESTADO <> @ESTADO_PERIODO_LECTIVO_CREADO
					AND PL.ID_TIPO_OPCION = @ID_TIPO_OPCION)
		
		SET @RESULT = -30
	ELSE
	BEGIN
		IF EXISTS	(SELECT TOP 1 ID_PERIODOS_LECTIVOS_POR_INSTITUCION FROM transaccional.periodos_lectivos_por_institucion WHERE ES_ACTIVO = 1
					AND ESTADO = @ESTADO_PERIODO_LECTIVO_CREADO AND ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO AND ID_INSTITUCION = @ID_INSTITUCION)
			BEGIN
			
				UPDATE transaccional.periodos_lectivos_por_institucion
				SET	ESTADO = 7,
					NOMBRE_PERIODO_LECTIVO_INSTITUCION = UPPER(@NOMBRE_PERIODO_LECTIVO_INSTITUCION),
					FECHA_INICIO_INSTITUCION = @FECHA_INICIO,
					FECHA_FIN_INSTITUCION = @FECHA_FIN,
					--DESCRIPCION = UPPER(@DESCRIPCION),
					USUARIO_MODIFICACION = @USUARIO,
					FECHA_MODIFICACION = GETDATE()
				WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
			END
		ELSE
			INSERT INTO transaccional.periodos_lectivos_por_institucion(
				ID_PERIODO_LECTIVO,
				ID_INSTITUCION,
				NOMBRE_PERIODO_LECTIVO_INSTITUCION,
				FECHA_INICIO_INSTITUCION,
				FECHA_FIN_INSTITUCION,
				--DESCRIPCION,
				ES_ACTIVO,
				ESTADO,
				FECHA_CREACION,
				USUARIO_CREACION
			)VALUES(			
				@ID_PERIODO_LECTIVO,
				@ID_INSTITUCION,
				UPPER(@NOMBRE_PERIODO_LECTIVO_INSTITUCION),
				@FECHA_INICIO,
				@FECHA_FIN,
				--UPPER(@DESCRIPCION),
				1,
				7,
				GETDATE(),
				@USUARIO
			)

		IF NOT EXISTS(	SELECT TOP 1 ID_PARAMETROS_INSTITUCION 
						FROM maestro.parametros_institucion 
						WHERE NOMBRE_PARAMETRO='NOTA_MINIMA_APROBATORIA' AND ID_INSTITUCION=@ID_INSTITUCION )
		BEGIN
			INSERT INTO maestro.parametros_institucion
			        ( ID_INSTITUCION,NOMBRE_PARAMETRO,VALOR_PARAMETRO,ESTADO,USUARIO_CREACION,FECHA_CREACION)
			VALUES  ( @ID_INSTITUCION,'NOTA_MINIMA_APROBATORIA',13,1,@USUARIO, GETDATE())
        END

		SET @RESULT = 1
	END

	SELECT @RESULT
END
GO


