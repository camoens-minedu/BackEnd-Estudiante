-------------------------------------------------------------------------------------------------------------
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	12/04/2020
--LLAMADO POR			:
--DESCRIPCION			:	actualizacion de evaluacion
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ADMISION_UPD_EVALUACION]
(
	@ID_RESULTADOS_POR_POSTULANTE         		INT,
	@NOTA_RESULTADO						DECIMAL(10,2),
	@USUARIO							VARCHAR(20)
)AS 
BEGIN

	UPDATE [transaccional].[resultados_por_postulante]
	   SET [NOTA_RESULTADO] = @NOTA_RESULTADO
		  ,[USUARIO_MODIFICACION] = @USUARIO
		  ,[FECHA_MODIFICACION] = GETDATE()
	 WHERE ID_RESULTADOS_POR_POSTULANTE = @ID_RESULTADOS_POR_POSTULANTE;

	SELECT 1;
END
GO


