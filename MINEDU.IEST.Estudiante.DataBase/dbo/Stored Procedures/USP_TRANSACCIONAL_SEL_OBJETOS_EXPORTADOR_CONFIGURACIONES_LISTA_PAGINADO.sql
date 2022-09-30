-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		04/06/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	OBTIENE LA LISTA DE TODOS LOS REGISTROS DE CONFIGURACION DE LA EXPORTACION DE DATOS

--  TEST:			
/*
EXEC USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR_CONFIGURACIONES_LISTA_PAGINADO 1911, '', 0, 1, 10
*/
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR_CONFIGURACIONES_LISTA_PAGINADO]
(
	@ID_INSTITUCION			INT,
	@NOMBRE_CONFIGURACION	VARCHAR(100),
	@ID_EXPORTADOR_DATOS	INT,
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
			--*****transaccional.exportador_datos_configuracion edc
			IdExportadorDatosConfiguracionEDC		= edc.ID_EXPORTADOR_DATOS_CONFIGURACION,
			IdExportadorDatosEDC					= edc.ID_EXPORTADOR_DATOS,
			IdInstitucionEDC						= edc.ID_INSTITUCION,
			NombreConfiguracionEDC					= UPPER(edc.NOMBRE_CONFIGURACION),
			EsActivoEDC								= edc.ES_ACTIVO,
			EstadoEDC								= edc.ESTADO,
			UsuarioCreacionEDC						= edc.USUARIO_CREACION,
			FechaCreacionEDC						= edc.FECHA_CREACION,
			UsuarioModificacionEDC					= edc.USUARIO_MODIFICACION,
			FechaModificacionEDC					= edc.FECHA_MODIFICACION,
			--*****transaccional.exportador_datos ed
			NombreObjetoED							= UPPER(ed.NOMBRE_OBJETO),
			--*****
			ROW_NUMBER() OVER ( ORDER BY edc.ID_EXPORTADOR_DATOS_CONFIGURACION) AS Row,
			Total = COUNT(1) OVER ( )
		FROM transaccional.exportador_datos_configuracion edc
			INNER JOIN transaccional.exportador_datos ed ON ed.ID_EXPORTADOR_DATOS = edc.ID_EXPORTADOR_DATOS
		WHERE 1 = 1
			AND edc.ID_INSTITUCION = @ID_INSTITUCION --1911
			AND UPPER(edc.NOMBRE_CONFIGURACION) LIKE '%' + UPPER(@NOMBRE_CONFIGURACION) + '%'
			AND edc.ID_EXPORTADOR_DATOS =	CASE WHEN @ID_EXPORTADOR_DATOS IS NULL	OR	LEN(@ID_EXPORTADOR_DATOS) = 0		OR @ID_EXPORTADOR_DATOS = ''	THEN edc.ID_EXPORTADOR_DATOS	ELSE @ID_EXPORTADOR_DATOS	END
			--AND UPPER(ed.NOMBRE_OBJETO) LIKE '%' + UPPER(@NOMBRE_OBJETO) + '%'
			-------
			AND edc.ES_ACTIVO = 1 AND edc.ESTADO = 1
			AND ed.ES_ACTIVO = 1 AND ed.ESTADO = 1
	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
	 
END

--************************************************************************************

/*
UPPER(pe.NOMBRE_PLAN_ESTUDIOS) LIKE '%' + UPPER(@NOMBRE_PLAN_ESTUDIOS) + '%'
AND enum.ID_ENUMERADO =	CASE WHEN @ID_ITINERARIO IS NULL	OR	LEN(@ID_ITINERARIO) = 0		OR @ID_ITINERARIO = ''	THEN enum.ID_ENUMERADO	ELSE @ID_ITINERARIO	END
AND cpi.ID_CARRERA =	CASE WHEN @ID_CARRERA IS NULL		OR	LEN(@ID_CARRERA) = 0		OR @ID_CARRERA = ''		THEN cpi.ID_CARRERA		ELSE @ID_CARRERA	END
AND cpi.ID_INSTITUCION = @ID_INSTITUCION

*/


	--WITH    tempPaginado AS
	--(	   
	--	SELECT	a.ID_SEDE_INSTITUCION	IdSedeInstitucion,
	--			(SELECT TOP 1 NOMBRE_SEDE FROM maestro.sede_institucion where ID_SEDE_INSTITUCION = a.ID_SEDE_INSTITUCION) SedeInstitucion,
	--			a.ID_AULA				IdAula,
	--			a.NOMBRE_AULA			NumeroAula,
	--			a.AFORO_AULA			Aforo,
	--			a.CATEGORIA_AULA		IdTipoAula,
	--			ta.VALOR_ENUMERADO		TipoAula,				
	--			a.ID_PISO				IdPiso,
	--			pa.VALOR_ENUMERADO		Piso,
	--			a.UBICACION_AULA		Ubicacion,
	--			a.OBSERVACION_AULA		Observacion,
	--			ROW_NUMBER() OVER ( ORDER BY a.ID_AULA) AS Row,
	--			Total = COUNT(1) OVER ( )
	--	FROM	maestro.aula a
	--			LEFT JOIN sistema.enumerado ta ON a.CATEGORIA_AULA = ta.ID_ENUMERADO
	--			LEFT JOIN sistema.enumerado pa ON a.ID_PISO = pa.ID_ENUMERADO
	--	WHERE	ID_SEDE_INSTITUCION IN (SELECT ID_SEDE_INSTITUCION FROM maestro.sede_institucion WHERE ID_INSTITUCION = @ID_INSTITUCION AND ES_ACTIVO = 1)
	--			AND (a.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION = 0)
	--			AND (a.CATEGORIA_AULA = @CATEGORIA_AULA OR @CATEGORIA_AULA = 0)
	--			AND (a.NOMBRE_AULA LIKE '%'+@NUMERO_AULA + '%' COLLATE LATIN1_GENERAL_CI_AI OR @NUMERO_AULA = '')
	--			AND (a.AFORO_AULA = @AFORO_AULA OR @AFORO_AULA = 0)
	--			AND a.ES_ACTIVO = 1
	--)
	--SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0
GO


