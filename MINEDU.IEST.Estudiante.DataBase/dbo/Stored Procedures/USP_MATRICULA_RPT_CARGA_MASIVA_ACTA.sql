/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Obtiene los datos de la cabecera que se muestran en el reporte de nómina por carga masiva
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2021		JCHAVEZ			Creación

TEST:			
	EXEC USP_MATRICULA_RPT_CARGA_MASIVA_ACTA 2,2945
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_RPT_CARGA_MASIVA_ACTA]
(	
	@ID_CARGA_MASIVA_ACTA INT,
	@ID_INSTITUCION INT
)
AS
BEGIN
	SELECT  
		CMN.NOMBRE_PERIODO_LECTIVO,
		MI.NOMBRE_DEPARTAMENTO DRE_GRE,
		MI.NOMBRE_DEPARTAMENTO,
		MI.NOMBRE_PROVINCIA,
		MI.NOMBRE_DISTRITO,
		CMN.NOMBRE_SEDE_INSTITUCION,
		MI.DIRECCION,
		MI.CENTRO_POBLADO,
		MI.NOMBRE_INSTITUCION,
		MI.CODIGO_MODULAR,
		MI.TIPO_GESTION_NOMBRE,
		C.NOMBRE_CARRERA + ' - ' + C.NIVEL_FORMACION CARRERA,
		CMN.NOMBRE_PLAN_ESTUDIO,
		ENU_SA.VALOR_ENUMERADO CICLO,
		ENU_TU.VALOR_ENUMERADO TURNO,
		ENU_SE.VALOR_ENUMERADO SECCION
	FROM 
		transaccional.carga_masiva_nominas CMN
		INNER JOIN transaccional.carga_masiva_actas CMA ON CMA.ID_CARGA_MASIVA_NOMINA = CMN.ID_CARGA_MASIVA_NOMINA
		INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION MI ON CMN.ID_INSTITUCION = MI.ID_INSTITUCION
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA C ON CMN.ID_CARRERA = C.ID_CARRERA
		INNER JOIN sistema.enumerado ENU_SA ON CMN.ID_SEMESTRE_ACADEMICO = ENU_SA.ID_ENUMERADO
		INNER JOIN sistema.enumerado ENU_TU ON CMN.ID_TURNO = ENU_TU.ID_ENUMERADO
		INNER JOIN sistema.enumerado ENU_SE ON CMN.ID_SECCION = ENU_SE.ID_ENUMERADO
	WHERE CMA.ID_CARGA_MASIVA_ACTA = @ID_CARGA_MASIVA_ACTA AND CMN.ID_INSTITUCION = @ID_INSTITUCION AND CMN.ES_ACTIVO = 1
END