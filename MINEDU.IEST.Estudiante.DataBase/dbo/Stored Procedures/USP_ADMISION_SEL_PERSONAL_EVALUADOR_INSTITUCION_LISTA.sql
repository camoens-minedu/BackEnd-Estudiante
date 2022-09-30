﻿CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_PERSONAL_EVALUADOR_INSTITUCION_LISTA]
(
	@ID_INSTITUCION					INT,
	@ID_PERIODO_LECTIVO_INSTITUCION	INT

	--DECLARE @ID_INSTITUCION					INT=440
	--DECLARE @ID_PERIODO_LECTIVO_INSTITUCION	INT=5517
)AS 
BEGIN
	SELECT 
		
		A.ID_PERSONAL_INSTITUCION	Value, 
		UPPER(P.APELLIDO_PATERNO_PERSONA) + ' '+ UPPER(P.APELLIDO_MATERNO_PERSONA) + ', ' + UPPER(P.NOMBRE_PERSONA) Text, 
		A.ID_PERSONAL_INSTITUCION	Code
		
	FROM maestro.personal_institucion A
	JOIN maestro.persona_institucion B ON B.ID_PERSONA_INSTITUCION = A.ID_PERSONA_INSTITUCION
	JOIN maestro.persona P ON P.ID_PERSONA = B.ID_PERSONA
	WHERE B.ID_INSTITUCION = @ID_INSTITUCION
	AND A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
	AND A.ES_ACTIVO = 1 AND A.ID_ROL=49
	
END
GO


