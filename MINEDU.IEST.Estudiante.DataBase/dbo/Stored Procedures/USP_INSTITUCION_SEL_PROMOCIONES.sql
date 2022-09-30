CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_PROMOCIONES]
(
    @ID_INSTITUCION INT,
	@ID_PROMOCION INT,
	@ID_VERSION INT,
	@ID_CRITERIO INT,
	@ID_TIPOUD INT,
	@Pagina						int		=1,
	@Registros					int		=10

 --   declare @ID_INSTITUCION INT=2457
	--declare @ID_PROMOCION INT=0
	--declare @ID_VERSION INT=0
	--declare @ID_CRITERIO INT=0
	--declare @ID_TIPOUD INT=0
	--declare @Pagina						int		=1
	--declare @Registros					int		=10

)AS
BEGIN
SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;

	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 
    
	WITH    tempPaginado AS
	(
	SELECT 
		piest.ID_PROMOCION_INSTITUCION_ESTUDIANTE          IdPromocionInstitucionEstudiante,
		enu.ID_ENUMERADO                                   IdTipoPromocion,
		enu.VALOR_ENUMERADO                                TipoPromocion,
		enumerado.ID_ENUMERADO                             IdVersionItinerario,
		enumerado.VALOR_ENUMERADO                          VersionItinerario,
		tud.ID_TIPO_UNIDAD_DIDACTICA                       IdTipoUnidadDidactica,
		tud.NOMBRE_TIPO_UNIDAD                             TipoUD,
		enumera.ID_ENUMERADO                               IdCriterio,
		enumera.VALOR_ENUMERADO                            Criterio,
		piest.VALOR                                        Valor,  
		enumeradoO.VALOR_ENUMERADO                         Estado,
		ROW_NUMBER() OVER ( ORDER BY piest.ID_PROMOCION_INSTITUCION_ESTUDIANTE) AS Row,
		Total = COUNT(1) OVER ( )
		FROM transaccional.promocion_institucion_estudiante piest INNER JOIN sistema.enumerado enu
		ON piest.TIPO_PROMOCION = enu.ID_ENUMERADO INNER JOIN sistema.enumerado enumerado
		ON piest.TIPO_VERSION = enumerado.ID_ENUMERADO INNER JOIN maestro.tipo_unidad_didactica tud
		ON piest.ID_TIPO_UNIDAD_DIDACTICA = tud.ID_TIPO_UNIDAD_DIDACTICA INNER JOIN sistema.enumerado enumera
		ON piest.CRITERIO = enumera.ID_ENUMERADO INNER JOIN sistema.enumerado enumeradoO
		ON piest.ESTADO = enumeradoO.ID_ENUMERADO
		WHERE
		piest.ID_INSTITUCION =	CASE WHEN @ID_INSTITUCION IS NULL	OR	LEN(@ID_INSTITUCION) = 0		OR @ID_INSTITUCION = ''	THEN piest.TIPO_PROMOCION	ELSE @ID_INSTITUCION  END AND		
		piest.TIPO_PROMOCION =	CASE WHEN @ID_PROMOCION IS NULL	OR	LEN(@ID_PROMOCION) = 0		OR @ID_PROMOCION = ''	THEN piest.TIPO_PROMOCION	ELSE @ID_PROMOCION	END AND
		piest.TIPO_VERSION = CASE WHEN @ID_VERSION IS NULL	OR	LEN(@ID_VERSION) = 0		OR @ID_VERSION = ''	THEN piest.TIPO_VERSION	ELSE @ID_VERSION	END AND
		piest.CRITERIO = CASE WHEN @ID_CRITERIO IS NULL	OR	LEN(@ID_CRITERIO) = 0		OR @ID_CRITERIO = ''	THEN piest.CRITERIO	ELSE @ID_CRITERIO	END AND
		piest.ID_TIPO_UNIDAD_DIDACTICA = CASE WHEN @ID_TIPOUD IS NULL	OR	LEN(@ID_TIPOUD) = 0		OR @ID_TIPOUD = ''	THEN piest.ID_TIPO_UNIDAD_DIDACTICA	ELSE @ID_TIPOUD	END 
		AND piest.ES_ACTIVO = 1

	)
	SELECT  *
    FROM    tempPaginado T   WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)
	
END
GO


