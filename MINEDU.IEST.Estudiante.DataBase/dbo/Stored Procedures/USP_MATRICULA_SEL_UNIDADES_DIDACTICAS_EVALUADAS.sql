/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2018
LLAMADO POR			:
DESCRIPCION			:	Realizar promoción de alumnos en el periodo lectivo
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2018		JTOVAR			Creación
2.0			21/01/2022		JCHAVEZ			Optimización de proceso

TEST:
	USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_EVALUADAS 228855,4139
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_EVALUADAS]
(
	@ID_MATRICULA_ESTUDIANTE	          INT,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT

	--DECLARE @ID_MATRICULA_ESTUDIANTE	          INT=228848
	--DECLARE @ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT=4139
)AS
BEGIN

DECLARE  @CANT_UD_MATRICULADAS INT, @CANT_UD_EVALUADAS INT, @ESTADO INT

	SET @CANT_UD_MATRICULADAS = (SELECT 
								COUNT(*) FROM  transaccional.matricula_estudiante mestu 
								INNER JOIN transaccional.programacion_clase_por_matricula_estudiante pclaseMat
								ON mestu.ID_MATRICULA_ESTUDIANTE = pclaseMat.ID_MATRICULA_ESTUDIANTE 
								INNER JOIN transaccional.unidades_didacticas_por_programacion_clase udppclase
								ON pclaseMat.ID_PROGRAMACION_CLASE = udppclase.ID_PROGRAMACION_CLASE
								WHERE mestu.ID_MATRICULA_ESTUDIANTE = @ID_MATRICULA_ESTUDIANTE 
								AND mestu.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION
								AND mestu.ES_ACTIVO = 1 AND  pclaseMat.ES_ACTIVO = 1 AND udppclase.ES_ACTIVO = 1)

	SET @CANT_UD_EVALUADAS = (SELECT COUNT(*) FROM  transaccional.evaluacion_detalle edet
								WHERE edet.ID_MATRICULA_ESTUDIANTE = @ID_MATRICULA_ESTUDIANTE 
								AND edet.ES_ACTIVO = 1)


	IF @CANT_UD_MATRICULADAS = @CANT_UD_EVALUADAS
	BEGIN

		SET @ESTADO = 1

	END
	ELSE
	BEGIN
		SET @ESTADO = 0

	END
	
	SELECT @ESTADO EstadoFinal
END