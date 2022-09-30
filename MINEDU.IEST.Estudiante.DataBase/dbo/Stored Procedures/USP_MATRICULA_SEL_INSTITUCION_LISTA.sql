CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_INSTITUCION_LISTA]
(  
@ID_PERSONA INT
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
	/*SELECT 
		VALOR_ENUMERADO Text, 
		ID_TURNOS_POR_INSTITUCION Value		
	FROM maestro.turno_equivalencia mte
		inner join sistema.enumerado se on mte.ID_TURNO =se.ID_ENUMERADO
		inner join maestro.turnos_por_institucion  mti on mti.ID_TURNO_EQUIVALENCIA =mte.ID_TURNO_EQUIVALENCIA
	WHERE mti.ID_INSTITUCION =@ID_INSTITUCION */

	SELECT 		
		I.NOMBRE_INSTITUCION Text,
		I.ID_INSTITUCION Value
	FROM maestro.persona_institucion PEI
		INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION I ON I.ID_INSTITUCION = PEI.ID_INSTITUCION
	WHERE PEI.ID_PERSONA = @ID_PERSONA


END
GO


