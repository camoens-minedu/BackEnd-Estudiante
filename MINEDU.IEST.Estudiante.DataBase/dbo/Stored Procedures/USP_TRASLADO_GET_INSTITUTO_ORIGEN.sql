/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene los datos de origen de un traslado de un estudiante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			CREACIÓN
2.0			30/07/2021		JCHAVEZ			SE AÑADE MATCH CON TABLA liberacion_estudiante EN TRASLADO EXTERNO PARA MOSTRAR SÓLO CARRERA DE SALIDA

TEST:	EXEC USP_TRASLADO_GET_INSTITUTO_ORIGEN 383,26,'77239666',290
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRASLADO_GET_INSTITUTO_ORIGEN] 
(
	@ID_INSTITUTO_ORIGEN INT,
	@ID_TIPO_DOCUMENTO INT,
	@NRO_DOCUMENTO VARCHAR(16),
	@ID_INSTITUTO_DESTINO INT

	--DECLARE @ID_INSTITUTO_ORIGEN INT=2164
	--DECLARE @ID_TIPO_DOCUMENTO INT=26
	--DECLARE @NRO_DOCUMENTO VARCHAR(16)='78576049'
	--DECLARE @ID_INSTITUTO_DESTINO INT=2164
)
AS
BEGIN
	DECLARE @RESULT INT

	IF @ID_INSTITUTO_ORIGEN <> @ID_INSTITUTO_DESTINO
	BEGIN
	-- VALIDAR SI ESTA LIBERADO
		IF EXISTS(SELECT TOP 1 lestudiante.ID_LIBERACION_ESTUDIANTE FROM maestro.persona persona INNER JOIN maestro.persona_institucion pinstitucion
		ON persona.ID_PERSONA = pinstitucion.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einstitucion
		ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION INNER JOIN transaccional.liberacion_estudiante lestudiante
		ON einstitucion.ID_ESTUDIANTE_INSTITUCION = lestudiante.ID_ESTUDIANTE_INSTITUCION
		WHERE einstitucion.ES_ACTIVO = 1 AND lestudiante.ES_ACTIVO = 1 AND persona.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO AND persona.NUMERO_DOCUMENTO_PERSONA= @NRO_DOCUMENTO AND
		pinstitucion.ID_INSTITUCION = @ID_INSTITUTO_ORIGEN)
		BEGIN
		
			SET @RESULT = -210 -- EL ESTUDIANTE SE ENCUENTRA LIBERADO
			-- MUESTRA LA CARRERA ORIGEN DEL ESTUDIANTE
			SELECT 
			carrera.ID_CARRERA                                              IdPrograma,
			--cpinst.ID_CARRERAS_POR_INSTITUCION                            IdPrograma,
			carrera.NOMBRE_CARRERA                                          Programa,
			pestudio.ID_PLAN_ESTUDIO                                        IdPlanEstudio,
			pestudio.NOMBRE_PLAN_ESTUDIOS                                   PlanEstudio,
			pestudio.NOMBRE_PLAN_ESTUDIOS									PlanEstudiosOrigen
 
			FROM maestro.persona persona INNER JOIN maestro.persona_institucion pinstitucion
			ON persona.ID_PERSONA = pinstitucion.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einstitucion
			ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION INNER JOIN transaccional.liberacion_estudiante lestudiante
			ON einstitucion.ID_ESTUDIANTE_INSTITUCION = lestudiante.ID_ESTUDIANTE_INSTITUCION INNER JOIN transaccional.carreras_por_institucion_detalle cpidet
			ON einstitucion.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpidet.ID_CARRERAS_POR_INSTITUCION_DETALLE INNER JOIN transaccional.carreras_por_institucion cpinst
			ON cpidet.ID_CARRERAS_POR_INSTITUCION = cpinst.ID_CARRERAS_POR_INSTITUCION INNER JOIN db_auxiliar.dbo.UVW_CARRERA carrera
			ON cpinst.ID_CARRERA = carrera.ID_CARRERA INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION institucion
			ON cpinst.ID_INSTITUCION = institucion.ID_INSTITUCION INNER JOIN transaccional.plan_estudio pestudio
			ON einstitucion.ID_PLAN_ESTUDIO = pestudio.ID_PLAN_ESTUDIO

			WHERE einstitucion.ES_ACTIVO = 1 AND lestudiante.ES_ACTIVO = 1 AND cpidet.ES_ACTIVO=1 AND cpinst.ES_ACTIVO=1 AND pinstitucion.ID_INSTITUCION=@ID_INSTITUTO_ORIGEN
			AND persona.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO AND persona.NUMERO_DOCUMENTO_PERSONA = @NRO_DOCUMENTO

		END
		ELSE
		BEGIN

		SET @RESULT = -211  -- EL ESTUDIANTE NO SE ENCUENTRA LIBERADO Y NO MUESTRA LA CARRERA

		SELECT 

		@RESULT                                     Resultado


		END

	END
	ELSE
	BEGIN 
	    SET @RESULT = -212 -- TRASLADO INTERNO
		SELECT 
		        carrera.ID_CARRERA                                                IdPrograma,
				--cpinst.ID_CARRERAS_POR_INSTITUCION                                IdPrograma,
				carrera.NOMBRE_CARRERA                                            Programa,
				pestudio.ID_PLAN_ESTUDIO                                          IdPlanEstudio,
			    pestudio.NOMBRE_PLAN_ESTUDIOS                                     PlanEstudio,
				pestudio.NOMBRE_PLAN_ESTUDIOS                                     PlanEstudiosOrigen
 
				FROM maestro.persona persona INNER JOIN maestro.persona_institucion pinstitucion
				ON persona.ID_PERSONA = pinstitucion.ID_PERSONA INNER JOIN transaccional.estudiante_institucion einstitucion
				ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION INNER JOIN transaccional.carreras_por_institucion_detalle cpidet
				ON einstitucion.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpidet.ID_CARRERAS_POR_INSTITUCION_DETALLE INNER JOIN transaccional.carreras_por_institucion cpinst
				ON cpidet.ID_CARRERAS_POR_INSTITUCION = cpinst.ID_CARRERAS_POR_INSTITUCION INNER JOIN db_auxiliar.dbo.UVW_CARRERA carrera
				ON cpinst.ID_CARRERA = carrera.ID_CARRERA INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION institucion
				ON cpinst.ID_INSTITUCION = institucion.ID_INSTITUCION INNER JOIN transaccional.plan_estudio pestudio
			    ON einstitucion.ID_PLAN_ESTUDIO = pestudio.ID_PLAN_ESTUDIO

				WHERE einstitucion.ES_ACTIVO = 1 AND cpidet.ES_ACTIVO=1 AND cpinst.ES_ACTIVO=1 AND pinstitucion.ID_INSTITUCION=@ID_INSTITUTO_ORIGEN
				AND persona.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO AND persona.NUMERO_DOCUMENTO_PERSONA = @NRO_DOCUMENTO

		END

END
SELECT @RESULT
GO


