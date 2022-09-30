/******************************************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta programación de matrícula.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

TEST:			
	1.0			21/11/2019		MALVA          MODIFICACIÓN PARA VALIDAR SI ES QUE EL PERIODO DE CLASES O ALGUNA DE LAS CLASES SE HAN CERRADO. 
	1.1			10/01/2020		MALVA		   SE AGREGA VALIDACIÓN POR SI EL REGISTRO YA EXISTE EN EL SISTEMA (@RESULT = -180)
******************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_INS_PROGRAMACION_MATRICULA]
(
	@ID_PERIODO_LECTIVO_INSTITUCION INT,
	@ID_TIPO_MATRICULA	 INT,
	@FECHA_INICIO DATETIME,
	@FECHA_FIN	DATETIME,
	@USUARIO	VARCHAR(20)
)
AS
BEGIN
	DECLARE @RESULT INT
	IF (EXISTS (SELECT TOP 1 ID_PROGRAMACION_MATRICULA FROM transaccional.programacion_matricula WHERE ID_TIPO_MATRICULA= @ID_TIPO_MATRICULA AND ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION AND ES_ACTIVO=1))
		SET @RESULT = -180	
	ELSE IF EXISTS ( SELECT  TOP 1 eva.ID_EVALUACION 
			FROM transaccional.matricula_estudiante me INNER JOIN transaccional.evaluacion_detalle edet 
			ON me.ID_MATRICULA_ESTUDIANTE = edet.ID_MATRICULA_ESTUDIANTE INNER JOIN transaccional.evaluacion eva
			ON edet.ID_EVALUACION = eva.ID_EVALUACION
			INNER JOIN transaccional.programacion_clase_por_matricula_estudiante pcme on pcme.ID_MATRICULA_ESTUDIANTE = me.ID_MATRICULA_ESTUDIANTE and pcme.ES_ACTIVO=1
			INNER JOIN transaccional.programacion_clase pc on pc.ID_PROGRAMACION_CLASE = pcme.ID_PROGRAMACION_CLASE and pc.ES_ACTIVO=1 and pc.ESTADO=0 --No cerrado
			WHERE me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION and me.ES_ACTIVO=1 and edet.ES_ACTIVO=1
		)
			SET @RESULT = -332 --No puede realizar registro, ya que el periodo de clases se encuentra cerrado.
	--ELSE IF EXISTS( SELECT TOP 1 eva.ID_EVALUACION FROM transaccional.matricula_estudiante me INNER JOIN transaccional.evaluacion_detalle edet 
	--					ON me.ID_MATRICULA_ESTUDIANTE = edet.ID_MATRICULA_ESTUDIANTE INNER JOIN transaccional.evaluacion eva
	--					ON edet.ID_EVALUACION = eva.ID_EVALUACION WHERE me.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND eva.CIERRE_PROGRAMACION = 235 
	--					and me.ES_ACTIVO=1 and edet.ES_ACTIVO=1 and eva.ES_ACTIVO=1)
	--		SET @RESULT = -344 --No puede realizar registro, ya que se tienen clases cerradas.
	ELSE
	BEGIN
			INSERT INTO transaccional.programacion_matricula (ID_PERIODOS_LECTIVOS_POR_INSTITUCION, ID_TIPO_MATRICULA, FECHA_INICIO, FECHA_FIN, ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION)
			VALUES 
				(
				 @ID_PERIODO_LECTIVO_INSTITUCION,
				 @ID_TIPO_MATRICULA,
				 @FECHA_INICIO,
				 @FECHA_FIN,
				 1,
				 1,
				 @USUARIO,
				 GETDATE()
				)

		SET @RESULT= CONVERT(INT,@@IDENTITY)
	END
	SELECT @RESULT
END
GO


