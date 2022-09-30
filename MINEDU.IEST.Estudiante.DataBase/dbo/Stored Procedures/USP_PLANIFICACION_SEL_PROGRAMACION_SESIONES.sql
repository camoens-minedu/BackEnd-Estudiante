/********************************************************************************************************************
AUTOR				:	Juan Tovar
FECHA DE CREACION	:	01/10/2018
LLAMADO POR			:
DESCRIPCION			:	Retorna la lista de sesiones de una clase.
REVISIONES			:  
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			01/10/2018		JTOVAR          CREACIÓN
2.0			07/02/2022		JCHAVEZ			Se agregó LEFT JOIN con sistema.enumerado para ID_DOCENTE_CLASE

  TEST:			
	USP_PLANIFICACION_SEL_PROGRAMACION_SESIONES 84475
*********************************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_PLANIFICACION_SEL_PROGRAMACION_SESIONES]
(  
@ID_PROGRAMACION_CLASE INT
)  
AS  

BEGIN  
	SET NOCOUNT ON;  
			
	SELECT	tsc.[ID_SESION_PROGRAMACION_CLASE] IdSesionProgramacionClase,
			tsc.ID_PROGRAMACION_CLASE IdProgramacionClase,
			tsc.ID_AULA IdAula,
			enu.ID_ENUMERADO IdTipoAula,
			enu.VALOR_ENUMERADO TipoAula,
			ma.NOMBRE_AULA Aula, 
			ma.AFORO_AULA Aforo,
			tsc.DIA IdDia,
			se.VALOR_ENUMERADO Dia,
			tsc.ID_TIPO_CLASE IdTipoClase,
			se_tc.VALOR_ENUMERADO TipoClase,
			tsc.[HORA_INICIO] HoraInicio,
			tsc.[HORA_FIN] HoraFin,
			tsc.ES_ACTIVO EsActivo,
			tsc.ID_DOCENTE_CLASE IdDocenteClase,
			enume.VALOR_ENUMERADO DocenteClase
	FROM [transaccional].[sesion_programacion_clase] tsc
	inner join maestro.aula ma on tsc.ID_AULA = ma.ID_AULA
	INNER JOIN sistema.enumerado se on se.ID_ENUMERADO = tsc.DIA	
	INNER JOIN sistema.enumerado se_tc on se_tc.ID_ENUMERADO= tsc.ID_TIPO_CLASE
	inner JOIN sistema.enumerado enu on enu.ID_ENUMERADO=ma.CATEGORIA_AULA
	LEFT JOIN sistema.enumerado enume on tsc.ID_DOCENTE_CLASE = enume.ID_ENUMERADO --versión 2.0

	WHERE ID_PROGRAMACION_CLASE=@ID_PROGRAMACION_CLASE		
	order by 1 asc
END
GO


