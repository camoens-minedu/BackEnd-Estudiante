-------------------------------------------------------------------------------------------------------------
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	12/04/2020
--LLAMADO POR			:
--DESCRIPCION			:	guardar evaluacion de admision
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ADMISION_SAVE_EVALUACION]
(
	@ID_POSTULANTES_POR_MODALIDAD         		INT,
	--@ID_OPCIONES_POR_POSTULANTE         		INT,
	@NOTA_RESULTADO						DECIMAL(10,2),
	@ES_ACTIVO							BOOLEANO,
	@ESTADO								INT,
	@USUARIO							VARCHAR(20)
)AS 
BEGIN

	INSERT INTO [transaccional].[resultados_por_postulante]
           ([ID_POSTULANTES_POR_MODALIDAD]
           --,[ID_OPCIONES_POR_POSTULANTE]
           ,[NOTA_RESULTADO]
           ,[ES_ACTIVO]
           ,[ESTADO]
           ,[USUARIO_CREACION]
           ,[FECHA_CREACION])
     VALUES
           (@ID_POSTULANTES_POR_MODALIDAD
           --,@ID_OPCIONES_POR_POSTULANTE
           ,@NOTA_RESULTADO
           ,@ES_ACTIVO
           ,@ESTADO
           ,@USUARIO
           ,GETDATE())

	SELECT 1;
END
GO


