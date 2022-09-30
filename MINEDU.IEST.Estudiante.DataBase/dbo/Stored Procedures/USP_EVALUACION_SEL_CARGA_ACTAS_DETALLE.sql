--/*************************************************************************************************************************************************
--AUTOR				    :	JUAN JOSE TOVAR YAÑEZ
--FECHA DE CREACION	    :	01/04/2021
--LLAMADO POR			:
--DESCRIPCION			:	Listado de cargados actas
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------

--**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_SEL_CARGA_ACTAS_DETALLE]
(  
	@ID_CARGA_MASIVA_ACTAS_CABECERA INT	
)  
AS  
BEGIN  
 SET NOCOUNT ON;  

	    SELECT 
	   NUMERO_DOCUMENTO_IDENTIDAD,
	   APELLIDOS_NOMBRES,
	   SEXO,
	   EDAD,
	   UNIDAD_DIDACTICA_1,
	   UNIDAD_DIDACTICA_2,
	   UNIDAD_DIDACTICA_3,
	   UNIDAD_DIDACTICA_4,
	   UNIDAD_DIDACTICA_5,
	   UNIDAD_DIDACTICA_6,
	   UNIDAD_DIDACTICA_7,
	   UNIDAD_DIDACTICA_8,
	   UNIDAD_DIDACTICA_9,
	   UNIDAD_DIDACTICA_10,
	   UNIDAD_DIDACTICA_11,
	   UNIDAD_DIDACTICA_12,
	   UNIDAD_DIDACTICA_13,
	   UNIDAD_DIDACTICA_14,
	   UNIDAD_DIDACTICA_15,
	   UNIDAD_DIDACTICA_16,
	   UNIDAD_DIDACTICA_17,
	   UNIDAD_DIDACTICA_18,
	   UNIDAD_DIDACTICA_19,
	   UNIDAD_DIDACTICA_20,
	   ROW_NUMBER() OVER ( ORDER BY  NUMERO_DOCUMENTO_IDENTIDAD, APELLIDOS_NOMBRES) AS Row
	   FROM transaccional.carga_masiva_actas_cabecera_detalle
	   WHERE ID_CARGA_MASIVA_ACTAS_CABECERA = @ID_CARGA_MASIVA_ACTAS_CABECERA

		
		
END