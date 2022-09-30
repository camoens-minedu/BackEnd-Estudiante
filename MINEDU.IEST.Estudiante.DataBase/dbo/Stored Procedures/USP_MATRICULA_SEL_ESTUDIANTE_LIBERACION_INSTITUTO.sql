--USP_MATRICULA_SEL_ESTUDIANTE_LIBERACION_INSTITUTO 564, 27, 'CE123456'
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_ESTUDIANTE_LIBERACION_INSTITUTO] 
(
	@ID_INSTITUCION INT,
	@ID_TIPO_DOCUMENTO	INT,
	@NUMERO_DOCUMENTO VARCHAR(15)
)AS
BEGIN
	
	DECLARE @RESULT INT
	DECLARE @ESTUDIANTE_INSTITUCION1 INT

	--IF EXISTS(SELECT 
	--			TOP 1
	--			einsti.ID_ESTUDIANTE_INSTITUCION                   IdEstudianteInstitucion,
	--			persona.NOMBRE_PERSONA                             Nombres, 
	--			persona.APELLIDO_PATERNO_PERSONA                   Paterno, 
	--			persona.APELLIDO_MATERNO_PERSONA                   Materno,
	--			sedeinstitucion.NOMBRE_SEDE                        Sede,
	--			carrera.NOMBRE_CARRERA                             Programa,
	--			enu.VALOR_ENUMERADO                                Ciclo

	--			FROM transaccional.matricula_estudiante mestu INNER JOIN transaccional.estudiante_institucion einsti
	--			ON mestu.ID_ESTUDIANTE_INSTITUCION = einsti.ID_ESTUDIANTE_INSTITUCION INNER JOIN maestro.persona_institucion pinsti
	--			ON einsti.ID_PERSONA_INSTITUCION = pinsti.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona persona
	--			ON pinsti.ID_PERSONA = persona.ID_PERSONA INNER JOIN transaccional.carreras_por_institucion_detalle cpidet
	--			ON einsti.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpidet.ID_CARRERAS_POR_INSTITUCION_DETALLE INNER JOIN transaccional.carreras_por_institucion cpinsti
	--			ON cpidet.ID_CARRERAS_POR_INSTITUCION = cpinsti.ID_CARRERAS_POR_INSTITUCION INNER JOIN maestro.carrera carrera
	--			ON cpinsti.ID_CARRERA = carrera.ID_CARRERA INNER JOIN maestro.sede_institucion sedeinstitucion
	--			ON cpidet.ID_SEDE_INSTITUCION = sedeinstitucion.ID_SEDE_INSTITUCION INNER JOIN sistema.enumerado enu
	--			ON mestu.ID_SEMESTRE_ACADEMICO = enu.ID_ENUMERADO INNER JOIN maestro.institucion institucion
	--			ON sedeinstitucion.ID_INSTITUCION = institucion.ID_INSTITUCION INNER JOIN transaccional.liberacion_estudiante lestudiante
	--			ON einsti.ID_ESTUDIANTE_INSTITUCION = lestudiante.ID_ESTUDIANTE_INSTITUCION

	--			WHERE 
	
	--			persona.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO 
	--			AND persona.NUMERO_DOCUMENTO_PERSONA = @NUMERO_DOCUMENTO 
	--			AND institucion.ID_INSTITUCION=@ID_INSTITUCION 
	--			AND mestu.ES_ACTIVO=1 AND einsti.ES_ACTIVO=1 AND cpidet.ES_ACTIVO=1 AND cpinsti.ES_ACTIVO=1
	--			ORDER BY
	--			mestu.ID_MATRICULA_ESTUDIANTE DESC)
	--	BEGIN
	--		SET @RESULT = -210 -- EL ESTUDIANTE SE ENCUENTRA LIBERADO
	--	END
	--	ELSE
	--		BEGIN    	--print 'dentro de la transaccion'
	
	--			SELECT
	--			TOP 1
	--			einsti.ID_ESTUDIANTE_INSTITUCION                            IdEstudianteInstitucion,
	--			persona.NOMBRE_PERSONA                                      Nombres, 
	--			persona.APELLIDO_PATERNO_PERSONA                            Paterno, 
	--			persona.APELLIDO_MATERNO_PERSONA                            Materno,
	--			sinstitucion.NOMBRE_SEDE                                    Sede,
	--			carrera.NOMBRE_CARRERA                                      Programa,
	--			enu.VALOR_ENUMERADO                                         Ciclo
				
	--			FROM maestro.persona persona INNER JOIN maestro.persona_institucion pinsti
	--			ON persona.ID_PERSONA = pinsti.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einsti
	--			ON pinsti.ID_PERSONA_INSTITUCION = einsti.ID_PERSONA_INSTITUCION INNER JOIN transaccional.matricula_estudiante mestu
	--			ON einsti.ID_ESTUDIANTE_INSTITUCION = mestu.ID_ESTUDIANTE_INSTITUCION INNER JOIN transaccional.carreras_por_institucion_detalle cidet
	--			ON einsti.ID_CARRERAS_POR_INSTITUCION_DETALLE = cidet.ID_CARRERAS_POR_INSTITUCION_DETALLE INNER JOIN transaccional.carreras_por_institucion cinstitucion
	--			ON cidet.ID_CARRERAS_POR_INSTITUCION = cinstitucion.ID_CARRERAS_POR_INSTITUCION INNER JOIN maestro.carrera carrera
	--			ON cinstitucion.ID_CARRERA = carrera.ID_CARRERA INNER JOIN maestro.sede_institucion sinstitucion
	--			ON cidet.ID_SEDE_INSTITUCION = sinstitucion.ID_SEDE_INSTITUCION INNER JOIN maestro.institucion institucion
	--			ON sinstitucion.ID_INSTITUCION = institucion.ID_INSTITUCION INNER JOIN sistema.enumerado enu
	--			ON mestu.ID_SEMESTRE_ACADEMICO = enu.ID_ENUMERADO
	--			WHERE 
	--			persona.NUMERO_DOCUMENTO_PERSONA=@NUMERO_DOCUMENTO AND 
	--			institucion.ID_INSTITUCION=@ID_INSTITUCION AND
	--			persona.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO 
	--			AND mestu.ES_ACTIVO=1 AND einsti.ES_ACTIVO=1 AND cidet.ES_ACTIVO=1 AND cinstitucion.ES_ACTIVO=1
	--			ORDER BY
	--			mestu.ID_MATRICULA_ESTUDIANTE DESC
					
				
	--		SET @RESULT = 1 -- ES ESTUDIANTE ES DEL IES Y NO ESTA LIBERADO
	--	END	

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


