-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		29/05/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	OBTIENE TODOS LOS OBJETOS REGISTRADOS PARA LA EXPORTACION DE DATOS

--  TEST:			
/*
EXEC USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR 1911
*/
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR]
(
	@ID_INSTITUCION	INT
)
AS

SELECT 
	IdExportadorDatosED		= ed.ID_EXPORTADOR_DATOS,	
	NombreBaseDatosED		= ed.NOMBRE_BASE_DATOS,
	NombreEsquemaED			= ed.NOMBRE_ESQUEMA,
	NombreObjetoED			= UPPER(ed.NOMBRE_OBJETO),
	EsActivoED				= ed.ES_ACTIVO,
	EstadoED				= ed.ESTADO,
	UsuarioCreacionED		= ed.USUARIO_CREACION,
	FechaCreacionED			= ed.FECHA_CREACION,
	UsuarioModificacionED	= ed.USUARIO_MODIFICACION,
	FechaModificacionED		= ed.FECHA_MODIFICACION
FROM
	transaccional.exportador_datos ed
ORDER BY ed.NOMBRE_OBJETO ASC

--NOMBRE_BASE_DATOS, NOMBRE_ESQUEMA, NOMBRE_OBJETO

/*
SELECT 
		*
FROM 
		UVW_SEDE S		
WHERE
		S.IdInstitucion = @ID_INSTITUCION
ORDER BY S.IdTipoSede ASC
*/
GO


