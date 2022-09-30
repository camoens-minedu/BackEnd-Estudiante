/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de estudiantes por periodo lectivo institucion.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO		DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			01/10/2018		MALVA		CREACIÓN
1.1			06/01/2020		MALVA       MODIFICACIÓN SE OBTIENEN LAS COLUMNAS TipoPlanEstudios,IdPlanEstudios y PlanEstudios. 
1.2			07/01/2020		MALVA       MODIFICACIÓN SE AÑADE PARÁMETRO @ID_PLAN_ESTUDIO.
1.3			18/06/2020		MALVA		OBTENCIÓN DE LA COLUMNA Condicion, modificación de columna. Adición parámetro @ID_ESTUDIANTE_INSTITUCION.
2.0			07/01/2022		JCHAVEZ		OBTENCIÓN DE SOLO UN UNICO ESTUDIANTE POR INSTITUCION Y CARRERA (DISTINCT)

TEST:			
	USP_MATRICULA_SEL_ESTUDIANTE_PAGINADO 3574, 0, '', '', 0, 0, 0, 0, 262, 0
	USP_MATRICULA_SEL_ESTUDIANTE_PAGINADO 1911, 0, '', '', 0, 0, 0, 0, 4139, 0
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_ESTUDIANTE_PAGINADO]
(  
	@ID_INSTITUCION					INT,
	@ID_TIPO_DOCUMENTO				INT,
	@NUMERO_DOCUMENTO_PERSONA		VARCHAR(16),
	@ESTUDIANTE						VARCHAR(150),
	@ID_SEDE_INSTITUCION			INT,	
	@ID_CARRERA						INT,
	@ID_TIPO_ITINERARIO				INT,
	@ID_TURNOS_POR_INSTITUCION		INT,
	@ID_PERIODO_LECTIVO_INSTITUCION	INT,
	@ID_PLAN_ESTUDIO				INT,  
	@Pagina							int = 1,
	@Registros						int = 10,
	@ID_ESTUDIANTE_INSTITUCION		INT = 0
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
 DECLARE @ESTADO_EN_TRASLADO INT =333, @ESTADO_TRASLADADO INT = 334, @ESTADO_EN_CONVALIDACION INT = 200
 DECLARE @desde INT , @hasta INT;  
 SET @desde = ( @Pagina - 1 ) * @Registros;  
    SET @hasta = ( @Pagina * @Registros ) + 1;
 WITH    tempPaginado AS  
 (
	SELECT DISTINCT *,
		ROW_NUMBER() OVER ( ORDER BY Estudiante) AS Row ,
		Total = COUNT(1) OVER ( )  
	FROM (
		SELECT 
		mp.ID_PERSONA IdPersona,
		mpi.ID_PERSONA_INSTITUCION IdPersonaInstitucion,
		tehi.ID_ESTUDIANTE_INSTITUCION IdEstudianteInstitucion,
		se_itin.VALOR_ENUMERADO			TipoPlanEstudios,
		mp.ID_TIPO_DOCUMENTO IdTipoDocumento,
		se_tipo_doc.VALOR_ENUMERADO TipoDocumento,
		mp.NUMERO_DOCUMENTO_PERSONA NumeroDocumento,
		UPPER(mp.APELLIDO_PATERNO_PERSONA)  + ' ' + UPPER(mp.APELLIDO_MATERNO_PERSONA) + ', ' + dbo.UFN_CAPITALIZAR(mp.NOMBRE_PERSONA) Estudiante,
		mp.NOMBRE_PERSONA Nombre,
		mp.APELLIDO_PATERNO_PERSONA ApellidoPaterno,
		mp.APELLIDO_MATERNO_PERSONA ApellidoMaterno,
		mp.SEXO_PERSONA IdSexo,
		mpi.ESTADO_CIVIL IdEstadoCivil,
		mp.FECHA_NACIMIENTO_PERSONA FechaNacimiento,
		convert(date, mp.FECHA_NACIMIENTO_PERSONA, 103) as FechaNac,
		mp.ES_DISCAPACITADO EsDiscapacitado,
		mpi.ID_TIPO_DISCAPACIDAD IdTipoDiscapacidad,
		mp.ID_LENGUA_MATERNA IdLenguaMaterna,
		mp.PAIS_NACIMIENTO IdPaisNacimiento,
		mp.UBIGEO_NACIMIENTO UbigeoNacimiento,
		tehi.ID_TIPO_DOCUMENTO_APODERADO IdTipoDocumentoApoderado,
		tehi.NUMERO_DOCUMENTO_APODERADO NumeroDocumentoApoderado,
		tehi.NOMBRE_APODERADO NombreApoderado,
		tehi.APELLIDO_APODERADO ApellidosApoderado,
		tehi.ID_TIPO_PARENTESCO IdTipoParentesco,
		tehi.NOMBRE_APODERADO + ' ' + tehi.APELLIDO_APODERADO  Apoderado,
		se_parentesco.VALOR_ENUMERADO Parentesco,
		mpi.PAIS_PERSONA IdPaisResidencia,
		mpi.UBIGEO_PERSONA UbigeoResidencia,
		mpi.DIRECCION_PERSONA Direccion,
		mpi.CORREO Correo,
		mpi.TELEFONO Telefono,
		mpi.CELULAR Celular,
		mib.ID_INSTITUCION_BASICA IdInstitucionBasica,
		mib.ID_TIPO_INSTITUCION_BASICA IdTipoIEBasica,
		mib.CODIGO_MODULAR_IE_BASICA CodigoModularBasica,
		tehi.CODIGO_ESTUDIANTE CodigoEstudiante,
		tehi.ANIO_EGRESO  AnioEgreso,
		mib.NOMBRE_IE_BASICA NombreIeBasica,
		mib.ID_NIVEL_IE_BASICA IdNivelBasica,
		mib.ID_TIPO_GESTION_IE_BASICA IdTipoGestionBasica,
		mib.ID_PAIS IdPaisBasica,
		mib.UBIGEO_IE_BASICA UbigeoBasica,
		mib.DIRECCION_IE_BASICA DireccionBasica,
		tehi.ARCHIVO_FOTO ArchivoFoto,
		'' ArchivoRuta,		
		msi.ID_SEDE_INSTITUCION IdSedeInstitucion,
		msi.NOMBRE_SEDE SedeInstitucion,
		mpi.DIRECCION_PERSONA  +' ' + UBI.DISTRITO_UBIGEO + '-' + UBI.PROVINCIA_UBIGEO + '-' + UBI.DEPARTAMENTO_UBIGEO + ' ' + PAIS.DSCPAIS  DireccionCompleta,	
		PBAS.DSCPAIS PaisBasica,		
		tci.ID_CARRERAS_POR_INSTITUCION IdCarreraInstitucion,
		tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE IdCarreraInstitucionDetalle,
		mc.ID_CARRERA IdCarrera,
		mc.NOMBRE_CARRERA ProgramaEstudio,
		mti.ID_TURNOS_POR_INSTITUCION IdTurnoInstitucion,
		se_turno.VALOR_ENUMERADO TurnoInstitucion,
		tehi.ID_SEMESTRE_ACADEMICO IdSemestreAcademico,
		se_semestre.VALOR_ENUMERADO SemestreAcademico,
		CASE WHEN EXISTS (SELECT TOP 1 ID_MATRICULA_ESTUDIANTE FROM transaccional.matricula_estudiante TME 
							WHERE TME.ID_ESTUDIANTE_INSTITUCION= tehi.ID_ESTUDIANTE_INSTITUCION AND TME.ES_ACTIVO=1) 
			THEN 1
			ELSE 0
			END			EsMatriculado, 
		CASE WHEN EXISTS (SELECT TOP 1 TC.ID_CONVALIDACION FROM transaccional.convalidacion TC 
							WHERE TC.ID_ESTUDIANTE_INSTITUCION= tehi.ID_ESTUDIANTE_INSTITUCION AND TC.ES_ACTIVO=1) 
			THEN 1
			ELSE 0
			END			EsConvalidado, 
		'PENDIENTE' Estado,
		tehi.ID_TIPO_ESTUDIANTE IdTipoEstudiante, 
		tci.ID_TIPO_ITINERARIO  IdTipoItinerario,
		pl.CODIGO_PERIODO_LECTIVO	PeriodoLectivo,
		plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	IdPeriodoLectivoInstitucion,
		ISNULL(pe.ID_PLAN_ESTUDIO, 0)				IdPlanEstudios, 
		pe.NOMBRE_PLAN_ESTUDIOS	+ ' (' + se_itin.VALOR_ENUMERADO	+ ')'					PlanEstudios,
		CASE	WHEN se_estado_ei.ID_ENUMERADO= @ESTADO_EN_TRASLADO OR se_estado_ei.ID_ENUMERADO= @ESTADO_TRASLADADO
					THEN se_estado_ei.VALOR_ENUMERADO		
				WHEN SUBCONSULTA_LICENCIAS.ID_LICENCIA_ESTUDIANTE  IS NOT NULL  AND SUBCONSULTA_LICENCIAS.ID_REINGRESO_ESTUDIANTE IS NULL 
					THEN 'LICENCIA '
				WHEN SUBCONSULTA_RESERVAS.ID_RESERVA_MATRICULA IS NOT NULL  AND SUBCONSULTA_RESERVAS.ID_REINGRESO_ESTUDIANTE IS NULL
					THEN 'RESERVA MATRICULA'
				WHEN conv.ID_CONVALIDACION IS NOT NULL
					THEN 'EN CONVALIDACION'
				ELSE 'REGULAR' END																	Condicion
		from transaccional.estudiante_institucion tehi
		inner join maestro.persona_institucion mpi on tehi.ID_PERSONA_INSTITUCION = mpi.ID_PERSONA_INSTITUCION AND tehi.ES_ACTIVO=1
		inner join maestro.persona mp on mpi.ID_PERSONA = mp.ID_PERSONA
		inner join sistema.enumerado se_tipo_doc on mp.ID_TIPO_DOCUMENTO = se_tipo_doc.ID_ENUMERADO
		inner join transaccional.carreras_por_institucion_detalle tcid ON tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE= tehi.ID_CARRERAS_POR_INSTITUCION_DETALLE
		AND tcid.ES_ACTIVO=1
		inner join [maestro].[sede_institucion] msi ON msi.ID_SEDE_INSTITUCION = tcid.ID_SEDE_INSTITUCION
		and msi.ES_ACTIVO=1
		inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION = tcid.ID_CARRERAS_POR_INSTITUCION AND tci.ES_ACTIVO=1		
		inner join db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA= tci.ID_CARRERA
		inner join [maestro].[turnos_por_institucion] mti on mti.ID_TURNOS_POR_INSTITUCION = tehi.ID_TURNOS_POR_INSTITUCION AND mti.ES_ACTIVO=1
		inner join [maestro].[turno_equivalencia] mte on mte.ID_TURNO_EQUIVALENCIA = mti.ID_TURNO_EQUIVALENCIA
		inner join sistema.enumerado se_turno on mte.ID_TURNO = se_turno.ID_ENUMERADO
		inner join transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  and plxi.ES_ACTIVO=1
		inner join maestro.periodo_lectivo pl on pl.ID_PERIODO_LECTIVO= plxi.ID_PERIODO_LECTIVO 
		LEFT JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = tehi.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO=1
		LEFT JOIN [maestro].[institucion_basica] mib on tehi.ID_INSTITUCION_BASICA = mib.ID_INSTITUCION_BASICA		--POR LA CARGA MASIVA, esto ya no es obligatorio
		LEFT JOIN db_auxiliar.dbo.UVW_PAIS PBAS ON CONVERT(INT,SUBSTRING(PBAS.CODIGO,1,5)) = mib.ID_PAIS --POR LA CARGA MASIVA, esto ya no es obligatorio
		INNER JOIN sistema.enumerado se_semestre on se_semestre.ID_ENUMERADO = tehi.ID_SEMESTRE_ACADEMICO		
		INNER JOIN sistema.enumerado se_itin on se_itin.ID_ENUMERADO= tci.ID_TIPO_ITINERARIO  
		INNER JOIN sistema.enumerado se_estado_ei on se_estado_ei.ID_ENUMERADO = tehi.ESTADO
		LEFT JOIN (	SELECT le.ID_LICENCIA_ESTUDIANTE, le.ID_ESTUDIANTE_INSTITUCION, re.ID_REINGRESO_ESTUDIANTE FROM transaccional.licencia_estudiante  le
					LEFT JOIN transaccional.reingreso_estudiante re on le.ID_LICENCIA_ESTUDIANTE = re.ID_LICENCIA_ESTUDIANTE AND re.ES_ACTIVO=1
					WHERE le.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND le.ES_ACTIVO=1
				) SUBCONSULTA_LICENCIAS ON SUBCONSULTA_LICENCIAS.ID_ESTUDIANTE_INSTITUCION = tehi.ID_ESTUDIANTE_INSTITUCION
		LEFT JOIN (	SELECT rm.ID_RESERVA_MATRICULA, rm.ID_ESTUDIANTE_INSTITUCION, re.ID_REINGRESO_ESTUDIANTE FROM transaccional.reserva_matricula  rm
					LEFT JOIN transaccional.reingreso_estudiante re on rm.ID_RESERVA_MATRICULA = re.ID_RESERVA_MATRICULA and re.ES_ACTIVO=1
					WHERE rm.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND rm.ES_ACTIVO=1
				) SUBCONSULTA_RESERVAS ON SUBCONSULTA_RESERVAS.ID_ESTUDIANTE_INSTITUCION =  tehi.ID_ESTUDIANTE_INSTITUCION
		LEFT JOIN transaccional.convalidacion conv on conv.ID_ESTUDIANTE_INSTITUCION = tehi.ID_ESTUDIANTE_INSTITUCION and conv.ES_ACTIVO=1 AND conv.ESTADO=@ESTADO_EN_CONVALIDACION
		LEFT JOIN db_auxiliar.dbo.UVW_UBIGEO_RENIEC UBI ON UBI.CODIGO_UBIGEO = mpi.UBIGEO_PERSONA
		LEFT JOIN db_auxiliar.dbo.UVW_PAIS PAIS ON CONVERT(INT,SUBSTRING(PAIS.CODIGO,1,5)) = mpi.PAIS_PERSONA --POR LA CARGA MASIVA, esto ya no es obligatorio
		left JOIN sistema.enumerado se_parentesco on tehi.ID_TIPO_PARENTESCO = se_parentesco.ID_ENUMERADO		
		WHERE 
		(mp.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO = 0)  		
		AND (mp.NUMERO_DOCUMENTO_PERSONA) LIKE '%' + @NUMERO_DOCUMENTO_PERSONA + '%' COLLATE LATIN1_GENERAL_CI_AI
		AND (mp.APELLIDO_PATERNO_PERSONA + ' '+ mp.APELLIDO_MATERNO_PERSONA + ', ' + mp.NOMBRE_PERSONA) LIKE '%'+ @ESTUDIANTE +'%' COLLATE LATIN1_GENERAL_CI_AI
		AND (msi.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION = 0)  				
		AND (tci.ID_CARRERA=@ID_CARRERA OR @ID_CARRERA=0 )
		AND (tci.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO OR @ID_TIPO_ITINERARIO=0)
		AND (mti.ID_TURNOS_POR_INSTITUCION = @ID_TURNOS_POR_INSTITUCION OR @ID_TURNOS_POR_INSTITUCION = 0)  	
		AND msi.ID_INSTITUCION = @ID_INSTITUCION	
		and (tehi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION OR @ID_PERIODO_LECTIVO_INSTITUCION= 0 or (@NUMERO_DOCUMENTO_PERSONA<>'' or @ESTUDIANTE<>''))
		AND (pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO OR @ID_PLAN_ESTUDIO = 0)
		AND (tehi.ID_ESTUDIANTE_INSTITUCION = @ID_ESTUDIANTE_INSTITUCION OR @ID_ESTUDIANTE_INSTITUCION = 0)
	)EST
)
SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) ORDER BY T.Row  
END
GO


