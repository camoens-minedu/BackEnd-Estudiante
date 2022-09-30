﻿CREATE PROCEDURE [dbo].[USP_MAESTROS_UPD_PERSONA]
(
	@ID_INSTITUCION				INT,
	@ID_PERSONA_INSTITUCION		INT,
	@ID_PERSONA					INT,
	@TIPO_DOCUMENTO_PERSONA		INT				= null,
	@NUMERO_DOCUMENTO_PERSONA	VARCHAR(15)		= null,
	@NOMBRE_PERSONA				VARCHAR(50)		= null,
	@APELLIDO_PATERNO_PERSONA	VARCHAR(40)		= null,
	@APELLIDO_MATERNO_PERSONA	VARCHAR(40)		= null,
	@FECHA_NACIMIENTO_PERSONA	DATETIME		= null,
	@SEXO_PERSONA				INT				= null,
	@ESTADO_CIVIL_PERSONA		INT				= null,
	@PAIS_NACIMIENTO			INT				= null,
	@UBIGEO_NACIMIENTO			INT				= null,

	@PAIS_PERSONA				INT				= null,
	@UBIGEO_PERSONA				INT				= null,
	@DIRECCION_PERSONA			VARCHAR(250)	= null,
	@CORREO1					VARCHAR(50)		= null,
	@TELEFONO					VARCHAR(15)		= null,
	@CELULAR1					VARCHAR(15)		= null,

	@ID_GRADO_PROFESIONAL		INT				= null,
	@TITULO_PROFESIONAL			VARCHAR(100)	= null,
	@ID_CARRERA_PROFESIONAL		INT				= null,
	@INSTITUCION_PROFESIONAL	VARCHAR(100)	= null,
	@ANIO_INICIO				INT				= null,
	@ANIO_FIN					INT				= null,

	@USUARIO					VARCHAR(20),
	@INDEX						INT
)
AS
BEGIN
	IF (@INDEX = 1)
	BEGIN
		UPDATE maestro.persona
		SET	ID_TIPO_DOCUMENTO = @TIPO_DOCUMENTO_PERSONA,
			NUMERO_DOCUMENTO_PERSONA = UPPER(@NUMERO_DOCUMENTO_PERSONA),
			NOMBRE_PERSONA =UPPER(@NOMBRE_PERSONA),
			APELLIDO_PATERNO_PERSONA = UPPER(@APELLIDO_PATERNO_PERSONA),
			APELLIDO_MATERNO_PERSONA = UPPER(@APELLIDO_MATERNO_PERSONA),
			FECHA_NACIMIENTO_PERSONA = @FECHA_NACIMIENTO_PERSONA,
			SEXO_PERSONA = @SEXO_PERSONA,
			--ESTADO_CIVIL_PERSONA = @ESTADO_CIVIL_PERSONA,
			PAIS_NACIMIENTO = @PAIS_NACIMIENTO,
			UBIGEO_NACIMIENTO = @UBIGEO_NACIMIENTO,			
			FECHA_MODIFICACION = GETDATE(),
			USUARIO_MODIFICACION = @USUARIO
		WHERE ID_PERSONA = @ID_PERSONA
		IF @ID_PERSONA_INSTITUCION = 0
			INSERT INTO maestro.persona_institucion(
				ID_PERSONA,
				ID_INSTITUCION,
				ESTADO_CIVIL,
				ESTADO,
				USUARIO_CREACION,
				FECHA_CREACION
			)
			VALUES(
				@ID_PERSONA,
				@ID_INSTITUCION,
				@ESTADO_CIVIL_PERSONA,
				1,
				@USUARIO,
				GETDATE()
			)
		ELSE
			UPDATE maestro.persona_institucion
			SET ESTADO_CIVIL = @ESTADO_CIVIL_PERSONA,
				ESTADO = 1,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
			WHERE ID_PERSONA_INSTITUCION = @ID_PERSONA_INSTITUCION
	END		
	IF (@INDEX = 2)			
		IF @ID_PERSONA_INSTITUCION = 0
			INSERT INTO maestro.persona_institucion(
				ID_PERSONA,
				ID_INSTITUCION,
				PAIS_PERSONA,
				UBIGEO_PERSONA,
				DIRECCION_PERSONA,
				CORREO,
				TELEFONO,
				CELULAR,
				ESTADO,
				USUARIO_CREACION,
				FECHA_CREACION
			)
			VALUES(
				@ID_PERSONA,
				@ID_INSTITUCION,
				@PAIS_PERSONA,
				@UBIGEO_PERSONA,
				@DIRECCION_PERSONA,
				@CORREO1,
				@TELEFONO,
				@CELULAR1,
				1,
				@USUARIO,
				GETDATE()
			)
		ELSE
			UPDATE maestro.persona_institucion
			SET PAIS_PERSONA = @PAIS_PERSONA,
				UBIGEO_PERSONA = @UBIGEO_PERSONA,
				DIRECCION_PERSONA = @DIRECCION_PERSONA,
				CORREO = @CORREO1,
				TELEFONO = @TELEFONO,
				CELULAR = @CELULAR1,
				ESTADO = 1,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
			WHERE ID_PERSONA_INSTITUCION = @ID_PERSONA_INSTITUCION			
	IF (@INDEX = 3)		
		IF @ID_PERSONA_INSTITUCION = 0
			INSERT INTO maestro.persona_institucion(
				ID_PERSONA,
				ID_INSTITUCION,
				ID_GRADO_PROFESIONAL,
				ID_CARRERA_PROFESIONAL,
				INSTITUCION_PROFESIONAL,
				ANIO_INICIO,
				ANIO_FIN,				
				ESTADO,
				USUARIO_CREACION,
				FECHA_CREACION
			)VALUES(
				@ID_PERSONA,
				@ID_INSTITUCION,
				@ID_GRADO_PROFESIONAL,
				@ID_CARRERA_PROFESIONAL,
				UPPER(@INSTITUCION_PROFESIONAL),
				@ANIO_INICIO,
				@ANIO_FIN,
				1,
				@USUARIO,
				GETDATE()
			)
		ELSE
			UPDATE maestro.persona_institucion
			SET ID_GRADO_PROFESIONAL = @ID_GRADO_PROFESIONAL,
				ID_CARRERA_PROFESIONAL = @ID_CARRERA_PROFESIONAL,
				INSTITUCION_PROFESIONAL = @INSTITUCION_PROFESIONAL,
				ANIO_INICIO = @ANIO_INICIO,
				ANIO_FIN = @ANIO_FIN,				
				ESTADO = 1,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
			WHERE ID_PERSONA_INSTITUCION = @ID_PERSONA_INSTITUCION	
	SELECT @ID_PERSONA
END
GO


