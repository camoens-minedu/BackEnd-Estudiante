/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina un registro de la persona de una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		31/01/2020		MALVA           SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--  TEST:  
--			USP_MAESTROS_DEL_PERSONAL_INSTITUCION 1106, 1207, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_DEL_PERSONAL_INSTITUCION]
(
	@ID_INSTITUCION				INT, 
	@ID_PERSONAL_INSTITUCION	INT,
	@USUARIO					VARCHAR(20)
		
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0
	DECLARE @ID_PERIODOS_LECTIVOS_POR_INSTITUCION1 INT

	SELECT	@ID_INSTITUCION_CONSULTA = plinstitucion.ID_INSTITUCION, 
			@ID_PERIODOS_LECTIVOS_POR_INSTITUCION1 = plinstitucion.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	FROM maestro.personal_institucion pinstituto INNER JOIN transaccional.periodos_lectivos_por_institucion plinstitucion
	ON pinstituto.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plinstitucion.ID_PERIODOS_LECTIVOS_POR_INSTITUCION  
	WHERE ID_PERSONAL_INSTITUCION=@ID_PERSONAL_INSTITUCION

	IF @ID_INSTITUCION <>  @ID_INSTITUCION_CONSULTA
			SET @RESULT = -362
	ELSE IF EXISTS (select TOP 1 ID_COMISION_PROCESO_ADMISION from transaccional.comision_proceso_admision where ID_PERSONAL_INSTITUCION = @ID_PERSONAL_INSTITUCION AND ES_ACTIVO=1)
			OR EXISTS( select TOP 1 ID_EVALUADOR_ADMISION_MODALIDAD from transaccional.evaluador_admision_modalidad where ID_PERSONAL_INSTITUCION  = @ID_PERSONAL_INSTITUCION AND ES_ACTIVO=1)
			OR EXISTS (SELECT TOP 1 ID_PROGRAMACION_CLASE FROM transaccional.programacion_clase where ID_PERSONAL_INSTITUCION=@ID_PERSONAL_INSTITUCION AND
			ID_PERIODO_ACADEMICO IN (SELECT ID_PERIODO_ACADEMICO FROM transaccional.periodo_academico WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION1)
			AND ID_SEDE_INSTITUCION IN (SELECT sinstitutcion.ID_SEDE_INSTITUCION FROM maestro.sede_institucion sinstitutcion INNER JOIN transaccional.periodos_lectivos_por_institucion pinstitucion
			ON sinstitutcion.ID_INSTITUCION = pinstitucion.ID_INSTITUCION
			WHERE pinstitucion.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION1))
			SET @RESULT = -162
	ELSE
	BEGIN
		UPDATE maestro.personal_institucion
		SET ES_ACTIVO = 0,
			USUARIO_MODIFICACION = @USUARIO,
			FECHA_MODIFICACION = GETDATE()
		WHERE ID_PERSONAL_INSTITUCION = @ID_PERSONAL_INSTITUCION

		SET @RESULT = @ID_PERSONAL_INSTITUCION
	END
	SELECT @RESULT 
END
GO


