/*************************************************************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Listado de enumerado histórico general total.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE	Creación

TEST:
	USP_SISTEMA_SEL_ENUMERADO_HISTORICO_GENERAL_TOTAL 0,0,1,10
**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_ENUMERADO_HISTORICO_GENERAL_TOTAL] 
(
	@ID_TIPO_ENUMERADO_HISTORICO int,
	@ID_ENUMERADO_HISTORICO int,
	@Pagina					int = 1,
	@Registros				int = 10

	--DECLARE @ID_TIPO_ENUMERADO_HISTORICO int=0
	--DECLARE @ID_ENUMERADO_HISTORICO int=0
	--DECLARE @Pagina					int = 1
	--DECLARE @Registros				int = 10

)
AS

DECLARE @GRUPO VARCHAR(100) = 'Documentos Históricos DRE' ;

BEGIN
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1;  

	IF @ID_TIPO_ENUMERADO_HISTORICO = 0
		BEGIN
				WITH    tempPaginado AS
					(
						Select	EP.ID_ENUMERADO_HISTORICO IdEnumeradoClaseHistorica,
								EH.ID_ENUMERADO_HISTORICO IdTiposEnumeradosHistoricos,
								EP.CODIGO_GRUPO_ENUMERADO_HISTORICO CodigoGrupoEnumeradoHistorico,
								EP.PADRE ValorEnumeradoHistorico,
								EH.HIJO ValorTiposEnumeradosHistoricos,
								EH.ESTADO_ENUMERADO_HISTORICO IdEstadoEnumeradoHistorico,
								@GRUPO as Grupo,
								Case When EH.ESTADO_ENUMERADO_HISTORICO =1 then 'ACTIVO' else 'INACTIVO' end EstadoEnumeradoHistorico,
								ROW_NUMBER() OVER ( ORDER BY EP.PADRE,EH.HIJO,EP.CODIGO_GRUPO_ENUMERADO_HISTORICO) AS Row,
								Total = COUNT(1) OVER ( )
						From
						(select ID_ENUMERADO_HISTORICO,
								CODIGO_GRUPO_ENUMERADO_HISTORICO,
								VALOR_ENUMERADO_HISTORICO PADRE,
								ESTADO_ENUMERADO_HISTORICO
						from sistema.enumerado_historico
						where CODIGO_ENUMERADO_HISTORICO_PADRE is Null AND ESTADO_ENUMERADO_HISTORICO=1
						) as EP
							INNER JOIN (
								select	ID_ENUMERADO_HISTORICO,
										CODIGO_GRUPO_ENUMERADO_HISTORICO,
										CODIGO_ENUMERADO_HISTORICO_PADRE,
										VALOR_ENUMERADO_HISTORICO HIJO,
										ESTADO_ENUMERADO_HISTORICO
								from sistema.enumerado_historico
								where CODIGO_ENUMERADO_HISTORICO_PADRE is not Null AND ESTADO_ENUMERADO_HISTORICO=1
							) as EH on EP.ID_ENUMERADO_HISTORICO=EH.CODIGO_ENUMERADO_HISTORICO_PADRE 
							where EP.ID_ENUMERADO_HISTORICO <> 9 AND EH.CODIGO_ENUMERADO_HISTORICO_PADRE <> 9
					)
					SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
		END
	ELSE
		BEGIN
				IF @ID_ENUMERADO_HISTORICO = 0
					BEGIN
						WITH    tempPaginado AS
						(
							Select	EP.ID_ENUMERADO_HISTORICO IdEnumeradoClaseHistorica,
									EH.ID_ENUMERADO_HISTORICO IdTiposEnumeradosHistoricos,
									EP.CODIGO_GRUPO_ENUMERADO_HISTORICO CodigoGrupoEnumeradoHistorico,
									EP.PADRE ValorEnumeradoHistorico,
									EH.HIJO ValorTiposEnumeradosHistoricos,
									EH.ESTADO_ENUMERADO_HISTORICO IdEstadoEnumeradoHistorico,
									Case When EH.ESTADO_ENUMERADO_HISTORICO =1 then 'ACTIVO' else 'INACTIVO' end EstadoEnumeradoHistorico,
									ROW_NUMBER() OVER ( ORDER BY EP.PADRE,EH.HIJO,EP.CODIGO_GRUPO_ENUMERADO_HISTORICO) AS Row,
									Total = COUNT(1) OVER ( )
							From
							(select ID_ENUMERADO_HISTORICO,
									CODIGO_GRUPO_ENUMERADO_HISTORICO,
									VALOR_ENUMERADO_HISTORICO PADRE,
									ESTADO_ENUMERADO_HISTORICO
							from sistema.enumerado_historico
							where CODIGO_ENUMERADO_HISTORICO_PADRE is Null AND ESTADO_ENUMERADO_HISTORICO=1
							) as EP
								INNER JOIN (
									select	ID_ENUMERADO_HISTORICO,
											CODIGO_GRUPO_ENUMERADO_HISTORICO,
											CODIGO_ENUMERADO_HISTORICO_PADRE,
											VALOR_ENUMERADO_HISTORICO HIJO,
											ESTADO_ENUMERADO_HISTORICO
									from sistema.enumerado_historico
									where CODIGO_ENUMERADO_HISTORICO_PADRE is not Null AND ESTADO_ENUMERADO_HISTORICO=1
								) as EH on EP.ID_ENUMERADO_HISTORICO=EH.CODIGO_ENUMERADO_HISTORICO_PADRE 
							Where EP.ID_ENUMERADO_HISTORICO=@ID_TIPO_ENUMERADO_HISTORICO
									AND EP.ID_ENUMERADO_HISTORICO <> 9 AND EH.CODIGO_ENUMERADO_HISTORICO_PADRE <> 9
						)
						SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
					END
				ELSE
					BEGIN
					WITH    tempPaginado AS
					(
						Select	EP.ID_ENUMERADO_HISTORICO IdEnumeradoClaseHistorica,
								EH.ID_ENUMERADO_HISTORICO IdTiposEnumeradosHistoricos,
								EP.CODIGO_GRUPO_ENUMERADO_HISTORICO CodigoGrupoEnumeradoHistorico,
								EP.PADRE ValorEnumeradoHistorico,
								EH.HIJO ValorTiposEnumeradosHistoricos,
								EH.ESTADO_ENUMERADO_HISTORICO IdEstadoEnumeradoHistorico,
								Case When EH.ESTADO_ENUMERADO_HISTORICO =1 then 'ACTIVO' else 'INACTIVO' end EstadoEnumeradoHistorico,
								ROW_NUMBER() OVER ( ORDER BY EP.PADRE,EH.HIJO,EP.CODIGO_GRUPO_ENUMERADO_HISTORICO) AS Row,
								Total = COUNT(1) OVER ( )
						From
						(select ID_ENUMERADO_HISTORICO,
								CODIGO_GRUPO_ENUMERADO_HISTORICO,
								VALOR_ENUMERADO_HISTORICO PADRE,
								ESTADO_ENUMERADO_HISTORICO
						from sistema.enumerado_historico
						where CODIGO_ENUMERADO_HISTORICO_PADRE is Null AND ESTADO_ENUMERADO_HISTORICO=1
						) as EP
							INNER JOIN (
								select	ID_ENUMERADO_HISTORICO,
										CODIGO_GRUPO_ENUMERADO_HISTORICO,
										CODIGO_ENUMERADO_HISTORICO_PADRE,
										VALOR_ENUMERADO_HISTORICO HIJO,
										ESTADO_ENUMERADO_HISTORICO
								from sistema.enumerado_historico
								where CODIGO_ENUMERADO_HISTORICO_PADRE is not Null AND ESTADO_ENUMERADO_HISTORICO=1
										AND ID_ENUMERADO_HISTORICO=@ID_ENUMERADO_HISTORICO
							) as EH on EP.ID_ENUMERADO_HISTORICO=EH.CODIGO_ENUMERADO_HISTORICO_PADRE 
						Where EP.ID_ENUMERADO_HISTORICO=@ID_TIPO_ENUMERADO_HISTORICO
									AND EP.ID_ENUMERADO_HISTORICO <> 9 AND EH.CODIGO_ENUMERADO_HISTORICO_PADRE <> 9
					)
					SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
					END	
		END 
END