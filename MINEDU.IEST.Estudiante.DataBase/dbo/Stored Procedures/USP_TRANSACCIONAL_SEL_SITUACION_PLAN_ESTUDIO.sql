/*************************************************************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Obtiene situación de plan de estudios
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE		Creación

TEST:
	USP_TRANSACCIONAL_SEL_SITUACION_PLAN_ESTUDIO 1235,'','',1,10000
**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_SITUACION_PLAN_ESTUDIO] (
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	INT,
	@CODIGO_DEPARTAMENTO			VARCHAR(MAX),
	@CODIGO_PROVINCIA				VARCHAR(MAX),
	@Pagina							int = 1,
	@Registros						int = 10  
) AS
DECLARE @ID_PERIODO_LECTIVO_R INT;
BEGIN  
	SET NOCOUNT ON;  
 
	DECLARE @desde INT , @hasta INT;  
	SET @desde = ( @Pagina - 1 ) * @Registros;  
    SET @hasta = ( @Pagina * @Registros ) + 1;

	SET @ID_PERIODO_LECTIVO_R = (SELECT TOP 1 ID_PERIODO_LECTIVO FROM transaccional.periodos_lectivos_por_institucion
								WHERE ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION);

	WITH lista AS 
	(
		--select
		--inst_all.NOMBRE_INSTITUCION as NombreInstitucion,
		--(
		--	select			
		--	CASE WHEN (count(*) > 0)
  --             THEN 'Sí'
  --             ELSE 'No'
		--	END
		--	from transaccional.plan_estudio as ps
		--	inner join transaccional.carreras_por_institucion as cpi on ps.ID_CARRERAS_POR_INSTITUCION = cpi.ID_CARRERAS_POR_INSTITUCION
		--	inner join db_auxiliar.dbo.UVW_INSTITUCION as inst on cpi.ID_INSTITUCION = inst.ID_INSTITUCION
		--	inner join db_auxiliar.dbo.UVW_CARRERA as carr on cpi.ID_CARRERA = carr.ID_CARRERA
		--	inner join sistema.enumerado as enum_tip_iti on ps.ID_TIPO_ITINERARIO = enum_tip_iti.ID_ENUMERADO
		--	where inst.NOMBRE_INSTITUCION = inst_all.NOMBRE_INSTITUCION
		--) as TienePeriodoLectivo
		--from db_auxiliar.dbo.UVW_INSTITUCION as inst_all
		--WHERE inst_all.CODIGO_PROVINCIA LIKE CONCAT(@CODIGO_DEPARTAMENTO, '%')
		SELECT 
		i.NOMBRE_INSTITUCION,
		i.CODIGO_MODULAR + ' - ' + i.NOMBRE_INSTITUCION AS NombreInstitucion,
		Asignatura = SUM(CASE WHEN pestudio.ID_TIPO_ITINERARIO=99 THEN 1 ELSE 0 END),
		Transversal = SUM(CASE WHEN pestudio.ID_TIPO_ITINERARIO=100 THEN 1 ELSE 0 END),
		Modular = SUM(CASE WHEN pestudio.ID_TIPO_ITINERARIO=101 THEN 1 ELSE 0 END)
		/*(
		SELECT 

		COUNT(pestudio.ID_TIPO_ITINERARIO)	

		FROM db_auxiliar.dbo.UVW_INSTITUCION i INNER JOIN transaccional.carreras_por_institucion cins
		ON i.ID_INSTITUCION = cins.ID_INSTITUCION INNER JOIN transaccional.plan_estudio pestudio
		ON cins.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION INNER JOIN transaccional.periodos_lectivos_por_institucion plectivo
		ON i.ID_INSTITUCION = plectivo.ID_INSTITUCION INNER JOIN sistema.enumerado e 
		ON pestudio.ID_TIPO_ITINERARIO = e.ID_ENUMERADO
		WHERE pestudio.ID_TIPO_ITINERARIO=99 AND plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plec.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND cins.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1
		) AS Asignatura,
		(
		SELECT 

		COUNT(pestudio.ID_TIPO_ITINERARIO)	

		FROM db_auxiliar.dbo.UVW_INSTITUCION i INNER JOIN transaccional.carreras_por_institucion cins
		ON i.ID_INSTITUCION = cins.ID_INSTITUCION INNER JOIN transaccional.plan_estudio pestudio
		ON cins.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION INNER JOIN transaccional.periodos_lectivos_por_institucion plectivo
		ON i.ID_INSTITUCION = plectivo.ID_INSTITUCION INNER JOIN sistema.enumerado e 
		ON pestudio.ID_TIPO_ITINERARIO = e.ID_ENUMERADO
		WHERE pestudio.ID_TIPO_ITINERARIO=100 AND plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plec.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND cins.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1
		) AS Transversal,
		(
		SELECT
		
		COUNT(pestudio.ID_TIPO_ITINERARIO)	

		FROM db_auxiliar.dbo.UVW_INSTITUCION i INNER JOIN transaccional.carreras_por_institucion cins
		ON i.ID_INSTITUCION = cins.ID_INSTITUCION INNER JOIN transaccional.plan_estudio pestudio
		ON cins.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION INNER JOIN transaccional.periodos_lectivos_por_institucion plectivo
		ON i.ID_INSTITUCION = plectivo.ID_INSTITUCION INNER JOIN sistema.enumerado e 
		ON pestudio.ID_TIPO_ITINERARIO = e.ID_ENUMERADO
		WHERE pestudio.ID_TIPO_ITINERARIO=101 AND plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plec.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND cins.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1
		) AS Modular*/
    FROM     
       db_auxiliar.dbo.UVW_INSTITUCION i INNER JOIN transaccional.carreras_por_institucion cins
		ON i.ID_INSTITUCION = cins.ID_INSTITUCION INNER JOIN transaccional.plan_estudio pestudio
		ON cins.ID_CARRERAS_POR_INSTITUCION = pestudio.ID_CARRERAS_POR_INSTITUCION INNER JOIN transaccional.periodos_lectivos_por_institucion plec
		ON i.ID_INSTITUCION = plec.ID_INSTITUCION INNER JOIN sistema.enumerado e 
		ON pestudio.ID_TIPO_ITINERARIO = e.ID_ENUMERADO
		WHERE /*pestudio.ID_TIPO_ITINERARIO=101 AND plectivo.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND*/ cins.ES_ACTIVO=1 AND pestudio.ES_ACTIVO=1
		AND i.CODIGO_PROVINCIA LIKE CONCAT(@CODIGO_DEPARTAMENTO, '%') AND plec.ID_PERIODO_LECTIVO = @ID_PERIODO_LECTIVO_R
		GROUP BY i.CODIGO_MODULAR,i.NOMBRE_INSTITUCION
			   		 
	)

	SELECT  *    
	FROM    (SELECT RT.* , 		
	ROW_NUMBER() OVER ( ORDER BY RT.NOMBRE_INSTITUCION ASC ) AS Row ,
	Total = COUNT(1) OVER ( )     
	FROM    lista RT) as T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
	--SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
END