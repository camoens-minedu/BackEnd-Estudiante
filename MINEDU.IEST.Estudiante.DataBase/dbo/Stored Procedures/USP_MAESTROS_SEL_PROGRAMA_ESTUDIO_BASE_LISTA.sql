/**********************************************************************************************************
AUTOR				:	Maura Alva
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el listado de programa de estudios.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			17/01/2020		MALVA			SE AÑADE FILTRO OPCIONAL @D_PERIODO_LECTIVO_INSTITUCION PARA QUE LISTE  
--											DE ACUERDO A LO CONFIGURADO EN METAS POR SEDES.
--  TEST:			
/*
USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_BASE_LISTA 1106, 4221,  10319
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_BASE_LISTA]
(  
@ID_INSTITUCION						INT,
@ID_SEDE_INSTITUCION				INT,
@ID_PERIODO_LECTIVO_INSTITUCION		INT = 0
)  
AS  
BEGIN  
SET NOCOUNT ON;  
IF @ID_PERIODO_LECTIVO_INSTITUCION = 0 
BEGIN	 
	SELECT 
		UPPER(mc.NOMBRE_CARRERA)Text,
		mc.ID_CARRERA Value,
		mnf.SEMESTRES_ACADEMICOS  Code	 
	 FROM 
		db_auxiliar.dbo.UVW_CARRERA mc	
		INNER JOIN transaccional.carreras_por_institucion tci on tci.ID_CARRERA= mc.ID_CARRERA
		inner join transaccional.carreras_por_institucion_detalle tcid on tcid.ID_CARRERAS_POR_INSTITUCION= tci.ID_CARRERAS_POR_INSTITUCION
		inner join maestro.nivel_formacion mnf on mnf.CODIGO_TIPO = mc.TIPO_NIVEL_FORMACION  --mnf.ID_NIVEL_FORMACION= mc.ID_NIVEL_FORMACION			--reemplazoPorVista
	 WHERE (tcid.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION OR  @ID_SEDE_INSTITUCION=0)
		AND tci.ES_ACTIVO=1 and tcid.ES_ACTIVO=1 AND tci.ID_INSTITUCION=@ID_INSTITUCION
	 GROUP BY mc.ID_CARRERA, mc.NOMBRE_CARRERA,mnf.SEMESTRES_ACADEMICOS
	 ORDER BY 1 ASC
END
ELSE
BEGIN
	SELECT DISTINCT 
		UPPER(mc.NOMBRE_CARRERA) Text, 
		mc.ID_CARRERA Value
	FROM 
		transaccional.meta_carrera_institucion_detalle mcid
		INNER JOIN transaccional.meta_carrera_institucion mci on mcid.ID_META_CARRERA_INSTITUCION = mci.ID_META_CARRERA_INSTITUCION AND mcid.ES_ACTIVO=1 AND mci.ES_ACTIVO=1
		INNER JOIN transaccional.carreras_por_institucion ci on ci.ID_CARRERAS_POR_INSTITUCION = mci.ID_CARRERAS_POR_INSTITUCION AND ci.ES_ACTIVO=1 
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA = ci.ID_CARRERA
	WHERE mcid.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION and mcid.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
END
END

--*******************************************************************************
--5. USP_MAESTROS_SEL_PLAN_ESTUDIO_LISTA.sql
GO


