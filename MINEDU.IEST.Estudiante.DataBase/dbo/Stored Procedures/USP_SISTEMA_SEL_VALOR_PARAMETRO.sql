/**********************************************************************************************************
AUTOR				:	Juan Chavez
FECHA DE CREACION	:	30/11/2021
LLAMADO POR			:
DESCRIPCION			:	Obtiene el valor de un parámetro
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO     DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			30/11/2021		JCHAVEZ		Creación

TEST:     
  EXEC USP_SISTEMA_SEL_VALOR_PARAMETRO 'MinimoSemanasPeriodoLectivo'
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_VALOR_PARAMETRO]
 @NOMBRE_PARAMETRO VARCHAR(150)
AS
BEGIN
	SELECT CODIGO_PARAMETRO Codigo,NOMBRE_PARAMETRO Nombre,VALOR_PARAMETRO Valor 
	FROM sistema.parametro WHERE NOMBRE_PARAMETRO = @NOMBRE_PARAMETRO
END