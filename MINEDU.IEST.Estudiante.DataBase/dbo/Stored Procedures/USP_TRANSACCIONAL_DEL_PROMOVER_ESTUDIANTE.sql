/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Elimina el registro de promover estudiante.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--/*
--	1.0		31/01/2020		MALVA          SE AÑADE PARÁMETRO @ID_INSTITUCION PARA VERIFICAR SI ESTÁ PERMITIDO ELIMINAR REGISTRO. 
--*/
--  TEST:		USP_TRANSACCIONAL_DEL_PROMOVER_ESTUDIANTE 1106, 22, 'MALVA'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_DEL_PROMOVER_ESTUDIANTE]
(
	@ID_INSTITUCION						INT, 
    @ID_PROMOVER_ESTUDIANTE				INT,        
    @USUARIO							nvarchar(20)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @RESULT INT, @ID_INSTITUCION_CONSULTA INT = 0

	SELECT @ID_INSTITUCION_CONSULTA = plxi.ID_INSTITUCION 
	FROM transaccional.promover_persona_institucion ppi
	INNER JOIN transaccional.periodos_lectivos_por_institucion plxi ON ppi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	AND ppi.ES_ACTIVO=1 AND plxi.ES_ACTIVO =1
	WHERE ppi.ID_PROMOVER_PERSONA_INSTITUCION = @ID_PROMOVER_ESTUDIANTE

	IF @ID_INSTITUCION <> @ID_INSTITUCION_CONSULTA
	BEGIN
		SET @RESULT = -362 GOTO FIN
	END
	DECLARE @ID_PERSONA_INSTITUCION INT

	SET @ID_PERSONA_INSTITUCION = (SELECT pinstitucion.ID_PERSONA_INSTITUCION FROM transaccional.promover_persona_institucion ppinsti 
	INNER JOIN transaccional.postulantes_por_modalidad ppmod
	ON ppinsti.ID_POSTULANTES_POR_MODALIDAD_PROMOVIDO = ppmod.ID_POSTULANTES_POR_MODALIDAD INNER JOIN maestro.persona_institucion pinstitucion
	ON ppmod.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION
	WHERE ppinsti.ID_PROMOVER_PERSONA_INSTITUCION = @ID_PROMOVER_ESTUDIANTE)


	IF EXISTS (SELECT TOP (1) eins.ID_ESTUDIANTE_INSTITUCION FROM transaccional.estudiante_institucion eins INNER JOIN maestro.persona_institucion pins ON eins.ID_PERSONA_INSTITUCION = pins.ID_PERSONA_INSTITUCION
			   WHERE pins.ID_PERSONA_INSTITUCION = @ID_PERSONA_INSTITUCION AND eins.ES_ACTIVO=1)
					SET @RESULT = -162 -- YA SE ENCUENTRA REGISTRADO				
	ELSE
	BEGIN 	
		UPDATE transaccional.promover_persona_institucion
		SET 
			[ES_ACTIVO]	= 0 
			,[FECHA_MODIFICACION]	  = GETDATE()   
			,[USUARIO_MODIFICACION]	  = @USUARIO
		WHERE 
			[ID_PROMOVER_PERSONA_INSTITUCION]	= @ID_PROMOVER_ESTUDIANTE	      

		SET @RESULT = 1
	END	
	FIN:
	SELECT @RESULT
END
GO


