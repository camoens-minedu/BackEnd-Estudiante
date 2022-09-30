/*************************************************************************************************************************************************
AUTOR				:	Consultores DRE
FECHA DE CREACION	:	22/01/2020
LLAMADO POR			:
DESCRIPCION			:	Listado de documento DRE histórico.
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
1.0			22/01/2020		Consultores DRE	Creación

TEST:
	USP_TRANSACCIONAL_SEL_DOCUMENTO_DRE_HISTORICO 1911,0,0,0,0,0,0,0,0,0,1,10
**************************************************************************************************************************************************/
CREATE PROCEDURE [dbo].USP_TRANSACCIONAL_SEL_DOCUMENTO_DRE_HISTORICO (
	@ID_INSTITUCION					INT,
	@ID_SEDE_INSTITUCION			INT,
	@ID_PERIODO_LECTIVO				INT,
	@PROGRAMA_ESTUDIO				INT,
	@PROGRAMA_ESTUDIO_HISTORICO		INT,
	@PLAN_ESTUDIO					INT,
	@CICLO							INT,
	@SECCION						INT,
	@TURNO							INT,
	@NIVEL_FORMATIVO				INT,
	@Pagina							int = 1,
	@Registros						int = 10  
) AS
BEGIN  
	SET NOCOUNT ON;  
 
	DECLARE @desde INT , @hasta INT;  
	SET @desde = ( @Pagina - 1 ) * @Registros;  
	SET @hasta = ( @Pagina * @Registros ) + 1;    
	
	DECLARE @clase_historica TABLE (ID_CLASE_HISTORICA ID)

	INSERT INTO @clase_historica
	SELECT ID_CLASE_HISTORICA
	FROM maestro.clase_historica
	WHERE ID_INSTITUCION = @ID_INSTITUCION

	BEGIN
		WITH tempPaginado AS  
		( 
			SELECT docdre.ID_DOCUMENTOS_DRE		AS	IdDocumentosDre, 
			docdre.ID_PROGRAMACION_CLASE	AS	IdProgramacionClase, 
			docdre.ID_CLASE_HISTORICA	AS	IdClaseHistorica, 
			docdre.CODIGO_TIPO_ENUMERADO	AS	CodigoTipoEnumerado  , 
			enum_his_tipo_doc.VALOR_ENUMERADO_HISTORICO AS ValorEnumeradoHistorico,
			docdre.DESCARGADO	AS	Descargado  , 
			docdre.SUBIDO	AS	Subido  , 
			docdre.VERIFICADO	AS	Verificado  , 
			sede_inst.NOMBRE_SEDE AS Sede,
			enum_his_car.VALOR_ENUMERADO_HISTORICO AS CarreraHistorica,
			uvw_car.NOMBRE_CARRERA AS Carrera,
			enum_his_cicl.VALOR_ENUMERADO_HISTORICO AS Ciclo,
			enum_his_per_lec.VALOR_ENUMERADO_HISTORICO AS PeriodoLectivo,
			enum_his_tur.VALOR_ENUMERADO_HISTORICO AS Turno,
			enum_his_sec.VALOR_ENUMERADO_HISTORICO AS Seccion,
			 ROW_NUMBER() OVER ( ORDER BY  docdre.ID_DOCUMENTOS_DRE ASC ) AS Row ,
			 Total = COUNT(1) OVER ( )  
			FROM @clase_historica ch
				INNER JOIN maestro.clase_historica clahist ON clahist.ID_CLASE_HISTORICA = ch.ID_CLASE_HISTORICA
				INNER JOIN transaccional.documentos_dre docdre on docdre.ID_CLASE_HISTORICA = clahist.ID_CLASE_HISTORICA
				INNER JOIN sistema.enumerado_historico enum_his_tipo_doc on docdre.CODIGO_TIPO_ENUMERADO = enum_his_tipo_doc.ID_ENUMERADO_HISTORICO
				INNER JOIN maestro.sede_institucion sede_inst on clahist.ID_SEDE_INSTITUCION = sede_inst.ID_SEDE_INSTITUCION

				LEFT JOIN sistema.enumerado_historico enum_his_car on clahist.PROGRAMA_ESTUDIO_HISTORICO = enum_his_car.ID_ENUMERADO_HISTORICO
				LEFT JOIN db_auxiliar.dbo.UVW_CARRERA uvw_car on clahist.PROGRAMA_ESTUDIO = uvw_car.ID_CARRERA

				INNER JOIN sistema.enumerado_historico enum_his_per_lec on clahist.ID_PERIODO_LECTIVO = enum_his_per_lec.ID_ENUMERADO_HISTORICO
				INNER JOIN sistema.enumerado_historico enum_his_cicl on clahist.CICLO = enum_his_cicl.ID_ENUMERADO_HISTORICO
				INNER JOIN sistema.enumerado_historico enum_his_sec on clahist.SECCION = enum_his_sec.ID_ENUMERADO_HISTORICO
				INNER JOIN sistema.enumerado_historico enum_his_tur on clahist.TURNO = enum_his_tur.ID_ENUMERADO_HISTORICO
			WHERE clahist.ID_INSTITUCION = @ID_INSTITUCION 
					AND (clahist.ID_SEDE_INSTITUCION  = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION = 0) 
					AND (clahist.ID_PERIODO_LECTIVO  = @ID_PERIODO_LECTIVO OR @ID_PERIODO_LECTIVO = 0) 
					AND (clahist.PROGRAMA_ESTUDIO = @PROGRAMA_ESTUDIO OR @PROGRAMA_ESTUDIO = 0) 
					AND (clahist.PROGRAMA_ESTUDIO_HISTORICO = @PROGRAMA_ESTUDIO_HISTORICO OR @PROGRAMA_ESTUDIO_HISTORICO = 0) 
					AND (clahist.PLAN_ESTUDIO = @PLAN_ESTUDIO OR @PLAN_ESTUDIO = 0) 
					AND (clahist.CICLO = @CICLO OR @CICLO = 0) 
					AND (clahist.SECCION = @SECCION OR @SECCION = 0) 
					AND (clahist.TURNO = @TURNO OR @TURNO = 0) 
					AND (clahist.NIVEL_FORMATIVO = @NIVEL_FORMATIVO OR @NIVEL_FORMATIVO = 0)
					--AND clahist.ESTADO = 1 estado le falta a la tabla clase_Historica
		)
		SELECT * FROM tempPaginado T WHERE ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)  
	END 
END