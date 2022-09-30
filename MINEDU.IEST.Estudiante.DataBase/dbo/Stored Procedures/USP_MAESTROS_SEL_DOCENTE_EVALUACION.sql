/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtener lista de personal de una institucion para llenar grilla paginada
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
-- [dbo].[USP_MAESTROS_SEL_DOCENTE_EVALUACION] 1145,607,49
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_DOCENTE_EVALUACION]
(	
	@ID_INSTITUCION				INT=1145,
	@ID_PERIODO_LECTIVO			INT=607,
	@ID_ROL						int=49
)
 AS
 BEGIN
	    SET NOCOUNT ON;
		SELECT				 
			PRLI.ID_PERSONAL_INSTITUCION			AS IdPersonalInstitucion,			
			P.NOMBRE_PERSONA						AS Nombre,
			P.APELLIDO_PATERNO_PERSONA				AS ApellidoPaterno,
			P.APELLIDO_MATERNO_PERSONA				AS ApellidoMaterno
		FROM [maestro].[persona] P
			 INNER JOIN maestro.persona_institucion PEI ON PEI.ID_PERSONA = P.ID_PERSONA
		     INNER JOIN [maestro].[personal_institucion] PRLI ON (PEI.ID_PERSONA_INSTITUCION = PRLI.ID_PERSONA_INSTITUCION)		 
		WHERE 		
			 PEI.ID_INSTITUCION = @ID_INSTITUCION 		 
			 AND (@ID_ROL = PRLI.ID_ROL OR (@ID_ROL = 0 AND ID_ROL <> 49))
			 AND PRLI.ES_ACTIVO = 1		
			 AND (PRLI.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO OR PRLI.ID_ROL = 46)
       ORDER BY P.APELLIDO_PATERNO_PERSONA,P.APELLIDO_MATERNO_PERSONA,P.NOMBRE_PERSONA
  END
GO


