/*********************************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Retorna los datos de un programa de estudio.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2021		JCHAVEZ         CREACIÓN

TEST:			
	EXEC USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_ID 1193
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_ID]
 @ID_CARRERA INT
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT 
		mc.ID_CARRERA IdCarrera,
		LTRIM(mc.NOMBRE_CARRERA) Carrera,
		mc.NIVEL_FORMACION NivelFormacion,
		mc.CODIGO_FAMILIA_PRODUCTIVO CodigoFamiliaProductiva,
		mc.NOMBRE_FAMILIA_PRODUCTIVA FamiliaProductiva,
		mc.NOMBRE_SECTOR Sector
	FROM db_auxiliar.dbo.UVW_CARRERA mc
	WHERE mc.ID_CARRERA = @ID_CARRERA
	ORDER BY 1
END