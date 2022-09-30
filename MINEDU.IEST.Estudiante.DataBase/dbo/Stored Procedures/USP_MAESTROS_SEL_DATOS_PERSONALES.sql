/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de datos personales de la persona
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_DATOS_PERSONALES]
(  
 @ID_TIPO_DOCUMENTO INT,
 @NUMERO_DOCUMENTO_PERSONA VARCHAR(16)
)  
AS  
BEGIN  
	SET NOCOUNT ON;  

SELECT 
		TOP 1
		MP.NOMBRE_PERSONA Nombre,
		MP.APELLIDO_PATERNO_PERSONA ApellidoPaterno,
		MP.APELLIDO_MATERNO_PERSONA ApellidoMaterno,
		MP.SEXO_PERSONA		IdSexo,
		MPI.ESTADO_CIVIL	IdEstadoCivil, --PI
		CONVERT (VARCHAR(10),MP.FECHA_NACIMIENTO_PERSONA, 103) FechaNacimiento,
		MP.UBIGEO_NACIMIENTO UbigeoNacimiento,
		MPI.UBIGEO_PERSONA UbigeoResidencia, --PI
		MP.PAIS_NACIMIENTO IdPaisNacimiento,
		MPI.PAIS_PERSONA IdPaisResidencia, --PI
		MPI.DIRECCION_PERSONA Direccion --PI
 FROM	
		maestro.persona MP
		INNER JOIN maestro.persona_institucion MPI ON MP.ID_PERSONA= MPI.ID_PERSONA 
 WHERE	
		MP.ID_TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO 
		AND MP.NUMERO_DOCUMENTO_PERSONA= @NUMERO_DOCUMENTO_PERSONA 
 ORDER BY  
		ISNULL(MPI.FECHA_MODIFICACION, MPI.FECHA_CREACION)  DESC
 
END
GO


