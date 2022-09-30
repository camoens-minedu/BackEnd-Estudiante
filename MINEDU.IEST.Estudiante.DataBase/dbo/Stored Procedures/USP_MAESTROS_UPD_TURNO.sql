
-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:		MANUEL RUIZ FIESTAS
--  CREACION:		26/06/2017
--  BASE DE DATOS:	DB_REGIA
--  DESCRIPCION:	CREACION DE AULAS

--  TEST:

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_MAESTROS_UPD_TURNO]
(    
    @ID_TURNO_INSTITUCION int,
	@ID_ESTADO int,
	@USUARIO varchar(20)
)
AS

UPDATE maestro.turnos_por_institucion 
SET ESTADO = CASE WHEN @ID_ESTADO = 1 THEN 2 ELSE 1 END,
ES_ACTIVO = 1,
FECHA_MODIFICACION = GETDATE(),
USUARIO_MODIFICACION = @USUARIO
WHERE ID_TURNOS_POR_INSTITUCION = @ID_TURNO_INSTITUCION

SELECT 1
GO


