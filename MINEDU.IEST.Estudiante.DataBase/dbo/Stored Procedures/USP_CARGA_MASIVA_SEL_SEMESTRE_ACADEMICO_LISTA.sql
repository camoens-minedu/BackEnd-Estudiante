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
	EXEC USP_CARGA_MASIVA_SEL_SEMESTRE_ACADEMICO_LISTA 2945,'PLAN 2020'
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_CARGA_MASIVA_SEL_SEMESTRE_ACADEMICO_LISTA]
 @ID_INSTITUCION INT,
 @NOMBRE_PLAN_ESTUDIO VARCHAR(150)
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT DISTINCT
		e.VALOR_ENUMERADO Text, 
		e.ID_ENUMERADO Value
	FROM transaccional.carga_masiva_nominas cmn	
		INNER JOIN sistema.enumerado e ON cmn.ID_SEMESTRE_ACADEMICO = e.ID_ENUMERADO		
	WHERE cmn.ID_INSTITUCION = @ID_INSTITUCION AND cmn.NOMBRE_PLAN_ESTUDIO = @NOMBRE_PLAN_ESTUDIO AND cmn.ES_ACTIVO = 1
END