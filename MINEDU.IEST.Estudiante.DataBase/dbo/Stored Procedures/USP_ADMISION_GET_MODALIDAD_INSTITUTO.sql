/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el registro de modalidad de proceso de admisión por periodo lectivo en la institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_GET_MODALIDAD_INSTITUTO]  
(
    @ID_INSTITUCION INT='',
	@ID_PERIODOLECTIVO_INSTITUCION INT=''
	
)AS
BEGIN
		
		SELECT 
		enu.ID_ENUMERADO                             IdModalidad,
		enu.VALOR_ENUMERADO                          Modalidad

		FROM transaccional.proceso_admision_periodo padp JOIN transaccional.modalidades_por_proceso_admision mppad
		ON padp.ID_PROCESO_ADMISION_PERIODO = mppad.ID_PROCESO_ADMISION_PERIODO JOIN transaccional.examen_admision_sede eads
		ON mppad.ID_PROCESO_ADMISION_PERIODO = eads.ID_PROCESO_ADMISION_PERIODO JOIN maestro.sede_institucion sinst
		ON eads.ID_SEDE_INSTITUCION = sinst.ID_SEDE_INSTITUCION JOIN sistema.enumerado enu
		ON mppad.ID_MODALIDAD = enu.ID_ENUMERADO

		WHERE padp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOLECTIVO_INSTITUCION AND sinst.ID_INSTITUCION=@ID_INSTITUCION
	
END
GO


