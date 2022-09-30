/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/02/2021
LLAMADO POR			:
DESCRIPCION			:	Lista los módulos por unidad didáctica
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 05/02/2021		JCHAVEZ

--  TEST:  
--			USP_MAESTROS_SEL_MODULOS_PLAN_ESTUDIO 2287--ASIGNATURA
--			USP_MAESTROS_SEL_MODULOS_PLAN_ESTUDIO 995 --TRANSVERSAL
--			USP_MAESTROS_SEL_MODULOS_PLAN_ESTUDIO 905 --MODULAR
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_MODULOS_PLAN_ESTUDIO]
(
	@ID_PLAN_ESTUDIO INT
)
AS
BEGIN
	SELECT m.ID_MODULO IdModulo,m.NOMBRE_MODULO NombreModulo
	FROM transaccional.plan_estudio pe
	INNER JOIN transaccional.modulo m ON m.ID_PLAN_ESTUDIO = pe.ID_PLAN_ESTUDIO AND m.ES_ACTIVO=1
	WHERE pe.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO AND ISNULL(m.ID_TIPO_MODULO,0) <> 160

	
END