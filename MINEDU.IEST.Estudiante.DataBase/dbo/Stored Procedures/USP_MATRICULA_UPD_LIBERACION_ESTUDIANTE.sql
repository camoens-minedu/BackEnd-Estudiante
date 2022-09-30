/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualiza un registro de un estudiante por liberación
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			CREACIÓN
2.0			30/07/2021		JCHAVEZ			SE AGREGÓ PARÁMETRO @ID_ESTUDIANTE_INSTITUCION

--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_UPD_LIBERACION_ESTUDIANTE]
(
	@ID_LIBERACION_ESTUDIANTE INT,
	@NRO_RESOLUCION VARCHAR(50),
	@ARCHIVO_TRASLADO VARCHAR(50),
	@ARCHIVO_RUTA VARCHAR(255),
	@ID_ESTUDIANTE_INSTITUCION INT,
	@USUARIO VARCHAR(20)
)
AS

DECLARE @RESULT INT = 0
IF EXISTS(SELECT TOP 1 tle.ID_LIBERACION_ESTUDIANTE FROM transaccional.liberacion_estudiante tle WHERE tle.ES_ACTIVO=1 
			AND tle.NRO_RD=@NRO_RESOLUCION AND tle.ID_LIBERACION_ESTUDIANTE<> @ID_LIBERACION_ESTUDIANTE)
BEGIN 
    SET @RESULT = -180
END
ELSE IF (EXISTS(SELECT TOP 1 ID_LIBERACION_ESTUDIANTE FROM transaccional.liberacion_estudiante WHERE ARCHIVO_RD = @ARCHIVO_TRASLADO AND ES_ACTIVO=1 AND ID_LIBERACION_ESTUDIANTE<>@ID_LIBERACION_ESTUDIANTE ))
	SET @RESULT = -260
ELSE
BEGIN
	update transaccional.liberacion_estudiante
	SET ID_ESTUDIANTE_INSTITUCION=@ID_ESTUDIANTE_INSTITUCION,
		NRO_RD= @NRO_RESOLUCION,
		ARCHIVO_RD= @ARCHIVO_TRASLADO,
		ARCHIVO_RUTA = @ARCHIVO_RUTA,
		FECHA_MODIFICACION = GETDATE(),
		USUARIO_MODIFICACION= @USUARIO
	WHERE ID_LIBERACION_ESTUDIANTE= @ID_LIBERACION_ESTUDIANTE
	SET @RESULT = 1
END	
SELECT @RESULT
GO


