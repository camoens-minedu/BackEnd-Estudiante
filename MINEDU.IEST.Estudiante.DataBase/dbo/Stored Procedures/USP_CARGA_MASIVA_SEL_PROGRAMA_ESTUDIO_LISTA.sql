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
	EXEC USP_CARGA_MASIVA_SEL_PROGRAMA_ESTUDIO_LISTA 2945,''
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_CARGA_MASIVA_SEL_PROGRAMA_ESTUDIO_LISTA]
 @ID_INSTITUCION INT,
 @NOMBRE_SEDE VARCHAR(150)
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT DISTINCT
		c.NOMBRE_CARRERA Text, 
		c.ID_CARRERA Value
	FROM transaccional.carga_masiva_nominas cmn	
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON c.ID_CARRERA = cmn.ID_CARRERA 		
	WHERE cmn.ID_INSTITUCION = @ID_INSTITUCION AND cmn.ES_ACTIVO = 1
		AND (cmn.NOMBRE_SEDE_INSTITUCION = @NOMBRE_SEDE OR @NOMBRE_SEDE = '')
	ORDER BY c.NOMBRE_CARRERA
END