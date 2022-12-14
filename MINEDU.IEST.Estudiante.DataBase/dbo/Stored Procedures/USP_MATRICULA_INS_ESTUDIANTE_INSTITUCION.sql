/********************************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta el registro de matricula de un estudiante de una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN	FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0		09/01/2020		MALVA           MODIFICACIÓN, EN LA INSERCIÓN DE INSTITUCIÓN BÁSICA DE TIPO EBA
										SE CONSIDERA QUE NO TRAE CÓDIGO MODULAR. 
1.1		07/01/2020		MALVA           MODIFICACIÓN SE AÑADE PARÁMETRO @ID_PLAN_ESTUDIO para registro de estudiante institución.
1.2     14/05/2020		MALVA		    SE FILTRA LA CONSULTA DE SIAGIE PARA QUE NO RETORNE NIVEL D0.
1.3     20/05/2020		MALVA		    MODIFICACIÓN POR SEGUNDA CARRERA DEL ESTUDIANTE.
1.3		08/04/2021		JTOVAR		    MODIFICACIÓN DE VALIDACION DE REGISTRO DE POSTULACION Y LA MODALIDAD DE ADMISION.
1.4		21/04/2021		JCHAVEZ			MODIFICACIÓN PARA AGREGAR VALIDACIÓN DE ACCESITARIOS CON LA TABLA promover_persona_institucion
1.5		29/04/2021		JTOVAR			MODIFICACION PARA PERMITIR REGISTRO DE POSTULANTE Y POSTERIOR REGISTRO DE ESTUDIANTE EN OTRO PERIODO Y QUE PERMITA REGISTRA A LA MISMA PERSONA EN OTRO INSTITUTO EN EL MISMO PROGRAMA DE ESTUDIO Y TURNO
1.6		10/05/2021		JTOVAR			MODIFICACION PARA PERMITIR REGISTRO DE POSTULANTE Y POSTERIOR REGISTRO DE ESTUDIANTE EN OTRO PERIODO Y QUE PERMITA REGISTRA A LA MISMA PERSONA EN OTRO INSTITUTO EN EL MISMO PROGRAMA DE ESTUDIO Y TURNO Y TIPO DE PLAN
1.7		28/02/2022		JCHAVEZ			MODIFICACIÓN PARA PERMITIR AL ESPECIALISTA REGISTRAR ESTUDIANTES QUE AUN NO TIENEN ACTUALIZADO SU INFORMACIÓN EN SIAGIE
1.8		04/04/2022		JCHAVEZ			MODIFICACION PARA PERMITIR REGISTRO DE POSTULANTE EN EL MISMO INSITITUTO Y MISMO PROGRAMA CON DIFERENTE PLAN DE ESTUDIO.

TEST:			
	USP_MATRICULA_INS_ESTUDIANTE_INSTITUCION 0,0,0, 26, '44485129', 'juan roy', 'arbi', 'vargas', 35, 69, '1987-03-11', 0, 
		92330, '140106', 
		0, '','','',0,
		6, 32, 92330, '140105', 'PROVIV LOS CLAVELES mz. N lt. 16', 
		'4546455','912212312','roy@gmial.com', 0,
		9, 2009, '', 70, '0012216', 'MIS GOLONDRINAS', 73,3,92330,
		'240101', 'HURACÁN', 'estudiante 2.jpg', '\\10.1.1.74\FileSystem\Fabrica\Regia\dev\ESTUDIANTES_HIST_FOTOS\estudiante 2.jpg', 
		6,6,99, 10, 111, 190,895, ,'MALVA'

********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_INS_ESTUDIANTE_INSTITUCION]
(

	@ID_PERSONA						INT,
	@ID_PERSONA_INSTITUCION			INT,
	@ID_ESTUDIANTE_INSTITUCION	INT,
	@ID_TIPO_DOCUMENTO				INT,
	@NUMERO_DOCUMENTO_PERSONA		VARCHAR(16),
	@NOMBRE_PERSONA					VARCHAR(50),
	@APELLIDO_PATERNO_PERSONA		VARCHAR(40),
	@APELLIDO_MATERNO_PERSONA		VARCHAR(40),	
	@SEXO_PERSONA					INT,
	@ID_LENGUA_MATERNA				INT,
	@FECHA_NACIMIENTO_PERSONA		DATETIME,
	@ES_DISCAPACITADO				INT,
	@PAIS_NACIMIENTO				INT,
	@UBIGEO_NACIMIENTO				VARCHAR(6),
	@ID_TIPO_DOCUMENTO_APODERADO	INT,
	@NUMERO_DOCUMENTO_APODERADO		VARCHAR(16),
	@NOMBRE_APODERADO				VARCHAR(50),
	@APELLIDO_APODERADO				VARCHAR(150),
	@ID_TIPO_PARENTESCO				INT,
	@ID_INSTITUCION					INT,
	@ESTADO_CIVIL					INT,
	@PAIS_PERSONA					INT,
	@UBIGEO_PERSONA					VARCHAR(6),
	@DIRECCION_PERSONA				VARCHAR(255),
	@TELEFONO						VARCHAR(15),
	@CELULAR						VARCHAR(15),
	@CORREO							VARCHAR(100),
	@ID_TIPO_DISCAPACIDAD			INT,
	@ID_INSTITUCION_BASICA			INT,
	@ANIO_EGRESO					INT,
	@CODIGO_ESTUDIANTE				VARCHAR(16),
	@ID_TIPO_INSTITUCION_BASICA		INT,
	@CODIGO_MODULAR					VARCHAR(7),
	@NOMBRE_IE_BASICA				VARCHAR(150),
	@ID_NIVEL_IE_BASICA				INT,
	@ID_TIPO_GESTION_IE_BASICA		INT,
	@ID_PAIS_BASICA					INT,
	@UBIGEO_IE_BASICA				VARCHAR(6),
	@DIRECCION_IE_BASICA			VARCHAR(255),
	@ARCHIVO_FOTO					VARCHAR(50),
	@ARCHIVO_RUTA					VARCHAR(255),
	@ID_SEDE_INSTITUCION			INT, 
	@ID_CARRERA						INT,
	@ID_TIPO_ITINERARIO				INT, 
	@ID_TURNOS_POR_INSTITUCION		INT,
	@ID_SEMESTRE_ACADEMICO			INT,	
	@ID_TIPO_ESTUDIANTE				INT,
	@ID_PERIODO_LECTIVO_INSTITUCION	INT,	
	@ID_PLAN_ESTUDIO				INT,	
	@USUARIO						VARCHAR(20),
	@ID_ROL                         INT
)
AS 
DECLARE 
	@RESULT INT,
	@ID_TURNO INT,
	@ID_NIVEL_IE_SECUNDARIA INT =75,
	@ESTADO_ALCANZO_VACANTE INT= 174, 
	@ESTADO_TRASLADADO INT = 334

	SET @ID_TURNO =(SELECT mte.ID_TURNO FROM maestro.turnos_por_institucion mti
	INNER JOIN maestro.turno_equivalencia mte on mti.ID_TURNO_EQUIVALENCIA= mte.ID_TURNO_EQUIVALENCIA and mti.ES_ACTIVO=1
	WHERE mti.ID_TURNOS_POR_INSTITUCION= @ID_TURNOS_POR_INSTITUCION)

BEGIN --> Validar con SIAGIE
	--NUEVOS
	DECLARE @APROBADO INT = 1;		--> Aprobado
	DECLARE @NIVEL CHAR(2) = 'F0';	--> Secundaria
	DECLARE @GRADO CHAR(2) = '14'	--> 5to Año
	DECLARE @VALIDAR_EXISTE INT;		-- EXISTE = 1 / NO EXISTE = 0
	DECLARE @VALIDAR_REQUITOS INT;		-- GRABAR = 1 / NO GRABAR = 0
	DECLARE @ID_TIPO_DOCUMENTO_SIAGIE INT;	--> Tipo de documento SIAGIE

	--Cambio de valor tipo de documento
	IF @ID_TIPO_DOCUMENTO = 26 BEGIN SET @ID_TIPO_DOCUMENTO_SIAGIE = 2 END	--> SIAGIE: Documento Nacional de Identidad = 2
	IF @ID_TIPO_DOCUMENTO = 27 BEGIN SET @ID_TIPO_DOCUMENTO_SIAGIE = 6 END	--> SIAGIE: Carnet de Extranjería = 6
	IF @ID_TIPO_DOCUMENTO = 28 BEGIN SET @ID_TIPO_DOCUMENTO_SIAGIE = 5 END	--> SIAGIE: Pasaporte = 5
	IF @ID_TIPO_DOCUMENTO = 317 BEGIN SET @ID_TIPO_DOCUMENTO_SIAGIE = 9 END --> SIAGIE: Otro = 9

	--Valida antes de crear mi tabla temporal
	IF (OBJECT_ID('tempdb.dbo.#tmpVista','U')) IS NOT NULL
	DROP TABLE #tmpVista

	--Inserta los datos devueltos en una tabla temporal
	SELECT 
	* 
	INTO #tmpVista
	FROM db_auxiliar.dbo.UVW_REGIA_ESTUDIANTE_ULT_ANIO
	WHERE	
		DNI = @NUMERO_DOCUMENTO_PERSONA
		AND TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO_SIAGIE
		--AND ID_NIVEL <>'D0'
		AND ID_NIVEL NOT IN ('D0','D1','D2') --NO EBA

	SET @VALIDAR_EXISTE = (SELECT COUNT(TIPO_DOCUMENTO) FROM #tmpVista);

	SET @VALIDAR_REQUITOS = (
	SELECT TOP 1 COUNT(TIPO_DOCUMENTO) 
	FROM #tmpVista
	WHERE	
		DNI = @NUMERO_DOCUMENTO_PERSONA
		AND TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO_SIAGIE
		AND PROMOVIDO = @APROBADO
		AND ID_NIVEL = @NIVEL
		AND ID_GRADO = @GRADO
	)
END
IF(((@ID_ROL <> 46 AND @VALIDAR_EXISTE = 1 AND @VALIDAR_REQUITOS = 0) AND (@ID_ROL <> 46 OR @ID_TIPO_INSTITUCION_BASICA <> 71)) 
	OR @ID_NIVEL_IE_BASICA<>@ID_NIVEL_IE_SECUNDARIA 
	)
BEGIN
	SET @RESULT = -284
END
ELSE
BEGIN
DECLARE @ID_ESTADO INT
	SELECT  @ID_ESTADO  = (SELECT TOP 1 (CASE WHEN ppi_prom.ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO IS NOT NULL THEN 174
											  WHEN ppi_ret.ID_POSTULANTES_POR_MODALIDAD_RETIRADO IS NOT NULL THEN 170 ELSE rp.ESTADO END) --version1.4
					FROM maestro.persona p 
					inner join maestro.persona_institucion pin on p.ID_PERSONA = pin.ID_PERSONA 
					inner join transaccional.postulantes_por_modalidad pm on pm.ID_PERSONA_INSTITUCION = pin.ID_PERSONA_INSTITUCION
					inner join transaccional.opciones_por_postulante op on op.ID_POSTULANTES_POR_MODALIDAD = pm.ID_POSTULANTES_POR_MODALIDAD and op.ES_ACTIVO=1
					inner join transaccional.meta_carrera_institucion_detalle mcid on mcid.ID_META_CARRERA_INSTITUCION_DETALLE = op.ID_META_CARRERA_INSTITUCION_DETALLE and mcid.ES_ACTIVO=1
					inner join transaccional.meta_carrera_institucion mci on mci.ID_META_CARRERA_INSTITUCION = mcid.ID_META_CARRERA_INSTITUCION and mci.ES_ACTIVO=1 and pm.ES_ACTIVO=1
					inner join transaccional.resultados_por_postulante rp on rp.ID_POSTULANTES_POR_MODALIDAD= pm.ID_POSTULANTES_POR_MODALIDAD and rp.ES_ACTIVO=1 --and rp.ESTADO<>174
					LEFT JOIN transaccional.promover_persona_institucion ppi_prom ON ppi_prom.ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO=pm.ID_POSTULANTES_POR_MODALIDAD	--version1.4
					LEFT JOIN transaccional.promover_persona_institucion ppi_ret ON ppi_ret.ID_POSTULANTES_POR_MODALIDAD_RETIRADO=pm.ID_POSTULANTES_POR_MODALIDAD		--version1.4
					inner join transaccional.modalidades_por_proceso_admision mpad ON pm.ID_MODALIDADES_POR_PROCESO_ADMISION = mpad.ID_MODALIDADES_POR_PROCESO_ADMISION
					inner join transaccional.proceso_admision_periodo padp ON mpad.ID_PROCESO_ADMISION_PERIODO = padp.ID_PROCESO_ADMISION_PERIODO
					WHERE p.ID_PERSONA=@ID_PERSONA AND mci.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO AND padp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND op.ES_ACTIVO=1 AND mcid.ES_ACTIVO=1 AND rp.ES_ACTIVO=1 AND ppi_prom.ES_ACTIVO=1
					AND ppi_ret.ES_ACTIVO=1 AND mpad.ES_ACTIVO=1 AND padp.ES_ACTIVO=1
				    --GROUP BY rp.ESTADO, pm.ID_MODALIDADES_POR_PROCESO_ADMISION
					ORDER BY rp.ESTADO, pm.ID_MODALIDADES_POR_PROCESO_ADMISION DESC)

					--rp.ESTADO
					--FROM maestro.persona p 
					--inner join maestro.persona_institucion pin on p.ID_PERSONA = pin.ID_PERSONA 
					--inner join transaccional.postulantes_por_modalidad pm on pm.ID_PERSONA_INSTITUCION = pin.ID_PERSONA_INSTITUCION
					--inner join transaccional.opciones_por_postulante op on op.ID_POSTULANTES_POR_MODALIDAD = pm.ID_POSTULANTES_POR_MODALIDAD and op.ES_ACTIVO=1
					--inner join transaccional.meta_carrera_institucion_detalle mcid on mcid.ID_META_CARRERA_INSTITUCION_DETALLE = op.ID_META_CARRERA_INSTITUCION_DETALLE and mcid.ES_ACTIVO=1
					--inner join transaccional.meta_carrera_institucion mci on mci.ID_META_CARRERA_INSTITUCION = mcid.ID_META_CARRERA_INSTITUCION and mci.ES_ACTIVO=1 and pm.ES_ACTIVO=1
					--left join transaccional.resultados_por_postulante rp on rp.ID_POSTULANTES_POR_MODALIDAD= pm.ID_POSTULANTES_POR_MODALIDAD and rp.ES_ACTIVO=1 and rp.ESTADO<>@ESTADO_ALCANZO_VACANTE
					--WHERE p.ID_PERSONA=@ID_PERSONA AND mci.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO


	IF EXISTS ( SELECT TOP 1 tei.ID_ESTUDIANTE_INSTITUCION FROM maestro.persona mp 
				INNER JOIN maestro.persona_institucion mpi on mp.ID_PERSONA=mpi.ID_PERSONA
				inner join transaccional.estudiante_institucion tei on tei.ID_PERSONA_INSTITUCION= mpi.ID_PERSONA_INSTITUCION and tei.ES_ACTIVO=1
				inner join transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE= tei.ID_CARRERAS_POR_INSTITUCION_DETALLE and tcid.ES_ACTIVO=1
				inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION= tcid.ID_CARRERAS_POR_INSTITUCION and tci.ES_ACTIVO=1
				inner join maestro.turnos_por_institucion mtxi on mtxi.ID_TURNOS_POR_INSTITUCION= tei.ID_TURNOS_POR_INSTITUCION and mtxi.ES_ACTIVO=1
				inner join maestro.turno_equivalencia mte on mte.ID_TURNO_EQUIVALENCIA= mtxi.ID_TURNO_EQUIVALENCIA
				inner join transaccional.plan_estudio pestudio on tei.ID_PLAN_ESTUDIO = pestudio.ID_PLAN_ESTUDIO
				WHERE mp.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO AND mp.NUMERO_DOCUMENTO_PERSONA=@NUMERO_DOCUMENTO_PERSONA
				and tci.ID_CARRERA=@ID_CARRERA and mte.ID_TURNO=@ID_TURNO AND mpi.ID_INSTITUCION = @ID_INSTITUCION --version1.5
				AND pestudio.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO --version1.6
				AND pestudio.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO --version1.8
				AND tei.ES_ACTIVO=1 AND tcid.ES_ACTIVO = 1 AND tci.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1 

	) 
		SET @RESULT=-233
	ELSE IF @ID_ESTADO = 170 --version1.4
		SET @RESULT = -214
	ELSE IF @ID_ESTADO = 176
		SET @RESULT = -215
	ELSE IF @ID_ESTADO = 177
		SET @RESULT = -216
	--ELSE IF EXISTS (select top 1 ei.ID_ESTUDIANTE_INSTITUCION from maestro.persona p
	--	inner join maestro.persona_institucion pin on p.ID_PERSONA = pin.ID_PERSONA 
	--	inner join transaccional.estudiante_institucion ei on ei.ID_PERSONA_INSTITUCION = pin.ID_PERSONA_INSTITUCION and ei.ES_ACTIVO=1
	--	AND ei.ESTADO <> @ESTADO_TRASLADADO
	--	inner join transaccional.plan_estudio pe on pe.ID_PLAN_ESTUDIO = ei.ID_PLAN_ESTUDIO and pe.ES_ACTIVO=1
	--	inner join transaccional.carreras_por_institucion ci on ci.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION and ci.ES_ACTIVO=1
	--	WHERE p.NUMERO_DOCUMENTO_PERSONA =@NUMERO_DOCUMENTO_PERSONA AND p.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO
	--	and ci.ID_CARRERA = @ID_CARRERA)
	--	SET @RESULT = -198
	ELSE
	BEGIN
		DECLARE
			@ID_CARRERAS_POR_INSTITUCION_DETALLE INT =0 
		BEGIN TRY
		BEGIN TRANSACTION T1
			SET @RESULT =0
			DECLARE @REGISTRO_EXISTE BIT = 0, @ID_INSTITUCION_BASICA_PREVIO INT 
			IF  @ID_TIPO_INSTITUCION_BASICA = 70   -- IE BÁSICA EBR 
			AND EXISTS (SELECT TOP 1 ID_INSTITUCION_BASICA FROM maestro.institucion_basica (NOLOCK)
									WHERE ID_TIPO_INSTITUCION_BASICA = @ID_TIPO_INSTITUCION_BASICA AND CODIGO_MODULAR_IE_BASICA = @CODIGO_MODULAR
									AND ID_PAIS = @ID_PAIS_BASICA AND ID_NIVEL_IE_BASICA=@ID_NIVEL_IE_BASICA 
									AND ID_TIPO_GESTION_IE_BASICA= @ID_TIPO_GESTION_IE_BASICA)
									SET @REGISTRO_EXISTE =1
			--GRABO LA INSTITUCION BASICA		
			IF @ID_INSTITUCION_BASICA = 0
			BEGIN	
				IF @REGISTRO_EXISTE = 0
				BEGIN
					INSERT INTO maestro.institucion_basica(
						ID_TIPO_INSTITUCION_BASICA,
						CODIGO_MODULAR_IE_BASICA,
						NOMBRE_IE_BASICA,
						ID_NIVEL_IE_BASICA,
						ID_TIPO_GESTION_IE_BASICA,
						DIRECCION_IE_BASICA,
						ID_PAIS,
						UBIGEO_IE_BASICA,
						ESTADO,
						USUARIO_CREACION,
						FECHA_CREACION
					)VALUES(
						@ID_TIPO_INSTITUCION_BASICA,
						@CODIGO_MODULAR,
						@NOMBRE_IE_BASICA,
						@ID_NIVEL_IE_BASICA,
						@ID_TIPO_GESTION_IE_BASICA,
						@DIRECCION_IE_BASICA,
						@ID_PAIS_BASICA,
						RIGHT(REPLICATE('0',6) + @UBIGEO_IE_BASICA,6),
						1,
						@USUARIO,
						GETDATE()
					)

					SET @ID_INSTITUCION_BASICA = CONVERT(INT,@@IDENTITY)
				END
				ELSE
				BEGIN
					SET @ID_INSTITUCION_BASICA = (SELECT TOP 1 ID_INSTITUCION_BASICA FROM maestro.institucion_basica (NOLOCK)
									WHERE ID_TIPO_INSTITUCION_BASICA = @ID_TIPO_INSTITUCION_BASICA AND CODIGO_MODULAR_IE_BASICA = @CODIGO_MODULAR						
									AND ID_PAIS = @ID_PAIS_BASICA AND ID_NIVEL_IE_BASICA=@ID_NIVEL_IE_BASICA 
									AND ID_TIPO_GESTION_IE_BASICA= @ID_TIPO_GESTION_IE_BASICA)

					UPDATE maestro.institucion_basica
					SET NOMBRE_IE_BASICA = @NOMBRE_IE_BASICA,
						ID_NIVEL_IE_BASICA = @ID_NIVEL_IE_BASICA,
						ID_TIPO_GESTION_IE_BASICA = @ID_TIPO_GESTION_IE_BASICA,
						DIRECCION_IE_BASICA = @DIRECCION_IE_BASICA,
						UBIGEO_IE_BASICA = RIGHT(REPLICATE('0',6) + @UBIGEO_IE_BASICA,6),
						USUARIO_MODIFICACION = @USUARIO,
						FECHA_MODIFICACION = GETDATE()
					WHERE 
						ID_INSTITUCION_BASICA = @ID_INSTITUCION_BASICA
				END
			END
			ELSE
			BEGIN
				UPDATE maestro.institucion_basica
				SET ID_TIPO_INSTITUCION_BASICA = @ID_TIPO_INSTITUCION_BASICA,
					CODIGO_MODULAR_IE_BASICA = @CODIGO_MODULAR,
					NOMBRE_IE_BASICA = @NOMBRE_IE_BASICA,
					ID_NIVEL_IE_BASICA = @ID_NIVEL_IE_BASICA,
					ID_TIPO_GESTION_IE_BASICA = @ID_TIPO_GESTION_IE_BASICA,
					DIRECCION_IE_BASICA = @DIRECCION_IE_BASICA,
					UBIGEO_IE_BASICA = RIGHT(REPLICATE('0',6) + @UBIGEO_IE_BASICA,6),
					USUARIO_MODIFICACION = @USUARIO,
					FECHA_MODIFICACION = GETDATE()
				WHERE 
					ID_INSTITUCION_BASICA = @ID_INSTITUCION_BASICA	
			END

			IF @ID_PERSONA = 0
			SET @ID_PERSONA =(SELECT ID_PERSONA FROM maestro.persona (NOLOCK)
								WHERE ESTADO = 1 AND ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO 
								AND NUMERO_DOCUMENTO_PERSONA=@NUMERO_DOCUMENTO_PERSONA)
			
				IF @ID_PERSONA IS NULL
				BEGIN
					INSERT INTO maestro.persona(
						ID_TIPO_DOCUMENTO,
						NUMERO_DOCUMENTO_PERSONA,
						NOMBRE_PERSONA,
						APELLIDO_PATERNO_PERSONA,
						APELLIDO_MATERNO_PERSONA,
						FECHA_NACIMIENTO_PERSONA,
						SEXO_PERSONA,
						ID_LENGUA_MATERNA,
						ES_DISCAPACITADO,
						UBIGEO_NACIMIENTO,
						PAIS_NACIMIENTO,
						ESTADO,
						USUARIO_CREACION,
						FECHA_CREACION
					)VALUES(
						@ID_TIPO_DOCUMENTO,
						@NUMERO_DOCUMENTO_PERSONA,
						@NOMBRE_PERSONA,
						@APELLIDO_PATERNO_PERSONA,
						@APELLIDO_MATERNO_PERSONA,
						@FECHA_NACIMIENTO_PERSONA,
						@SEXO_PERSONA,
						@ID_LENGUA_MATERNA,
						@ES_DISCAPACITADO,
						RIGHT(REPLICATE('0',6) + @UBIGEO_NACIMIENTO,6),
						@PAIS_NACIMIENTO,
						1,
						@USUARIO,
						GETDATE()
					)
				
					SET @ID_PERSONA = CONVERT(INT,@@IDENTITY)
				END	
				ELSE
				BEGIN
					IF @ID_TIPO_DOCUMENTO <> 26
					BEGIN
						UPDATE maestro.persona
						SET NOMBRE_PERSONA=@NOMBRE_PERSONA,
						APELLIDO_PATERNO_PERSONA=@APELLIDO_PATERNO_PERSONA,
						APELLIDO_MATERNO_PERSONA=@APELLIDO_MATERNO_PERSONA,
						SEXO_PERSONA = @SEXO_PERSONA ,
						FECHA_NACIMIENTO_PERSONA=@FECHA_NACIMIENTO_PERSONA,
						ID_LENGUA_MATERNA=@ID_LENGUA_MATERNA,
						ES_DISCAPACITADO=@ES_DISCAPACITADO,
						PAIS_NACIMIENTO=@PAIS_NACIMIENTO,
						UBIGEO_NACIMIENTO=RIGHT(REPLICATE('0',6) + @UBIGEO_NACIMIENTO,6)
						WHERE ID_PERSONA= @ID_PERSONA
					END
					ELSE
					BEGIN
						UPDATE maestro.persona
						SET
						ID_LENGUA_MATERNA=@ID_LENGUA_MATERNA,
						ES_DISCAPACITADO=@ES_DISCAPACITADO		
						WHERE ID_PERSONA= @ID_PERSONA
					END
				END			

				IF NOT EXISTS(SELECT TOP 1 ID_PERSONA_INSTITUCION FROM maestro.persona_institucion (NOLOCK)
								WHERE ESTADO = 1 AND ID_PERSONA = @ID_PERSONA AND ID_INSTITUCION = @ID_INSTITUCION)
				BEGIN				
					INSERT INTO maestro.persona_institucion(
						ID_PERSONA,
						ESTADO_CIVIL,
						PAIS_PERSONA,
						UBIGEO_PERSONA,
						DIRECCION_PERSONA,
						TELEFONO,
						CELULAR,
						CORREO,
						ID_TIPO_DISCAPACIDAD,
						ID_GRADO_PROFESIONAL,					
						ID_INSTITUCION,
						NIVEL_EDUCATIVO,
						ESTADO,
						USUARIO_CREACION,
						FECHA_CREACION
					)VALUES(
						@ID_PERSONA,
						@ESTADO_CIVIL,
						@PAIS_PERSONA,
						RIGHT(REPLICATE('0',6) + @UBIGEO_PERSONA,6),
						@DIRECCION_PERSONA,
						@TELEFONO,
						@CELULAR,
						@CORREO,
						@ID_TIPO_DISCAPACIDAD,
						0,
						@ID_INSTITUCION,
						0,
						1,
						@USUARIO,
						GETDATE()					
					)				
					SET @ID_PERSONA_INSTITUCION = CONVERT(INT,@@IDENTITY)
				END	
				ELSE
				BEGIN
					UPDATE maestro.persona_institucion
					SET ESTADO_CIVIL = @ESTADO_CIVIL,
						PAIS_PERSONA = @PAIS_PERSONA,
						UBIGEO_PERSONA = RIGHT(REPLICATE('0',6) + @UBIGEO_PERSONA,6),
						DIRECCION_PERSONA = @DIRECCION_PERSONA,
						TELEFONO = @TELEFONO,
						CELULAR = @CELULAR,
						CORREO = @CORREO,
						ID_TIPO_DISCAPACIDAD = @ID_TIPO_DISCAPACIDAD,
						ESTADO = 1,
						USUARIO_MODIFICACION = @USUARIO,
						FECHA_MODIFICACION = GETDATE()
					WHERE ID_PERSONA_INSTITUCION = @ID_PERSONA_INSTITUCION
				END		

			--IF @ID_ESTUDIANTE_INSTITUCION = 0
			--BEGIN
			--	IF NOT EXISTS(SELECT TOP 1 ID_ESTUDIANTE_INSTITUCION FROM transaccional.estudiante_institucion 
			--					WHERE ES_ACTIVO = 1 AND ID_PERSONA_INSTITUCION = @ID_PERSONA_INSTITUCION
			--					--AND CODIGO_ESTUDIANTE = @CODIGO_ESTUDIANTE
			--					)
				BEGIN
				SET @ID_CARRERAS_POR_INSTITUCION_DETALLE = (SELECT 
																CXID.ID_CARRERAS_POR_INSTITUCION_DETALLE 
															FROM transaccional.carreras_por_institucion_detalle CXID 
																INNER JOIN transaccional.carreras_por_institucion CXI ON CXI.ID_CARRERAS_POR_INSTITUCION= CXID.ID_CARRERAS_POR_INSTITUCION 
																													 AND CXI.ES_ACTIVO=1 
															WHERE
																CXID.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION 
																AND CXID.ES_ACTIVO=1 
																AND CXI.ID_CARRERA=@ID_CARRERA
																AND CXI.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO)	
				INSERT INTO transaccional.estudiante_institucion (
					ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
					ID_PERSONA_INSTITUCION,
					ID_INSTITUCION_BASICA,
					ID_CARRERAS_POR_INSTITUCION_DETALLE,
					ID_TURNOS_POR_INSTITUCION,
					ID_SEMESTRE_ACADEMICO,
					ID_TIPO_ESTUDIANTE,
					--CODIGO_POSTULANTE,
					CODIGO_ESTUDIANTE,
					ID_TIPO_DOCUMENTO_APODERADO,
					NUMERO_DOCUMENTO_APODERADO,
					NOMBRE_APODERADO,
					APELLIDO_APODERADO,
					ID_TIPO_PARENTESCO,
					ANIO_EGRESO,
					ARCHIVO_FOTO,
					ARCHIVO_RUTA,
					ID_PLAN_ESTUDIO,
					ES_ACTIVO,
					ESTADO,					
					USUARIO_CREACION,
					FECHA_CREACION
				)
				VALUES
				(
					@ID_PERIODO_LECTIVO_INSTITUCION,
					@ID_PERSONA_INSTITUCION,
					@ID_INSTITUCION_BASICA,
					@ID_CARRERAS_POR_INSTITUCION_DETALLE,
					@ID_TURNOS_POR_INSTITUCION,
					@ID_SEMESTRE_ACADEMICO,
					@ID_TIPO_ESTUDIANTE,
					--@CODIGO_POSTULANTE,
					@CODIGO_ESTUDIANTE,
					@ID_TIPO_DOCUMENTO_APODERADO,
					@NUMERO_DOCUMENTO_APODERADO,
					@NOMBRE_APODERADO,
					@APELLIDO_APODERADO,
					@ID_TIPO_PARENTESCO,
					case when @ANIO_EGRESO = 0 then null else @ANIO_EGRESO END,
					@ARCHIVO_FOTO,
					@ARCHIVO_RUTA,
					@ID_PLAN_ESTUDIO, 
					1,
					1,
					@USUARIO,
					GETDATE()
				)
				SET @ID_ESTUDIANTE_INSTITUCION = CONVERT(INT,@@IDENTITY)
					
				END
			--	ELSE	
			--	BEGIN			
			--		RAISERROR('ERROR DE INSERCION',12,-1) WITH SETERROR
			--	END
			--END


			COMMIT TRANSACTION T1	
			SET @RESULT = 1			
		END TRY
		BEGIN CATCH
			IF @@ERROR = 50000
			BEGIN
				ROLLBACK TRANSACTION T1	   
				SET @RESULT = -180
					PRINT ERROR_MESSAGE()
			END
			ELSE
				IF @@ERROR <> 0
				BEGIN
					ROLLBACK TRANSACTION T1	   
					SET @RESULT = -1
				END
				ELSE
				BEGIN
					ROLLBACK TRANSACTION T1	   
					SET @RESULT = -2
					PRINT ERROR_MESSAGE()
				END
		END CATCH
	END
END

SELECT @RESULT
GO


