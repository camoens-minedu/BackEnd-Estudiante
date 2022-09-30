/**********************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de las unidades didácticas según filtros. 
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			01/10/2018		MALVA			CREACIÓN
2.0			12/12/2019		MALVA           MODIFICACIÓN SE REEMPLAZA FILTRO ID_TIPO_ITINERARIO POR ID_PLAN_ESTUDIOS.
3.0			24/03/2021		JCHAVEZ			MODIFICACIÓN PARA EXCLUIR UD DE EXPERIENCIAS FORMATIVAS
--  TEST:			
/*
	 dbo.USP_MAESTROS_SEL_UNIDAD_DIDACTICA_LISTA 1106, 1101, 6043, 111,2	 
*/
--**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_UNIDAD_DIDACTICA_LISTA]
(  
@ID_INSTITUCION				INT,
@ID_CARRERA					INT,
@ID_PLAN_ESTUDIOS			INT,
@ID_SEMESTRE_ACADEMICO		INT,
@ID_ENFOQUE					INT
)  
AS  
BEGIN  
 SET NOCOUNT ON;   
 DECLARE @ID_ITINERARIO_MODULAR INT = 101,
		 @ID_TIPO_UD_EXPERIENCIA_FORMATIVA INT = 3
SELECT 		
		tud.NOMBRE_UNIDAD_DIDACTICA UnidadDidactica, 
		tude.ID_UNIDADES_DIDACTICAS_POR_ENFOQUE IdUnidadDidacticaPorEnfoque, 
		tud.CREDITOS Creditos,
		tud.ID_SEMESTRE_ACADEMICO
	FROM 
		transaccional.unidades_didacticas_por_enfoque tude
		inner join transaccional.enfoques_por_plan_estudio tepl on tude.ID_ENFOQUES_POR_PLAN_ESTUDIO= tepl.ID_ENFOQUES_POR_PLAN_ESTUDIO and tude.ES_ACTIVO=1 AND tepl.ES_ACTIVO=1
		inner join transaccional.plan_estudio tpe on tpe.ID_PLAN_ESTUDIO= tepl.ID_PLAN_ESTUDIO and tpe.ES_ACTIVO=1
		inner join transaccional.carreras_por_institucion tci on tci.ID_CARRERAS_POR_INSTITUCION= tpe.ID_CARRERAS_POR_INSTITUCION and tci.ES_ACTIVO=1
		inner join transaccional.unidad_didactica tud on tude.ID_UNIDAD_DIDACTICA = tud.ID_UNIDAD_DIDACTICA AND tud.ES_ACTIVO=1
	WHERE tud.ID_SEMESTRE_ACADEMICO = @ID_SEMESTRE_ACADEMICO  and tpe.ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIOS and tci.ID_CARRERA=@ID_CARRERA and tci.ID_INSTITUCION=@ID_INSTITUCION
	and (tepl.ID_ENFOQUE=@ID_ENFOQUE or (@ID_ENFOQUE=0 AND tpe.ID_TIPO_ITINERARIO <> @ID_ITINERARIO_MODULAR))
	AND tud.ID_TIPO_UNIDAD_DIDACTICA <> @ID_TIPO_UD_EXPERIENCIA_FORMATIVA
END
GO


