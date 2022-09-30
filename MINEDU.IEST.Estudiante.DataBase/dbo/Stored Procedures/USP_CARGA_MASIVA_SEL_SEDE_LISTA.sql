/*********************************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de sedes de las cargas masivas de la institucion.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2021		JCHAVEZ         CREACIÓN

TEST:			
	EXEC USP_CARGA_MASIVA_SEL_SEDE_LISTA 2945, ''
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_CARGA_MASIVA_SEL_SEDE_LISTA]
 @ID_INSTITUCION INT,
 @NOMBRE_PERIODO_LECTIVO VARCHAR(50)
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT DISTINCT
		cmn.NOMBRE_SEDE_INSTITUCION Text, 
		CAST(ROW_NUMBER() OVER (ORDER BY cmn.NOMBRE_SEDE_INSTITUCION) AS INT) Value	
	FROM
		(SELECT DISTINCT cmn.NOMBRE_SEDE_INSTITUCION
		FROM transaccional.carga_masiva_nominas cmn	 		
		WHERE cmn.ID_INSTITUCION = @ID_INSTITUCION AND cmn.ES_ACTIVO = 1
			AND (cmn.NOMBRE_PERIODO_LECTIVO = @NOMBRE_PERIODO_LECTIVO OR @NOMBRE_PERIODO_LECTIVO = ''))cmn
END