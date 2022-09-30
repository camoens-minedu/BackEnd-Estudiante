﻿CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_PROGRAMACION_MATRICULA]
(
	@ID_PERIODO_LECTIVO_INSTITUCION INT
)
AS
BEGIN
SELECT 
			ID_PROGRAMACION_MATRICULA		IdProgramacionMatricula, 
			ID_TIPO_MATRICULA				IdTipoMatricula,
			SE.VALOR_ENUMERADO				TipoMatricula,
			FECHA_INICIO					FechaInicio, 
			FECHA_FIN						FechaFin
FROM 
			transaccional.programacion_matricula PM
INNER JOIN 
			sistema.enumerado SE ON PM.ID_TIPO_MATRICULA = SE.ID_ENUMERADO

WHERE
			ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODO_LECTIVO_INSTITUCION AND PM.ES_ACTIVO=1
END
GO


