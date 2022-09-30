/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el id del registro de una persona en una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	USP_EVALUACION_GET_IdPersonalInstitucion 23985770
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_GET_IdPersonalInstitucion] (
	@NUMERO_DOCUMENTO_PERSONA varchar(20)
)
AS
BEGIN
SET NOCOUNT ON;

	SELECT 
	TOP 1 ID_PERSONAL_INSTITUCION as IdPersonalInstitucion
	FROM maestro.persona A
	INNER JOIN maestro.persona_institucion B ON A.ID_PERSONA= B.ID_PERSONA AND B.ESTADO= 1
	INNER JOIN maestro.personal_institucion C ON B.ID_PERSONA_INSTITUCION=C.ID_PERSONA_INSTITUCION AND C.ES_ACTIVO=1
	WHERE A.NUMERO_DOCUMENTO_PERSONA =@NUMERO_DOCUMENTO_PERSONA

END
GO


