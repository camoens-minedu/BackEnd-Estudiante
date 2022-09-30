/*********************************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de periodos lectivos de las cargas masivas de la institucion.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2021		JCHAVEZ         CREACIÓN

TEST:			
	EXEC USP_CARGA_MASIVA_SEL_PERIODO_LECTIVO_LISTA 2945
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_CARGA_MASIVA_SEL_PERIODO_LECTIVO_LISTA]
 @ID_INSTITUCION INT
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT DISTINCT
		cmn.NOMBRE_PERIODO_LECTIVO Text, 
		CAST(ROW_NUMBER() OVER (ORDER BY cmn.NOMBRE_PERIODO_LECTIVO) AS INT) Value	
	FROM 
		(SELECT DISTINCT NOMBRE_PERIODO_LECTIVO
		FROM transaccional.carga_masiva_nominas cmn	 		
		WHERE cmn.ID_INSTITUCION = @ID_INSTITUCION AND cmn.ES_ACTIVO = 1) cmn
END