/**********************************************************************************************************
AUTOR				:	Luis Espinoza
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el registro de la institución por Id
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

TEST:			
	USP_MAESTROS_SEL_INSTITUCION_ID 1911,'70557821'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_INSTITUCION_ID] 
(
	   @ID_INSTITUCION	    int,
	   @USUARIO_CREACION	Varchar(20)
)
AS

BEGIN --> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS 
IF (OBJECT_ID('tempdb.dbo.#temp001','U')) IS NOT NULL DROP TABLE #temp001
END

BEGIN --> #temp001 reemplaza a una vista antigua que obtenia datos de maestro.institucion
	
	SELECT
		v.ID_INSTITUCION				AS IdInstitucion,
		v.CODIGO_MODULAR				AS CodigoModularIe,
		v.NOMBRE_INSTITUCION			AS NombreInstituto,
		v.TIPO_GESTION_NOMBRE			AS NombreGestion,
		v.DRE_GRE						AS DireccionRegional,
		v.TIPO_GESTION					AS IdTipoGestionIe,															--FRAMOS_CAMBIO_PROVISIONAL_VISTA
		v.NOMBRE_INSTITUCION			AS NombreInstitucion,
		v.CENTRO_POBLADO				AS CentroPoblado,
		v.TIPO_INSTITUCION_NOMBRE		AS NombreTipoInstitucion,				
		v.REALIZA_ADMISION				AS TieneAdmision,															--FRAMOS_CAMBIO_PROVISIONAL_VISTA		
		v.PERMITE_ADMISION				AS PermiteAdmision,
		NULL							AS FechaCreacionAutorizacion,				--EliminadoTablaMaestroInstitucion: FECHA_CREACION_AUTORIZACION
		NULL							AS NroResolucionCreacionAutorizacion,		--EliminadoTablaMaestroInstitucion: NRO_RESOLUCION_CREACION_AUTORIZACION
		NULL							AS TipoResolucionCreacionAutorizacion,		--EliminadoTablaMaestroInstitucion: TIPO_RESOLUCION_CREACION_AUTORIZACION
		NULL							AS PeriodoCreacionAutorizacion,
		NULL							AS FechaRevalidacion,						--EliminadoTablaMaestroInstitucion: FECHA_REVALIDACION
		NULL							AS NroResolucionRevalidacion,				--EliminadoTablaMaestroInstitucion: NRO_RESOLUCION_REVALIDACION
		NULL							AS TipoResolucionRevalidacion,				--EliminadoTablaMaestroInstitucion: TIPO_RESOLUCION_REVALIDACION
		NULL							AS PeriodoRevalidacion,						--EliminadoTablaMaestroInstitucion: PERIODO_REVALIDACION
		NULL							AS CodigoTipoInstitucion,					--EliminadoTablaMaestroInstitucion: CODIGO_TIPO_INSTITUCION		
		NULL							AS CodigoArea,								--EliminadoTablaMaestroInstitucion: COD_AREA_IE
		NULL							AS Area,									--EliminadoTablaMaestroInstitucion: DSC_COD_AREA_IE
		NULL							AS CodigoTurno,								--EliminadoTablaMaestroInstitucion: COD_TUR_IE
		NULL							AS CantidadCarreras,						--EliminadoTablaMaestroInstitucion: CANTIDAD_CARRERAS_INSTITUCION
		ISNULL(v.DIRECCION,		'')		AS DireccionIe,
		ISNULL(v.PAGINA_WEB,	'')		AS PaginaWeb,
		ISNULL(v.EMAIL,			'')		AS Correo,
		ISNULL(v.TELEFONO,		'')		AS Telefono,
		ISNULL(v.CELULAR,		'')		AS Celular
	INTO #temp001
	FROM 
		db_auxiliar.dbo.UVW_INSTITUCION v
	
END 

	SELECT 
		ID_INSTITUCION AS IdInstitucion,
		CodigoModularIe,
		
		NombreGestion,
		DireccionRegional,
		IdTipoGestionIe,
		NombreInstitucion,
		A.CentroPoblado,
		NombreTipoInstitucion,
		ISNULL(A.TieneAdmision,CONVERT(Bit, 'False'))		AS TieneAdmision,			--B.ADMISION TieneAdmision,				--FRAMOS_CAMBIO_PROVISIONAL_VISTA
		PermiteAdmision,
		FechaCreacionAutorizacion,			
		NroResolucionCreacionAutorizacion,
		TipoResolucionCreacionAutorizacion,
		isnull(cast(PeriodoCreacionAutorizacion as int),0)	AS PeriodoCreacionAutorizacion,			
		FechaRevalidacion,
		NroResolucionRevalidacion,
		TipoResolucionRevalidacion,
		isnull(cast(PeriodoRevalidacion as int),null)		AS PeriodoRevalidacion,
		CodigoTipoInstitucion,		
		A.PaginaWeb,
		A.Correo,
		A.Telefono											AS Telefono,								--A.Telefono,
		A.DireccionIe,
		A.Celular											AS CELULAR,										--B.CELULAR,			
		''													AS KeyLogoIe,									--B.KEY_LOGO_IE as KeyLogoIe,
		''													AS NombreArchivoLogoIe,							--B.NOMBRE_ARCHIVO_LOGO_IE  as NombreArchivoLogoIe,
		''													AS DirectorNombre,								--B.DIRECTOR_NOMBRE as DirectorNombre,		
		U.DEPARTAMENTO_UBIGEO as DepartamentoUbigeo,
		U.PROVINCIA_UBIGEO as ProvinciaUbigeo,
		U.DISTRITO_UBIGEO as DistritoUbigeo
	FROM #temp001 A
		INNER JOIN db_auxiliar.dbo.UVW_INSTITUCION B ON (A.CodigoModularIe = B.CODIGO_MODULAR)	
		INNER JOIN db_auxiliar.dbo.UVW_UBIGEO U on (B.CODIGO_DISTRITO = U.CODIGO_UBIGEO)
	WHERE 
		B.ID_INSTITUCION=@ID_INSTITUCION
GO


