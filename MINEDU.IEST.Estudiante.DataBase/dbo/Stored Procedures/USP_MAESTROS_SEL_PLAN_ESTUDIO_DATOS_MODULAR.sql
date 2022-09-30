/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	12/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta una programación de clase.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			12/06/2019		JTOVAR			Creación
1.1			05/04/2022		JCHAVEZ			Se agregó campo TieneUnidadesDidacticas

TEST:
	USP_MAESTROS_SEL_PLAN_ESTUDIO_DATOS_MODULAR 2501
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PLAN_ESTUDIO_DATOS_MODULAR]
(  
@ID_PLAN_ESTUDIO	INT
)  
AS  
BEGIN  
 --SET NOCOUNT ON;  

	select top 1
		me.ID_MODALIDAD_ESTUDIO IdModalidadEstudio, 
		se.VALOR_ENUMERADO		ModalidadEstudio,
		me.ID_ENFOQUE			IdEnfoque,
		me.NOMBRE_ENFOQUE		NombreEnfoque,
		CASE WHEN (SELECT COUNT(1) FROM transaccional.unidades_didacticas_por_enfoque tudxe WHERE  tudxe.ID_ENFOQUES_POR_PLAN_ESTUDIO=   texpe.ID_ENFOQUES_POR_PLAN_ESTUDIO and 
					tudxe.ES_ACTIVO =1 and texpe.ES_ACTIVO=1)>0 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END AsignadoTipoEnfoque,
		CASE WHEN (SELECT COUNT(1) FROM transaccional.unidad_didactica ud INNER JOIN transaccional.modulo m ON ud.ID_MODULO=m.ID_MODULO
					WHERE m.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1 AND ud.ES_ACTIVO=1)>0 THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END TieneUnidadesDidacticas
	from 
		transaccional.enfoques_por_plan_estudio texpe
		INNER JOIN maestro.enfoque me on texpe.ID_ENFOQUE= me.ID_ENFOQUE and texpe.ES_ACTIVO=1
		INNER JOIN sistema.enumerado se ON se.ID_ENUMERADO= me.ID_MODALIDAD_ESTUDIO
	WHERE 
		ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO
END
GO


