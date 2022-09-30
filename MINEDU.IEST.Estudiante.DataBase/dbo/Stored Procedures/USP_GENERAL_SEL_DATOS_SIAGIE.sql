--/**********************************************************************************************************************************
--AUTOR				:	Fernando Ramos
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Consulta a datos del estudiante en SIAGIE
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		
--/*
--	1.0			07/02/2020		MALVA          SE CONSIDERA UN VALOR EN AÑO DE EGRESO SOLO SI EL ESTUDIANTE HA SIDO PROMOVIDO.  
--  1.1			14/05/2020		MALVA		   SE FILTRA LA CONSULTA DE SIAGIE PARA QUE NO RETORNE NIVEL D0.
--  1.2			09/04/2021		JCHAVEZ		   SE FILTRA LA CONSULTA DE SIAGIE PARA QUE NO RETORNE NIVEL D0,D1,D2.
--*/
--************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_GENERAL_SEL_DATOS_SIAGIE](
	
	@ID_TIPO_DOCUMENTO	INT,
	@NUMERO_DOCUMENTO	VARCHAR(15), 
	@NIVEL				VARCHAR(10)

	--DECLARE @ID_TIPO_DOCUMENTO	INT=26
	--DECLARE @NUMERO_DOCUMENTO	VARCHAR(15)='75689273'
	--DECLARE @NIVEL				VARCHAR(10)='F0'
)
AS
BEGIN
	DECLARE  @ID_TIPO_DOCUMENTO_SIAGIE INT

	DECLARE @EBR INT= 70, @EBE INT =72
	DECLARE @NIVEL_FINAL CHAR(2) = 'F0';	--> Secundaria
	DECLARE @GRADO_FINAL CHAR(2) = '14'	--> 5to Año
	--Cambio de valor tipo de documento
	IF @ID_TIPO_DOCUMENTO = 26 BEGIN SET @ID_TIPO_DOCUMENTO_SIAGIE = 2 END	--> SIAGIE: Documento Nacional de Identidad = 2
	IF @ID_TIPO_DOCUMENTO = 27 BEGIN SET @ID_TIPO_DOCUMENTO_SIAGIE = 6 END	--> SIAGIE: Carnet de Extranjería = 6
	IF @ID_TIPO_DOCUMENTO = 28 BEGIN SET @ID_TIPO_DOCUMENTO_SIAGIE = 5 END	--> SIAGIE: Pasaporte = 5
	IF @ID_TIPO_DOCUMENTO = 317 BEGIN SET @ID_TIPO_DOCUMENTO_SIAGIE = 9 END --> SIAGIE: Otro = 9

	--Valida antes de crear mi tabla temporal
	IF (OBJECT_ID('tempdb.dbo.#tmpVista','U')) IS NOT NULL
	DROP TABLE #tmpVistaT

	--Inserta los datos devueltos en una tabla temporal
	SELECT 
	* 
	INTO #tmpVistaT
	FROM db_auxiliar.dbo.UVW_REGIA_ESTUDIANTE_ULT_ANIO
	WHERE	
		DNI = @NUMERO_DOCUMENTO
		AND TIPO_DOCUMENTO = @ID_TIPO_DOCUMENTO_SIAGIE
		--AND ID_NIVEL <>'D0'
		AND ID_NIVEL NOT IN ('D0','D1','D2') --NO EBA

		SELECT 
				CASE	WHEN ID_NIVEL ='E2' and @NIVEL = ''	THEN @EBE 
						WHEN ID_NIVEL ='B0' and @NIVEL = ''	THEN @EBR
						WHEN ID_NIVEL ='F0'					THEN @EBR
						ELSE 0 END										IdTipoIEBasica,
				ISNULL(COD_MOD,'')										CodigoModularBasica,
				CASE    WHEN ID_NIVEL  = @NIVEL_FINAL 
						AND ID_GRADO = @GRADO_FINAL AND PROMOVIDO = 1	
						THEN ID_ANIO ELSE '' END						AnioEgreso,
				ID_ANIO													AnioMatriculaUlt,
				ID_NIVEL												IdNivelUlt,
				ID_GRADO												IdGradoActualUlt,
				convert(bit, PROMOVIDO)									Promovido
		FROM #tmpVistaT		
		
DROP TABLE #tmpVistaT
END
GO


