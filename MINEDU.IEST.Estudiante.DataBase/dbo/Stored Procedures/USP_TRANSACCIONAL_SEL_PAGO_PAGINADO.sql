/**********************************************************************************************************
AUTOR				:	Luis Espinoza
FECHA DE CREACION	:	10/03/2021
LLAMADO POR			:
DESCRIPCION			:	Selecciona los registros de pago por institucion 
REVISIONES			:
-----------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
-----------------------------------------------------------------------------------------------------------
--  TEST:			
/*
	
*/
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_PAGO_PAGINADO]
(
    	@ID_INSTITUCION			int,	
	@TIPO_PAGO				int = 0,
	@ID_PERIODOS_LECTIVOS_POR_INSTITUCION	int = 0,
	@ID_SEDE_INSTITUCION	int = 0,
	@ID_CARRERA				int = 0,
	@Pagina					int = 1,
	@Registros				int = 10
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @desde INT , @hasta INT;
	SET @desde = ( @Pagina - 1 ) * @Registros;
    SET @hasta = ( @Pagina * @Registros ) + 1;  

	WITH    tempPaginado AS
	(	   
		SELECT	p.ID_PAGO_INSTITUCION	IdPagoInstitucion,
				p.ID_INSTITUCION		IdInstitucion,
				p.ID_SEDE_INSTITUCION	IdSedeInstitucion,
				p.TIPO_PAGO				IdTipoPago,
				ta.VALOR_ENUMERADO		TipoPago,				
				pli.NOMBRE_PERIODO_LECTIVO_INSTITUCION PeriodoLectivo,
				p.ID_CARRERA			IdCarrera,
				ca.NOMBRE_CARRERA		ProgramaEstudio,
				p.VALOR					Valor,
				ROW_NUMBER() OVER ( ORDER BY p.ID_PAGO_INSTITUCION) AS Row,
				Total = COUNT(1) OVER ( ),
				CASE WHEN p.ES_ACTIVO = 1 THEN 1 ELSE 0 END	EsActivo
		FROM	transaccional.pago_institucion p
				LEFT JOIN sistema.enumerado ta ON p.TIPO_PAGO = ta.ID_ENUMERADO
				LEFT JOIN UVW_CARRERA ca on p.ID_CARRERA = ca.ID_CARRERA AND p.ID_INSTITUCION = ca.ID_INSTITUCION  
				LEFT JOIN transaccional.periodos_lectivos_por_institucion pli on p.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = pli.ID_PERIODOS_LECTIVOS_POR_INSTITUCION AND p.ID_INSTITUCION = pli.ID_INSTITUCION  
		WHERE	(p.ID_INSTITUCION = @ID_INSTITUCION)
				AND (p.TIPO_PAGO = @TIPO_PAGO OR @TIPO_PAGO = 0)
				AND (p.ID_PERIODOS_LECTIVOS_POR_INSTITUCION = @ID_PERIODOS_LECTIVOS_POR_INSTITUCION OR @ID_PERIODOS_LECTIVOS_POR_INSTITUCION = 0)
				AND (p.ID_SEDE_INSTITUCION = @ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION = 0)
				AND (p.ID_CARRERA = @ID_CARRERA OR @ID_CARRERA = 0)
				AND p.ES_ACTIVO = 1 AND pli.ES_ACTIVO = 1
	)
	SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0) 
	 
END








/****** Object:  StoredProcedure [dbo].[USP_TRANSACCIONAL_INS_PAGO]    Script Date: 25/02/2021 18:50:51 ******/
SET ANSI_NULLS ON