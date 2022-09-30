/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	13/09/2021
LLAMADO POR			:
DESCRIPCION			:	Obtiene información detallada de personal de una institución en un periodo lectivo. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			13/09/2021		JCHAVEZ			CREACIÓN
TEST:			
	EXEC USP_REPORTE_MONITOREO_PERSONAL 3938
**********************************************************************************************************/
CREATE PROCEDURE dbo.USP_REPORTE_MONITOREO_PERSONAL
 @ID_PERIODO_LECTIVO_INSTITUCION INT
AS
BEGIN
	SELECT plectivo.CODIGO_PERIODO_LECTIVO,i.NOMBRE_DEPARTAMENTO,i.NOMBRE_PROVINCIA,i.NOMBRE_DISTRITO,i.NOMBRE_INSTITUCION, i.CODIGO_MODULAR, i.TIPO_GESTION_NOMBRE,
		enutd.VALOR_ENUMERADO TIPO_DOCUMENTO,p.NUMERO_DOCUMENTO_PERSONA, p.APELLIDO_PATERNO_PERSONA, p.APELLIDO_MATERNO_PERSONA , 
		p.NOMBRE_PERSONA,pins.CELULAR, pins.CORREO, enu.VALOR_ENUMERADO TIPO_PERSONAL,CONVERT(VARCHAR(10),plins.FECHA_CREACION,103) FECHA_CREACION, enucl.VALOR_ENUMERADO CONDICION_LABORAL
	FROM maestro.persona p 
		INNER JOIN maestro.persona_institucion pins ON p.ID_PERSONA = pins.ID_PERSONA AND pins.ESTADO=1
		INNER JOIN maestro.personal_institucion plins ON pins.ID_PERSONA_INSTITUCION = plins.ID_PERSONA_INSTITUCION AND plins.ES_ACTIVO=1 AND plins.ESTADO = 1
		INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON plins.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
		INNER JOIN maestro.periodo_lectivo plectivo ON plxi.ID_PERIODO_LECTIVO = plectivo.ID_PERIODO_LECTIVO 
		INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION i ON pins.ID_INSTITUCION = i.ID_INSTITUCION 
		INNER JOIN sistema.enumerado enu ON plins.ID_ROL = enu.ID_ENUMERADO
		INNER JOIN sistema.enumerado enutd ON p.ID_TIPO_DOCUMENTO = enutd.ID_ENUMERADO
		INNER JOIN sistema.enumerado enucl ON plins.CONDICION_LABORAL = enucl.ID_ENUMERADO
	WHERE plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
	ORDER BY plectivo.CODIGO_PERIODO_LECTIVO,i.NOMBRE_DEPARTAMENTO,i.NOMBRE_PROVINCIA,i.NOMBRE_DISTRITO,
		i.NOMBRE_INSTITUCION, i.CODIGO_MODULAR,p.APELLIDO_PATERNO_PERSONA,p.APELLIDO_MATERNO_PERSONA,p.NOMBRE_PERSONA
END