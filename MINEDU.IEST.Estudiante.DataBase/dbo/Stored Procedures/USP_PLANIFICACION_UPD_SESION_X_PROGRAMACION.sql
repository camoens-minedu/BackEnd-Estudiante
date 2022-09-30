/********************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Actualiza los datos de una clase.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			01/10/2018		JTOVAR          CREACIÓN
2.0			22/12/2021		JTOVAR			Se agregó parámetro @ID_DOCENTE_CLASE

TEST:			
	USP_PLANIFICACION_UPD_PROGRAMACION_CLASE 3842
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_PLANIFICACION_UPD_SESION_X_PROGRAMACION]
(  
@ID_SESION_PROGRAMACION_CLASE INT,
@ID_AULA INT,
@ID_DIA INT,
@ID_TIPO_CLASE INT=0,
@HORA_INICIO VARCHAR(5),
@HORA_FIN VARCHAR(5),
@ID_DOCENTE_CLASE INT,
@USUARIO VARCHAR(20)
)  
AS 

DECLARE @RESULT INT
 BEGIN  
	SET @RESULT=0

				UPDATE transaccional.sesion_programacion_clase
				SET ID_AULA = @ID_AULA, 
				DIA = @ID_DIA,
				HORA_INICIO=@HORA_INICIO,
				HORA_FIN=@HORA_FIN,
				ID_TIPO_CLASE=@ID_TIPO_CLASE,
				USUARIO_MODIFICACION=@USUARIO,
				FECHA_MODIFICACION =GETDATE(),
				ID_DOCENTE_CLASE=@ID_DOCENTE_CLASE
				WHERE ID_SESION_PROGRAMACION_CLASE=@ID_SESION_PROGRAMACION_CLASE			
			SET @RESULT = 1
END  
SELECT @RESULT
GO


