/*************************************************************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Inserción de registro de enumerado histórico
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE Creación

**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_INS_ENUMERADO_HISTORICO]
(
	@CODIGO_ENUMERADO_HISTORICO_PADRE int,
    @VALOR_ENUMERADO_HISTORICO nvarchar(150),
	@ESTADO_ENUMERADO_HISTORICO int,
	@ID_INSTITUCION int,
	@NRO_RD nvarchar(150),
	@ARCHIVO_RD nvarchar(150),
	@ARCHIVO_RUTA nvarchar(150),
    @USUARIO	 nvarchar(20)
)
AS
DECLARE @RESULT INT

BEGIN	   	   
	--Registrar Padre
	IF (@CODIGO_ENUMERADO_HISTORICO_PADRE = 0)
		BEGIN
			IF EXISTS(	
						SELECT TOP 1 VALOR_ENUMERADO_HISTORICO 
						FROM sistema.enumerado_historico
						WHERE RTRIM(LTRIM(VALOR_ENUMERADO_HISTORICO)) 
						COLLATE LATIN1_GENERAL_CI_AI = RTRIM(LTRIM(UPPER(@VALOR_ENUMERADO_HISTORICO)))
						AND ESTADO_ENUMERADO_HISTORICO = 1 
					)
				BEGIN
					SET @RESULT = -180 --Datos ya existen
				END
			ELSE					
				BEGIN
					INSERT INTO sistema.enumerado_historico
							(
								CODIGO_GRUPO_ENUMERADO_HISTORICO,
								VALOR_ENUMERADO_HISTORICO,
								ESTADO_ENUMERADO_HISTORICO,		  
								USUARIO_CREACION,
								FECHA_CREACION
							)
					VALUES
							(		  
								(	SELECT ISNULL(MAX(CODIGO_GRUPO_ENUMERADO_HISTORICO), 0)+1 
								FROM sistema.enumerado_historico),		  
								UPPER(@VALOR_ENUMERADO_HISTORICO), --@VALOR_ENUMERADO_HISTORICO - varchar (150)
								1, -- ES_ACTIVO - ESTADO - smallint							  
								@USUARIO, -- USUARIO_CREACION - nvarchar
								getdate()  -- FECHA_CREACION - datetime
							)
					SET @RESULT = 1
				END
		END
	--fin registrar padre
	ELSE
		BEGIN
			-- Registrar hijos-CARRERAS
			IF (@CODIGO_ENUMERADO_HISTORICO_PADRE = 9)
				BEGIN

					IF EXISTS(	
								SELECT TOP 1 eh.VALOR_ENUMERADO_HISTORICO 
								FROM sistema.enumerado_historico eh
										INNER JOIN sistema.resolucion_enumerado_historico reh on reh.ID_ENUMERADO_HISTORICO = eh.ID_ENUMERADO_HISTORICO
								WHERE RTRIM(LTRIM(eh.VALOR_ENUMERADO_HISTORICO)) 
										COLLATE LATIN1_GENERAL_CI_AI = RTRIM(LTRIM(UPPER(@VALOR_ENUMERADO_HISTORICO))) 
										AND eh.CODIGO_ENUMERADO_HISTORICO_PADRE=@CODIGO_ENUMERADO_HISTORICO_PADRE
										AND reh.NRO_RD=@NRO_RD AND eh.ID_INSTITUCION=@ID_INSTITUCION
										AND ESTADO_ENUMERADO_HISTORICO = 1
							)
						BEGIN
							SET @RESULT = -180 --Datos ya existen
						END
					ELSE
						BEGIN
							BEGIN TRANSACTION T1
								BEGIN TRY
									INSERT INTO sistema.enumerado_historico
											(
												CODIGO_GRUPO_ENUMERADO_HISTORICO,
												CODIGO_ENUMERADO_HISTORICO_PADRE,
												VALOR_ENUMERADO_HISTORICO,
												ESTADO_ENUMERADO_HISTORICO,	
												ID_INSTITUCION,  
												USUARIO_CREACION,
												FECHA_CREACION
											)
									VALUES
											(		  
												(SELECT CODIGO_GRUPO_ENUMERADO_HISTORICO 
												FROM sistema.enumerado_historico 
												WHERE ID_ENUMERADO_HISTORICO=@CODIGO_ENUMERADO_HISTORICO_PADRE), --@CODIGO_GRUPO_ENUMERADO_HISTORICO - int
												@CODIGO_ENUMERADO_HISTORICO_PADRE, --@CODIGO_ENUMERADO_HISTORICO - int
												UPPER(@VALOR_ENUMERADO_HISTORICO), --@VALOR_ENUMERADO_HISTORICO - varchar (150)
												@ESTADO_ENUMERADO_HISTORICO, -- ES_ACTIVO - ESTADO - smallint							  
												@ID_INSTITUCION,
												@USUARIO, -- USUARIO_CREACION - nvarchar
												getdate()  -- FECHA_CREACION - datetime
											)
									DECLARE	@ID_ENUMERADO_HISTORICO int
									SET @ID_ENUMERADO_HISTORICO = SCOPE_IDENTITY()

									INSERT INTO sistema.resolucion_enumerado_historico
											(
											ID_ENUMERADO_HISTORICO,
											NRO_RD,
											ARCHIVO_RD,
											ARCHIVO_RUTA,
											USUARIO_CREACION,
											FECHA_CREACION
											)
									VALUES
											(
											@ID_ENUMERADO_HISTORICO,
											@NRO_RD,
											@ARCHIVO_RD,
											@ARCHIVO_RUTA, 
											@USUARIO, -- USUARIO_CREACION - nvarchar
											getdate()  -- FECHA_CREACION - datetime
											)						
							COMMIT TRANSACTION T1
								SET @RESULT = 1
							END TRY
	   
							BEGIN CATCH
								IF @@ERROR<>0
								BEGIN
									ROLLBACK TRANSACTION T1	   
									SET @RESULT =-1
									PRINT ERROR_MESSAGE()
								END
							END CATCH	
						END
				END					
			--fin regristrar carreras
			ELSE
			-- Registrar Hijos
				BEGIN
					IF EXISTS(	
								SELECT TOP 1 VALOR_ENUMERADO_HISTORICO 
								FROM sistema.enumerado_historico
								WHERE RTRIM(LTRIM(VALOR_ENUMERADO_HISTORICO)) 
								COLLATE LATIN1_GENERAL_CI_AI = RTRIM(LTRIM(UPPER(@VALOR_ENUMERADO_HISTORICO))) 
								AND CODIGO_ENUMERADO_HISTORICO_PADRE=@CODIGO_ENUMERADO_HISTORICO_PADRE	
								AND ESTADO_ENUMERADO_HISTORICO = 1	
							)
						BEGIN
							SET @RESULT = -180 --Datos ya existen
						END
					ELSE
						BEGIN
							INSERT INTO sistema.enumerado_historico
									(
										CODIGO_GRUPO_ENUMERADO_HISTORICO,
										CODIGO_ENUMERADO_HISTORICO_PADRE,
										VALOR_ENUMERADO_HISTORICO,
										ESTADO_ENUMERADO_HISTORICO,		  
										USUARIO_CREACION,
										FECHA_CREACION
									)
							VALUES
									(		  
										(SELECT CODIGO_GRUPO_ENUMERADO_HISTORICO 
										FROM sistema.enumerado_historico 
										WHERE ID_ENUMERADO_HISTORICO=@CODIGO_ENUMERADO_HISTORICO_PADRE), --@CODIGO_GRUPO_ENUMERADO_HISTORICO - int
										@CODIGO_ENUMERADO_HISTORICO_PADRE, --@CODIGO_ENUMERADO_HISTORICO - int
										UPPER(@VALOR_ENUMERADO_HISTORICO), --@VALOR_ENUMERADO_HISTORICO - varchar (150)
										@ESTADO_ENUMERADO_HISTORICO, -- ES_ACTIVO - ESTADO - smallint							  
										@USUARIO, -- USUARIO_CREACION - nvarchar
										getdate()  -- FECHA_CREACION - datetime
									)
							SET @RESULT = 1
						END
				END
			--fin registrar hisjos
		END
END
SELECT @RESULT