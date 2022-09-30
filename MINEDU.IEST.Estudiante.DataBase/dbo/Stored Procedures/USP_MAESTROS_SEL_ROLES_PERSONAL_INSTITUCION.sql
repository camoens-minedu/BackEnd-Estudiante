/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene los registros de los roles del personal de la institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_ROLES_PERSONAL_INSTITUCION]
(
	@ID_INSTITUCION						INT,	
	@ID_TIPO_DOCUMENTO					INT,
	@NUMERO_DOCUMENTO					VARCHAR(15)	
)
AS
BEGIN
	select DISTINCT mpins.ID_ROL IdRol
	from maestro.persona mp
	inner join maestro.persona_institucion mpi on mp.ID_PERSONA= mpi.ID_PERSONA
	inner join maestro.personal_institucion mpins on mpins.ID_PERSONA_INSTITUCION = mpi.ID_PERSONA_INSTITUCION 
	AND mpins.ES_ACTIVO=1
	where mp.ID_TIPO_DOCUMENTO=@ID_TIPO_DOCUMENTO 
	and mp.NUMERO_DOCUMENTO_PERSONA=@NUMERO_DOCUMENTO
	and mpins.ID_ROL in (47, 48) --director y secretario académico
	and mpi.ID_INSTITUCION=@ID_INSTITUCION
END
GO


