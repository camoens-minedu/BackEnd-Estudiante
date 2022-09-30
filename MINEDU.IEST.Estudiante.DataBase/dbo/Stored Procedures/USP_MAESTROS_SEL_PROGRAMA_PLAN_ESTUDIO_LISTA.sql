CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PROGRAMA_PLAN_ESTUDIO_LISTA]
(  
@ID_SEDE_INSTITUCION INT,
@ID_CARRERA INT
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
SELECT  
	se_tipo_itin.VALOR_ENUMERADO Text, 
	tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE Value,
	tci.ID_CARRERAS_POR_INSTITUCION Code 
FROM 
transaccional.carreras_por_institucion tci
inner join transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION= tci.ID_CARRERAS_POR_INSTITUCION
INNER JOIN transaccional.plan_estudio tpe on tpe.ID_CARRERAS_POR_INSTITUCION = tci.ID_CARRERAS_POR_INSTITUCION
INNER JOIN sistema.enumerado se_tipo_itin on se_tipo_itin.ID_ENUMERADO= tpe.ID_TIPO_ITINERARIO
WHERE 
tci.ID_CARRERA=@ID_CARRERA and tcid.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION and tcid.ES_ACTIVO=1 and tci.ES_ACTIVO=1
and tpe.ES_ACTIVO=1
END
GO


