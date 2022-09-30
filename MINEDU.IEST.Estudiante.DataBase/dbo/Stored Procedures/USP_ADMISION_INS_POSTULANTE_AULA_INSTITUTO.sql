/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Inserta un registro del postulante por modalidad del proceso de admisión
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_ADMISION_INS_POSTULANTE_AULA_INSTITUTO] 
(
	@ID_PERIODOLECTIVO_INSTITUCION INT,
	@ID_SEDE_INSTITUCION INT,
	@ID_MODALIDAD INT,
	@USUARIO VARCHAR(20)
)
AS

DECLARE @RESULT INT;
DECLARE @CANTIDAD_MAX INT;
DECLARE @CANTIDAD_MAX_POS INT;
DECLARE @DISTRIBUCION_EXAMEN_ADMISION INT;
DECLARE @ID_POSTULANTES_POR_MODALIDAD INT;
DECLARE @AA INT;
DECLARE @DD INT;

--SACAMOS LA CANTIDAD MAXIMA DE DISTRIBUCION
--SET @CANTIDAD_MAX = (SELECT COUNT(deadm.ID_DISTRIBUCION_EXAMEN_ADMISION) FROM
--transaccional.distribucion_examen_admision deadm INNER JOIN transaccional.examen_admision_sede eadms
--ON deadm.ID_EXAMEN_ADMISION_SEDE = eadms.ID_EXAMEN_ADMISION_SEDE INNER JOIN maestro.sede_institucion sinstitucion
--ON eadms.ID_SEDE_INSTITUCION = sinstitucion.ID_SEDE_INSTITUCION INNER JOIN transaccional.proceso_admision_periodo padmp
--ON eadms.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO INNER JOIN maestro.aula aula
--ON deadm.ID_AULA = aula.ID_AULA INNER JOIN transaccional.modalidades_por_proceso_admision mppadm
--ON padmp.ID_PROCESO_ADMISION_PERIODO = mppadm.ID_PROCESO_ADMISION_PERIODO
--WHERE padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION AND eadms.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION AND mppadm.ID_MODALIDAD=@ID_MODALIDAD)

SET @CANTIDAD_MAX = (SELECT COUNT(deadm.ID_DISTRIBUCION_EXAMEN_ADMISION) 
FROM transaccional.distribucion_examen_admision deadm 
INNER JOIN transaccional.examen_admision_sede eadms ON deadm.ID_EXAMEN_ADMISION_SEDE = eadms.ID_EXAMEN_ADMISION_SEDE AND deadm.ES_ACTIVO=1 AND eadms.ES_ACTIVO=1
INNER JOIN maestro.sede_institucion sinstitucion ON eadms.ID_SEDE_INSTITUCION = sinstitucion.ID_SEDE_INSTITUCION AND sinstitucion.ES_ACTIVO=1
INNER JOIN transaccional.proceso_admision_periodo padmp ON eadms.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO AND padmp.ES_ACTIVO=1
INNER JOIN maestro.aula aula ON deadm.ID_AULA = aula.ID_AULA AND aula.ES_ACTIVO=1
INNER JOIN transaccional.modalidades_por_proceso_admision mppadm ON padmp.ID_PROCESO_ADMISION_PERIODO = mppadm.ID_PROCESO_ADMISION_PERIODO AND mppadm.ES_ACTIVO=1
WHERE padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION 
AND eadms.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION AND mppadm.ID_MODALIDAD=@ID_MODALIDAD
AND eadms.ID_MODALIDAD =@ID_MODALIDAD )

--CARGAMOS EN UNA TMP DE LOS NUEVOS ID REFERENCIALES
    SELECT 
		ROW_NUMBER() OVER ( ORDER BY deadm.ID_DISTRIBUCION_EXAMEN_ADMISION) AS INDICE,
		deadm.ID_DISTRIBUCION_EXAMEN_ADMISION,
		aula.AFORO_AULA
	INTO #TablaTemporal 	
	FROM
	transaccional.distribucion_examen_admision deadm INNER JOIN transaccional.examen_admision_sede eadms
	ON deadm.ID_EXAMEN_ADMISION_SEDE = eadms.ID_EXAMEN_ADMISION_SEDE INNER JOIN maestro.sede_institucion sinstitucion
	ON eadms.ID_SEDE_INSTITUCION = sinstitucion.ID_SEDE_INSTITUCION INNER JOIN transaccional.proceso_admision_periodo padmp
	ON eadms.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO INNER JOIN maestro.aula aula
	ON deadm.ID_AULA = aula.ID_AULA INNER JOIN transaccional.modalidades_por_proceso_admision mppadm
	ON padmp.ID_PROCESO_ADMISION_PERIODO = mppadm.ID_PROCESO_ADMISION_PERIODO
	WHERE padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION =@ID_PERIODOLECTIVO_INSTITUCION AND eadms.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION 
	AND mppadm.ID_MODALIDAD=@ID_MODALIDAD AND deadm.ES_ACTIVO=1 AND eadms.ES_ACTIVO=1 AND padmp.ES_ACTIVO=1 AND mppadm.ES_ACTIVO=1
	AND eadms.ID_MODALIDAD =@ID_MODALIDAD
    
--CARGAMOS EN UNA TMP DE LOS NUEVOS ID REFERENCIALES
	DECLARE @Id INT;							
	--SELECT Id = ppmod.ID_POSTULANTES_POR_MODALIDAD INTO #TempParaWhile FROM transaccional.postulantes_por_modalidad ppmod INNER JOIN transaccional.modalidades_por_proceso_admision mppad
	--ON ppmod.ID_MODALIDADES_POR_PROCESO_ADMISION = mppad.ID_MODALIDADES_POR_PROCESO_ADMISION INNER JOIN transaccional.proceso_admision_periodo padmp
	--ON mppad.ID_PROCESO_ADMISION_PERIODO = padmp.ID_PROCESO_ADMISION_PERIODO INNER JOIN transaccional.examen_admision_sede eadse 
	--ON padmp.ID_PROCESO_ADMISION_PERIODO = eadse.ID_PROCESO_ADMISION_PERIODO INNER JOIN maestro.persona_institucion pinstitucion
	--ON ppmod.ID_PERSONA_INSTITUCION = pinstitucion.ID_PERSONA_INSTITUCION INNER JOIN maestro.persona persona
	--ON pinstitucion.ID_PERSONA = persona.ID_PERSONA INNER JOIN sistema.enumerado enu
	--ON mppad.ID_MODALIDAD = enu.ID_ENUMERADO INNER JOIN maestro.sede_institucion sinstitucion
	--ON eadse.ID_SEDE_INSTITUCION = sinstitucion.ID_SEDE_INSTITUCION
	--WHERE padmp.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOLECTIVO_INSTITUCION AND eadse.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION AND mppad.ID_MODALIDAD =@ID_MODALIDAD 
	--AND ppmod.ES_ACTIVO=1 AND mppad.ES_ACTIVO=1 AND padmp.ES_ACTIVO=1 AND eadse.ES_ACTIVO=1
	--AND eadse.ID_MODALIDAD =@ID_MODALIDAD


	SELECT Id = pxm.ID_POSTULANTES_POR_MODALIDAD INTO #TempParaWhile 
	FROM transaccional.postulantes_por_modalidad pxm 
	INNER JOIN transaccional.modalidades_por_proceso_admision mxpa on pxm.ID_MODALIDADES_POR_PROCESO_ADMISION = mxpa.ID_MODALIDADES_POR_PROCESO_ADMISION and mxpa.ES_ACTIVO=1 and pxm.ES_ACTIVO=1
	INNER JOIN transaccional.proceso_admision_periodo pap on pap.ID_PROCESO_ADMISION_PERIODO = mxpa.ID_PROCESO_ADMISION_PERIODO and pap.ES_ACTIVO= 1
	INNER JOIN transaccional.examen_admision_sede eas on eas.ID_EXAMEN_ADMISION_SEDE= pxm.ID_EXAMEN_ADMISION_SEDE and eas.ES_ACTIVO=1
	INNER JOIN maestro.persona_institucion mpi on mpi.ID_PERSONA_INSTITUCION= pxm.ID_PERSONA_INSTITUCION 
	INNER JOIN maestro.persona MP ON MP.ID_PERSONA= mpi.ID_PERSONA
	where pap.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= @ID_PERIODOLECTIVO_INSTITUCION and eas.ID_SEDE_INSTITUCION= @ID_SEDE_INSTITUCION and eas.ID_MODALIDAD= @ID_MODALIDAD
							
	declare @cantidadDistribuidos int =0
	declare @cantidadRegistrosTemp int =1
							
	WHILE (SELECT COUNT(*) FROM #TempParaWhile) > 0
	Begin								
		SELECT TOP 1 @Id = Id FROM #TempParaWhile

		--Proceso a usar en el bucle
		if (@cantidadRegistrosTemp>@CANTIDAD_MAX)
		SET @DD = (SELECT ABS(CHECKSUM(NEWID())) %@CANTIDAD_MAX +1)		
		else
		SET @DD = @cantidadRegistrosTemp

		set @cantidadRegistrosTemp =  @cantidadRegistrosTemp + 1

		SELECT 
			@AA=ID_DISTRIBUCION_EXAMEN_ADMISION
		FROM 
		#TablaTemporal
		WHERE INDICE = @DD

		
		set @cantidadDistribuidos = ( select count(1) from transaccional.distribucion_evaluacion_admision_detalle where ID_DISTRIBUCION_EXAMEN_ADMISION= @AA and ES_ACTIVO=1)

		if (@cantidadDistribuidos< (select AFORO_AULA FROM #TablaTemporal WHERE INDICE = @DD) )
		BEGIN
			IF EXISTS(SELECT TOP 1 ID_DISTRIBUCION_EVALUACION_ADMISION_DETALLE  distribucion_evaluacion_admision_detalle FROM transaccional.distribucion_evaluacion_admision_detalle
			WHERE ID_POSTULANTES_POR_MODALIDAD=@Id AND ES_ACTIVO=1)
			BEGIN
				SET @RESULT = -180 -- YA SE ENCUENTRA REGISTRADO
			END
			ELSE
			BEGIN    	--print 'dentro de la transaccion'		
			INSERT INTO [transaccional].[distribucion_evaluacion_admision_detalle]
				   ([ID_DISTRIBUCION_EXAMEN_ADMISION] 
				   ,[ID_POSTULANTES_POR_MODALIDAD]
				   ,[ES_ACTIVO]
				   ,[ESTADO]
				   ,[FECHA_CREACION]
				   ,[USUARIO_CREACION]
				 )

			 VALUES
				   (@AA 
				  ,(@Id)		  
				  ,1		  
				  ,1		  
				  ,GETDATE()
				  ,@USUARIO	  
				  )
			 SET @RESULT = 1
			END							
			DELETE #TempParaWhile WHERE Id = @Id
		END 
		
	End
		
	SELECT @RESULT

DROP TABLE  #TablaTemporal 
drop table #TempParaWhile
GO


