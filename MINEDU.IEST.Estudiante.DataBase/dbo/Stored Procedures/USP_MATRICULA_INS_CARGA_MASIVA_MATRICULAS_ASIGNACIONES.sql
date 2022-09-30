/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta los registros de las asignaciones de la matriculas
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_INS_CARGA_MASIVA_MATRICULAS_ASIGNACIONES]
(
@ID_MATRICULA_ESTUDIANTE					INT,
@ASIGNACIONES_UNIDADES_DIDACTICAS			NVARCHAR(MAX), --'4379|4380|4381|4383|4384'
@ID_CARGA									INT,
@ID_SEDE_INSTITUCION						INT,
@ID_TURNOS_POR_INSTITUCION					INT,
@ID_SECCION									INT,
@USUARIO									VARCHAR(20)
)
AS
DECLARE @RESULT INT
SET @RESULT =0 
BEGIN

	MERGE INTO transaccional.programacion_clase_por_matricula_estudiante AS TARGET
		USING (
					SELECT	 
						CONVERT(INT, SplitData) ID_UNIDAD_DIDACTICA								
					FROM dbo.UFN_SPLIT(@ASIGNACIONES_UNIDADES_DIDACTICAS,'|')
		) AS SOURCE ON  --TARGET.ID_UNIDAD_DIDACTICA = SOURCE.ID_UNIDAD_DIDACTICA AND --comentado x generación script
		 TARGET.ID_MATRICULA_ESTUDIANTE= @ID_MATRICULA_ESTUDIANTE
		WHEN MATCHED
		THEN
			UPDATE
			SET ES_ACTIVO = 1,
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE()
		WHEN NOT MATCHED BY TARGET
		THEN
			INSERT (ID_PROGRAMACION_CLASE,
					ID_MATRICULA_ESTUDIANTE,
					ID_ESTADO_UNIDAD_DIDACTICA,
					ES_ACTIVO,
					ESTADO,
					USUARIO_CREACION,
					FECHA_CREACION)
			VALUES(
				NULL,
				@ID_MATRICULA_ESTUDIANTE,
				NULL,
				1,
				1,	
				@USUARIO,
				GETDATE()		
			)
		WHEN NOT MATCHED BY SOURCE AND TARGET.ID_MATRICULA_ESTUDIANTE= @ID_MATRICULA_ESTUDIANTE
		THEN
			UPDATE
			SET
				ES_ACTIVO = 0,				
				USUARIO_MODIFICACION = @USUARIO,
				FECHA_MODIFICACION = GETDATE();

	SET @RESULT =1

END
RETURN (@RESULT)
GO


