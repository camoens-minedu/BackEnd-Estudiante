/*********************************************************************************************************************
AUTOR				:	Mayra Alva
FECHA DE CREACION	:	01/11/2018
LLAMADO POR			:
DESCRIPCION			:	Retorna el listado de estudiantes por periodo lectivo institucion.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--	1.0		 06/01/2020		MALVA           MODIFICACIÓN SE AGREGA PARÁMETRO OPCIONAL @ID_TURNO_INSTITUCION PARA
--											VISUALIZAR EL TURNO ASÍ ESTÉ INACTIVO, FUNCIONA SI SE ESTABLECE @ESTADO = 0
--  TEST:			
/*
	USP_MAESTROS_SEL_TURNO_LISTA 1911, 0, 1646
*/
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_TURNO_LISTA]
(  
@ID_INSTITUCION INT,
@ESTADO INT = 0,
@ID_TURNO_INSTITUCION INT = 0
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
	SELECT 
		VALOR_ENUMERADO Text, 
		ID_TURNOS_POR_INSTITUCION Value		
	FROM maestro.turno_equivalencia mte
		inner join sistema.enumerado se on mte.ID_TURNO =se.ID_ENUMERADO
		inner join maestro.turnos_por_institucion  mti on mti.ID_TURNO_EQUIVALENCIA =mte.ID_TURNO_EQUIVALENCIA		 		
	WHERE mti.ID_INSTITUCION =@ID_INSTITUCION 
	and (mti.ESTADO=@ESTADO OR @ESTADO=0 )
	AND ((mti.ID_TURNOS_POR_INSTITUCION = @ID_TURNO_INSTITUCION )OR (mti.ID_TURNOS_POR_INSTITUCION <> @ID_TURNO_INSTITUCION AND mti.ESTADO= 1) OR @ID_TURNO_INSTITUCION=0) 
END

 --*************************************************************************
--84. USP_MAESTROS_SEL_PROGRAMA_ESTUDIO_EXCEL.sql
GO


