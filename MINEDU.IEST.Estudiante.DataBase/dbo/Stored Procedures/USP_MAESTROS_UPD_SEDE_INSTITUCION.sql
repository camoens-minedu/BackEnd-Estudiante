/************************************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Actualización de registro de sede institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		MALVA			CREACIÓN
1.1			16/12/2019		MALVA			MODIFICACIÓN DE CÓDIGO DE SEDE EXISTENTE, SE CONSULTA SI EXISTE A NIVEL DE INSTITUTO Y QUE NO SE REPITA CÓDIGO NI NOMBRE DE SEDE.
2.0			04/04/2022		JCHAVEZ			SE AGREGÓ NUEVO CAMPO RESOLUCIÓN

TEST:		
	USP_MAESTROS_UPD_SEDE_INSTITUCION 897, '492623', '24 DE JULIO DE LA CRUz', '240101', 'AV. 24 DE JULIO DE LA CRUZ', 'GENARO MARQUEZ', '1234567', 'ist24_julio_sede7@gmail.como', 205, 'MALVA'
*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_UPD_SEDE_INSTITUCION]
(  
	@ID_SEDE_INSTITUCION		INT, 
	@CODIGO_SEDE				VARCHAR(7),
	@NOMBRE_SEDE				VARCHAR(150),
	@CODIGO_UBIGEO_SEDE			VARCHAR(6),
	@DIRECCION_SEDE				VARCHAR(255),
	--@DIRECTOR_SEDE				VARCHAR(150),
	@TELEFONO_SEDE				VARCHAR(15),
	@CORREO_SEDE				VARCHAR(100),
	@ID_TIPO_SEDE				INT,
	@NRO_RESOLUCION				VARCHAR(50),
	@ARCHIVO_RESOLUCION			VARCHAR(100),
    @RUTA_RESOLUCION			VARCHAR(300),
	@USUARIO					VARCHAR(20)
)  
AS 

DECLARE @RESULT INT,
		@ID_TIPO_SEDE_PRINCIPAL INT = 203,
		@ID_INSTITUCION INT

		SET @ID_INSTITUCION = (SELECT ID_INSTITUCION FROM maestro.sede_institucion WHERE ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION)

 IF EXISTS(SELECT TOP 1 CODIGO_SEDE FROM maestro.sede_institucion WHERE (CODIGO_SEDE =@CODIGO_SEDE OR NOMBRE_SEDE = @NOMBRE_SEDE)  AND ID_SEDE_INSTITUCION <> @ID_SEDE_INSTITUCION AND ID_INSTITUCION= @ID_INSTITUCION AND ES_ACTIVO=1)
	SET @RESULT = -180  
 ELSE 
	IF EXISTS (SELECT TOP 1 CODIGO_SEDE FROM maestro.sede_institucion WHERE ES_SEDE_PRINCIPAL=1 AND ID_SEDE_INSTITUCION <> @ID_SEDE_INSTITUCION AND ES_ACTIVO=1 AND @ID_TIPO_SEDE=@ID_TIPO_SEDE_PRINCIPAL
	AND ID_INSTITUCION= @ID_INSTITUCION)
		SET @RESULT = -145  
	ELSE
	BEGIN
		UPDATE maestro.sede_institucion
		SET	CODIGO_SEDE			=	UPPER(@CODIGO_SEDE),
			NOMBRE_SEDE			=	UPPER(@NOMBRE_SEDE), 
			CODIGO_UBIGEO_SEDE	=	RIGHT(REPLICATE('0',6) + @CODIGO_UBIGEO_SEDE,6),
			DIRECCION_SEDE		=	UPPER(@DIRECCION_SEDE),
			--DIRECTOR_SEDE		=	UPPER(@DIRECTOR_SEDE),
			TELEFONO_SEDE		=	@TELEFONO_SEDE,
			CORREO_SEDE			=	@CORREO_SEDE,
			ES_SEDE_PRINCIPAL	=	CASE WHEN @ID_TIPO_SEDE = @ID_TIPO_SEDE_PRINCIPAL THEN 1 ELSE 0 END,
			ID_TIPO_SEDE		=	@ID_TIPO_SEDE,
			NRO_RESOLUCION		=	UPPER(@NRO_RESOLUCION),
			ARCHIVO_RESOLUCION	=	@ARCHIVO_RESOLUCION,
			ARCHIVO_RUTA		=	@RUTA_RESOLUCION,
			USUARIO_MODIFICACION=	@USUARIO,
			FECHA_MODIFICACION	=	GETDATE()		
		WHERE 
			ID_SEDE_INSTITUCION	=	@ID_SEDE_INSTITUCION		

		SET @RESULT = 1
	END  
SELECT @RESULT
GO


