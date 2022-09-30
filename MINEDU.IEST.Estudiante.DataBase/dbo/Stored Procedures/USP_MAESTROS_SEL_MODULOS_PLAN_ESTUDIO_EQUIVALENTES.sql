/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	18/01/2022
LLAMADO POR			:
DESCRIPCION			:	Lista los módulos equivalentes por unidad didáctica
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

TEST:
	USP_MAESTROS_SEL_MODULOS_PLAN_ESTUDIO_EQUIVALENTES 4048
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_MODULOS_PLAN_ESTUDIO_EQUIVALENTES]
(
	@ID_PLAN_ESTUDIO INT
)
AS
BEGIN
	
	SELECT m.ID_MODULO_EQUIVALENCIA IdModulo,m.NOMBRE_MODULO NombreModulo
	FROM transaccional.plan_estudio pe
	INNER JOIN transaccional.modulo_equivalencia m ON m.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1
	WHERE pe.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO AND ISNULL(m.ID_TIPO_MODULO,0) <> 160
END