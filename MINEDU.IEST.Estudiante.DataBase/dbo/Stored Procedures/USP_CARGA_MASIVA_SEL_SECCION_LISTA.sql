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
	EXEC USP_CARGA_MASIVA_SEL_SECCION_LISTA 2945,13
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_CARGA_MASIVA_SEL_SECCION_LISTA]
 @ID_INSTITUCION INT,
 @ID_TURNO INT
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT DISTINCT
		e.VALOR_ENUMERADO Text, 
		e.ID_ENUMERADO Value
	FROM transaccional.carga_masiva_nominas cmn	
		INNER JOIN sistema.enumerado e ON cmn.ID_SECCION = e.ID_ENUMERADO		
	WHERE cmn.ID_INSTITUCION = @ID_INSTITUCION AND cmn.ID_TURNO = @ID_TURNO AND cmn.ES_ACTIVO = 1
END