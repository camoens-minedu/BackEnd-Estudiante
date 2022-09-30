/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	10/01/2022
LLAMADO POR			:
DESCRIPCION			:	Lista de las unidades didácticas por plan de estudio
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_MODULOS_EQUIVALENCIAS]
(
	@ID_PLAN_ESTUDIO INT
)
AS
BEGIN
	
		SELECT 
			ROW_NUMBER() OVER(ORDER BY NUMERO_MODULO ASC) AS Row,
			ID_PLAN_ESTUDIO IdPlanEstudio,
			ID_MODULO_EQUIVALENCIA IdModulo,
			NOMBRE_MODULO NombreModulo,
			NUMERO_MODULO NumeroModulo,
			TOTHORAS TotalHoras,
			TOTCREDITOS TotalCreditos
					
		FROM transaccional.modulo_equivalencia 
		WHERE ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO AND ES_ACTIVO = 1
		ORDER BY NUMERO_MODULO
END