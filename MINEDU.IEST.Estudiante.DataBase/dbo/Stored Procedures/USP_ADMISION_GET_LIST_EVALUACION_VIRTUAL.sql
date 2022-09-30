-------------------------------------------------------------------------------------------------------------
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	12/04/2020
--LLAMADO POR			:
--DESCRIPCION			:	obtener lista de evaluaciones virtuales
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ADMISION_GET_LIST_EVALUACION_VIRTUAL]
(
	@ID_MODALIDADES_POR_PROCESO_ADMISION         		INT,
	--@ESTADO				                    INT,
	@USUARIO								VARCHAR(20)
)AS 
BEGIN

	select 
    PPM.ID_POSTULANTES_POR_MODALIDAD as IdPostulantesPorModalidad,
	0 as IdOpcionesPorPostulante,
	ER.PUNTAJE as NotaResultado,
	P.ID_PERSONA as IdPersona,
	P.ID_TIPO_DOCUMENTO as IdTipoDocumento,
	P.NUMERO_DOCUMENTO_PERSONA as NumeroDocumentoPersona,
	P.NOMBRE_PERSONA as NombrePersona
	from transaccional.postulantes_por_modalidad PPM
	INNER JOIN maestro.persona_institucion PI ON PPM.ID_PERSONA_INSTITUCION = PI.ID_PERSONA_INSTITUCION
	INNER JOIN maestro.persona P ON PI.ID_PERSONA = P.ID_PERSONA
	INNER JOIN [db_digeexamen].[dbo].[persona] DP ON P.NUMERO_DOCUMENTO_PERSONA = DP.NUMERO_DOCUMENTO
	INNER JOIN [db_digeexamen].[dbo].[usuario] US ON DP.CODIGO_PERSONA = US.CODIGO_PERSONA
	INNER JOIN [db_digeexamen].[admonline].[examen_resultado] ER ON US.CODIGO_USUARIO = ER.CODIGO_USUARIO
	where PPM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION;

END
GO


