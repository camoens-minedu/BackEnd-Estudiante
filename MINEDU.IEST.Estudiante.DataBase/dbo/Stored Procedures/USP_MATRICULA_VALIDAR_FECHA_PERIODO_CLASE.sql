/**********************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	20/06/2019
LLAMADO POR			:
DESCRIPCION			:	Obtiene el registro  del periodo lecitvo activo por insitución 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			20/06/2019		JTOVAR			Creación
2.0			28/02/2022		JCHAVEZ			Se modificó para validar fecha con el periodo lectivo y no con el periodo de clases

TEST:			
	USP_MATRICULA_VALIDAR_FECHA_PERIODO_CLASE 4139
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MATRICULA_VALIDAR_FECHA_PERIODO_CLASE]
(	
	@ID_PERIODO_LECTIVO_INSTITUCION INT
)
AS  
SET NOCOUNT ON;

SELECT TOP (1)
		A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION	IdPeriodoLectivoInstitucion,
		A.FECHA_INICIO_INSTITUCION           				FechaInicio,
		A.FECHA_FIN_INSTITUCION             				FechaFin
FROM 
		--transaccional.periodo_academico A
		transaccional.periodos_lectivos_por_institucion A
WHERE	A.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODO_LECTIVO_INSTITUCION
		AND A.ES_ACTIVO = 1
GO


