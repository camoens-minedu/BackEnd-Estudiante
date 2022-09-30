/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2018
LLAMADO POR			:
DESCRIPCION			:	Obtener las opciones registradas en la postulanción de una persona
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2018		JTOVAR			Creación
1.1			23/03/2021		JCHAVEZ			Modificación, se agregó ORDEN

TEST:
	SELECT dbo.UFN_CONCAT_opcion_postulante_Xregistro(20484)
**********************************************************************************************************/
CREATE FUNCTION [dbo].[UFN_CONCAT_opcion_postulante_Xregistro] (@Number INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @values AS NVARCHAR(300)
DECLARE @table AS TABLE (ORDEN INT,CAD NVARCHAR(MAX))
INSERT INTO @table
SELECT 
		--CONVERT(VARCHAR,E2.ID_SEDE_INSTITUCION) + '|' +
		--ID_POSTULANTES_POR_MODALIDAD,
		ORDEN,
		CASE WHEN E8.ES_SEDE_PRINCIPAL = 1 THEN 'PRINCIPAL' ELSE 'LOCAL' END + ' - ' + E8.NOMBRE_SEDE + ' - ' +		
		E4.NOMBRE_CARRERA + ' - ' +		
		E7.VALOR_ENUMERADO + ' ' 
		CAD
	FROM	
		transaccional.opciones_por_postulante E1
		INNER JOIN transaccional.meta_carrera_institucion_detalle E2 ON E2.ID_META_CARRERA_INSTITUCION_DETALLE = E1.ID_META_CARRERA_INSTITUCION_DETALLE AND E2.ES_ACTIVO = 1
		INNER JOIN transaccional.meta_carrera_institucion E3 ON E3.ID_META_CARRERA_INSTITUCION = E2.ID_META_CARRERA_INSTITUCION AND E3.ES_ACTIVO = 1
		INNER JOIN UVW_CARRERA E4 ON E4.ID_CARRERAS_POR_INSTITUCION = E3.ID_CARRERAS_POR_INSTITUCION
		INNER JOIN maestro.turnos_por_institucion E5 ON E5.ID_TURNOS_POR_INSTITUCION = E3.ID_TURNOS_POR_INSTITUCION AND E5.ES_ACTIVO = 1
		INNER JOIN maestro.turno_equivalencia E6 ON E6.ID_TURNO_EQUIVALENCIA = E5.ID_TURNO_EQUIVALENCIA
		INNER JOIN sistema.enumerado E7 ON E7.ID_ENUMERADO = E6.ID_TURNO
		INNER JOIN maestro.sede_institucion E8 ON E8.ID_SEDE_INSTITUCION = E2.ID_SEDE_INSTITUCION
	WHERE E1.ID_POSTULANTES_POR_MODALIDAD = @Number AND E1.ES_ACTIVO = 1
	ORDER BY E1.ORDEN

	SELECT	@values = COALESCE(@values +' ; ' ,'') + A.CAD
	FROM @table A
	ORDER BY ORDEN

	RETURN @values
END