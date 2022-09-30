--/************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Eliminación de enumerado 
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		  USP_MAESTROS_DEL_ENUMERADO 10066, 'MALVA'
--/*
--	1.0			19/12/2019		MALVA         SOLO SE ELIMINA SI EL ENUMERADO ES EDITABLE
--*/
--*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_DEL_ENUMERADO]
(
    @ID_ENUMERADO int,
    @USUARIO nvarchar(20)
    ) 
AS
--DECLARE @ESTADO int = (SELECT TOP 1 e.ID_ENUMERADO FROM sistema.enumerado e WHERE e.ID_TIPO_ENUMERADO=56 AND e.VALOR_ENUMERADO='INACTIVO')
DECLARE @ID_TIPO_ENUMERADO INT, @EXISTE BIT = 0
SET @ID_TIPO_ENUMERADO = (SELECT ID_TIPO_ENUMERADO FROM sistema.enumerado WHERE ID_ENUMERADO = @ID_ENUMERADO) 

IF (@ID_TIPO_ENUMERADO = 10) --TIPO DE PERSONAL
	IF EXISTS(SELECT TOP 1 ID_PERSONAL_INSTITUCION FROM maestro.personal_institucion WHERE ES_ACTIVO = 1 AND ID_TIPO_PERSONAL = @ID_ENUMERADO)
		SET @EXISTE = 1
IF (@ID_TIPO_ENUMERADO = 16) --TIPO DE CONTRATO
	IF EXISTS(SELECT TOP 1 ID_PERSONAL_INSTITUCION FROM maestro.personal_institucion WHERE ES_ACTIVO = 1 AND CONDICION_LABORAL = @ID_ENUMERADO)
		SET @EXISTE = 1
IF (@ID_TIPO_ENUMERADO = 14) --GRADO PROFESIONAL
	IF EXISTS(SELECT TOP 1 ID_PERSONA FROM maestro.persona_institucion WHERE ID_GRADO_PROFESIONAL= @ID_ENUMERADO)
		SET @EXISTE = 1 
--IF (@ID_TIPO_ENUMERADO = 59) --CARRERA PROFESIONAL
--	IF EXISTS(SELECT TOP 1 ID_PERSONA FROM maestro.persona WHERE ES_ACTIVO = 1 AND ID_CARRERA_PROFESIONAL= @ID_ENUMERADO)
--		SET @EXISTE = 1 
IF (@ID_TIPO_ENUMERADO = 4) --TIPO AULA
	IF EXISTS(SELECT TOP 1 ID_AULA FROM maestro.aula WHERE ES_ACTIVO = 1 AND CATEGORIA_AULA = @ID_ENUMERADO)
		SET @EXISTE = 1 
DECLARE @ES_EDITABLE BIT  =0 

SET @ES_EDITABLE = (SELECT e.ES_EDITABLE FROM sistema.enumerado e WHERE e.ID_ENUMERADO=@ID_ENUMERADO )

IF @ES_EDITABLE  = 0
	SELECT 0
ELSE IF @EXISTE = 1
	SELECT -154
ELSE
BEGIN
	BEGIN TRANSACTION T1
	BEGIN TRY		
		UPDATE sistema.enumerado SET ESTADO = 0 WHERE ID_ENUMERADO = @ID_ENUMERADO
	COMMIT TRANSACTION T1
		SELECT 1
	END TRY	   
	BEGIN CATCH
		IF @@ERROR<>0
		BEGIN
			ROLLBACK TRANSACTION T1	   
			SELECT -154
		END
	END CATCH		
END
GO


