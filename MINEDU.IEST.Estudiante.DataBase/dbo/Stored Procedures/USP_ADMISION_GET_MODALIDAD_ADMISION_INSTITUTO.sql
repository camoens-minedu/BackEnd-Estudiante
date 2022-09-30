/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el registro de una modalidad del proceso de admisión en la institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_GET_MODALIDAD_ADMISION_INSTITUTO] 
(
	@ID_MODALIDAD INT=''
)
AS
BEGIN
	
	SELECT 
	enu.ID_ENUMERADO                       IdModalidad,
	enu.VALOR_ENUMERADO                    NombreModalidad,
	enu.CODIGO_ENUMERADO                   CodigoModalidad
	
	FROM sistema.enumerado enu
	WHERE enu.ID_ENUMERADO = @ID_MODALIDAD
	
END
GO


