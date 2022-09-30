-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		27/09/2018
--  ACTUALIZACION:	
--					Se modificó el valor 443 por @ID_INSTITUCION por error al subir plan de estudios por asignatura. MALVA.18/02/2019 
--					Se modificó para que se considera la columna ES_ACTIVO de plan_estudios. MALVA. 05/09/2019
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	VALIDA SI LA EXISTENCIA DE UN PLAN DE ESTUDIOS A REGISTRAR
--  REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--  VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		USP_INSTITUCION_SEL_PLAN_ESTUDIO_EXISTENTE 394, 'FABRICACIÓN DE PRENDAS DE VESTIR', 'POR ASIGNATURA'
--/*
--	1.0			07/01/2020		MALVA          MODIFICACIÓN SE AGREGA FILTRO @PLAN_ESTUDIOS.
--*/
--*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_PLAN_ESTUDIO_EXISTENTE]  
(  
--	--@QUERY_EXCEL NVARCHAR(MAX),	
	--//
	--DECLARE @ID_INSTITUCION			INT=443
	--DECLARE @PROGRAMA_ESTUDIOS		VARCHAR(200)='DISEÑO WEB'
	--DECLARE @TIPO_ITINERARIO		VARCHAR(200)='MODULAR'	

	@ID_INSTITUCION			INT,
	@PROGRAMA_ESTUDIOS		VARCHAR(200),
	@TIPO_ITINERARIO		VARCHAR(200), 
	@PLAN_ESTUDIOS			VARCHAR(150)
)  
AS  
BEGIN  

	--Begin --> DECLARACION DE VARIABLES
		DECLARE @ID_CARRERA											INT							
		DECLARE @ID_TIPO_ITINERARIO									INT
		DECLARE @ID_CARRERAS_POR_INSTITUCION						INT
		DECLARE @CODIGO_ENUMERADO_TIPO_ITINERARIO					INT = 33					--//Itinerario en tabla enumerados es 33 

		DECLARE @ITINERARIO_POR_ASIGNATURA							INT = 99					--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 33
		DECLARE @ITINERARIO_TRANSVERSAL								INT	= 100					--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 33
		DECLARE @ITINERARIO_MODULAR									INT	= 101					--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 33

		DECLARE @VALORITINERARIO                                    INT
		DECLARE @RESULT INT

	--End
	
	SET @VALORITINERARIO = (SELECT e.ID_ENUMERADO FROM sistema.enumerado e
	WHERE UPPER(e.VALOR_ENUMERADO) = UPPER(@TIPO_ITINERARIO))
	


	IF (EXISTS (SELECT TOP 1 pestudios.ID_PLAN_ESTUDIO FROM transaccional.carreras_por_institucion cpi
				INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA							
				INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO 
				INNER JOIN transaccional.plan_estudio pestudios ON cpi.ID_CARRERAS_POR_INSTITUCION = pestudios.ID_CARRERAS_POR_INSTITUCION
			WHERE 1 = 1 

				AND	cpi.ID_INSTITUCION =		@ID_INSTITUCION							
				--AND LTRIM( RTRIM( UPPER(c.NOMBRE_CARRERA))) =	LTRIM(RTRIM(UPPER(@PROGRAMA_ESTUDIOS)))
				--AND cpi.ID_TIPO_ITINERARIO =	@VALORITINERARIO
				AND LTRIM( RTRIM( UPPER(pestudios.NOMBRE_PLAN_ESTUDIOS))) =	LTRIM(RTRIM(UPPER(@PLAN_ESTUDIOS)))
				AND cpi.ES_ACTIVO =				1				
				AND enum.ESTADO =				1 and cpi.ES_ACTIVO=1 and pestudios.ES_ACTIVO=1 ))
	BEGIN
		SET @RESULT = 0 --ya existe
	END
	ELSE
		SET @RESULT = 1 -- no existe

	SELECT @RESULT
	END

--**************************************************************************************
--60. USP_INSTITUCION_INS_PLAN_ESTUDIO.sql
GO


