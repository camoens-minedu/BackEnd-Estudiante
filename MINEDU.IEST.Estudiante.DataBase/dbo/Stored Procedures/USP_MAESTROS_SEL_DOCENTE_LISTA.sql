﻿CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_DOCENTE_LISTA]
(  
@ID_INSTITUCION INT,
 @ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT

 --DECLARE @ID_INSTITUCION INT=440
 --DECLARE @ID_PERIODOS_LECTIVOS_POR_INSTITUCION INT=5550
)  
AS 
BEGIN  
 SET NOCOUNT ON;  
select 	
	(APELLIDO_PATERNO_PERSONA + ' ' + APELLIDO_MATERNO_PERSONA+ ', ' + NOMBRE_PERSONA ) Text,
	mpli.ID_PERSONAL_INSTITUCION Value
from maestro.persona_institucion mpi
inner join maestro.persona mp on mp.ID_PERSONA = mpi.ID_PERSONA
inner join maestro.personal_institucion mpli  on  mpi.ID_PERSONA_INSTITUCION = mpli.ID_PERSONA_INSTITUCION
--inner join transaccional.periodos_lectivos_por_institucion tpli on tpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = mpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
where mpi.ID_INSTITUCION=@ID_INSTITUCION and mpli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=@ID_PERIODOS_LECTIVOS_POR_INSTITUCION
AND ID_TIPO_PERSONAL =(select ID_ENUMERADO from sistema.enumerado where VALOR_ENUMERADO='ACADÉMICO') AND ID_ROL =
(select ID_ENUMERADO from sistema.enumerado where VALOR_ENUMERADO='DOCENTE' )
AND mpli.ES_ACTIVO=1 AND mpli.ESTADO = 1
order by APELLIDO_PATERNO_PERSONA + ' ' + APELLIDO_MATERNO_PERSONA+ ', ' + NOMBRE_PERSONA ASC
END
GO

