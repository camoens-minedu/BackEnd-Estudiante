
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_ESTUDIANTE_RETIRADO_INSTITUTO] 
(
	@ID_INSTITUCION INT,
	@ID_TIPO_DOCUMENTO	INT,
	@NUMERO_DOCUMENTO VARCHAR(15)
)AS
BEGIN
	
	DECLARE @RESULT INT
	DECLARE @ESTUDIANTE_INSTITUCION1 INT

		SET @ESTUDIANTE_INSTITUCION1=(SELECT einstitucion.ID_ESTUDIANTE_INSTITUCION FROM maestro.persona persona INNER JOIN maestro.persona_institucion pins
		ON persona.ID_PERSONA = pins.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einstitucion
		ON pins.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION
		
		WHERE persona.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO AND persona.NUMERO_DOCUMENTO_PERSONA = @NUMERO_DOCUMENTO AND pins.ID_INSTITUCION = @ID_INSTITUCION AND einstitucion.ES_ACTIVO=1)

		IF EXISTS(SELECT TOP 1 lestu.ID_LIBERACION_ESTUDIANTE FROM transaccional.liberacion_estudiante lestu
		WHERE lestu.ID_ESTUDIANTE_INSTITUCION = @ESTUDIANTE_INSTITUCION1 AND lestu.ES_ACTIVO=1)
		BEGIN
			SET @RESULT = -210 -- EL ESTUDIANTE SE ENCUENTRA LIBERADO
		END
		ELSE
			BEGIN

				SELECT 
				TOP 1
				einstitucion.ID_ESTUDIANTE_INSTITUCION                      IdEstudianteInstitucion,
				persona.NOMBRE_PERSONA                                      Nombres, 
				persona.APELLIDO_PATERNO_PERSONA                            Paterno, 
				persona.APELLIDO_MATERNO_PERSONA                            Materno,
				sinsti.NOMBRE_SEDE											Sede,
				carrera.NOMBRE_CARRERA                                      Programa,
				enu.VALOR_ENUMERADO                                         Ciclo,
				mestudiante.ID_MATRICULA_ESTUDIANTE                         IdMatricula

				FROM maestro.persona persona INNER JOIN maestro.persona_institucion pins
				ON persona.ID_PERSONA = pins.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einstitucion
				ON pins.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION INNER JOIN transaccional.matricula_estudiante mestudiante
				ON einstitucion.ID_ESTUDIANTE_INSTITUCION = mestudiante.ID_ESTUDIANTE_INSTITUCION INNER JOIN transaccional.carreras_por_institucion_detalle cpdet
				ON einstitucion.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpdet.ID_CARRERAS_POR_INSTITUCION_DETALLE INNER JOIN transaccional.carreras_por_institucion cpinst
				ON cpdet.ID_CARRERAS_POR_INSTITUCION = cpinst.ID_CARRERAS_POR_INSTITUCION INNER JOIN db_auxiliar.dbo.UVW_CARRERA carrera
				ON cpinst.ID_CARRERA = carrera.ID_CARRERA INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION insti
				ON pins.ID_INSTITUCION = insti.ID_INSTITUCION INNER JOIN maestro.sede_institucion sinsti
				ON insti.ID_INSTITUCION = sinsti.ID_INSTITUCION INNER JOIN sistema.enumerado enu
				ON mestudiante.ID_SEMESTRE_ACADEMICO = enu.ID_ENUMERADO

				WHERE 
				persona.NUMERO_DOCUMENTO_PERSONA = @NUMERO_DOCUMENTO and persona.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO and pins.ID_INSTITUCION = @ID_INSTITUCION
				ORDER BY mestudiante.ID_MATRICULA_ESTUDIANTE DESC

			SET @RESULT = 1 -- NO ESTA LIBERADO
		END	
SELECT @RESULT
END
GO


