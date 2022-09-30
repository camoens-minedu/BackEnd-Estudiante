/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro de peridoo lectivo por institucion en forma masiva
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	EXEC [USP_MAESTROS_INS_PERIODO_LECTIVO_INSTITUCION_MASIVO] '0635995|0719807|0737544',3,'2018-01-01 00:00:00','2018-01-21  00:00:00','MR','','gg',1
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_INS_PERIODO_LECTIVO_INSTITUCION_MASIVO_DIRECTO1]
(
	@ID_PERIODO_LECTIVO		INT,
	@FECHA_INICIO			DATE,
	@FECHA_FIN				DATE,
	@USUARIO				VARCHAR(20)
)
AS
DECLARE @ID_TIPO_GESTION INT = (SELECT ISNULL((SELECT ID_TIPO_OPCION FROM maestro.periodo_lectivo PL 
								WHERE PL.ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO),0))

MERGE INTO transaccional.periodos_lectivos_por_institucion AS TARGET
	USING (
		SELECT DISTINCT	
		I.ID_INSTITUCION ID_INSTITUCION		
		FROM transaccional.periodos_lectivos_por_institucion PLI
		INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION I ON PLI.ID_INSTITUCION = I.ID_INSTITUCION
		WHERE 
			ES_ACTIVO = 1 AND PLI.ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO AND
			(I.TIPO_GESTION = @ID_TIPO_GESTION OR @ID_TIPO_GESTION = 5)
	) AS SOURCE ON TARGET.ID_INSTITUCION = SOURCE.ID_INSTITUCION
	WHEN MATCHED
	THEN
		UPDATE 
		SET ES_ACTIVO = 1,
			USUARIO_MODIFICACION = @USUARIO,		
			FECHA_MODIFICACION = GETDATE()
	WHEN NOT MATCHED BY SOURCE AND TARGET.ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO
	THEN
		UPDATE 
		SET ES_ACTIVO = 0,
			USUARIO_MODIFICACION = @USUARIO,		
			FECHA_MODIFICACION = GETDATE()
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (
			ID_PERIODO_LECTIVO,
			ID_INSTITUCION,
			NOMBRE_PERIODO_LECTIVO_INSTITUCION,
			FECHA_INICIO_INSTITUCION,
			FECHA_FIN_INSTITUCION,
			ES_ACTIVO,
			ESTADO,
			USUARIO_CREACION,
			FECHA_CREACION
		) VALUES (
			@ID_PERIODO_LECTIVO,
			SOURCE.ID_INSTITUCION,
			'',
			@FECHA_INICIO,
			@FECHA_FIN,
			1,
			6,
			@USUARIO,
			GETDATE()
		);
--SELECT @@ROWCOUNT
GO


