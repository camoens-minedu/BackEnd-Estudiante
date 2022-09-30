/*************************************************************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Listado de enumerados históricos
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE	Creación

TEST:
	USP_SISTEMA_SEL_ENUMERADO_HISTORICO_GENERAL 1025
**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_ENUMERADO_HISTORICO_GENERAL] 
(
	@ID_INSTITUCION int
)
AS
BEGIN
		SELECT	ID_ENUMERADO_HISTORICO	as IdEnumeradoHistorico,
		CODIGO_GRUPO_ENUMERADO_HISTORICO as CodigoGrupoEnumeradoHistorico,
		CODIGO_ENUMERADO_HISTORICO_PADRE as CodigoEnumeradoHistoricoPadre,
		VALOR_ENUMERADO_HISTORICO as ValorEnumeradoHistorico
		FROM sistema.enumerado_historico
		WHERE (ID_INSTITUCION IS NULL OR ID_INSTITUCION = @ID_INSTITUCION)
		AND ESTADO_ENUMERADO_HISTORICO = 1
		--where CODIGO_ENUMERADO_HISTORICO_PADRE is not null
		ORDER BY CodigoGrupoEnumeradoHistorico,IdEnumeradoHistorico
END