/********************************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	07/02/2022
LLAMADO POR			:
DESCRIPCION			:	Actualiza el estado de las clases de un periodo de clases
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			07/02/2022		JCHAVEZ          Creación

  TEST:			
	USP_EVALUACION_UPD_ACTUALIZA_ESTADO_CIERRE_PERIODO 2371,3898,3775,0,'70557821'
*********************************************************************************************************************/
CREATE PROCEDURE dbo.USP_EVALUACION_UPD_ACTUALIZA_ESTADO_CIERRE_PERIODO
 @ID_INSTITUCION INT,  
 @ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT,  
 @ID_PERIODO_ACADEMICO INT,
 @ESTADO INT,
 @USUARIO VARCHAR(20)  
AS
BEGIN
	UPDATE transaccional.programacion_clase SET 
		ESTADO = @ESTADO,
		USUARIO_MODIFICACION = @USUARIO,
		FECHA_MODIFICACION=GETDATE() 
	WHERE ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO AND ES_ACTIVO = 1

	SELECT 1
END