/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro de turno por institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE  PROCEDURE [dbo].[USP_MAESTROS_INS_TURNO]
(
	@ID_INSTITUCION INT,
	@ID_TURNO	    INT,

	@USUARIO	    VARCHAR(20)
)
AS
DECLARE @RESULT INT = 0
IF EXISTS (SELECT TOP 1 TXI.ID_TURNOS_POR_INSTITUCION FROM maestro.turnos_por_institucion TXI
INNER JOIN maestro.turno_equivalencia TE ON TXI.ID_TURNO_EQUIVALENCIA= TE.ID_TURNO_EQUIVALENCIA AND TXI.ES_ACTIVO=1
WHERE TE.ID_TURNO = @ID_TURNO and TXI.ID_INSTITUCION= @ID_INSTITUCION
)
	SET @RESULT = -273
ELSE
BEGIN

DECLARE @ID_TURNO_EQUIVALENCIA INT 
SET @ID_TURNO_EQUIVALENCIA =(SELECT TOP 1 ID_TURNO_EQUIVALENCIA FROM maestro.turno_equivalencia WHERE ID_TURNO= @ID_TURNO)
INSERT INTO maestro.turnos_por_institucion(
					ID_TURNO_EQUIVALENCIA,
					ID_INSTITUCION,
					ES_ACTIVO,
					ESTADO,
					USUARIO_CREACION,
					FECHA_CREACION)
 VALUES 
 (					@ID_TURNO_EQUIVALENCIA,
					@ID_INSTITUCION, 
					1,
					1, 
					@USUARIO, 
					GETDATE()
 )
SET @RESULT = CONVERT(INT,@@IDENTITY)
END
SELECT @RESULT
GO


