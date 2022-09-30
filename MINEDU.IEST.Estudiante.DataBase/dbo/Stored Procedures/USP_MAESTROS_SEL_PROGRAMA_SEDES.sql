/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene los registros de los programas de estudios por institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PROGRAMA_SEDES]
(  
@ID_CARRERAS_POR_INSTITUCION INT  
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
select 
msi.ID_SEDE_INSTITUCION IdSedeInstitucion,
tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE   IdCarreraPorInstitucionDetalle,
tcid.ID_ESTADO_PROGRAMA IdEstadoPrograma,
msi.NOMBRE_SEDE SedeInstitucion,
se_prog.VALOR_ENUMERADO EstadoPrograma,
tcid.ES_ACTIVO EsActivo
from transaccional.carreras_por_institucion_detalle tcid 
	inner join maestro.sede_institucion msi on tcid.ID_SEDE_INSTITUCION = msi.ID_SEDE_INSTITUCION
	inner join sistema.enumerado se_prog on se_prog.ID_ENUMERADO = tcid.ID_ESTADO_PROGRAMA
where 
tcid.ID_CARRERAS_POR_INSTITUCION=@ID_CARRERAS_POR_INSTITUCION
AND tcid.ES_ACTIVO=1 
END
GO


