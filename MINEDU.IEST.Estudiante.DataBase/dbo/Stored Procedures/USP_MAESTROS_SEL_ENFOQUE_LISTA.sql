﻿CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_ENFOQUE_LISTA]
(  
@ID_INSTITUCION			INT,
@ID_TIPO_ITINERARIO		INT,
@ID_CARRERA				INT,
@ID_MODALIDAD_ESTUDIO	INT
)  
AS  
BEGIN  
	SET NOCOUNT ON;  
	
	SELECT 
		me.NOMBRE_ENFOQUE Text,  
		tep.ID_ENFOQUE Value, 
		tep.ID_PLAN_ESTUDIO Code
	FROM 
	transaccional.enfoques_por_plan_estudio tep
	INNER JOIN maestro.enfoque me on tep.ID_ENFOQUE = me.ID_ENFOQUE
	INNER JOIN transaccional.plan_estudio tpe on tep.ID_PLAN_ESTUDIO= tpe.ID_PLAN_ESTUDIO and tpe.ES_ACTIVO=1
	INNER JOIN transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION= tpe.ID_CARRERAS_POR_INSTITUCION and tci.ES_ACTIVO=1
	WHERE  
	me.ID_MODALIDAD_ESTUDIO =@ID_MODALIDAD_ESTUDIO and ID_CARRERA=@ID_CARRERA AND tpe.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO AND tci.ID_INSTITUCION= @ID_INSTITUCION
END
GO

