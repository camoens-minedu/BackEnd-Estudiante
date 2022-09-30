/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene los registros de las sedes de una institución
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			CREACIÓN
2.0			04/04/2022		JCHAVEZ			SE AGREGÓ CAMPO RESOLUCIÓN

TEST:			
	USP_MAESTROS_SEL_SEDE_INSTITUCION_LISTA_PAGINADO 1911,'',0
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_SEDE_INSTITUCION_LISTA_PAGINADO] 
( 
	@ID_INSTITUCION			INT,
	@NOMBRE_SEDE			VARCHAR (150),
	@ID_TIPO_SEDE			INT,
	@Pagina					int = 1,
	@Registros				int = 10
)  
AS  
BEGIN  
	SET NOCOUNT ON;
	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1;  
	   
	   	WITH    tempPaginado AS
	(	   
		SELECT 
			msi.ID_SEDE_INSTITUCION		     IdSedeInstitucion,
			msi.NOMBRE_SEDE				     NombreActual,
			msi.ID_TIPO_SEDE			     IdTipoSede,
			se.VALOR_ENUMERADO			     TipoSede,		
			ubi.DEPARTAMENTO_UBIGEO		     Departamento,
			ubi.PROVINCIA_UBIGEO		     Provincia,
			ubi.DISTRITO_UBIGEO			     Distrito,
			msi.DIRECCION_SEDE			     DireccionActual,
			msi.CODIGO_UBIGEO_SEDE		    UbigeoSede,
			msi.CODIGO_SEDE				    CodigoSede,
			msi.DIRECTOR_SEDE			    Director,
			msi.TELEFONO_SEDE			    TelefonoSede,
			msi.CORREO_SEDE				    CorreoSede,
			ISNULL(msi.NRO_RESOLUCION,'')	NroResolucion,
			ISNULL(msi.ARCHIVO_RESOLUCION,'')	ArchivoResolucion,
			ROW_NUMBER() OVER ( ORDER BY msi.ID_TIPO_SEDE,msi.NOMBRE_SEDE) AS Row,
			Total = COUNT(1) OVER ( ) 
			FROM 
				maestro.sede_institucion msi INNER JOIN sistema.enumerado se	ON se.ID_ENUMERADO= msi.ID_TIPO_SEDE 
				INNER JOIN db_auxiliar.dbo.UVW_UBIGEO ubi							ON ubi.CODIGO_UBIGEO = msi.CODIGO_UBIGEO_SEDE 
			WHERE 
				((NOMBRE_SEDE LIKE '%' + ISNULL(@NOMBRE_SEDE,'') + '%' COLLATE LATIN1_GENERAL_CI_AI) OR RTRIM(LTRIM(@NOMBRE_SEDE))='')
				AND (ID_TIPO_SEDE = @ID_TIPO_SEDE OR @ID_TIPO_SEDE=0)
				AND 
				msi.ID_INSTITUCION= @ID_INSTITUCION
				AND msi.ES_ACTIVO =1 
	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END  



		--SELECT 
		--	persona.ID_TIPO_DOCUMENTO        IdTipoDocumento,
		--	persona.NUMERO_DOCUMENTO_PERSONA NroDocumento,
		--	msi.ID_SEDE_INSTITUCION		     IdSedeInstitucion,
		--	msi.NOMBRE_SEDE				     NombreActual,
		--	msi.ID_TIPO_SEDE			     IdTipoSede,
		--	se.VALOR_ENUMERADO			     TipoSede,		
		--	ubi.DEPARTAMENTO_UBIGEO		     Departamento,
		--	ubi.PROVINCIA_UBIGEO		     Provincia,
		--	ubi.DISTRITO_UBIGEO			     Distrito,
		--	msi.DIRECCION_SEDE			     DireccionActual,
		--	msi.CODIGO_UBIGEO_SEDE		    UbigeoSede,
		--	msi.CODIGO_SEDE				    CodigoSede,
		--	msi.DIRECTOR_SEDE			    Director,
		--	msi.TELEFONO_SEDE			    TelefonoSede,
		--	msi.CORREO_SEDE				    CorreoSede,
		--	ROW_NUMBER() OVER ( ORDER BY msi.NOMBRE_SEDE) AS Row,
		--		Total = COUNT(1) OVER ( )
		--FROM	
		--	maestro.sede_institucion msi
		--	INNER JOIN sistema.enumerado se on se.ID_ENUMERADO= msi.ID_TIPO_SEDE 
		--	INNER JOIN db_auxiliar.dbo.UVW_UBIGEO ubi ON ubi.CODIGO_UBIGEO = msi.CODIGO_UBIGEO_SEDE
		--	INNER JOIN maestro.personal_institucion personalinst ON msi.ID_PERSONAL_INSTITUCION = personalinst.ID_PERSONAL_INSTITUCION
		--	INNER JOIN maestro.persona_institucion pinstitucion ON personalinst.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION
		--	INNER JOIN maestro.persona persona ON pinstitucion.ID_PERSONA = persona.ID_PERSONA

		--WHERE 
		--	((NOMBRE_SEDE LIKE '%' + ISNULL(@NOMBRE_SEDE,'') + '%' COLLATE LATIN1_GENERAL_CI_AI) OR RTRIM(LTRIM(@NOMBRE_SEDE))='')
		--	AND (ID_TIPO_SEDE = @ID_TIPO_SEDE OR @ID_TIPO_SEDE=0)
		--	AND msi.ID_INSTITUCION= @ID_INSTITUCION
		--	AND msi.ES_ACTIVO =1 AND personalinst.ES_ACTIVO=1	

		--//***********************************************************************

		--SELECT 
		--	IdTipoDocumento = 	(SELECT persona.ID_TIPO_DOCUMENTO FROM maestro.personal_institucion pinstitucion INNER JOIN maestro.persona_institucion personaInsti
		--	ON pinstitucion.ID_PERSONA_INSTITUCION = personaInsti.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona persona
		--	ON personaInsti.ID_PERSONA = persona.ID_PERSONA
		--	WHERE pinstitucion.ID_PERSONAL_INSTITUCION=personalinst.ID_PERSONAL_INSTITUCION),

		--	NroDocumento =  (SELECT persona.NUMERO_DOCUMENTO_PERSONA FROM maestro.personal_institucion pinstitucion INNER JOIN maestro.persona_institucion personaInsti
		--	ON pinstitucion.ID_PERSONA_INSTITUCION = personaInsti.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona persona
		--	ON personaInsti.ID_PERSONA = persona.ID_PERSONA
		--	WHERE pinstitucion.ID_PERSONAL_INSTITUCION=personalinst.ID_PERSONAL_INSTITUCION),

		--	msi.ID_SEDE_INSTITUCION		     IdSedeInstitucion,
		--	msi.NOMBRE_SEDE				     NombreActual,
		--	msi.ID_TIPO_SEDE			     IdTipoSede,
		--	se.VALOR_ENUMERADO			     TipoSede,		
		--	ubi.DEPARTAMENTO_UBIGEO		     Departamento,
		--	ubi.PROVINCIA_UBIGEO		     Provincia,
		--	ubi.DISTRITO_UBIGEO			     Distrito,
		--	msi.DIRECCION_SEDE			     DireccionActual,
		--	msi.CODIGO_UBIGEO_SEDE		    UbigeoSede,
		--	msi.CODIGO_SEDE				    CodigoSede,
		--	msi.DIRECTOR_SEDE			    Director,
		--	msi.TELEFONO_SEDE			    TelefonoSede,
		--	msi.CORREO_SEDE				    CorreoSede,
		--	ROW_NUMBER() OVER ( ORDER BY msi.NOMBRE_SEDE) AS Row,
		--	Total = COUNT(1) OVER ( ) 
		--	FROM maestro.sede_institucion msi INNER JOIN sistema.enumerado se 
		--	ON se.ID_ENUMERADO= msi.ID_TIPO_SEDE INNER JOIN db_auxiliar.dbo.UVW_UBIGEO ubi 
		--	ON ubi.CODIGO_UBIGEO = msi.CODIGO_UBIGEO_SEDE LEFT JOIN maestro.personal_institucion personalinst 
		--	ON msi.ID_PERSONAL_INSTITUCION = personalinst.ID_PERSONAL_INSTITUCION
		--	WHERE 
		--	--((NOMBRE_SEDE LIKE '%' + ISNULL(@NOMBRE_SEDE,'') + '%' COLLATE LATIN1_GENERAL_CI_AI) OR RTRIM(LTRIM(@NOMBRE_SEDE))='')
		--	--AND (ID_TIPO_SEDE = @ID_TIPO_SEDE OR @ID_TIPO_SEDE=0)
		--	--AND 
		--	msi.ID_INSTITUCION= @ID_INSTITUCION
		--	AND msi.ES_ACTIVO =1 
		--	--AND personalinst.ES_ACTIVO=1
GO


