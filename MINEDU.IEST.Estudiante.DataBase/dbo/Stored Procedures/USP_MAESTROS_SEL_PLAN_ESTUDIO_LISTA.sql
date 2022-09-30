
 /***************************************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	01/10/2019
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de los planes de estudios según filtros. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 12/12/2019		MALVA           SE MODIFICÓ LÓGICA PARA QUE RETORNE PLANES DE ESTUDIOS Y SE AÑADIÓ FILTRO ID_TIPO_PLAN_ESTUDIOS 
--  TEST:			
/*
	USP_MAESTROS_SEL_PLAN_ESTUDIO_LISTA 1106, 1101,0, 101
*/
******************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PLAN_ESTUDIO_LISTA]
(  

@ID_INSTITUCION	INT,
@ID_CARRERA INT,
@ID_SEDE_INSTITUCION INT,  
@ID_TIPO_PLAN_ESTUDIOS INT
)  
AS  
BEGIN  
 SET NOCOUNT ON; 
 
 SELECT 
		DISTINCT
		pe.ID_PLAN_ESTUDIO			Value,
		pe.NOMBRE_PLAN_ESTUDIOS		Text
 FROM 
		transaccional.plan_estudio pe 
		INNER JOIN transaccional.carreras_por_institucion cpi ON pe.ID_CARRERAS_POR_INSTITUCION= cpi.ID_CARRERAS_POR_INSTITUCION 
		AND cpi.ES_ACTIVO=1 AND pe.ES_ACTIVO=1
		INNER JOIN transaccional.carreras_por_institucion_detalle cpid ON cpi.ID_CARRERAS_POR_INSTITUCION = cpid.ID_CARRERAS_POR_INSTITUCION 
		AND cpid.ES_ACTIVO=1
 WHERE  cpi.ID_INSTITUCION = @ID_INSTITUCION AND (cpi.ID_CARRERA=@ID_CARRERA OR @ID_CARRERA=0) 
 AND (cpid.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION =0)
 AND (cpi.ID_TIPO_ITINERARIO = @ID_TIPO_PLAN_ESTUDIOS OR @ID_TIPO_PLAN_ESTUDIOS = 0)
END 


--******************************************************************
--88. USP_MAESTROS_SEL_INSTITUCION_LISTA.sql
GO


