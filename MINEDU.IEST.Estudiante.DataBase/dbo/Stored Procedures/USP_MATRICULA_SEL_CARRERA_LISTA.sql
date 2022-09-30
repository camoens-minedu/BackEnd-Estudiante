/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de programas de estudio de una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			Creación
1.1			28/02/2022		JCHAVEZ			Se agregó order by

TEST:			
	USP_MATRICULA_SEL_CARRERA_LISTA 20
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_CARRERA_LISTA]
(  
	@ID_SEDE_INSTITUCION INT
)  
AS  
BEGIN  
 SET NOCOUNT ON;   	
	SELECT 
	DISTINCT
	carrera.ID_CARRERA                                Value,
	LTRIM(carrera.NOMBRE_CARRERA)                            Text 
	
	FROM db_auxiliar.dbo.UVW_CARRERA carrera INNER JOIN transaccional.carreras_por_institucion cpinst
	ON carrera.ID_CARRERA = cpinst.ID_CARRERA INNER JOIN transaccional.carreras_por_institucion_detalle cpinstdet
	ON cpinst.ID_CARRERAS_POR_INSTITUCION = cpinstdet.ID_CARRERAS_POR_INSTITUCION

	WHERE cpinst.ES_ACTIVO = 1 AND cpinstdet.ES_ACTIVO = 1 AND cpinstdet.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION
	ORDER BY LTRIM(carrera.NOMBRE_CARRERA)
END
GO


