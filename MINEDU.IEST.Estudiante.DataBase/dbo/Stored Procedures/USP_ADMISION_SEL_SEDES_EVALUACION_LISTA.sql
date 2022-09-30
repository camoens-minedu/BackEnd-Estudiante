﻿CREATE PROCEDURE [dbo].[USP_ADMISION_SEL_SEDES_EVALUACION_LISTA]
(  
@ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT,
@ID_MODALIDAD INT
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
select 
	EAS.ID_EXAMEN_ADMISION_SEDE		IdExamenAdmisionSede,	
	SI.NOMBRE_SEDE					SedeInstitucion,
    EAS.FECHA_EVALUACION			FechaEvaluacion,
	EAS.HORA_EVALUACION				HoraEvaluacion
from 
	transaccional.examen_admision_sede EAS 
	INNER JOIN transaccional.proceso_admision_periodo PAP ON EAS.ID_PROCESO_ADMISION_PERIODO= PAP.ID_PROCESO_ADMISION_PERIODO 
	AND EAS.ES_ACTIVO=1 AND PAP.ES_ACTIVO=1
	INNER JOIN maestro.sede_institucion SI ON SI.ID_SEDE_INSTITUCION= EAS.ID_SEDE_INSTITUCION 
	AND SI.ES_ACTIVO=1
WHERE 
	PAP.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION 
	AND EAS.ID_MODALIDAD= @ID_MODALIDAD
END
GO

