/*
CREADO POR: MANUEL RUIZ
FECHA: 11/05/2017
TEST:
	[USP_MAESTROS_SEL_AULA_PAGINADO] @ID_INSTITUCION=697, @NUMERO_AULA='a' ,@Registros=100, @ID_SEDE_INSTITUCION=2 , @ID_CATEGORIA=10, @UBICACION='chi' ,@NUMERO_AULA='111'
*/

CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_AULA_PAGINADO]
(
    @ID_INSTITUCION			int,
	@ID_SEDE_INSTITUCION	int = 0,
	@CATEGORIA_AULA			int = 0,
	@NUMERO_AULA			VARCHAR(10)='',
	@AFORO_AULA				SMALLINT = 0,
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
		SELECT	a.ID_SEDE_INSTITUCION	IdSedeInstitucion,
				(SELECT TOP 1 NOMBRE_SEDE FROM maestro.sede_institucion where ID_SEDE_INSTITUCION = a.ID_SEDE_INSTITUCION) SedeInstitucion,
				a.ID_AULA				IdAula,
				a.NOMBRE_AULA			NumeroAula,
				a.AFORO_AULA			Aforo,
				a.CATEGORIA_AULA		IdTipoAula,
				ta.VALOR_ENUMERADO		TipoAula,				
				a.ID_PISO				IdPiso,
				pa.VALOR_ENUMERADO		Piso,
				a.UBICACION_AULA		Ubicacion,
				a.OBSERVACION_AULA		Observacion,
				ROW_NUMBER() OVER ( ORDER BY a.ID_AULA) AS Row,
				Total = COUNT(1) OVER ( )
		FROM	maestro.aula a
				LEFT JOIN sistema.enumerado ta ON a.CATEGORIA_AULA = ta.ID_ENUMERADO
				LEFT JOIN sistema.enumerado pa ON a.ID_PISO = pa.ID_ENUMERADO
		WHERE	ID_SEDE_INSTITUCION IN (SELECT ID_SEDE_INSTITUCION FROM maestro.sede_institucion WHERE ID_INSTITUCION = @ID_INSTITUCION AND ES_ACTIVO = 1)
				AND (a.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION = 0)
				AND (a.CATEGORIA_AULA = @CATEGORIA_AULA OR @CATEGORIA_AULA = 0)
				AND (a.NOMBRE_AULA LIKE '%'+@NUMERO_AULA + '%' COLLATE LATIN1_GENERAL_CI_AI OR @NUMERO_AULA = '')
				AND (a.AFORO_AULA = @AFORO_AULA OR @AFORO_AULA = 0)
				AND a.ES_ACTIVO = 1
	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
	 
END
GO


