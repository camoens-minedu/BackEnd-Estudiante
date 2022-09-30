/*********************************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de programas de estudios de las cargas masivas de la institucion.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2021		JCHAVEZ         CREACIÓN

TEST:			
	EXEC USP_CARGA_MASIVA_SEL_PLAN_ESTUDIO_LISTA 2945,1120
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_CARGA_MASIVA_SEL_PLAN_ESTUDIO_LISTA]
 @ID_INSTITUCION INT,
 @ID_CARRERA INT
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT DISTINCT
		cmn.NOMBRE_PLAN_ESTUDIO Text, 
		CAST(ROW_NUMBER() OVER (ORDER BY cmn.ID_CARGA_MASIVA_NOMINA) AS INT) Value
	FROM transaccional.carga_masiva_nominas cmn	
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON c.ID_CARRERA = cmn.ID_CARRERA 		
	WHERE cmn.ID_INSTITUCION = @ID_INSTITUCION AND cmn.ID_CARRERA = @ID_CARRERA AND cmn.ES_ACTIVO = 1
END