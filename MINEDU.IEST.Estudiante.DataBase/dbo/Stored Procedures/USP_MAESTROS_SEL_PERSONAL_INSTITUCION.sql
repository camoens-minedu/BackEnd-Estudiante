/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtener personal docente de una institucion para un periodo lectivo 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			Creación
1.1			04/03/2021		JCHAVEZ			Modificación, se agregó NumeroDocumento
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PERSONAL_INSTITUCION]
(
	@ID_INSTITUCION						INT,
	@ID_TIPO_DOCUMENTO					INT,
	@NUMERO_DOCUMENTO					VARCHAR(15),
	@ID_PERIODO_LECTIVO_INSTITUCION		INT
)
AS

SELECT
		P.ID_PERSONA								IdPersona,
		ISNULL(PEI.ID_PERSONA_INSTITUCION,0)		IdPersonaInstitucion,
		P.NUMERO_DOCUMENTO_PERSONA					NumeroDocumento,
		P.APELLIDO_PATERNO_PERSONA					ApellidoPaterno,
		P.APELLIDO_MATERNO_PERSONA					ApellidoMaterno,
		P.NOMBRE_PERSONA							Nombre,
		P.SEXO_PERSONA								IdSexo,
		PEI.ESTADO_CIVIL							IdEstadoCivil,
		P.FECHA_NACIMIENTO_PERSONA					FechaNacimiento,
		PEI.PAIS_PERSONA							IdPaisResidencia,
		URES.CODIGO_UBIGEO					        UbigeoResidencia,
		P.PAIS_NACIMIENTO							IdPaisNacimiento,
		UNAC.CODIGO_UBIGEO 					        UbigeoNacimiento,
		ISNULL(PINS.ID_PERSONAL_INSTITUCION,0)		IdPersonalInstitucion,
		PEI.DIRECCION_PERSONA						Direccion,
		PEI.CORREO									Correo,
		ISNULL(PEI.TELEFONO,'')						Telefono,
		ISNULL(PEI.CELULAR,'')						Celular,
		PEI.ID_GRADO_PROFESIONAL					IdGradoAcademico,
		ISNULL(PEI.TITULO_PROFESIONAL,'')			TituloProfesional,
		PEI.ID_CARRERA_PROFESIONAL					IdCarreraProfesional,
		ISNULL(PEI.INSTITUCION_PROFESIONAL,'')		InstitucionProfesional,
		PEI.ANIO_INICIO								AnioInicio,
		PEI.ANIO_FIN								AnioFin,
		PINS.ID_ROL									IdRol,
		CP.NOMBRE_CARRERA_PROFESIONAL				CarreraProfesional,
		PEI.ID_INSTITUCION							IdInstitucion
FROM
		maestro.persona P
		LEFT JOIN maestro.persona_institucion PEI ON PEI.ID_PERSONA = P.ID_PERSONA AND PEI.ID_INSTITUCION = @ID_INSTITUCION
		LEFT JOIN db_auxiliar.dbo.UVW_UBIGEO_RENIEC URES ON URES.CODIGO_UBIGEO = PEI.UBIGEO_PERSONA
		LEFT JOIN db_auxiliar.dbo.UVW_UBIGEO_RENIEC UNAC ON UNAC.CODIGO_UBIGEO = P.UBIGEO_NACIMIENTO
		LEFT JOIN maestro.personal_institucion PINS ON PEI.ID_PERSONA_INSTITUCION = PINS.ID_PERSONA_INSTITUCION AND PINS.ES_ACTIVO = 1 AND PINS.ID_ROL=49 --SOLO OBTENGO DE DOCENTE	
		AND PINS.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
		LEFT JOIN maestro.carrera_profesional CP ON CP.ID_CARRERA_PROFESIONAL= PEI.ID_CARRERA_PROFESIONAL AND CP.ESTADO=1
WHERE
		P.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO
		AND P.NUMERO_DOCUMENTO_PERSONA = @NUMERO_DOCUMENTO
GO


