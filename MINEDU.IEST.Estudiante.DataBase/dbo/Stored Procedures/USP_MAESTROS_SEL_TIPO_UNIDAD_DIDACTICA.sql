/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/02/2021
LLAMADO POR			:
DESCRIPCION			:	Lista los tipos de unidad didáctica
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 05/02/2021		JCHAVEZ
--  TEST:  
--			USP_MAESTROS_SEL_TIPO_UNIDAD_DIDACTICA 100
**********************************************************************************************************/
CREATE PROCEDURE dbo.USP_MAESTROS_SEL_TIPO_UNIDAD_DIDACTICA
(
	@ID_TIPO_ITINERARIO INT
)
AS
BEGIN
	IF (@ID_TIPO_ITINERARIO = 99)
		SELECT ID_TIPO_UNIDAD_DIDACTICA IdTipoUnidadDidactica, NOMBRE_TIPO_UNIDAD TipoUnidadDidactica
		FROM maestro.tipo_unidad_didactica WHERE ID_TIPO_UNIDAD_DIDACTICA = 7
	ELSE IF (@ID_TIPO_ITINERARIO = 100)
		SELECT ID_TIPO_UNIDAD_DIDACTICA IdTipoUnidadDidactica, NOMBRE_TIPO_UNIDAD TipoUnidadDidactica
		FROM maestro.tipo_unidad_didactica WHERE ID_TIPO_UNIDAD_DIDACTICA = 5
	ELSE IF (@ID_TIPO_ITINERARIO = 101)
		SELECT ID_TIPO_UNIDAD_DIDACTICA IdTipoUnidadDidactica, NOMBRE_TIPO_UNIDAD TipoUnidadDidactica
		FROM maestro.tipo_unidad_didactica WHERE ID_TIPO_UNIDAD_DIDACTICA IN (1,2,3)
END