/********************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Retorna la lista de sesiones de la clase seleccionada.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			01/10/2018		JTOVAR          CREACIÓN
2.0			07/02/2022		JCHAVEZ			Se modificó a left join las tablas de personal_institucion para registros sin docente

  TEST:			
	USP_MATRICULA_SEL_PROGRAMACION_CLASE 1911,3882,112155
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_PROGRAMACION_CLASE]
(  
	@ID_INSTITUCION				INT,
	--@ID_SEDE_INSTITUCION		INT,
	@ID_PERIODO_ACADEMICO		INT,
	@ID_UNIDAD_DIDACTICA		INT 
	--@ID_PROGRAMA_ESTUDIOS		INT= 0,
	--@ID_SECCION					INT =0,
	--@ID_TURNO_POR_INSTITUCION	INT = 0,
	--@ID_PERSONAL_INSTITUCION	INT = 0,
	--@Pagina						int = 1,
	--@Registros					int = 10  
)  
AS 

BEGIN  
	SET NOCOUNT ON;  
	DECLARE	@IdProgramacionClase int, @IdUnidadDidactica int, @IdSedeInstitucion int, @Sede varchar(150), 
			--@IdPeriodoAcademico int, @PeriodoAcademico varchar(50), @IdSeccion int,
			@Seccion varchar(5), @Clase varchar(150),@Turno varchar(30),
			--@IdTurnoPorInstitucion int, @Turno varchar(150), @ProgramasEstudio VARCHAR(2000),
			@IdPersonalInstitucion int, 
			@Docente varchar(200), @Aulas VARCHAR(1000), @Horarios VARCHAR(3000), @Vacante int, @NroMatriculados INT, @VacantesDisp INT

	CREATE TABLE #ProgramacionClases
	(
		IdProgramacionClase int, 
		IdUnidadDidactica int, 
		IdSedeInstitucion int,
		SedeInstitucion varchar(150),
		--IdPeriodoAcademico int,
		--PeriodoAcademico varchar(50),
		--IdSeccion int,
		Seccion varchar(5),
		NombreClase varchar(150),
		-- IdTurnoPorInstitucion int,
		Turno varchar(30),
		--ProgramasEstudio VARCHAR(2000),
		IdPersonalInstitucion int, 
		Docente varchar(200),
		Aulas VARCHAR(1000),
		Horarios VARCHAR(3000),
		Vacante int,
		VacantesDisp INT
	)

	DECLARE programacion_cursor CURSOR FOR   
	SELECT distinct
		tpc.ID_PROGRAMACION_CLASE IdProgramacionClase, 
		tude.ID_UNIDAD_DIDACTICA IdUnidadDidactica, 
		tpc.ID_SEDE_INSTITUCION IdSedeInstitucion, 
		msi.NOMBRE_SEDE NombreSede, 
		se_seccion.VALOR_ENUMERADO Seccion,
		tud.NOMBRE_UNIDAD_DIDACTICA NombreClase,   --
		se_turno.VALOR_ENUMERADO Turno,
		tpc.ID_PERSONAL_INSTITUCION IdPersonalInstitucion,
		ISNULL((mp.APELLIDO_PATERNO_PERSONA + ' ' + mp.APELLIDO_MATERNO_PERSONA + ', ' + mp.NOMBRE_PERSONA),'SIN DOCENTE') Docente,
		tpc.VACANTE_CLASE Vacante
	FROM transaccional.unidades_didacticas_por_enfoque tude 
		inner join transaccional.unidades_didacticas_por_programacion_clase  tudpc on tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = tudpc.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE
		inner join transaccional.unidad_didactica tud on tud.ID_UNIDAD_DIDACTICA = tude.ID_UNIDAD_DIDACTICA
		INNER JOIN transaccional.programacion_clase tpc on tpc.ID_PROGRAMACION_CLASE= tudpc.ID_PROGRAMACION_CLASE
		inner join transaccional.sesion_programacion_clase tspc on tspc.ID_PROGRAMACION_CLASE = tudpc.ID_PROGRAMACION_CLASE
		INNER JOIN maestro.sede_institucion msi on msi.ID_SEDE_INSTITUCION = tpc.ID_SEDE_INSTITUCION
		inner join sistema.enumerado se_seccion on se_seccion.ID_ENUMERADO = tpc.ID_SECCION
		LEFT join maestro.personal_institucion mpli on mpli.ID_PERSONAL_INSTITUCION = tpc.ID_PERSONAL_INSTITUCION
		LEFT join maestro.persona_institucion mpi on mpi.ID_PERSONA_INSTITUCION =  mpli.ID_PERSONA_INSTITUCION
		LEFT join maestro.persona mp on mp.ID_PERSONA = mpi.ID_PERSONA
		inner join maestro.turnos_por_institucion mti on mti.ID_TURNOS_POR_INSTITUCION = tpc.ID_TURNOS_POR_INSTITUCION
		inner join maestro.turno_equivalencia mte on mte.ID_TURNO_EQUIVALENCIA = mti.ID_TURNO_EQUIVALENCIA
		INNER JOIN sistema.enumerado se_turno on se_turno.ID_ENUMERADO = mte.ID_TURNO
	WHERE tude.ID_UNIDAD_DIDACTICA=@ID_UNIDAD_DIDACTICA and tpc.ID_PERIODO_ACADEMICO =@ID_PERIODO_ACADEMICO 
	AND msi.ID_INSTITUCION=@ID_INSTITUCION and tudpc.ES_ACTIVO=1
	OPEN programacion_cursor  

	FETCH NEXT FROM programacion_cursor   
	INTO	@IdProgramacionClase, 
			@IdUnidadDidactica,
			@IdSedeInstitucion, @Sede,		--@IdPeriodoAcademico, @PeriodoAcademico, @IdSeccion,
			@Seccion,
			@Clase,
			@Turno,
			--@IdTurnoPorInstitucion, @Turno, 
			@IdPersonalInstitucion, @Docente, @Vacante

	WHILE @@FETCH_STATUS = 0  
	BEGIN   

		SELECT @Aulas= COALESCE(@Aulas + ', ', '')+  LTRIM(RTRIM(ma.NOMBRE_AULA)) from transaccional.sesion_programacion_clase tspc
		inner join maestro.aula ma on ma.ID_AULA= tspc.ID_AULA
		where ID_PROGRAMACION_CLASE =@IdProgramacionClase  AND tspc.ES_ACTIVO=1

		SELECT @Horarios= COALESCE(@Horarios+ ', ', '')+  se.VALOR_ENUMERADO  + ' ' + tspc.HORA_INICIO + ' - ' +tspc.HORA_FIN from transaccional.sesion_programacion_clase tspc
		inner join sistema.enumerado se on se.ID_ENUMERADO = tspc.DIA
		where ID_PROGRAMACION_CLASE =@IdProgramacionClase AND tspc.ES_ACTIVO=1

		--select @NroMatriculados =count(tme.ID_ESTUDIANTE_INSTITUCION)   from transaccional.programacion_clase tpc
		--INNER JOIN transaccional.programacion_clase_por_matricula_estudiante tpcme ON tpc.ID_PROGRAMACION_CLASE= tpcme.ID_PROGRAMACION_CLASE
		--INNER JOIN transaccional.matricula_estudiante tme on tme.ID_MATRICULA_ESTUDIANTE= tpcme.ID_MATRICULA_ESTUDIANTE
		--where tpc.ID_PROGRAMACION_CLASE=@IdProgramacionClase AND tpc.ES_ACTIVO=1 and tpcme.ES_ACTIVO=1 and tpc.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO
		--AND tme.ES_ACTIVO=1

		select @NroMatriculados= COUNT(tme.ID_ESTUDIANTE_INSTITUCION) from transaccional.matricula_estudiante tme
		INNER JOIN transaccional.programacion_clase_por_matricula_estudiante tpcme ON tme.ID_MATRICULA_ESTUDIANTE = tpcme.ID_MATRICULA_ESTUDIANTE
		where tpcme.ID_PROGRAMACION_CLASE=@IdProgramacionClase 	AND 
		tpcme.ES_ACTIVO=1 and tme.ID_PERIODO_ACADEMICO=@ID_PERIODO_ACADEMICO
		AND tme.ES_ACTIVO=1

		SET @VacantesDisp = @Vacante - @NroMatriculados

		INSERT INTO #ProgramacionClases
		SELECT  @IdProgramacionClase,
				@IdUnidadDidactica, 
				@IdSedeInstitucion, 
				@Sede,
				--@IdPeriodoAcademico, 
				--@PeriodoAcademico, 
				--@IdSeccion, 
				@Seccion,
				@Clase,
				@Turno,
				--@IdTurnoPorInstitucion, 
				--@Turno, 
				--@ProgramasEstudio,
				@IdPersonalInstitucion, 
				@Docente,
				@Aulas, 
				@Horarios,
				@Vacante,
				@VacantesDisp
		SET @Aulas = NULL
		SET @Horarios	=	NULL

		FETCH NEXT FROM programacion_cursor   
		INTO	@IdProgramacionClase, 	
				@IdUnidadDidactica, 
				@IdSedeInstitucion, @Sede,	
				@Seccion,		
				@Clase,
				@Turno,
				@IdPersonalInstitucion, @Docente, @Vacante
	END   
	CLOSE programacion_cursor;
	DEALLOCATE programacion_cursor; 

	 --DECLARE @desde INT , @hasta INT;  
	 --SET @desde = ( @Pagina - 1 ) * @Registros;  
	 --   SET @hasta = ( @Pagina * @Registros ) + 1;    
  
	 --WITH    tempPaginado AS  
	 --( 

	SELECT  IdProgramacionClase, 	
			IdUnidadDidactica,
			IdSedeInstitucion,			
			SedeInstitucion,
			Seccion,
			NombreClase,	
			Turno,
			IdPersonalInstitucion, 
			Docente,
			Aulas, 
			Horarios,
			Vacante,
			VacantesDisp,
			ROW_NUMBER() OVER ( ORDER BY Seccion) AS Row
	FROM	#ProgramacionClases
	--	)
	--SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
	DROP TABLE #ProgramacionClases;
END
GO


