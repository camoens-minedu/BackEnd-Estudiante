/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene la lista de datos generales de la matricula
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			CREACIÓN
2.0			12/05/2022		JCHAVEZ			MODIFICACIÓN DE TOTAL DE CRÉDITOS SEGÚN NUEVA NORMA TÉCNICA
3.0			17/05/2022		JCHAVEZ			MODIFICACIÓN DE TOTAL DE CRÉDITOS PARA TOMAR EL DATO DE LA TABLA PARÁMETRO

TEST:			
	USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA 1366,113
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA] 
(
	@ID_PLAN_ESTUDIO INT,
	@ID_SEMESTRE_ACADEMICO	INT	
)AS
BEGIN
	SET NOCOUNT ON;  
	Declare @TotalCreditos decimal(5,1), @NumeroMaximoCreditosAdicionales decimal
	/*select @TotalCreditos = SUM (CREDITOS) from transaccional.unidad_didactica
					where ID_MODULO in (SELECT ID_MODULO FROM transaccional.modulo WHERE ID_PLAN_ESTUDIO=@ID_PLAN_ESTUDIO)
					AND ID_SEMESTRE_ACADEMICO=@ID_SEMESTRE_ACADEMICO*/
	/*SELECT @TotalCreditos = 24 --v2.0*/
	SELECT @TotalCreditos = VALOR_PARAMETRO FROM sistema.parametro WHERE NOMBRE_PARAMETRO ='NumeroMaximoCreditosPermitidos' --v3.0
	SELECT @NumeroMaximoCreditosAdicionales = VALOR_PARAMETRO FROM sistema.parametro WHERE NOMBRE_PARAMETRO ='NumeroMaximoCreditosAdicionales'

	SELECT @TotalCreditos TotalCreditos, @NumeroMaximoCreditosAdicionales NumeroMaximoCreditosAdicionales 
	
END
GO


