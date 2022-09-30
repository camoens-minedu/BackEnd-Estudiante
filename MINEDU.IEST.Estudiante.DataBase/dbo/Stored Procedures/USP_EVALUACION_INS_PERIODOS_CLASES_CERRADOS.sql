--/*************************************************************************************************************************************************
--AUTOR				    :	Juan Tovar
--FECHA DE CREACION	    :	15/10/2020
--LLAMADO POR			:
--DESCRIPCION			:	Registrar los periodos de clases cerrados.
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------
--VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-------------------------------------------------------------------------------------------------------------
--1.1			15/10/2020		JTOVAR			REGISTRAR LOS PERIODOS DE CLASES CERRADOS.
--*/
--  TEST:		USP_EVALUACION_INS_PERIODOS_CLASES_CERRADOS 3439
--**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_EVALUACION_INS_PERIODOS_CLASES_CERRADOS]--
(  
	@ID_PERIODO_ACADEMICO INT,
    @USUARIO              VARCHAR(20)	

	--DECLARE @ID_PERIODO_ACADEMICO INT=1502
 --   DECLARE @USUARIO              VARCHAR(20)='42122536'
)  
AS  
BEGIN  
  
 DECLARE @RESULT INT
 
 IF EXISTS(SELECT TOP  1 ID_CIERRE_PERIODO_CLASES FROM transaccional.cierre_periodo_clases WHERE ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO)
	 BEGIN
	 UPDATE transaccional.cierre_periodo_clases
	 SET ES_ACTIVO=1
	 WHERE 
	 ID_PERIODO_ACADEMICO = @ID_PERIODO_ACADEMICO
	 SET @RESULT = 1
	 END
	 ELSE
	 BEGIN
	 INSERT INTO transaccional.cierre_periodo_clases
							(
								ID_PERIODO_ACADEMICO,
								ES_ACTIVO,
								ESTADO,		  
								USUARIO_CREACION,
								FECHA_CREACION
							)
					VALUES
							(		  

								@ID_PERIODO_ACADEMICO,
								1,		  
								1, 					  
								@USUARIO,
								getdate() 
							)
					SET @RESULT = 1
 END
	 
SELECT @RESULT
END
GO


