/********************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Obtiene la programación de matrícula vigente
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  1.1		 08/06/2020		MALVA			SE AGREGA PARÁMETRO @ID_MATRICULA_ESTUDIANTE
--  TEST:			
/*
	USP_MATRICULA_SEL_PROGRAMACION_MATRICULA_VIGENTE 308,185,86000
*/
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_PROGRAMACION_MATRICULA_VIGENTE]
(
	@ID_PERIODO_LECTIVO_INSTITUCION INT,	
	@ID_TIPO_MATRICULA				INT = 0,
	@ID_MATRICULA_ESTUDIANTE		INT =0
)
AS  
BEGIN

	SET NOCOUNT ON;  
	DECLARE @FECHA_ACTUAL DATE
	SET @FECHA_ACTUAL = cast(getdate() as date )

	DECLARE @ID_PROGRAMACION_MATRICULA INT
	SET @ID_PROGRAMACION_MATRICULA = (SELECT ID_PROGRAMACION_MATRICULA 
	FROM transaccional.matricula_estudiante WHERE ID_MATRICULA_ESTUDIANTE = @ID_MATRICULA_ESTUDIANTE AND ES_ACTIVO=1)

	SELECT  
		PM.ID_PROGRAMACION_MATRICULA	IdProgramacionMatricula, 
		PM.ID_TIPO_MATRICULA			IdTipoMatricula, 
		SE.VALOR_ENUMERADO				TipoMatricula,
		PM.FECHA_INICIO					FechaInicio,
		PM.FECHA_FIN					FechaFin		
	FROM	
		transaccional.programacion_matricula PM
		INNER JOIN	sistema.enumerado SE ON PM.ID_TIPO_MATRICULA = SE.ID_ENUMERADO
	WHERE	
		ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION
		AND (( @FECHA_ACTUAL>=FECHA_INICIO AND @FECHA_ACTUAL<= FECHA_FIN AND @ID_MATRICULA_ESTUDIANTE=0)
		OR (@ID_MATRICULA_ESTUDIANTE > 0 AND PM.ID_PROGRAMACION_MATRICULA = @ID_PROGRAMACION_MATRICULA))
		AND (PM.ID_TIPO_MATRICULA = @ID_TIPO_MATRICULA OR @ID_TIPO_MATRICULA=0)
		AND ES_ACTIVO=1
END

--**************************************************
--7. USP_MATRICULA_SEL_ESTUDIANTE_PAGINADO.sql
GO


