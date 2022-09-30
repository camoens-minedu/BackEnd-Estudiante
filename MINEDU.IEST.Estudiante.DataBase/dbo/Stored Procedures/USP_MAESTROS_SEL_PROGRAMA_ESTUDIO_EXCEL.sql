/********************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Selecciona el programa de estudios según información de cabecera del Excel. 
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  1.1		 15/06/2020		MALVA			MODIFICACIÓN PARA QUE NO PERMITA SUBIR PLANES CON EL MISMO NOMBRE EN UN MISMO
											PROGRAMA DE ESTUDIOS
--  TEST:			
/*
	USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_EXCEL 2027,'LITERATURA BÍBLICA', 'PROFESIONAL',101,'PLAN LIT 2020'
*/
*********************************************************************************************************************/
 CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_EXCEL]
(  
	@ID_INSTITUCION			INT,
	@PROGRAMA_ESTUDIOS		VARCHAR(150), 
	@NIVEL_FORMACION		VARCHAR (50),
	@ID_TIPO_ITINERARIO		INT,
	@NOMBRE_PLAN_ESTUDIOS	VARCHAR(150)
)  
AS  
BEGIN  
SELECT 
		cxi.ID_CARRERAS_POR_INSTITUCION  IdCarreraPorInstitucion, 
		ISNULL(pe.ID_PLAN_ESTUDIO,0) IdPlanEstudio
FROM	
		transaccional.carreras_por_institucion cxi
		INNER JOIN db_auxiliar.dbo.UVW_CARRERA mc ON  cxi.ID_CARRERA= mc.ID_CARRERA and cxi.ES_ACTIVO=1 --and mc.ESTADO=1		--reemplazoPorVista
		INNER JOIN maestro.nivel_formacion mnf on mnf.CODIGO_TIPO = mc.TIPO_NIVEL_FORMACION --mnf.ID_NIVEL_FORMACION= mc.ID_NIVEL_FORMACION 	--reemplazoPorVista
		and mnf.ESTADO=1
		LEFT JOIN transaccional.plan_estudio pe on pe.ID_CARRERAS_POR_INSTITUCION = cxi.ID_CARRERAS_POR_INSTITUCION
		and pe.ID_TIPO_ITINERARIO= cxi.ID_TIPO_ITINERARIO and pe.ES_ACTIVO=1
		and ltrim(rtrim(upper(pe.NOMBRE_PLAN_ESTUDIOS)))=@NOMBRE_PLAN_ESTUDIOS
WHERE 
	cxi.ID_INSTITUCION=@ID_INSTITUCION 
	and ltrim(rtrim(upper(mc.NOMBRE_CARRERA)))= ltrim(rtrim(upper(@PROGRAMA_ESTUDIOS)))
	and upper(mnf.NOMBRE_NIVEL_FORMACION)= ltrim(rtrim(upper(@NIVEL_FORMACION)))
	and cxi.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO

END

--************************************************
--30. USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_BASE_LISTA.sql
GO


