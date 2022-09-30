/******************************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el listado de licencias.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			14/01/2020		MALVA			MODIFICACIÓN, SE OBTIENEN COLUMNAS PlanEstudios y TipoPlanEstudios.
--											SE AÑADEN FILTROS @ID_SEDE_INSTITUCION, @ID_CARRERA, @ID_TIPO_ITINERARIO, @ID_PLAN_ESTUDIO.
--											SE REEMPLAZA LAS COLUMNAS Nombres, Paterno, Materno por Estudiante.
1.1			12/05/2020		MALVA			LISTAR IdSedeInstitucion,IdCarrera,IdTipoPlanEstudios,IdPlanEstudios		
--  TEST:			
/*
	USP_TRANSACCIONAL_SEL_LICENCIA_ESTUDIANTES_PAGINADO 1106, 8561, 0,'',0, 0, 0,0, 0
*/
*********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_LICENCIA_ESTUDIANTES_PAGINADO]
(
    @ID_INSTITUCION INT='',
	@ID_PERIODOLECTIVO_INSTITUCION INT='',
	@ID_TIPO_DOCUMENTO INT='',
	@NRO_DOCUMENTO VARCHAR(15),
	@TIPOLICENCIA VARCHAR(10),
	@ID_SEDE_INSTITUCION				INT,
	@ID_CARRERA							INT,
	@ID_TIPO_ITINERARIO					INT,
	@ID_PLAN_ESTUDIO					INT,
	@Pagina						int		=1,
	@Registros					int		=10
)AS
BEGIN
SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;

	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 
    
	WITH    tempPaginado AS
	(
	SELECT
		lestu.ID_ESTUDIANTE_INSTITUCION                                                                IdEstudianteInstitucion,		
		lestu.ID_LICENCIA_ESTUDIANTE                                                                   IdLicenciaEstudiante,
		enu.ID_ENUMERADO                                                                               IdTipoDocumento,  
		enu.VALOR_ENUMERADO                                                                            TipoDocumento, 
		per.NUMERO_DOCUMENTO_PERSONA                                                                   NroDocumento,
		per.APELLIDO_PATERNO_PERSONA + ' ' 
		+ per.APELLIDO_MATERNO_PERSONA + ', ' 
		+ dbo.UFN_CAPITALIZAR(per.NOMBRE_PERSONA)													   Estudiante,
		sinsti.ID_SEDE_INSTITUCION																	   IdSedeInstitucion,
		sinsti.NOMBRE_SEDE                                                                             Sede,
		cinsti.ID_CARRERA																			   IdCarrera,
		carrera.NOMBRE_CARRERA                                                                         Programa,
		enume.VALOR_ENUMERADO                                                                          Ciclo,
		enumerado.ID_ENUMERADO                                                                         IdTipoLicencia,
		enumerado.VALOR_ENUMERADO                                                                      TipoLicencia,
		enumerados.ID_ENUMERADO                                                                        IdTiempoLicencia,
		enumerados.VALOR_ENUMERADO                                                                     TiempoLicencia,
		CONVERT (VARCHAR(10),  lestu.FECHA_INICIO, 103)                                                FechaInicioLicencia,
		lestu.ARCHIVO_RD                                                                               ArchivoRD,
		pe.ID_PLAN_ESTUDIO																			   IdPlanEstudios,
		pe.NOMBRE_PLAN_ESTUDIOS		+ ' (' + ti.VALOR_ENUMERADO + ')'								   PlanEstudios,
		cinsti.ID_TIPO_ITINERARIO																	   IdTipoPlanEstudios,
		ti.VALOR_ENUMERADO																			   TipoPlanEstudios,
		ROW_NUMBER() OVER ( ORDER BY lestu.ID_LICENCIA_ESTUDIANTE) AS Row,
		Total = COUNT(1) OVER ( )
		FROM maestro.persona per JOIN maestro.persona_institucion pinsti
		ON per.ID_PERSONA=pinsti.ID_PERSONA JOIN transaccional.estudiante_institucion einsti 
		ON pinsti.ID_PERSONA_INSTITUCION=einsti.ID_PERSONA_INSTITUCION and einsti.ES_ACTIVO=1 JOIN transaccional.licencia_estudiante lestu
		ON einsti.ID_ESTUDIANTE_INSTITUCION=lestu.ID_ESTUDIANTE_INSTITUCION and lestu.ES_ACTIVO=1  JOIN transaccional.carreras_por_institucion_detalle cinstidet
		ON einsti.ID_CARRERAS_POR_INSTITUCION_DETALLE=cinstidet.ID_CARRERAS_POR_INSTITUCION_DETALLE and cinstidet.ES_ACTIVO=1 JOIN transaccional.carreras_por_institucion cinsti
		ON cinstidet.ID_CARRERAS_POR_INSTITUCION=cinsti.ID_CARRERAS_POR_INSTITUCION and cinsti.ES_ACTIVO=1 JOIN maestro.sede_institucion sinsti
		ON cinstidet.ID_SEDE_INSTITUCION=sinsti.ID_SEDE_INSTITUCION and sinsti.ES_ACTIVO=1 JOIN db_auxiliar.dbo.UVW_CARRERA carrera
		ON cinsti.ID_CARRERA=carrera.ID_CARRERA JOIN sistema.enumerado enu
		ON per.ID_TIPO_DOCUMENTO=enu.ID_ENUMERADO JOIN sistema.enumerado enume
		ON einsti.ID_SEMESTRE_ACADEMICO=enume.ID_ENUMERADO JOIN sistema.enumerado enumerado
		ON lestu.ID_TIPO_LICENCIA=enumerado.ID_ENUMERADO JOIN sistema.enumerado enumerados
		ON lestu.ID_TIEMPO_PERIODO_LICENCIA=enumerados.ID_ENUMERADO
		INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = einsti.ID_PLAN_ESTUDIO and pe.ES_ACTIVO=1
		INNER JOIN sistema.enumerado ti ON ti.ID_ENUMERADO = pe.ID_TIPO_ITINERARIO 
		WHERE
				
		per.ID_TIPO_DOCUMENTO =	CASE WHEN @ID_TIPO_DOCUMENTO IS NULL	OR	LEN(@ID_TIPO_DOCUMENTO) = 0	OR @ID_TIPO_DOCUMENTO=0	OR @ID_TIPO_DOCUMENTO = ''	THEN per.ID_TIPO_DOCUMENTO	ELSE @ID_TIPO_DOCUMENTO	END AND
		per.NUMERO_DOCUMENTO_PERSONA= CASE WHEN @NRO_DOCUMENTO IS NULL	OR	LEN(@NRO_DOCUMENTO) = 0	OR @NRO_DOCUMENTO=0	OR @NRO_DOCUMENTO = ''	THEN per.NUMERO_DOCUMENTO_PERSONA	ELSE @NRO_DOCUMENTO	END AND
		lestu.ID_TIPO_LICENCIA= CASE WHEN @TIPOLICENCIA IS NULL	OR	LEN(@TIPOLICENCIA) = 0 OR @TIPOLICENCIA=0	OR @TIPOLICENCIA = ''	THEN lestu.ID_TIPO_LICENCIA	ELSE @TIPOLICENCIA	END AND
		lestu.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOLECTIVO_INSTITUCION AND pinsti.ID_INSTITUCION=@ID_INSTITUCION
		AND (@ID_SEDE_INSTITUCION = 0 OR cinstidet.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION)
		AND (@ID_CARRERA = 0 OR carrera.ID_CARRERA = @ID_CARRERA )
		AND (@ID_TIPO_ITINERARIO = 0 OR pe.ID_TIPO_ITINERARIO = @ID_TIPO_ITINERARIO)
		AND (@ID_PLAN_ESTUDIO =0 OR pe.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO)
	)
	SELECT  *
    FROM    tempPaginado T   WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END

--*******************************************************************************
--44. USP_TRANSACCIONAL_SEL_INGRESANTES.sql
GO


