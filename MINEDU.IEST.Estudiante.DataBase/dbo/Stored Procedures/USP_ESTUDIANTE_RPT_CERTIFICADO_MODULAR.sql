/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	31/01/2022
LLAMADO POR			:
DESCRIPCION			:	Obtiene los datos que se muestran en el reporte de certificado modular
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

TEST:			
	EXEC USP_ESTUDIANTE_RPT_CERTIFICADO_MODULAR 1911,137908,14
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ESTUDIANTE_RPT_CERTIFICADO_MODULAR]
(
	@ID_INSTITUCION INT,
	@ID_ESTUDIANTE_INSTITUCION INT,
	@ID_MODULO INT
)
AS
BEGIN
	DECLARE @DIRECTOR VARCHAR(MAX)

	SELECT TOP 1
		@DIRECTOR = (UPPER(p.APELLIDO_PATERNO_PERSONA) + ' '+ UPPER(p.APELLIDO_MATERNO_PERSONA)+ ', ' + p.NOMBRE_PERSONA)
	FROM maestro.persona p
	INNER JOIN maestro.persona_institucion pins ON pins.ID_PERSONA = p.ID_PERSONA
	INNER JOIN maestro.personal_institucion plins ON plins.ID_PERSONA_INSTITUCION = pins.ID_PERSONA_INSTITUCION
	WHERE pins.ID_INSTITUCION = @ID_INSTITUCION AND plins.ID_ROL = 47
	ORDER BY plins.ID_PERIODOS_LECTIVOS_POR_INSTITUCION DESC

	DECLARE @RUTA_FOTO VARCHAR(500) = (SELECT dbo.UFN_RUTA_BASE_ARCHIVOS() + 'ESTUDIANTES_FOTOS\')

	SELECT
		i.ID_INSTITUCION,
		i.TIPO_GESTION_NOMBRE,
		TIPO_INSTITUCION = (CASE i.TIPO_INSTITUCION
							 WHEN 10191 THEN 'INSTITUTO DE EDUCACIÓN SUPERIOR TECNOLÓGICO'
							 WHEN 10196 THEN 'INSTITUTO DE EDUCACIÓN SUPERIOR'
							 WHEN 10194 THEN 'ESCUELA SUPERIOR DE FORMACIÓN ARTÍSTICA'
							 ELSE i.TIPO_INSTITUCION_NOMBRE END),
		i.NOMBRE_INSTITUCION,
		i.NOMBRE_DISTRITO,
		p.NUMERO_DOCUMENTO_PERSONA,
		UPPER(p.APELLIDO_PATERNO_PERSONA) + ' '+ UPPER(p.APELLIDO_MATERNO_PERSONA)+ ', ' +  p.NOMBRE_PERSONA as ESTUDIANTE,	
		eins.ID_ESTUDIANTE_INSTITUCION,
		@RUTA_FOTO + eins.ARCHIVO_FOTO FOTO,
		c.NOMBRE_CARRERA,
		mequi.NOMBRE_MODULO,
		CAST(mequi.TOTHORAS AS INT) HORAS,
		CAST(mequi.TOTCREDITOS AS INT) CREDITOS,
		muc.NOMBRE_UNIDAD_COMPETENCIA,
		ilogro.NOMBRE_INDICADOR_LOGRO,
		@DIRECTOR DIRECTOR,
		(CAST(DAY(GETDATE()) AS NVARCHAR(2)) + ' de ' + 
		(SELECT RTRIM(mes.VALOR_ENUMERADO) FROM db_auxiliar.dbo.UVW_ENUMERADO mes WHERE NOMBRE_ENUMERADO='MES' AND mes.CODIGO_ENUMERADO= MONTH(GETDATE())) + ' del ' +
		CAST(YEAR(GETDATE()) AS NVARCHAR(4))) FECHA_ACTUAL
	FROM maestro.persona p 
		INNER JOIN maestro.persona_institucion pins ON p.ID_PERSONA = pins.ID_PERSONA 
		INNER JOIN transaccional.estudiante_institucion eins ON pins.ID_PERSONA_INSTITUCION = eins.ID_PERSONA_INSTITUCION AND eins.ES_ACTIVO = 1
		INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON pins.ID_INSTITUCION = i.ID_INSTITUCION 
		INNER JOIN transaccional.carreras_por_institucion_detalle cpdet ON eins.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpdet.ID_CARRERAS_POR_INSTITUCION_DETALLE AND cpdet.ES_ACTIVO = 1
		INNER JOIN transaccional.carreras_por_institucion ci ON cpdet.ID_CARRERAS_POR_INSTITUCION = ci.ID_CARRERAS_POR_INSTITUCION AND ci.ES_ACTIVO = 1
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON ci.ID_CARRERA = c.ID_CARRERA 
		INNER JOIN transaccional.modulo_equivalencia mequi ON eins.ID_PLAN_ESTUDIO = mequi.ID_PLAN_ESTUDIO AND mequi.ES_ACTIVO = 1
		LEFT JOIN transaccional.modulo_unidad_competencia muc ON mequi.ID_MODULO_EQUIVALENCIA = muc.ID_MODULO_EQUIVALENCIA AND muc.ES_ACTIVO = 1
		LEFT JOIN transaccional.indicadores_logro ilogro ON muc.ID_UNIDAD_COMPETENCIA = ilogro.ID_UNIDAD_COMPETENCIA AND ilogro.ES_ACTIVO = 1
	WHERE eins.ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION AND mequi.ID_MODULO_EQUIVALENCIA = @ID_MODULO 
END