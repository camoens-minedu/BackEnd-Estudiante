
/*********************************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de periodos lectivos para cargas masivas de la institucion.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			05/04/2021		JCHAVEZ         CREACIÓN

TEST:			
	EXEC USP_MAESTROS_SEL_PERIODO_LECTIVO_DISPONIBLE_CARGA_MASIVA_LISTA
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PERIODO_LECTIVO_DISPONIBLE_CARGA_MASIVA_LISTA]
AS  
BEGIN  
 SET NOCOUNT ON;  
	
	DECLARE @ID INT = 1
	DECLARE @NRO_ANIOS INT = 7
	DECLARE @ANIO INT = YEAR(GETDATE()) - 7
	DECLARE @periodo_lectivo TABLE (Text VARCHAR(7), Code INT, Value INT)

	WHILE(@ANIO <= YEAR(GETDATE()))
	BEGIN
		INSERT INTO @periodo_lectivo VALUES(CAST(@ANIO AS VARCHAR(4)) + '-1', @ID, @ID)
		SET @ID = @ID + 1
		INSERT INTO @periodo_lectivo VALUES(CAST(@ANIO AS VARCHAR(4)) + '-2', @ID, @ID)
		SET @ID = @ID + 1
		INSERT INTO @periodo_lectivo VALUES(CAST(@ANIO AS VARCHAR(4)) + '-3', @ID, @ID)

		SET @ANIO = @ANIO + 1
		SET @ID = @ID + 1
	END
	
	SELECT Text, Code, Value FROM @periodo_lectivo

END