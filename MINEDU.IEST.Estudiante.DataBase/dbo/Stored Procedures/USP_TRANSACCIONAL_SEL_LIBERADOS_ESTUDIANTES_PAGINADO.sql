/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Lista el registro de liberados de la institución.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		MALVA			CREACIÓN
1.1			07/02/2022		JCHAVEZ			SE AGREGÓ CAMPOS IdCarrera e IdSedeInstitucion

TEST:		
	USP_TRANSACCIONAL_SEL_LIBERADOS_ESTUDIANTES_PAGINADO 3937,0,'',1,10
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_LIBERADOS_ESTUDIANTES_PAGINADO]
(
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
	    einstitucion.ID_ESTUDIANTE_INSTITUCION, 
		einstitucion.ID_ESTUDIANTE_INSTITUCION							IdEstudianteInstitucion, 
		lestudiante.ID_LIBERACION_ESTUDIANTE							IdLiberacionEstudiante,
		enu.ID_ENUMERADO                                                IdTipoDocumento,
		enu.VALOR_ENUMERADO                                             TipoDocumento,
		persona.NUMERO_DOCUMENTO_PERSONA                                NroDocumento,
		persona.APELLIDO_PATERNO_PERSONA                                Paterno,
		persona.APELLIDO_MATERNO_PERSONA                                Materno,
		persona.NOMBRE_PERSONA                                          Nombres,
		UPPER(persona.APELLIDO_PATERNO_PERSONA) + ' ' +  UPPER(persona.APELLIDO_MATERNO_PERSONA)  + ', ' +  dbo.UFN_CAPITALIZAR(persona.NOMBRE_PERSONA) Estudiante,
		carrera.ID_CARRERA												IdCarrera,
		carrera.NOMBRE_CARRERA                                          Programa,
		sinstitucion.ID_SEDE_INSTITUCION                                IdSede,
		sinstitucion.ID_SEDE_INSTITUCION                                IdSedeInstitucion,
		sinstitucion.NOMBRE_SEDE                                        Sede,
		enumerado.VALOR_ENUMERADO									    Ciclo,
		--ISNULL(enumerado.VALOR_ENUMERADO,
		--		(select VALOR_ENUMERADO from sistema.enumerado 
		--		where ID_ENUMERADO =einstitucion.ID_SEMESTRE_ACADEMICO)
		--)																 Ciclo,
		lestudiante.NRO_RD                                               Nro_RD,
		lestudiante.ARCHIVO_RD                                           Archivo_RD,
		--mestu.ID_MATRICULA_ESTUDIANTE                                    IdMatriculaEstudiante,
		se_tipoitin.VALOR_ENUMERADO										TipoPlanEstudios,
		pestudio.ID_PLAN_ESTUDIO                                        IdPlanEstudio,
		pestudio.NOMBRE_PLAN_ESTUDIOS                                   PlanEstudio,
		ROW_NUMBER() OVER ( ORDER BY lestudiante.ID_LIBERACION_ESTUDIANTE) AS Row,
	    Total = COUNT(1) OVER ( )
		FROM maestro.persona persona 
		INNER JOIN maestro.persona_institucion pinstitucion ON persona.ID_PERSONA = pinstitucion.ID_PERSONA 
		INNER JOIN transaccional.estudiante_institucion einstitucion ON pinstitucion.ID_PERSONA_INSTITUCION = einstitucion.ID_PERSONA_INSTITUCION 
		INNER JOIN transaccional.liberacion_estudiante lestudiante ON einstitucion.ID_ESTUDIANTE_INSTITUCION = lestudiante.ID_ESTUDIANTE_INSTITUCION AND lestudiante.ES_ACTIVO=1
		INNER JOIN transaccional.carreras_por_institucion_detalle cpidet ON einstitucion.ID_CARRERAS_POR_INSTITUCION_DETALLE = cpidet.ID_CARRERAS_POR_INSTITUCION_DETALLE 
		INNER JOIN transaccional.carreras_por_institucion cpins ON cpidet.ID_CARRERAS_POR_INSTITUCION = cpins.ID_CARRERAS_POR_INSTITUCION INNER JOIN db_auxiliar.dbo.UVW_CARRERA carrera ON cpins.ID_CARRERA = carrera.ID_CARRERA 
		INNER JOIN maestro.sede_institucion sinstitucion ON sinstitucion.ID_SEDE_INSTITUCION= cpidet.ID_SEDE_INSTITUCION AND sinstitucion.ES_ACTIVO=1
		INNER JOIN sistema.enumerado enu 	ON persona.ID_TIPO_DOCUMENTO = enu.ID_ENUMERADO 
		INNER JOIN sistema.enumerado se_tipoitin ON se_tipoitin.ID_ENUMERADO= cpins.ID_TIPO_ITINERARIO
		INNER JOIN sistema.enumerado enumerado ON einstitucion.ID_SEMESTRE_ACADEMICO = enumerado.ID_ENUMERADO
		INNER JOIN transaccional.plan_estudio pestudio ON cpins.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION
		--LEFT JOIN  (SELECT mestu.ID_ESTUDIANTE_INSTITUCION, MAX(mestu.ID_SEMESTRE_ACADEMICO) ULT_SEMESTRE_ACADEMICO FROM transaccional.matricula_estudiante mestu		
		--				group by mestu.ID_ESTUDIANTE_INSTITUCION
		--			)A on A.ID_ESTUDIANTE_INSTITUCION =einstitucion.ID_ESTUDIANTE_INSTITUCION 
		WHERE 
		(persona.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO or @ID_TIPO_DOCUMENTO=0)
		AND (persona.NUMERO_DOCUMENTO_PERSONA = @NRO_DOCUMENTO or @NRO_DOCUMENTO ='')	
		AND lestudiante.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION
		AND einstitucion.ES_ACTIVO=1 AND lestudiante.ES_ACTIVO=1 AND cpidet.ES_ACTIVO=1 AND cpins.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1

	)
	SELECT  *
    FROM    tempPaginado T   WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END
GO


