﻿-------------------------------------------------------------------------------------------------------------
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	04/04/2020
--LLAMADO POR			:
--DESCRIPCION			:	Validar registro de carga masiva del IEST
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_PLANIFICACION_SEL_VALIDACION_CARGA]
(
	@ID_INSTITUCION         		        INT,
	@ID_PERIODO_LECTIVO_INSTITUCION			INT,
	@ID_SEDE_INSTITUCION					INT
)AS 

DECLARE @NOMBRE_IEST VARCHAR(400), @PERIODOLECTIVO VARCHAR(20)--, @SEDE VARCHAR(400)
BEGIN
	
	SET @NOMBRE_IEST = (SELECT concat(CODIGO_MODULAR, ' - ', NOMBRE_INSTITUCION) FROM db_auxiliar.dbo.UVW_INSTITUCION WHERE ID_INSTITUCION = @ID_INSTITUCION)
	SET @PERIODOLECTIVO = (SELECT NOMBRE_PERIODO_LECTIVO_INSTITUCION FROM transaccional.periodos_lectivos_por_institucion WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION AND ID_INSTITUCION = @ID_INSTITUCION AND ES_ACTIVO=1)
	--SET @SEDE = (SELECT NOMBRE_SEDE FROM maestro.sede_institucion WHERE ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION AND ID_INSTITUCION = @ID_INSTITUCION AND ES_ACTIVO=1)

	
	IF EXISTS (SELECT TOP 1 ID_CARGA_MASIVA_NOMINAS_CABECERA FROM transaccional.carga_masiva_nominas_cabecera
				WHERE NOMBRE_IEST = @NOMBRE_IEST AND PERIODO_LECTIVO = @PERIODOLECTIVO AND ES_ACTIVO =1)
		SELECT 1
	ELSE
	BEGIN
		
		SELECT 0
	END
END