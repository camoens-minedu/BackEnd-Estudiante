--/************************************************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Seleccionar Las Institucines Educativas
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--	1.0			06/03/2020		JTOVAR          LISTAR IE INACTIVAS
--*/
--*************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_INSTITUCION_BASICA_PAGINADO]
(
	@ID_PAIS							INT,
	@ID_TIPO_GESTION_BASICA				INT,
	@CODIGO_MODULAR_IE					VARCHAR(7),
	@NOMBRE_IE_BASICA					VARCHAR(150),
	@ID_TIPO_IE_BASICA					INT,
	@Niveles 							VARCHAR(10) ='74,75',
	@Pagina								int = 1,
	@Registros							int = 10
)AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
	SET @hasta = ( @Pagina * @Registros ) + 1; 

	DECLARE @EBR INT= 70, @EBA INT=71, @EBE INT =72, @PUBLICO INT =10061, @PRIVADO INT =10062, 
	@INICIAL INT = 73, @PRIMARIA INT =74, @SECUNDARIA INT =75;

	WITH    tempPaginado AS
	(	   
		SELECT *,
			ROW_NUMBER() OVER ( ORDER BY A.IdInstitucionBasica DESC) AS Row,			
			Total = COUNT(1) OVER ( )	
		FROM (
			
			SELECT 
				ISNULL(T1.IdInstitucionBasica,0)						IdInstitucionBasica,
				ISNULL(T1.CodigoModularBasica,T2.CodigoModularBasica)	CodigoModularBasica,
				ISNULL(T2.NombreIeBasica,T1.NombreIeBasica)				NombreIeBasica,
				ISNULL(T2.IdTipoIEBasica,T1.IdTipoIEBasica)				IdTipoIEBasica,
				ISNULL(T2.TipoIEBasica,T1.TipoIEBasica)					TipoIEBasica,
				ISNULL(T2.IdTipoGestionBasica,T1.IdTipoGestionBasica)	IdTipoGestionBasica,
				ISNULL(T2.TipoGestionBasica,T1.TipoGestionBasica)		TipoGestionBasica,
				ISNULL(T2.IdNivelBasica,T1.IdNivelBasica)				IdNivelBasica,
				ISNULL(T2.NivelBasica,T1.NivelBasica)					NivelBasica,
				ISNULL(T2.IdPaisBasica,T1.IdPaisBasica)					IdPaisBasica,
				--ISNULL(T2.PaisBasica,T1.PaisBasica)						PaisBasica,
				CASE WHEN T2.PaisBasica is null then T1.PaisBasica
				else T2.PaisBasica end									PaisBasica,
				ISNULL(T2.CodigoUbigeoBasica,T1.CodigoUbigeoBasica)		CodigoUbigeoBasica,
				ISNULL(T2.DireccionBasica,T1.DireccionBasica)			DireccionBasica

					
			FROM
				(SELECT 
					A.ID_INSTITUCION_BASICA				IdInstitucionBasica,
					A.CODIGO_MODULAR_IE_BASICA			CodigoModularBasica,
					A.NOMBRE_IE_BASICA					NombreIeBasica,
					A.ID_TIPO_INSTITUCION_BASICA		IdTipoIEBasica,
					TI.VALOR_ENUMERADO					TipoIEBasica,
					A.ID_TIPO_GESTION_IE_BASICA			IdTipoGestionBasica,
					TG.VALOR_ENUMERADO					TipoGestionBasica,
					A.ID_NIVEL_IE_BASICA				IdNivelBasica,
					N.VALOR_ENUMERADO					NivelBasica,
					A.ID_PAIS							IdPaisBasica,
					P.DSCPAIS							PaisBasica,
					A.UBIGEO_IE_BASICA					CodigoUbigeoBasica,
					A.DIRECCION_IE_BASICA				DireccionBasica
				FROM 
					maestro.institucion_basica A
					INNER JOIN sistema.enumerado TG ON TG.ID_ENUMERADO = A.ID_TIPO_GESTION_IE_BASICA
					INNER JOIN sistema.enumerado N ON N.ID_ENUMERADO = A.ID_NIVEL_IE_BASICA
					INNER JOIN db_auxiliar.dbo.UVW_PAIS P ON CONVERT(INT,(SUBSTRING(P.CODIGO, 1, 5))) = A.ID_PAIS
					INNER JOIN sistema.enumerado TI ON TI.ID_ENUMERADO = A.ID_TIPO_INSTITUCION_BASICA) T1
				FULL OUTER JOIN
				(SELECT 
					0															IdInstitucionBasica,
					A.CODIGO_MODULAR_IE	COLLATE DATABASE_DEFAULT				CodigoModularBasica, 
					A.NOMBRE_IE	COLLATE LATIN1_GENERAL_CI_AI					NombreIeBasica, 
					CASE WHEN A.NIVEL_IE IN ('E1','E2') THEN @EBE ELSE @EBR END		IdTipoIEBasica,
					TI.VALOR_ENUMERADO											TipoIEBasica,					
					CASE WHEN CONVERT(INT,A.TIPO_GESTION_IE)= 3 
						THEN @PRIVADO  ELSE @PUBLICO END										IdTipoGestionBasica,
					TG.VALOR_ENUMERADO											TipoGestionBasica,
					CASE 
						WHEN A.NIVEL_IE IN ('A1','A2','A3','A5','E1') THEN @INICIAL 
						WHEN A.NIVEL_IE IN ('B0','E2') THEN @PRIMARIA
						WHEN A.NIVEL_IE ='F0' THEN @SECUNDARIA
					    ELSE 0 
					END													        IdNivelBasica,
					N.VALOR_ENUMERADO											NivelBasica,
					92330														IdPaisBasica,
					'PERU'														PaisBasica,
					A.CODIGO_UBIGEO_IE											CodigoUbigeoBasica,
					A.DIRECCION_IE												DireccionBasica
				FROM 
					db_auxiliar.dbo.UVW_INSTITUCION_EDUCATIVA A					
					INNER JOIN sistema.enumerado TG ON TG.ID_ENUMERADO = CASE WHEN CONVERT(INT,A.TIPO_GESTION_IE)= 3 THEN @PRIVADO  ELSE  @PUBLICO END
					INNER JOIN sistema.enumerado N ON N.ID_ENUMERADO =	CASE 
																			WHEN A.NIVEL_IE IN ('A1','A2','A3','A5','E1') THEN @INICIAL 
																			WHEN A.NIVEL_IE IN ('B0','E2') THEN @PRIMARIA
																			WHEN A.NIVEL_IE = 'F0' THEN @SECUNDARIA
																		    ELSE 0
																		END	 
					INNER JOIN sistema.enumerado TI ON TI.ID_ENUMERADO = CASE WHEN A.NIVEL_IE IN ('E1','E2') THEN @EBE ELSE @EBR END
				WHERE 
					NIVEL_IE IN ('B0', 'F0', 'E2')--IN ('A1','A2','A3','A5','B0','F0','E1','E2') --consideramos  primaria y secundaria
					) T2  ON T1.CodigoModularBasica = T2.CodigoModularBasica) A
			WHERE 
				(A.IdPaisBasica = @ID_PAIS OR @ID_PAIS = 0)
				AND (A.IdTipoGestionBasica = @ID_TIPO_GESTION_BASICA OR @ID_TIPO_GESTION_BASICA = 0)
				AND (A.CodigoModularBasica = @CODIGO_MODULAR_IE COLLATE DATABASE_DEFAULT OR @CODIGO_MODULAR_IE = '')
				AND A.NombreIeBasica LIKE '%' + @NOMBRE_IE_BASICA + '%' COLLATE LATIN1_GENERAL_CI_AI
				AND (A.IdTipoIEBasica = @ID_TIPO_IE_BASICA OR @ID_TIPO_IE_BASICA = 0)
				AND A.IdNivelBasica IN (SELECT SplitData FROM dbo.UFN_SPLIT(@Niveles, ', '))
	) 
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END
GO


