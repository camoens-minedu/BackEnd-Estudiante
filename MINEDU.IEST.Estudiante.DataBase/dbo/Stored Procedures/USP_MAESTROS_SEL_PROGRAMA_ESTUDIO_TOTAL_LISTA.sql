/*********************************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de programas de estudios disponibles.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2021		JCHAVEZ         CREACIÓN

TEST:			
	EXEC USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_TOTAL_LISTA 0
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_TOTAL_LISTA]
 @ID_CARRERA INT
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT 
		LTRIM(mc.NOMBRE_CARRERA + ' - ' + mc.NIVEL_FORMACION) Text,
		mc.ID_CARRERA Value
	from db_auxiliar.dbo.UVW_CARRERA mc
	WHERE @ID_CARRERA = 0 OR mc.ID_CARRERA = @ID_CARRERA
	ORDER BY 1
END