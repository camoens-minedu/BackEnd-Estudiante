
-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:		MANUEL RUIZ FIESTAS
--  CREACION:		26/06/2017
--  BASE DE DATOS:	DB_REGIA
--  DESCRIPCION:	CREACION DE AULAS

--  TEST:
--		EXEC USP_MAESTROS_SEL_TURNO 394
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_TURNO]
(    
    @ID_INSTITUCION int
)
AS

SELECT 
	ISNULL(ti.ID_TURNOS_POR_INSTITUCION,0) IdTurnoInstitucion, 
	e.ID_ENUMERADO IdTurno, 
	e.VALOR_ENUMERADO Turno,  
	ISNULL(es.ID_ENUMERADO,97) IdEstado, 
	ISNULL(es.VALOR_ENUMERADO,'INACTIVO') Estado 
FROM 
	maestro.turnos_por_institucion ti 
	INNER JOIN maestro.turno_equivalencia te on te.ID_TURNO_EQUIVALENCIA = ti.ID_TURNO_EQUIVALENCIA
	INNER JOIN sistema.enumerado e on te.ID_TURNO = e.ID_ENUMERADO
	INNER JOIN sistema.enumerado es on es.ID_ENUMERADO = ti.ESTADO
WHERE 
	ti.ID_INSTITUCION = @ID_INSTITUCION
order by e.ID_ENUMERADO asc
GO


