/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Lista las unidades didácticas registradas a traves de la carga masiva de nómina 
						para descargar la plantilla de actas
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2021		JCHAVEZ			CREACIÓN
--  TEST:	
	EXEC [USP_EVALUACION_SEL_CARGA_MASIVA_ACTAS_UNIDAD_DIDACTICA] 2945,'2016-I','PRINCIPAL',1349,'PLAN 2016',111,13,105
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_CARGA_MASIVA_ACTAS_UNIDAD_DIDACTICA]
(
	@ID_INSTITUCION			INT,
	@NOMBRE_PERIODO_LECTIVO	VARCHAR(50),
	@NOMBRE_SEDE			VARCHAR(150),
	@ID_CARRERA				INT,
	@NOMBRE_PLAN_ESTUDIO	VARCHAR(150),
	@ID_SEMESTRE_ACADEMICO	INT,
	@ID_TURNO				INT,
	@ID_SECCION				INT
)
AS
BEGIN
	BEGIN	
		SELECT DISTINCT
			NombreUnidadDidactica = UPPER(cmnd.NOMBRE_UNIDAD_DIDACTICA) 	
		FROM transaccional.carga_masiva_nominas cmn
			INNER JOIN transaccional.carga_masiva_nominas_detalle cmnd ON cmnd.ID_CARGA_MASIVA_NOMINA = cmn.ID_CARGA_MASIVA_NOMINA
		WHERE cmn.ES_ACTIVO = 1 AND cmnd.ES_ACTIVO = 1
			AND cmn.ID_INSTITUCION = @ID_INSTITUCION
			AND cmn.NOMBRE_PERIODO_LECTIVO = @NOMBRE_PERIODO_LECTIVO
			AND cmn.NOMBRE_SEDE_INSTITUCION = @NOMBRE_SEDE
			AND cmn.ID_CARRERA = @ID_CARRERA	 
			AND cmn.NOMBRE_PLAN_ESTUDIO = @NOMBRE_PLAN_ESTUDIO
			AND cmn.ID_SEMESTRE_ACADEMICO = @ID_SEMESTRE_ACADEMICO
			AND cmn.ID_TURNO = @ID_TURNO
			AND cmn.ID_SECCION = @ID_SECCION
		ORDER BY UPPER(cmnd.NOMBRE_UNIDAD_DIDACTICA)
	END
END