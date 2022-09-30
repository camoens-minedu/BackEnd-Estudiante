CREATE PROCEDURE [dbo].[USP_ARCHIVO_SEL_OBTENER_CARGA_DETALLE] 
(
	@ID_CARGA				int,
	@Pagina					int = 1,
	@Registros				int = 10
)
AS
BEGIN
	DECLARE @desde INT , @hasta INT;
		SET @desde = ( @Pagina - 1 ) * @Registros;
		SET @hasta = ( @Pagina * @Registros ) + 1;

		WITH    tempPaginado AS
		(	   
			select 
				ID_CARGA					ID_CARGA, 
				E_tipo_doc.VALOR_ENUMERADO  TipoDocumento,
				cd.NUMERO_DOCUMENTO			NumeroDocumento,
				cd.APELLIDO_PATERNO			ApellidoPaterno,
				cd.APELLIDO_MATERNO			ApellidoMaterno,
				cd.NOMBRES					Nombres,
				E_sexo.VALOR_ENUMERADO		Sexo,
				CONVERT (VARCHAR(10),cd.FECHA_NACIMIENTO,103)			FechaNacimiento,
				(CASE WHEN cd.ES_DISCAPACITADO=1 THEN 'SÍ' ELSE 'NO'	END)		EsDiscapacitado,
				E_tipo_disc.VALOR_ENUMERADO TipoDiscapacidad,
				ROW_NUMBER() OVER ( ORDER BY cd.ID_DET_ARCHIVO) AS Row
				,COUNT(1) OVER ( )	as Total
			from archivo.carga_detalle cd
			INNER JOIN sistema.enumerado E_tipo_doc ON cd.ID_TIPO_DOCUMENTO= E_tipo_doc.ID_ENUMERADO
			INNER JOIN sistema.enumerado E_sexo ON cd.ID_SEXO= E_sexo.ID_ENUMERADO
			LEFT JOIN sistema.enumerado E_tipo_disc ON cd.ID_TIPO_DISCAPACIDAD = E_tipo_disc.ID_ENUMERADO
			WHERE cd.ID_CARGA=@ID_CARGA and
			 cd.ID_DET_ARCHIVO NOT IN (SELECT ID_DET_ARCHIVO FROM transaccional.log_carga WHERE ES_BORRADO = 0)
			
		)
		SELECT  *     FROM     tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
END
GO


