/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro de un evaluador por tipo de modalidad de proceso de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_INS_AULA_EVALUADOR]
(
	@ID_PERIODOLECTIVO_INSTITUCION INT,
	@ID_SEDE_INSTITUCION INT,
	@ID_MODALIDAD INT,
	@ID_AULA_INSTITUCION INT,
	@ID_DOCENTE_INSTITUCION INT,
	@USUARIO VARCHAR(20)
)
AS

DECLARE @RESULT INT;
DECLARE @ID_EXAMEN_ADMISION_SEDE INT;
DECLARE @ID_EVALUADOR_ADMISION_MODALIDAD INT

SET @ID_EXAMEN_ADMISION_SEDE = (SELECT eadmse.ID_EXAMEN_ADMISION_SEDE FROM transaccional.examen_admision_sede eadmse INNER JOIN maestro.sede_institucion sinstitucion
ON eadmse.ID_SEDE_INSTITUCION = sinstitucion.ID_SEDE_INSTITUCION INNER JOIN transaccional.proceso_admision_periodo padmp
ON eadmse.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO
WHERE sinstitucion.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION AND padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOLECTIVO_INSTITUCION AND eadmse.ES_ACTIVO=1 AND eadmse.ID_MODALIDAD=@ID_MODALIDAD)


SET @ID_EVALUADOR_ADMISION_MODALIDAD =	(SELECT eadmmod.ID_EVALUADOR_ADMISION_MODALIDAD FROM transaccional.evaluador_admision_modalidad eadmmod INNER JOIN transaccional.modalidades_por_proceso_admision mpproad
ON eadmmod.ID_MODALIDADES_POR_PROCESO_ADMISION = mpproad.ID_MODALIDADES_POR_PROCESO_ADMISION INNER JOIN transaccional.proceso_admision_periodo padmp
ON mpproad.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO INNER JOIN sistema.enumerado enu
ON mpproad.ID_MODALIDAD = enu.ID_ENUMERADO INNER JOIN maestro.personal_institucion personalinsti
ON eadmmod.ID_PERSONAL_INSTITUCION = personalinsti.ID_PERSONAL_INSTITUCION INNER JOIN maestro.persona_institucion pinstitucion
ON personalinsti.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona persona
ON pinstitucion.ID_PERSONA = persona.ID_PERSONA
WHERE padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION AND mpproad.ID_MODALIDAD=@ID_MODALIDAD AND persona.ID_PERSONA=@ID_DOCENTE_INSTITUCION
and eadmmod.ES_ACTIVO=1
)


IF EXISTS(SELECT TOP 1 ID_DISTRIBUCION_EXAMEN_ADMISION FROM [transaccional].[distribucion_examen_admision]
WHERE ID_EVALUADOR_ADMISION_MODALIDAD = @ID_EVALUADOR_ADMISION_MODALIDAD AND  ID_EXAMEN_ADMISION_SEDE=@ID_EXAMEN_ADMISION_SEDE AND ES_ACTIVO=1)
BEGIN
	SET @RESULT = -180 -- YA SE ENCUENTRA REGISTRADO
END
ELSE IF EXISTS (SELECT * FROM transaccional.distribucion_examen_admision WHERE ID_AULA= @ID_AULA_INSTITUCION AND ID_EXAMEN_ADMISION_SEDE = @ID_EXAMEN_ADMISION_SEDE AND ES_ACTIVO=1)
BEGIN
	SET @RESULT = -180 -- YA SE ENCUENTRA REGISTRADO
END
ELSE 

	BEGIN    	--print 'dentro de la transaccion'
	
	INSERT INTO [transaccional].[distribucion_examen_admision]
           ([ID_EVALUADOR_ADMISION_MODALIDAD] 
           ,[ID_EXAMEN_ADMISION_SEDE]
           ,[ID_AULA]
           ,[ES_ACTIVO]
           ,[ESTADO]
           ,[FECHA_CREACION]
           ,[USUARIO_CREACION]
		 )

     VALUES
           (@ID_EVALUADOR_ADMISION_MODALIDAD 
		  ,(@ID_EXAMEN_ADMISION_SEDE)		  
		  ,@ID_AULA_INSTITUCION	  
		  ,1		  
		  ,1		  
		  ,GETDATE()
		  ,@USUARIO	  
		  )

	SET @RESULT = 1
END	
SELECT @RESULT
GO


