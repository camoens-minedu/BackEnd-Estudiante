
 /**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	12/12/2019
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de los tipos de planes de estudios (tipo de itinerarios) según
						filtros. 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			17/01/2020		MALVA			SE AÑADE FILTRO OPCIONAL @D_PERIODO_LECTIVO_INSTITUCION PARA QUE LISTE  
--											DE ACUERDO A LO CONFIGURADO EN METAS POR SEDES.
--  TEST:			
/*
	USP_MAESTROS_SEL_TIPO_PLAN_ESTUDIO_LISTA 1106, 0,0
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_TIPO_PLAN_ESTUDIO_LISTA]
(  
@ID_INSTITUCION	INT,
@ID_CARRERA INT,
@ID_SEDE_INSTITUCION INT , 
@ID_PERIODO_LECTIVO_INSTITUCION INT = 0
)  
AS  
BEGIN  
 SET NOCOUNT ON; 
 
 IF @ID_PERIODO_LECTIVO_INSTITUCION = 0 
	 BEGIN
	  IF @ID_CARRERA = 0 
		 BEGIN  
			 SELECT DISTINCT   
					se_itin.VALOR_ENUMERADO				Text,  
					tci.ID_TIPO_ITINERARIO				Value		
			 FROM 	
			 transaccional.carreras_por_institucion tci
			 INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tci.ID_CARRERAS_POR_INSTITUCION= tcid.ID_CARRERAS_POR_INSTITUCION and tci.ES_ACTIVO=1 AND tcid.ES_ACTIVO=1 
			 inner join sistema.enumerado se_itin on se_itin.ID_ENUMERADO= tci.ID_TIPO_ITINERARIO 
			 WHERE 
					 (tci.ID_CARRERA =@ID_CARRERA OR @ID_CARRERA=0)and 
					 (tcid.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION=0) 		
					AND tci.ID_INSTITUCION=@ID_INSTITUCION
		 END
		 ELSE
		 BEGIN
			 SELECT DISTINCT   
					se_itin.VALOR_ENUMERADO				Text,  
					tci.ID_TIPO_ITINERARIO				Value, 
					CASE WHEN tpe.ID_PLAN_ESTUDIO IS NOT NULL THEN 1 ELSE 0 END		Code
			 FROM 	
			 transaccional.carreras_por_institucion tci
			 INNER JOIN transaccional.carreras_por_institucion_detalle tcid on tci.ID_CARRERAS_POR_INSTITUCION= tcid.ID_CARRERAS_POR_INSTITUCION and tci.ES_ACTIVO=1 AND tcid.ES_ACTIVO=1 
			 inner join sistema.enumerado se_itin on se_itin.ID_ENUMERADO= tci.ID_TIPO_ITINERARIO
			 LEFT JOIN transaccional.plan_estudio tpe on tpe.ID_CARRERAS_POR_INSTITUCION= tci.ID_CARRERAS_POR_INSTITUCION and tpe.ES_ACTIVO=1
			 WHERE 
					 (tci.ID_CARRERA =@ID_CARRERA OR @ID_CARRERA=0)and 
					 (tcid.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION=0) 		
					AND tci.ID_INSTITUCION=@ID_INSTITUCION

		 END
	 END 
 ELSE
	 BEGIN
		SELECT DISTINCT
			ti.VALOR_ENUMERADO					Text,
			ci.ID_TIPO_ITINERARIO				Value 
		FROM 
		transaccional.meta_carrera_institucion_detalle mcid 
		INNER JOIN transaccional.meta_carrera_institucion mci on mci.ID_META_CARRERA_INSTITUCION = mcid.ID_META_CARRERA_INSTITUCION and mci.ES_ACTIVO=1
		INNER JOIN transaccional.carreras_por_institucion ci on ci.ID_CARRERAS_POR_INSTITUCION = mci.ID_CARRERAS_POR_INSTITUCION and ci.ES_ACTIVO=1
		INNER JOIN sistema.enumerado ti on ti.ID_ENUMERADO = ci.ID_TIPO_ITINERARIO
		WHERE ci.ID_CARRERA =@ID_CARRERA AND mcid.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION  and ci.ID_INSTITUCION = @ID_INSTITUCION
		and mcid.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
	 END
END


--********************************************************************************
--37. USP_INSTITUCION_SEL_PERIODO_LECTIVO_INSTITUCION_INFO.sql