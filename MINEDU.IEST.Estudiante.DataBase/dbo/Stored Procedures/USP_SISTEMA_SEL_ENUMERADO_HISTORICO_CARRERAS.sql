--/*************************************************************************************************************************************************
--AUTOR				:	Consultores DRE
--FECHA DE CREACION	:	22/01/2020
--LLAMADO POR			:
--DESCRIPCION			:	Listado de enumerado histórico carreras
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--*/
--**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_ENUMERADO_HISTORICO_CARRERAS] (
	@ID_TIPO_ENUMERADO_HISTORICO	int, 
	@ID_INSTITUCION int,
	@Pagina					int = 1,
	@Registros				int = 10
)
As
BEGIN
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1; 

IF @ID_TIPO_ENUMERADO_HISTORICO = 0
	BEGIN
			SELECT	ID_ENUMERADO_HISTORICO IdEnumeradoClaseHistorica,
					CODIGO_GRUPO_ENUMERADO_HISTORICO CodigoEnumeradoHistorico,
					VALOR_ENUMERADO_HISTORICO ValorEnumeradoHistorico,
					ESTADO_ENUMERADO_HISTORICO IdEstadoEnumeradoHistorico,
					Case When ESTADO_ENUMERADO_HISTORICO =1 then 'ACTIVO' else 'INACTIVO' end EstadoEnumeradoHistorico
			FROM sistema.enumerado_historico
			WHERE CODIGO_ENUMERADO_HISTORICO_PADRE is null 
			ORDER BY VALOR_ENUMERADO_HISTORICO
	END
ELSE
	BEGIN
			WITH    tempPaginado AS
				(
						Select	EP.ID_ENUMERADO_HISTORICO IdEnumeradoClaseHistorica,
								RH.ID_RESOLUCION_ENUMERADO_HISTORICO IdResolucionEnumeradoHistorica,
								EH.ID_ENUMERADO_HISTORICO IdTiposEnumeradosHistoricos,
								EP.CODIGO_GRUPO_ENUMERADO_HISTORICO CodigoGrupoEnumeradoHistorico,
								EP.PADRE ValorEnumeradoHistorico,
								EH.HIJO ValorTiposEnumeradosHistoricos,
								EH.ESTADO_ENUMERADO_HISTORICO IdEstadoEnumeradoHistorico,
								RH.NRO_RD Nro_RD,
								RH.ARCHIVO_RD Archivo_RD,
								RH.ARCHIVO_RUTA Archivo_Ruta,
								Case When EH.ESTADO_ENUMERADO_HISTORICO =1 then 'ACTIVO' else 'INACTIVO' end EstadoEnumeradoHistorico,
								ROW_NUMBER() OVER ( ORDER BY EP.PADRE,EH.HIJO,EP.CODIGO_GRUPO_ENUMERADO_HISTORICO) AS Row,
								Total = COUNT(1) OVER ( )
						From
						(select ID_ENUMERADO_HISTORICO,
								CODIGO_GRUPO_ENUMERADO_HISTORICO,
								VALOR_ENUMERADO_HISTORICO PADRE,
								ESTADO_ENUMERADO_HISTORICO
						from sistema.enumerado_historico
						where CODIGO_ENUMERADO_HISTORICO_PADRE is Null 
						) as EP
							INNER JOIN (
								select	ID_ENUMERADO_HISTORICO,
										CODIGO_GRUPO_ENUMERADO_HISTORICO,
										CODIGO_ENUMERADO_HISTORICO_PADRE,
										VALOR_ENUMERADO_HISTORICO HIJO,
										ESTADO_ENUMERADO_HISTORICO
								from sistema.enumerado_historico
								where CODIGO_ENUMERADO_HISTORICO_PADRE is not Null AND ID_INSTITUCION = @ID_INSTITUCION
							) as EH on EP.ID_ENUMERADO_HISTORICO=EH.CODIGO_ENUMERADO_HISTORICO_PADRE 
								lEFT JOIN sistema.resolucion_enumerado_historico RH on RH.ID_ENUMERADO_HISTORICO = EH.ID_ENUMERADO_HISTORICO 
								WHERE CODIGO_ENUMERADO_HISTORICO_PADRE = 9
					)
					SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
			ORDER BY T.ValorEnumeradoHistorico
	END
END

--***********************************************************
--96. USP_SISTEMA_SEL_ENUMERADO_HISTORICO_GENERAL_TOTAL.sql