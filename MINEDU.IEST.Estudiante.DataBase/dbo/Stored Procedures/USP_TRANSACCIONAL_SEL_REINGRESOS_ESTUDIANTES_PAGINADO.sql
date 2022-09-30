CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_REINGRESOS_ESTUDIANTES_PAGINADO] 
(
    @ID_INSTITUCION INT,
	@ID_PERIODOLECTIVO_INSTITUCION INT,
	@ID_TIPO_DOCUMENTO INT,
	@NRO_DOCUMENTO VARCHAR(15),
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
	TRE.ID_REINGRESO_ESTUDIANTE										 IdReingresoEstudiante,
	persona.ID_TIPO_DOCUMENTO                                        IdTipoDocumento,
	enumerado.VALOR_ENUMERADO                                        TipoDocumento,
	persona.NUMERO_DOCUMENTO_PERSONA                                 NumeroDocumento,
	persona.NOMBRE_PERSONA                                           Nombres,
	persona.APELLIDO_PATERNO_PERSONA                                 Paterno,
	persona.APELLIDO_MATERNO_PERSONA                                 Materno,
	persona.APELLIDO_PATERNO_PERSONA + ' ' 
		+ persona.APELLIDO_MATERNO_PERSONA + ', ' 
		+ dbo.UFN_CAPITALIZAR(persona.NOMBRE_PERSONA)				 Estudiante,
	carrera.NOMBRE_CARRERA											 Programa,
	enu.VALOR_ENUMERADO                                              Ciclo,
	sinsti.NOMBRE_SEDE                                               Sede,
	CASE WHEN TRM.ID_RESERVA_MATRICULA IS NOT NULL 	THEN TRM.ID_MOTIVO_RESERVA
	WHEN TLE.ID_TIPO_LICENCIA IS NOT NULL THEN TLE.ID_TIPO_LICENCIA 
	ELSE 0
	END																	IdTipoLicencia,
	CASE WHEN TRM.ID_RESERVA_MATRICULA IS NOT NULL 	THEN  'RESERVA MATRICULA ' + (SELECT VALOR_ENUMERADO FROM sistema.enumerado WHERE ID_ENUMERADO= TRM.ID_MOTIVO_RESERVA)
	WHEN TLE.ID_TIPO_LICENCIA IS NOT NULL THEN 'LICENCIA ' + (SELECT VALOR_ENUMERADO FROM sistema.enumerado WHERE ID_ENUMERADO= TLE.ID_TIPO_LICENCIA)
	ELSE ''
	END																	TipoLicencia,

	TRE.TIEMPO_LICENCIA                                            TiempoLicencia,
	CONVERT (VARCHAR(10),  TRE.FECHA_FIN, 103)                     FechaReingreso,
	ti.VALOR_ENUMERADO											   TipoPlanEstudios,
	pe.NOMBRE_PLAN_ESTUDIOS										   PlanEstudios, 
	ROW_NUMBER() OVER ( ORDER BY persona.APELLIDO_PATERNO_PERSONA, persona.APELLIDO_MATERNO_PERSONA, persona.NOMBRE_PERSONA) AS Row,
	Total = COUNT(1) OVER ( )

	FROM maestro.persona persona 
	JOIN maestro.persona_institucion pinsti ON persona.ID_PERSONA=pinsti.ID_PERSONA 
	JOIN transaccional.estudiante_institucion einsti ON pinsti.ID_PERSONA_INSTITUCION=einsti.ID_PERSONA_INSTITUCION AND einsti.ES_ACTIVO=1 
	JOIN transaccional.carreras_por_institucion_detalle cinstidet ON einsti.ID_CARRERAS_POR_INSTITUCION_DETALLE=cinstidet.ID_CARRERAS_POR_INSTITUCION_DETALLE AND cinstidet.ES_ACTIVO=1
	JOIN transaccional.carreras_por_institucion cinsti ON cinstidet.ID_CARRERAS_POR_INSTITUCION=cinsti.ID_CARRERAS_POR_INSTITUCION AND cinsti.ES_ACTIVO=1
	JOIN db_auxiliar.dbo.UVW_CARRERA carrera ON cinsti.ID_CARRERA=carrera.ID_CARRERA 	
	JOIN sistema.enumerado enu ON einsti.ID_SEMESTRE_ACADEMICO=enu.ID_ENUMERADO 	
	JOIN sistema.enumerado enumerado ON persona.ID_TIPO_DOCUMENTO=enumerado.ID_ENUMERADO 
	JOIN maestro.sede_institucion sinsti ON cinstidet.ID_SEDE_INSTITUCION=sinsti.ID_SEDE_INSTITUCION	
	LEFT JOIN transaccional.reserva_matricula TRM ON einsti.ID_ESTUDIANTE_INSTITUCION = TRM.ID_ESTUDIANTE_INSTITUCION AND TRM.ES_ACTIVO=1
	LEFT JOIN transaccional.licencia_estudiante TLE ON einsti.ID_ESTUDIANTE_INSTITUCION= TLE.ID_ESTUDIANTE_INSTITUCION AND TLE.ES_ACTIVO=1
	INNER JOIN transaccional.reingreso_estudiante TRE ON TRE.ID_RESERVA_MATRICULA= TRM.ID_RESERVA_MATRICULA OR TRE.ID_LICENCIA_ESTUDIANTE= TLE.ID_LICENCIA_ESTUDIANTE
	INNER JOIN transaccional.plan_estudio pe ON pe.ID_PLAN_ESTUDIO = einsti.ID_PLAN_ESTUDIO AND pe.ES_ACTIVO=1
	INNER JOIN sistema.enumerado ti ON ti.ID_ENUMERADO = pe.ID_TIPO_ITINERARIO
	WHERE 

	persona.ID_TIPO_DOCUMENTO =	CASE WHEN @ID_TIPO_DOCUMENTO IS NULL	OR	LEN(@ID_TIPO_DOCUMENTO) = 0	OR @ID_TIPO_DOCUMENTO=0	OR @ID_TIPO_DOCUMENTO = ''	THEN persona.ID_TIPO_DOCUMENTO	ELSE @ID_TIPO_DOCUMENTO	END AND
	persona.NUMERO_DOCUMENTO_PERSONA= CASE WHEN @NRO_DOCUMENTO IS NULL	OR	LEN(@NRO_DOCUMENTO) = 0	OR @NRO_DOCUMENTO=0	OR @NRO_DOCUMENTO = ''	THEN persona.NUMERO_DOCUMENTO_PERSONA	ELSE @NRO_DOCUMENTO	END AND
	TRE.ES_ACTIVO=1 AND TRE.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION AND pinsti.ID_INSTITUCION = @ID_INSTITUCION
				

	)
	SELECT  *
    FROM    tempPaginado T   WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END

/**********************************************************************************************************/
GO


