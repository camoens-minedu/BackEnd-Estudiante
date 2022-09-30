CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_LISTA_DOCENTE_UNIDAD_DIDACTICA_ALUMNOS_POR_DOCENTE](
	@ID_INSTITUCION							INT, 
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT, 
	@ID_SEDE_INSTITUCION					INT, 	 
	@DOCUMENTO_DOCENTE		                VARCHAR(20),
	@ID_CARRERA								INT, 
	@ID_UNIDAD_DIDACTICA					INT, 
	@ID_PERIODO_ACADEMICO					INT,
	@ID_TURNOS_POR_INSTITUCION				INT, 
	@ID_SECCION								INT,	 
	@ID_SEMESTRE_ACADEMICO					INT,
	@CIERRE_PROGRAMACION					INT,
	@TIPO_CONSULTA							CHAR(1),
	@ID_PROGRAMACION_CLASE					INT =0,	 	
	@ID_TIPO_ITINERARIO						INT,
	@ID_PLAN_ESTUDIO						INT, 
	@Pagina									INT	=1, 
	@Registros								INT	=10 
)
AS  
BEGIN  
	SET NOCOUNT ON;
	DECLARE @ID_PERSONAL_INSTITUCION INT

	
	IF @DOCUMENTO_DOCENTE = '0'
		BEGIN
		SET @ID_PERSONAL_INSTITUCION=0
		END
	ELSE
		BEGIN
			SET @ID_PERSONAL_INSTITUCION = (
				SELECT TOP 1 ID_PERSONAL_INSTITUCION
				FROM maestro.persona A
				INNER JOIN maestro.persona_institucion	B ON A.ID_PERSONA= B.ID_PERSONA AND A.ESTADO=1 AND B.ESTADO= 1
				INNER JOIN maestro.personal_institucion C ON B.ID_PERSONA_INSTITUCION=C.ID_PERSONA_INSTITUCION AND C.ES_ACTIVO=1
				WHERE 
				C.ID_ROL= 49 AND
				A.NUMERO_DOCUMENTO_PERSONA =  @DOCUMENTO_DOCENTE AND 
				ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	
			)			
		END
	
	EXEC dbo.USP_EVALUACION_SEL_LISTA_DOCENTE_UNIDAD_DIDACTICA
		@ID_INSTITUCION,
		@ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
		@ID_SEDE_INSTITUCION,
		@ID_PERSONAL_INSTITUCION,
		@ID_CARRERA,
		@ID_UNIDAD_DIDACTICA,
		@ID_PERIODO_ACADEMICO,
		@ID_TURNOS_POR_INSTITUCION,		
		@ID_SECCION,
		@ID_SEMESTRE_ACADEMICO,
		@CIERRE_PROGRAMACION,
		@TIPO_CONSULTA,
		@ID_PROGRAMACION_CLASE,
		@ID_TIPO_ITINERARIO, 
		@ID_PLAN_ESTUDIO,
		@Pagina,
		@Registros
END


--/************************************************************************************************************************************
--AUTOR				:	Mayra Alva
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Consulta programaciones de clase registradas
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		USP_PLANIFICACION_SEL_PROGRAMACION_CLASE_PAGINADO 394,1082,0, 0,0,0,674,0,0,111,0, 1,10
--/*
--	1.0			07/01/2020		MALVA          MODIFICACIÓN SE AGREGA FILTRO @ID_PLAN_ESTUDIO.
--*/
--*************************************************************************************************************************************/
GO


