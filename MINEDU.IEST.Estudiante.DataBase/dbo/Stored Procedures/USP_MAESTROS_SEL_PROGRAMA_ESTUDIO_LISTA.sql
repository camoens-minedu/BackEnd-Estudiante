CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_LISTA]
(  
@ID_SEDE_INSTITUCION INT
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
select 
	mc.NOMBRE_CARRERA Text,
	tci.ID_CARRERAS_POR_INSTITUCION Value,
	tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE Code
  from transaccional.carreras_por_institucion_detalle  tcid
inner join transaccional.carreras_por_institucion  tci on tci.ID_CARRERAS_POR_INSTITUCION=tcid.ID_CARRERAS_POR_INSTITUCION
inner join db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA= tci.ID_CARRERA
where (tcid.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION or @ID_SEDE_INSTITUCION=0)
AND tcid.ES_ACTIVO=1
END
GO


