/************************************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Listado de postulante
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			26/12/2019		MALVA			SE AGREGA PARÁMETRO @EsReporte PARA CONSULTA DE REPORTE DE FICHA DE POSTULANTE
1.1			20/01/2020		MALVA			MODIFICACIÓN DE CONSULTA, SE UTILIZA UVW_CARRERA. 
2.0			09/08/2021		JCHAVEZ			Se modificó where ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO para optimizar la consulta
3.0			30/12/2021		JCHAVEZ			Opmitización de la consulta
3.1			15/05/2022		JCHAVEZ			Corrección en tabla temporal para mostrar datos en ficha de postulante

  TEST:		
	USP_ADMISION_SEL_POSTULANTES_PAGINADO 59,0,'','',0,0,0,0,0,0,1,1000,0,0
*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_POSTULANTES_PAGINADO]
(
	@ID_PROCESO_ADMISION_PERIODO			INT = 0,
	@ID_TIPO_DOCUMENTO						INT = 0,
	@NUMERO_DOCUMENTO_PERSONA				VARCHAR(16) ='',
	@POSTULANTE								VARCHAR(150) ='',
	@ID_SEDE_INSTITUCION					INT =0,
	@ID_CARRERAS_POR_INSTITUCION			INT =0,
	@ID_TURNOS_POR_INSTITUCION				INT =0,
	@ID_MODALIDADES_POR_PROCESO_ADMISION	INT =0,
	@ID_ESTADO_POSTULANTE					INT =0,
	@ID_EXAMEN_ADMISION_SEDE				INT =0,
	@Pagina									int = 1,
	@Registros								int = 1000, 
	@EsReporte								BIT = 0, 
	@ID_POSTULANTE_MODALIDAD				INT = 0
)AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
	SET @hasta = ( @Pagina * @Registros ) + 1;  

	DECLARE @postulantes_por_modalidad TABLE (	ID_POSTULANTES_POR_MODALIDAD ID, ID_MODALIDADES_POR_PROCESO_ADMISION ID, ID_TIPOS_MODALIDAD_POR_INSTITUCION ID,
												ID_EXAMEN_ADMISION_SEDE ID, ID_PERSONA_INSTITUCION ID, ID_INSTITUCION_BASICA ID, CODIGO_POSTULANTE CODIGO_LARGO,
												ANIO_EGRESO NUMERO_ENTERO, ID_TIPO_DOCUMENTO_APODERADO ID_ENUMERADO,NUMERO_DOCUMENTO_APODERADO CODIGO_LARGO,
												NOMBRE_APODERADO NOMBRE_CORTO, APELLIDO_APODERADO NOMBRE_LARGO, ID_TIPO_PARENTEZCO ID_ENUMERADO, ID_TIPO_PAGO ID_ENUMERADO,
												NUMERO_COMPROBANTE CODIGO_LARGO, MONTO_PAGO DECIMAL_DOS, MOTIVO_EXONERACION DESCRIPCION,ESTADO ESTADO,
												ARCHIVO_FOTO varchar(50), ARCHIVO_RUTA varchar(255), ARCHIVO_COMPROBANTE varchar(50), ARCHIVO_COMPROBANTE_RUTA varchar(255))

	INSERT INTO @postulantes_por_modalidad
	SELECT ID_POSTULANTES_POR_MODALIDAD,ppm.ID_MODALIDADES_POR_PROCESO_ADMISION,ID_TIPOS_MODALIDAD_POR_INSTITUCION,ID_EXAMEN_ADMISION_SEDE,ID_PERSONA_INSTITUCION,
	ID_INSTITUCION_BASICA,	CODIGO_POSTULANTE,ANIO_EGRESO,ID_TIPO_DOCUMENTO_APODERADO,NUMERO_DOCUMENTO_APODERADO,NOMBRE_APODERADO,APELLIDO_APODERADO,
	ID_TIPO_PARENTEZCO,ID_TIPO_PAGO,NUMERO_COMPROBANTE,	MONTO_PAGO,MOTIVO_EXONERACION,ppm.ESTADO,ARCHIVO_FOTO,ARCHIVO_RUTA,ARCHIVO_COMPROBANTE,ARCHIVO_COMPROBANTE_RUTA
	FROM transaccional.postulantes_por_modalidad ppm
	INNER JOIN transaccional.modalidades_por_proceso_admision mppa ON ppm.ID_MODALIDADES_POR_PROCESO_ADMISION=mppa.ID_MODALIDADES_POR_PROCESO_ADMISION
	WHERE (mppa.ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO OR ppm.ID_POSTULANTES_POR_MODALIDAD=@ID_POSTULANTE_MODALIDAD) AND ppm.ES_ACTIVO = 1 AND mppa.ES_ACTIVO = 1

	BEGIN
		WITH tempPaginado AS
		(
			SELECT 
				C.ID_PERSONA																				IdPersona,
				B.ID_PERSONA_INSTITUCION																	IdPersonaInstitucion,
				A.ID_POSTULANTES_POR_MODALIDAD																IdPostulanteModalidad,

				C.ID_TIPO_DOCUMENTO																			IdTipoDocumento,
				D.VALOR_ENUMERADO																			TipoDocumento,
				C.NUMERO_DOCUMENTO_PERSONA																	NumeroDocumento,			
				UPPER(C.NOMBRE_PERSONA)																		Nombre,
				UPPER(C.APELLIDO_PATERNO_PERSONA)															ApellidoPaterno,
				UPPER(C.APELLIDO_MATERNO_PERSONA)															ApellidoMaterno,
				C.SEXO_PERSONA																				IdSexo,
				C1.VALOR_ENUMERADO																			Sexo,
				B.ESTADO_CIVIL																				IdEstadoCivil,
				C.FECHA_NACIMIENTO_PERSONA																	FechaNacimiento,
				C.ES_DISCAPACITADO																			EsDiscapacitado,
				B.ID_TIPO_DISCAPACIDAD																		IdTipoDiscapacidad,
				C.ID_LENGUA_MATERNA																			IdLenguaMaterna,
				C.PAIS_NACIMIENTO																			IdPaisNacimiento,
				C.UBIGEO_NACIMIENTO																			UbigeoNacimiento,
				A.ID_TIPO_DOCUMENTO_APODERADO																IdTipoDocumentoApoderado,
				A.NUMERO_DOCUMENTO_APODERADO																NumeroDocumentoApoderado,
				A.NOMBRE_APODERADO																			NombreApoderado,
				A.APELLIDO_APODERADO																		ApellidosApoderado,
				A.ID_TIPO_PARENTEZCO																		IdTipoParentezco,
				A.NOMBRE_APODERADO + ' ' + A.APELLIDO_APODERADO												Apoderado,
				se_parentesco.VALOR_ENUMERADO																Parentesco,

				B.PAIS_PERSONA																				IdPaisResidencia,
				B.UBIGEO_PERSONA																			UbigeoResidencia,
				B.DIRECCION_PERSONA																			Direccion,
				B.CORREO																					Correo,
				B.TELEFONO																					Telefono,
				B.CELULAR																					Celular,			

				A.ID_INSTITUCION_BASICA																		IdInstitucionBasica,
				INS.ID_TIPO_INSTITUCION_BASICA																IdTipoIEBasica,
				INS.CODIGO_MODULAR_IE_BASICA																CodigoModularBasica,
				--A.CODIGO_ESTUDIANTE																			CodigoEstudiante,
				--A.CODIGO_POSTULANTE,
				A.ANIO_EGRESO																				AnioEgreso,
				INS.NOMBRE_IE_BASICA																		NombreIeBasica,
				INS.ID_NIVEL_IE_BASICA																		IdNivelBasica,
				INS.ID_TIPO_GESTION_IE_BASICA																IdTipoGestionBasica,																										
				INS.ID_PAIS																					IdPaisBasica,
				INS.UBIGEO_IE_BASICA																		UbigeoBasica,
				INS.DIRECCION_IE_BASICA																		DireccionBasica,
			
				A.ARCHIVO_FOTO																				ArchivoFoto,
				CASE WHEN @EsReporte = 1 THEN A.ARCHIVO_RUTA ELSE '' end								    ArchivoRuta,
				A.ID_MODALIDADES_POR_PROCESO_ADMISION														IdModalidadProcesoAdmision,
				A.ID_TIPOS_MODALIDAD_POR_INSTITUCION														IdTipoModalidadInstitucion,
				A.ID_EXAMEN_ADMISION_SEDE																	IdExamenAdmisionSede,
				--(SELECT dbo.UFN_CONCAT_opcion_postulante(A.ID_POSTULANTES_POR_MODALIDAD))					OpcionPostulante,
				--(SELECT dbo.UFN_CONCAT_opcion_postulante_Xregistro(A.ID_POSTULANTES_POR_MODALIDAD)) 		OpcionPostulanteXRegistro,
				A.ID_TIPO_PAGO																				IdTipoPago,
				A.NUMERO_COMPROBANTE																		NumeroComprobante,
				A.MONTO_PAGO																				MontoPago,
				A.MOTIVO_EXONERACION																		MotivoExoneracion,

				C.APELLIDO_PATERNO_PERSONA + ' '+ C.APELLIDO_MATERNO_PERSONA + ', ' + C.NOMBRE_PERSONA		Postulante,
				E8.ID_SEDE_INSTITUCION																		IdSedeInstitucion,
				E8.NOMBRE_SEDE																				SedeInstitucion,
				ci.ID_CARRERAS_POR_INSTITUCION																IdCarreraInstitucion,
				vc.NOMBRE_CARRERA																			CareraInstitucion,
				E5.ID_TURNOS_POR_INSTITUCION																IdTurnoInstitucion,
				E7.VALOR_ENUMERADO																			TurnoInstitucion,
			
				H.VALOR_ENUMERADO																			Modalidad,
				A.ESTADO																					IdEstadoPostulante,
				I.VALOR_ENUMERADO																			EstadoPostulante,

				--UPPER(B.DIRECCION_PERSONA) + 
				--		(CASE WHEN UBI.CODIGO_UBIGEO IS NOT NULL 
				--		THEN 
				--			', ' + UBI.DISTRITO_UBIGEO + ' - ' + UBI.PROVINCIA_UBIGEO + ' - ' + UBI.DEPARTAMENTO_UBIGEO + ' - '					
				--			ELSE 
				--			', '
				--		END ) + PAIS.DSCPAIS																	DireccionCompleta,
				UPPER(B.DIRECCION_PERSONA) + 
				ISNULL((SELECT ', ' + UBI.DISTRITO_UBIGEO + ' - ' + UBI.PROVINCIA_UBIGEO + ' - ' + UBI.DEPARTAMENTO_UBIGEO FROM db_auxiliar.dbo.UVW_UBIGEO_RENIEC UBI WHERE UBI.CODIGO_UBIGEO = B.UBIGEO_PERSONA),'') +
				', ' + PAIS.DSCPAIS																			DireccionCompleta,
				PBAS.DSCPAIS	PaisBasica,
				TM.NOMBRE_TIPO_MODALIDAD TipoModalidad,
				convert(varchar(20),EAS.FECHA_EVALUACION, 103) + ' ' + 	EAS.HORA_EVALUACION					Evaluacion,
				--pa.ID_PERSONA																				IdPersonaApoderado,
				0 IdPersonaApoderado,
				--(SELECT ID_PERSONA FROM maestro.persona WHERE NUMERO_DOCUMENTO_PERSONA = A.NUMERO_DOCUMENTO_APODERADO and ID_TIPO_DOCUMENTO=A.ID_TIPO_DOCUMENTO_APODERADO) IdPersonaApoderado,
				sede_eval.NOMBRE_SEDE																		SedeEvaluacion,
				PAP.NOMBRE_PROCESO_ADMISION																	NombreProcesoAdmision,
				MINS.NOMBRE_INSTITUCION																		NombreInstituto,
				--ROW_NUMBER() OVER ( ORDER BY A.ID_POSTULANTES_POR_MODALIDAD) AS Row,
				ROW_NUMBER() OVER ( ORDER BY C.APELLIDO_PATERNO_PERSONA,C.APELLIDO_MATERNO_PERSONA,C.NOMBRE_PERSONA ) AS Row,
				Total = count(1) OVER ()
				--INTO #postulantes_por_modalidad_final
			FROM 
				--transaccional.postulantes_por_modalidad A
				@postulantes_por_modalidad A
				INNER JOIN maestro.tipos_modalidad_por_institucion TMXI  (NOLOCK) ON TMXI.ID_TIPOS_MODALIDAD_POR_INSTITUCION = A.ID_TIPOS_MODALIDAD_POR_INSTITUCION
				INNER JOIN maestro.tipo_modalidad TM ON TM.ID_TIPO_MODALIDAD = TMXI.ID_TIPO_MODALIDAD
				INNER JOIN maestro.institucion_basica INS ON INS.ID_INSTITUCION_BASICA = A.ID_INSTITUCION_BASICA
				INNER JOIN db_auxiliar.dbo.UVW_PAIS PBAS ON CONVERT(INT,SUBSTRING(PBAS.CODIGO,1,5)) = INS.ID_PAIS
				INNER JOIN maestro.persona_institucion B ON B.ID_PERSONA_INSTITUCION = A.ID_PERSONA_INSTITUCION
				--LEFT JOIN db_auxiliar.dbo.UVW_UBIGEO_RENIEC UBI ON UBI.CODIGO_UBIGEO = B.UBIGEO_PERSONA
				INNER JOIN db_auxiliar.dbo.UVW_PAIS PAIS ON CONVERT(INT,SUBSTRING(PAIS.CODIGO,1,5)) = B.PAIS_PERSONA
				INNER JOIN maestro.persona C ON C.ID_PERSONA = B.ID_PERSONA
				INNER JOIN sistema.enumerado C1 ON C.SEXO_PERSONA =C1.ID_ENUMERADO
				INNER JOIN sistema.enumerado D ON D.ID_ENUMERADO = C.ID_TIPO_DOCUMENTO
			
				/*INNER JOIN (SELECT
								E1.ID_POSTULANTES_POR_MODALIDAD,
								E1.ID_OPCIONES_POR_POSTULANTE,
								--E4.ID_CARRERAS_POR_INSTITUCION,
								ci.ID_CARRERAS_POR_INSTITUCION,
								vc.NOMBRE_CARRERA,
								E3.ID_TURNOS_POR_INSTITUCION,
								E2.ID_SEDE_INSTITUCION,
								E8.NOMBRE_SEDE,
								E7.VALOR_ENUMERADO
							FROM 
								transaccional.opciones_por_postulante E1
								INNER JOIN transaccional.meta_carrera_institucion_detalle E2 ON E2.ID_META_CARRERA_INSTITUCION_DETALLE = E1.ID_META_CARRERA_INSTITUCION_DETALLE AND E2.ES_ACTIVO = 1
								INNER JOIN transaccional.meta_carrera_institucion E3 ON E3.ID_META_CARRERA_INSTITUCION = E2.ID_META_CARRERA_INSTITUCION AND E3.ES_ACTIVO = 1
								INNER JOIN transaccional.carreras_por_institucion ci (NOLOCK) ON ci.ID_CARRERAS_POR_INSTITUCION = E3.ID_CARRERAS_POR_INSTITUCION and ci.ES_ACTIVO=1
								INNER JOIN db_auxiliar.dbo.UVW_CARRERA vc on vc.ID_CARRERA = ci.ID_CARRERA
								--INNER JOIN UVW_CARRERA E4 ON E4.ID_CARRERAS_POR_INSTITUCION = E3.ID_CARRERAS_POR_INSTITUCION
								INNER JOIN maestro.turnos_por_institucion E5 ON E5.ID_TURNOS_POR_INSTITUCION = E3.ID_TURNOS_POR_INSTITUCION AND E5.ES_ACTIVO = 1
								INNER JOIN maestro.turno_equivalencia E6 ON E6.ID_TURNO_EQUIVALENCIA = E5.ID_TURNO_EQUIVALENCIA
								INNER JOIN sistema.enumerado E7 ON E7.ID_ENUMERADO = E6.ID_TURNO
								INNER JOIN maestro.sede_institucion E8 ON E8.ID_SEDE_INSTITUCION = E2.ID_SEDE_INSTITUCION
							WHERE E1.ORDEN = 1 AND E1.ES_ACTIVO=1) E
					ON E.ID_POSTULANTES_POR_MODALIDAD = A.ID_POSTULANTES_POR_MODALIDAD*/
				INNER JOIN transaccional.opciones_por_postulante E1 ON E1.ID_POSTULANTES_POR_MODALIDAD =A.ID_POSTULANTES_POR_MODALIDAD AND E1.ES_ACTIVO=1 AND  E1.ORDEN = 1
				INNER JOIN transaccional.meta_carrera_institucion_detalle E2 ON E2.ID_META_CARRERA_INSTITUCION_DETALLE = E1.ID_META_CARRERA_INSTITUCION_DETALLE AND E2.ES_ACTIVO = 1
				INNER JOIN transaccional.meta_carrera_institucion E3 ON E3.ID_META_CARRERA_INSTITUCION = E2.ID_META_CARRERA_INSTITUCION AND E3.ES_ACTIVO = 1
				INNER JOIN transaccional.carreras_por_institucion ci (NOLOCK) ON ci.ID_CARRERAS_POR_INSTITUCION = E3.ID_CARRERAS_POR_INSTITUCION and ci.ES_ACTIVO=1
				INNER JOIN db_auxiliar.dbo.UVW_CARRERA vc on vc.ID_CARRERA = ci.ID_CARRERA
				--INNER JOIN UVW_CARRERA E4 ON E4.ID_CARRERAS_POR_INSTITUCION = E3.ID_CARRERAS_POR_INSTITUCION
				INNER JOIN maestro.turnos_por_institucion E5 ON E5.ID_TURNOS_POR_INSTITUCION = E3.ID_TURNOS_POR_INSTITUCION AND E5.ES_ACTIVO = 1
				INNER JOIN maestro.turno_equivalencia E6 ON E6.ID_TURNO_EQUIVALENCIA = E5.ID_TURNO_EQUIVALENCIA
				INNER JOIN sistema.enumerado E7 ON E7.ID_ENUMERADO = E6.ID_TURNO
				INNER JOIN maestro.sede_institucion E8 ON E8.ID_SEDE_INSTITUCION = E2.ID_SEDE_INSTITUCION

				INNER JOIN transaccional.modalidades_por_proceso_admision F  (NOLOCK) ON F.ID_MODALIDADES_POR_PROCESO_ADMISION = A.ID_MODALIDADES_POR_PROCESO_ADMISION	
				INNER JOIN sistema.enumerado H ON H.ID_ENUMERADO = F.ID_MODALIDAD
				INNER JOIN sistema.enumerado I ON I.ID_ENUMERADO = A.ESTADO
				INNER JOIN transaccional.examen_admision_sede EAS  (NOLOCK) ON EAS.ID_EXAMEN_ADMISION_SEDE= A.ID_EXAMEN_ADMISION_SEDE AND EAS.ES_ACTIVO=1  --??
				INNER JOIN maestro.sede_institucion sede_eval	  ON sede_eval.ID_SEDE_INSTITUCION= EAS.ID_SEDE_INSTITUCION and sede_eval.ES_ACTIVO=1
				INNER JOIN transaccional.proceso_admision_periodo PAP  (NOLOCK) ON PAP.ID_PROCESO_ADMISION_PERIODO= F.ID_PROCESO_ADMISION_PERIODO AND PAP.ES_ACTIVO=1			
				INNER JOIN transaccional.periodos_lectivos_por_institucion PLXI ON PLXI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= PAP.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND PAP.ES_ACTIVO=1 
				--INNER JOIN maestro.institucion MINS ON MINS.ID_INSTITUCION= PLXI.ID_INSTITUCION 
				INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION MINS ON MINS.ID_INSTITUCION = PLXI.ID_INSTITUCION
				LEFT JOIN sistema.enumerado se_parentesco on A.ID_TIPO_PARENTEZCO = se_parentesco.ID_ENUMERADO
				--LEFT JOIN maestro.persona pa on pa.NUMERO_DOCUMENTO_PERSONA = A.NUMERO_DOCUMENTO_APODERADO and pa.ID_TIPO_DOCUMENTO=A.ID_TIPO_DOCUMENTO_APODERADO			
			
			WHERE
				--(F.ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO OR @ID_PROCESO_ADMISION_PERIODO = 0)
				--F.ID_PROCESO_ADMISION_PERIODO = @ID_PROCESO_ADMISION_PERIODO
				--AND A.ES_ACTIVO = 1
				/*AND*/ (C.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO = 0)
				AND (C.NUMERO_DOCUMENTO_PERSONA) LIKE '%' + @NUMERO_DOCUMENTO_PERSONA + '%' COLLATE LATIN1_GENERAL_CI_AI
				AND (C.APELLIDO_PATERNO_PERSONA + ' '+ C.APELLIDO_MATERNO_PERSONA + ', ' + C.NOMBRE_PERSONA) LIKE '%'+ @POSTULANTE +'%' COLLATE LATIN1_GENERAL_CI_AI
				AND (E8.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION = 0)
				AND (ci.ID_CARRERA = @ID_CARRERAS_POR_INSTITUCION OR @ID_CARRERAS_POR_INSTITUCION = 0)
				AND (E5.ID_TURNOS_POR_INSTITUCION = @ID_TURNOS_POR_INSTITUCION OR @ID_TURNOS_POR_INSTITUCION = 0)
				AND (A.ID_MODALIDADES_POR_PROCESO_ADMISION = @ID_MODALIDADES_POR_PROCESO_ADMISION OR @ID_MODALIDADES_POR_PROCESO_ADMISION = 0)
				AND (A.ESTADO = @ID_ESTADO_POSTULANTE OR @ID_ESTADO_POSTULANTE = 0)
				AND (EAS.ID_EXAMEN_ADMISION_SEDE= @ID_EXAMEN_ADMISION_SEDE OR @ID_EXAMEN_ADMISION_SEDE = 0)
				AND (A.ID_POSTULANTES_POR_MODALIDAD = @ID_POSTULANTE_MODALIDAD OR @ID_POSTULANTE_MODALIDAD =0)
		)
		SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
		END
	--SELECT * FROM #postulantes_por_modalidad_final T WHERE ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 

	--DROP TABLE #postulantes_por_modalidad
	--DROP TABLE #postulantes_por_modalidad_final 
END
GO


