--/*************************************************************************************************************************************************
--AUTOR				:	Consultores DRE
--FECHA DE CREACION	:	22/01/2020
--LLAMADO POR			:
--DESCRIPCION			:	Listado de enumerados históricos
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--/*
--*/
--**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_ENUMERADO_HISTORICO] (
	@ID_TIPO_ENUMERADO_HISTORICO	INT 
)
As
IF @ID_TIPO_ENUMERADO_HISTORICO = 0
	BEGIN
			SELECT	ID_ENUMERADO_HISTORICO IdEnumeradoClaseHistorica,
					CODIGO_GRUPO_ENUMERADO_HISTORICO CodigoEnumeradoHistorico,
					VALOR_ENUMERADO_HISTORICO ValorEnumeradoHistorico,
					ESTADO_ENUMERADO_HISTORICO IdEstadoEnumeradoHistorico,
					Case When ESTADO_ENUMERADO_HISTORICO =1 then 'ACTIVO' else 'INACTIVO' end EstadoEnumeradoHistorico
			FROM sistema.enumerado_historico
			WHERE CODIGO_ENUMERADO_HISTORICO_PADRE is null --and ESTADO_ENUMERADO_HISTORICO=1
					AND ID_ENUMERADO_HISTORICO <> 9 
			ORDER BY VALOR_ENUMERADO_HISTORICO
	END
ELSE
	BEGIN
			SELECT	ID_ENUMERADO_HISTORICO IdEnumeradoClaseHistorica,
					CODIGO_GRUPO_ENUMERADO_HISTORICO CodigoEnumeradoHistorico,
					VALOR_ENUMERADO_HISTORICO ValorEnumeradoHistorico,
					ESTADO_ENUMERADO_HISTORICO IdEstadoEnumeradoHistorico,
					Case When ESTADO_ENUMERADO_HISTORICO =1 then 'ACTIVO' else 'INACTIVO' end EstadoEnumeradoHistorico
			FROM sistema.enumerado_historico
			WHERE CODIGO_ENUMERADO_HISTORICO_PADRE = @ID_TIPO_ENUMERADO_HISTORICO --and ESTADO_ENUMERADO_HISTORICO=1
					AND ID_ENUMERADO_HISTORICO <> 9 AND CODIGO_ENUMERADO_HISTORICO_PADRE <> 9
			ORDER BY VALOR_ENUMERADO_HISTORICO
	END

--*******************************************************************
--95. USP_SISTEMA_SEL_ENUMERADO_HISTORICO_CARRERAS.sql