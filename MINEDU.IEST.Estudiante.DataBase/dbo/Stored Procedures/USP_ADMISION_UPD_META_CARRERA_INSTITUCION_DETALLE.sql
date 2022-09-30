/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza el registro del detalle de una Meta por programa de estudio de una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			Creación
2.0			07/02/2022		JCHAVEZ			Se modificó la validación para permitir editar la meta siempre y cuando no sea menor a la utilizada

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_META_CARRERA_INSTITUCION_DETALLE]
(
	@ID_META_CARRERA_INSTITUCION_DETALLE	INT,	
	@META_PERIODO							INT,
	@ID_SEDE_INSTITUCION					INT,
	@USUARIO								VARCHAR(20)

	--DECLARE @ID_META_CARRERA_INSTITUCION_DETALLE	INT=114
	--DECLARE @META_PERIODO							INT=1
	--DECLARE @ID_SEDE_INSTITUCION					INT=1954
	--DECLARE @USUARIO								VARCHAR(20)='42122536'
)
AS
BEGIN
	DECLARE @ID_META_CARRERA_INSTITUCION INT
	DECLARE @ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT
	DECLARE @MODALIDAD_POR_PROCESO_ADMISION INT
	DECLARE @META_ALCANZADA_ACTUAL INT
	DECLARE @RESULT INT
	
	SELECT @ID_META_CARRERA_INSTITUCION = ID_META_CARRERA_INSTITUCION,
		@ID_PERIODOS_LECTIVOS_POR_INSTITUCION = ID_PERIODOS_LECTIVOS_POR_INSTITUCION,
		@META_ALCANZADA_ACTUAL = META_ALCANZADA 
	FROM transaccional.meta_carrera_institucion_detalle 
	WHERE ID_META_CARRERA_INSTITUCION_DETALLE = @ID_META_CARRERA_INSTITUCION_DETALLE
	
	--SET @MODALIDAD_POR_PROCESO_ADMISION = (SELECT TOP 1 mppadm.ID_MODALIDADES_POR_PROCESO_ADMISION FROM transaccional.proceso_admision_periodo pap INNER JOIN transaccional.modalidades_por_proceso_admision mppadm
	--										ON pap.ID_PROCESO_ADMISION_PERIODO = mppadm.ID_PROCESO_ADMISION_PERIODO INNER JOIN transaccional.examen_admision_sede easede
	--										ON pap.ID_PROCESO_ADMISION_PERIODO = easede.ID_PROCESO_ADMISION_PERIODO INNER JOIN transaccional.postulantes_por_modalidad ppmod
	--										ON easede.ID_EXAMEN_ADMISION_SEDE = ppmod.ID_EXAMEN_ADMISION_SEDE
	--										WHERE pap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND pap.ES_ACTIVO = 1 and mppadm.ES_ACTIVO =1 and mppadm.ESTADO = 97 
	--										and easede.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION)

	--IF	EXISTS (SELECT TOP 1 mppadm.ID_MODALIDADES_POR_PROCESO_ADMISION FROM transaccional.proceso_admision_periodo pap INNER JOIN transaccional.modalidades_por_proceso_admision mppadm
	--			ON pap.ID_PROCESO_ADMISION_PERIODO = mppadm.ID_PROCESO_ADMISION_PERIODO INNER JOIN transaccional.examen_admision_sede easede
	--			ON pap.ID_PROCESO_ADMISION_PERIODO = easede.ID_PROCESO_ADMISION_PERIODO INNER JOIN transaccional.postulantes_por_modalidad ppmod
	--			ON easede.ID_EXAMEN_ADMISION_SEDE = ppmod.ID_EXAMEN_ADMISION_SEDE
	--			WHERE pap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND pap.ES_ACTIVO = 1 and mppadm.ES_ACTIVO =1 and mppadm.ESTADO = 97 and easede.ES_ACTIVO=1 and ppmod.ES_ACTIVO=1
	--			and easede.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION)
	--	SET @RESULT = -312

	IF (@META_PERIODO < @META_ALCANZADA_ACTUAL) --versión 2.0
		SET @RESULT = -397
	ELSE
	BEGIN
		UPDATE transaccional.meta_carrera_institucion_detalle
		SET		META_SEDE = @META_PERIODO,
				ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION,		
				ID_META_CARRERA_INSTITUCION = @ID_META_CARRERA_INSTITUCION,	
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
		WHERE 
				ID_META_CARRERA_INSTITUCION_DETALLE = @ID_META_CARRERA_INSTITUCION_DETALLE    

		SET @RESULT = 1
	END

	--UPDATE transaccional.meta_carrera_institucion_detalle
	--SET		META_SEDE = @META_PERIODO,
	--		ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION,		
	--		ID_META_CARRERA_INSTITUCION = @ID_META_CARRERA_INSTITUCION,	
	--		USUARIO_MODIFICACION = @USUARIO,
	--		FECHA_MODIFICACION = GETDATE()
	--WHERE 
	--		ID_META_CARRERA_INSTITUCION_DETALLE = @ID_META_CARRERA_INSTITUCION_DETALLE
	SELECT @RESULT
	--SELECT @ID_META_CARRERA_INSTITUCION_DETALLE
END
GO


