/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	05/04/2021
LLAMADO POR			:
DESCRIPCION			:	Listar instituciones para asignación de carga masiva
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		05/04/2021		JCHAVEZ			Creación
--  TEST:  
--			dbo.USP_MAESTROS_SEL_ASIGNACION_CARGA_INSTITUCION '','',1,10
**********************************************************************************************************/
CREATE PROCEDURE dbo.USP_MAESTROS_SEL_ASIGNACION_CARGA_INSTITUCION (
	@CODIGO_MODULAR VARCHAR(7),
	@NOMBRE_INSTITUCION VARCHAR(100),
	@Pagina INT,
	@Registros INT
)
AS
BEGIN
	DECLARE @desde INT , @hasta INT

	SET @desde = ( @Pagina - 1 ) * @Registros;
	SET @hasta = ( @Pagina * @Registros ) + 1; 

	WITH tempPaginado AS
	(
		SELECT i.ID_INSTITUCION IdInstitucion,
			i.CODIGO_MODULAR CodigoModular,
			i.NOMBRE_INSTITUCION NombreInstitucion,
			i.TIPO_GESTION_NOMBRE TipoGestion,
			(CASE ISNULL(aic.ESTADO,0) WHEN 1 THEN 'ASIGNADO' ELSE 'SIN ASIGNAR' END) Estado,
			CAST((CASE ISNULL(aic.ESTADO,0) WHEN 1 THEN 0 ELSE 1 END) AS BIT) VerAsignar,
			ROW_NUMBER() OVER ( ORDER BY i.NOMBRE_INSTITUCION) AS Row,
			Total = COUNT(1) OVER ( )	
		FROM db_auxiliar.dbo.UVW_INSTITUCION i
		LEFT JOIN transaccional.asignación_institucion_carga aic ON i.ID_INSTITUCION = aic.ID_INSTITUCION AND aic.ES_ACTIVO = 1
		WHERE 
			i.CODIGO_MODULAR LIKE @CODIGO_MODULAR + '%' AND
			i.NOMBRE_INSTITUCION LIKE '%' + UPPER(@NOMBRE_INSTITUCION) + '%'
	)
	SELECT  *
    FROM    tempPaginado T
    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
END