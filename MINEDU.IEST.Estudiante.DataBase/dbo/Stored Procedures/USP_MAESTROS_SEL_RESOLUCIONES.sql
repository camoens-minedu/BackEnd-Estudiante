--/**********************************************************************************************************
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	20/06/2019
--LLAMADO POR			:
--DESCRIPCION			:	Listado de resoluciones
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
----  TEST:		USP_MAESTROS_SEL_RESOLUCIONES '',1033,5560,0	
--/*
--	1.0			20/11/2019		MALVA          MODIFICACIÓN PARA LISTAR RESOLUCIONES SEGÚN PERIODO LECTIVO. 
--*/
--**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_RESOLUCIONES] 
(
    @NUMERO_RESOLUCION				nvarchar(50)='',
	@ID_INSTITUCION					int,
	@ID_PERIODO_LECTIVO_INSTITUCION int,
	@ID_TIPO_RESOLUCION				int,

	--@ID_ENUMERADO_ESTADO			int,
	@Pagina							int		=1,
	@Registros						int		=10
 )
 AS
 BEGIN
	SET NOCOUNT ON;
	DECLARE @desde INT , @hasta INT, @ID_PERIODO_LECTIVO INT, @ANIO INT
	
	SELECT @ID_PERIODO_LECTIVO = ID_PERIODO_LECTIVO FROM transaccional.periodos_lectivos_por_institucion WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
	SELECT @ANIO = ANIO FROM maestro.periodo_lectivo WHERE ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO
	

	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1;     
	WITH    tempPaginado AS
	(

	   SELECT	r.ID_RESOLUCION			IdResolucion, 
				pl.ID_PERIODO_LECTIVO	IdPeriodoLectivo, 
				r.NUMERO_RESOLUCION		NumeroResolucion, 
				r.ARCHIVO_RESOLUCION	ArchivoResolucion, 
				r.ID_TIPO_RESOLUCION	IdTipoResolucion,
				--dbo.UFN_CONCAT_resolucion_institucion(r.ID_RESOLUCION) IdInstituciones,
				dbo.UFN_CONCAT_resolucion_carreras (r.ID_RESOLUCION) IdCarrerasInstitucion,
				(SELECT e.VALOR_ENUMERADO  from sistema.enumerado e where e.ID_ENUMERADO=r.ID_TIPO_RESOLUCION) AS TipoResolucion,
				r.ESTADO ,
				CASE WHEN (SELECT ID_PERIODOS_LECTIVOS_POR_INSTITUCION FROM transaccional.resoluciones_por_periodo_lectivo_institucion WHERE ID_RESOLUCION=r.ID_RESOLUCION AND ES_ACTIVO=1 ) =@ID_PERIODO_LECTIVO_INSTITUCION THEN 1 ELSE 0 END EsPeriodoLectivoActual,
				ROW_NUMBER() OVER ( ORDER BY r.ID_RESOLUCION) AS Row,
				Total = COUNT(1) OVER ( )
	   FROM	maestro.resolucion r 
				INNER JOIN transaccional.resoluciones_por_periodo_lectivo_institucion ri ON r.ID_RESOLUCION = ri.ID_RESOLUCION
				INNER JOIN transaccional.periodos_lectivos_por_institucion plxi on plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = ri.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
				INNER JOIN maestro.periodo_lectivo pl on pl.ID_PERIODO_LECTIVO = plxi.ID_PERIODO_LECTIVO
		WHERE	r.ESTADO = 1 AND ri.ES_ACTIVO = 1 AND plxi.ES_ACTIVO = 1 AND pl.ESTADO = 1
				AND plxi.ESTADO IN (6,7,8)
				AND plxi.ID_INSTITUCION = @ID_INSTITUCION
				AND ((r.ID_TIPO_RESOLUCION = 21 AND pl.ANIO = @ANIO) OR (r.ID_TIPO_RESOLUCION = 22 AND pl.ANIO = @ANIO) 
				OR (r.ID_TIPO_RESOLUCION <> 21 and r.ID_TIPO_RESOLUCION <> 22))				
				AND ISNULL(r.NUMERO_RESOLUCION,'') LIKE '%' + ISNULL(@NUMERO_RESOLUCION,'') + '%' COLLATE LATIN1_GENERAL_CI_AI
				AND (r.ID_TIPO_RESOLUCION= @ID_TIPO_RESOLUCION OR @ID_TIPO_RESOLUCION=0)
				AND r.ID_TIPO_RESOLUCION in (21,22)
				AND plxi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODO_LECTIVO_INSTITUCION
)
	SELECT  *
    FROM    tempPaginado T
    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)    
END
GO


