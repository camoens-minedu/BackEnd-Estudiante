-------------------------------------------------------------------------------------------------------------
--AUTOR				:	Juan Tovar
--FECHA DE CREACION	:	12/04/2020
--LLAMADO POR			:
--DESCRIPCION			:	obtener lista de evaluacion virtual sincronizado
--REVISIONES			:
-------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ADMISION_GET_LIST_EVALUACION_VIRTUAL_SINCRONIZADO]
(
	@ID_MODALIDADES_POR_PROCESO_ADMISION         		INT,
	--@ESTADO				                    INT,
	@USUARIO								VARCHAR(20)
)AS 
BEGIN

	select 
	RPP.ID_RESULTADOS_POR_POSTULANTE as IdResultadosPorPostulante,
    PPM.ID_POSTULANTES_POR_MODALIDAD as IdPostulantesPorModalidad,
	0 as IdOpcionesPorPostulante,
	RPP.NOTA_RESULTADO as NotaResultado,
	P.ID_PERSONA as IdPersona,
	P.ID_TIPO_DOCUMENTO as IdTipoDocumento,
	P.NUMERO_DOCUMENTO_PERSONA as NumeroDocumentoPersona,
	P.NOMBRE_PERSONA as NombrePersona
	from transaccional.resultados_por_postulante RPP
	INNER JOIN transaccional.postulantes_por_modalidad PPM ON RPP.ID_POSTULANTES_POR_MODALIDAD = PPM.ID_POSTULANTES_POR_MODALIDAD
	INNER JOIN maestro.persona_institucion PI ON PPM.ID_PERSONA_INSTITUCION = PI.ID_PERSONA_INSTITUCION
	INNER JOIN maestro.persona P ON PI.ID_PERSONA = P.ID_PERSONA
	where PPM.ID_MODALIDADES_POR_PROCESO_ADMISION=@ID_MODALIDADES_POR_PROCESO_ADMISION;

END
GO


