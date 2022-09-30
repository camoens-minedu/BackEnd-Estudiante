/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtener lista de personal de una institucion para llenar grilla paginada
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
-- [dbo].[USP_MAESTROS_SEL_PERSONAL_INSTITUCION_PAGINADO] 620, 1
-- USP_MAESTROS_SEL_PERSONAL_INSTITUCION_PAGINADO 443,895, '','','','', 0, 0,49,0,0 ,0,0
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PERSONAL_INSTITUCION_PAGINADO]
(
	--@ID_SEDE_INSTITUCION		INT,
	@ID_INSTITUCION				INT,
	@ID_PERIODO_LECTIVO			INT,
	@APELLIDO_PATERNO_PERSONA	VARCHAR(30)='',
	@APELLIDO_MATERNO_PERSONA	VARCHAR(30)='',
	@NOMBRE_PERSONA				VARCHAR(30)='',
	@NUMERO_DOCUMENTO_PERSONA	VARCHAR(30)='',
	--@CARGO_PERSONA				int=0,
	@ESTADO						INT		=0,

	@ID_TIPO_DOCUMENTO			int		=0,
	@ID_ROL						int		=0,
	@ID_TIPO_PERSONAL			int		=0,
	@ID_TIPO_CONTRATO			int		=0,

	@Pagina						int		=1,
	@Registros					int		=10
 )
 AS
 BEGIN
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;

	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 
    
	WITH    tempPaginado AS
	(
		--select * from maestro.persona
		SELECT		
		PRLI.ES_ACTIVO AS ACTIVO,
			P.ID_PERSONA							AS IdPersona,
			PEI.ID_PERSONA_INSTITUCION				AS IdPersonaInstitucion,
			PRLI.ID_PERSONAL_INSTITUCION			AS IdPersonalInstitucion,
			
			P.NOMBRE_PERSONA						AS Nombre,
			P.APELLIDO_PATERNO_PERSONA				AS ApellidoPaterno,
			P.APELLIDO_MATERNO_PERSONA				AS ApellidoMaterno,
			--isnull(P.APELLIDO_PATERNO_PERSONA,'') + ' ' + isnull(P.APELLIDO_MATERNO_PERSONA,'') + ' '+			isnull(P.NOMBRE_PERSONA,'')				AS NombreCompleto,
			TD.ID_ENUMERADO							AS IdTipoDocumento,
			TD.VALOR_ENUMERADO						AS TipoDocumento,
			P.NUMERO_DOCUMENTO_PERSONA				AS NumeroDocumento,
			PRLI.ID_TIPO_PERSONAL					AS IdTipoPersonal,
			TP.VALOR_ENUMERADO						AS TipoPersonal,
			PRLI.ID_ROL								AS IdRol,
			ROL.VALOR_ENUMERADO						AS Rol,
			PRLI.CONDICION_LABORAL					AS IdCondicionLaboral,
			TC.VALOR_ENUMERADO						AS CondicionLaboral,
			PRLI.ESTADO								AS IdEstado,
			EP.VALOR_ENUMERADO						AS Estado,
			--PEI.CARGO_PERSONA						AS IdCargoPersonal,
			--TCAR.VALOR_ENUMERADO					AS CargoPersonal,
			P.FECHA_NACIMIENTO_PERSONA				AS FechaNacimiento,
			P.SEXO_PERSONA							AS IdSexo,
			PEI.ESTADO_CIVIL						AS IdEstadoCivil,
			P.PAIS_NACIMIENTO						AS IdPaisNacimiento,
			--UN.ID_UBIGEO_DEPARTAMENTO				AS IdUbigeoDepartamentoNacimiento,
			--UN.ID_UBIGEO_PROVINCIA					AS IdUbigeoProvinciaNacimiento,
			P.UBIGEO_NACIMIENTO						AS UbigeoNacimiento,

			PEI.PAIS_PERSONA						AS IdPaisResidencia,
			--UR.ID_UBIGEO_DEPARTAMENTO				AS IdUbigeoDepartamentoResidencia,
			--UR.ID_UBIGEO_PROVINCIA					AS IdUbigeoProvinciaResidencia,
			PEI.UBIGEO_PERSONA						AS UbigeoResidencia,
			PEI.DIRECCION_PERSONA					AS Direccion,
			PEI.CORREO								AS Correo,
			PEI.TELEFONO							AS Telefono,			
			PEI.CELULAR								AS Celular,
			PEI.CELULAR2							AS Celular2,

			PEI.ID_GRADO_PROFESIONAL				AS IdGradoAcademico,
			PEI.TITULO_PROFESIONAL					AS TituloProfesional,	
			PEI.ID_CARRERA_PROFESIONAL				AS IdCarreraProfesional,
			CP.NOMBRE_CARRERA_PROFESIONAL			AS CarreraProfesional,
			PEI.ID_INSTITUCION						AS IdInstitucion,
			PEI.INSTITUCION_PROFESIONAL				AS InstitucionProfesional,
			PEI.ANIO_INICIO							AS AnioInicio,
			PEI.ANIO_FIN							AS AnioFin,		
			
			PRLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AS IdPeriodoLectivoInstitucion,
			ISNULL(PRLI.ID_PERMISO_PASSPORT,0)		AS IdPermisoPassport,
			ROW_NUMBER() OVER ( ORDER BY P.APELLIDO_PATERNO_PERSONA, P.APELLIDO_MATERNO_PERSONA, P.NOMBRE_PERSONA,ROL.VALOR_ENUMERADO,TC.VALOR_ENUMERADO) AS Row,
			
			Total = COUNT(1) OVER ( )
		FROM [maestro].[persona] P
		INNER JOIN maestro.persona_institucion PEI ON PEI.ID_PERSONA = P.ID_PERSONA
		INNER JOIN [maestro].[personal_institucion] PRLI ON (PEI.ID_PERSONA_INSTITUCION = PRLI.ID_PERSONA_INSTITUCION)
		INNER JOIN sistema.enumerado TD ON TD.ID_ENUMERADO = P.ID_TIPO_DOCUMENTO
		INNER JOIN maestro.carrera_profesional CP ON CP.ID_CARRERA_PROFESIONAL= PEI.ID_CARRERA_PROFESIONAL
		LEFT JOIN sistema.enumerado TP ON TP.ID_ENUMERADO = PRLI.ID_TIPO_PERSONAL
		LEFT JOIN sistema.enumerado ROL ON ROL.ID_ENUMERADO = PRLI.ID_ROL
		LEFT JOIN sistema.enumerado TC ON TC.ID_ENUMERADO = PRLI.CONDICION_LABORAL
		LEFT JOIN sistema.enumerado EP ON EP.ID_ENUMERADO = PRLI.ESTADO
		--LEFT JOIN sistema.enumerado TCAR ON TCAR.ID_ENUMERADO = PEI.CARGO_PERSONA
		LEFT JOIN db_auxiliar.dbo.UVW_UBIGEO_RENIEC UN	ON UN.CODIGO_UBIGEO = P.UBIGEO_NACIMIENTO
		LEFT JOIN db_auxiliar.dbo.UVW_UBIGEO_RENIEC UR	ON UR.CODIGO_UBIGEO = PEI.UBIGEO_PERSONA
		WHERE 
		--PEI.ID_SEDE_INSTITUCION IN (SELECT ID_SEDE_INSTITUCION FROM maestro.sede_institucion WHERE ID_INSTITUCION = @ID_INSTITUCION)
		PEI.ID_INSTITUCION = @ID_INSTITUCION 
		AND P.NOMBRE_PERSONA LIKE '%' + ISNULL(@NOMBRE_PERSONA,'') + '%' COLLATE LATIN1_GENERAL_CI_AI
		AND APELLIDO_PATERNO_PERSONA LIKE '%' + ISNULL(@APELLIDO_PATERNO_PERSONA,'') + '%' COLLATE LATIN1_GENERAL_CI_AI
		AND APELLIDO_MATERNO_PERSONA LIKE '%' + ISNULL(@APELLIDO_MATERNO_PERSONA,'') + '%' COLLATE LATIN1_GENERAL_CI_AI
		AND NUMERO_DOCUMENTO_PERSONA LIKE '%' + ISNULL(@NUMERO_DOCUMENTO_PERSONA,'') + '%' COLLATE LATIN1_GENERAL_CI_AI
		AND (PRLI.ESTADO = @ESTADO OR @ESTADO = 0)
		AND (@ID_TIPO_DOCUMENTO	= P.ID_TIPO_DOCUMENTO OR @ID_TIPO_DOCUMENTO = 0)
		AND (@ID_ROL = PRLI.ID_ROL OR (@ID_ROL = 0 AND ID_ROL <> 49))
		AND (@ID_TIPO_PERSONAL = PRLI.ID_TIPO_PERSONAL OR @ID_TIPO_PERSONAL = 0)
		AND (@ID_TIPO_CONTRATO = PRLI.CONDICION_LABORAL OR @ID_TIPO_CONTRATO = 0)
		
	    --AND (CARGO_PERSONA=@CARGO_PERSONA or @CARGO_PERSONA=0)
		--AND (PEI.ES_ACTIVO = Case @ESTADO When -1 Then PEI.ES_ACTIVO Else @ESTADO End)
		AND PRLI.ES_ACTIVO=1
		--AND PRLI.ID_ROL NOT IN (176,175)
		AND (PRLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO OR PRLI.ID_ROL = 46)	
	)

	SELECT  *
    FROM    tempPaginado T
    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
    
END

-- [USP_MAESTROS_SEL_PERSONAL_INSTITUCION_PAGINADO] 697,1261
GO


