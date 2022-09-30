/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de instituciones activas desde la BD db_digepadron a traves de  
						de la BD db_auxiliar
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO     DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR		Creación
1.2			22/10/2019		Freddy H.   Agregamos CODIGO_PROVINCIA para que pueda ser usado por el rol DRE
1.3			10/09/2021		JCHAVEZ		Se agregó TIPO_INSTITUCION_NOMBRE

TEST:     
  EXEC USP_MAESTROS_SEL_INSTITUCION_LISTA
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_INSTITUCION_LISTA]
AS
DECLARE @TIPO_OPCION_MIXTA INT,@TIPO_OPCION_PUBLICO INT,@TIPO_OPCION_PRIVADA INT

BEGIN --> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS 
IF (OBJECT_ID('tempdb.dbo.#temp001','U')) IS NOT NULL DROP TABLE #temp001
END

BEGIN --> #temp001 reemplaza a una vista antigua que obtenia datos de maestro.institucion
	
	SELECT
	  ID_INSTITUCION		AS IdInstitucion,
	  CODIGO_MODULAR		AS CodigoModularIe,
	  CODIGO_PROVINCIA		AS CodigoProvincia,
	  NULL					AS FechaCreacionAutorizacion,
	  NULL					AS NroResolucionCreacionAutorizacion,
	  NULL					AS TipoResolucionCreacionAutorizacion,
	  NULL					AS PeriodoCreacionAutorizacion,
	  NULL					AS FechaRevalidacion,
	  NULL					AS NroResolucionRevalidacion,
	  NULL					AS TipoResolucionRevalidacion,
	  NULL					AS PeriodoRevalidacion,
	  NULL					AS CodigoTipoInstitucion,
	  NOMBRE_INSTITUCION	AS NombreInstituto,
	  NULL					AS NombreGestion,
	  DRE_GRE				AS DireccionRegional,
	  i.TIPO_INSTITUCION_NOMBRE AS NombreTipoInstitucion,

	  TIPO_GESTION			AS IdTipoGestionIe,
	  --CASE WHEN TIPO_GESTION = 10061 THEN 3 WHEN TIPO_GESTION = 10062 THEN 4 END AS IdTipoGestionIe,		--FRAMOS_CAMBIO_PROVISIONAL_VISTA


	  NOMBRE_INSTITUCION	AS NombreInstitucion,
	  CENTRO_POBLADO		AS CentroPoblado,
	  NULL					AS CodigoArea,
	  NULL					AS Area,
	  NULL					AS CodigoTurno,
	  NULL					AS CantidadCarreras,
	  NULL					AS PaginaWeb,
	  NULL					AS Correo,
	  NULL					AS EXPR1,
	  NULL					AS DireccionIe,
	  NULL					AS TieneAdmision,
	  i.HABILITADA			AS Habilitada
	INTO #temp001
	FROM db_auxiliar.dbo.UVW_INSTITUCION AS i

	--SELECT * FROM #temp001
	
END 

SELECT	IdInstitucion			IdInstitucion,
		CodigoProvincia			CodigoProvincia,
		NombreInstitucion		NombreInstitucion,
		CodigoModularIe			CodigoModularIe,		
		TieneAdmision,
		IdTipoGestionIe			TipoGestion,
		NombreTipoInstitucion	NombreTipoInstitucion,
		Habilitada				Habilitada
FROM #temp001
ORDER BY NombreInstitucion ASC
GO


