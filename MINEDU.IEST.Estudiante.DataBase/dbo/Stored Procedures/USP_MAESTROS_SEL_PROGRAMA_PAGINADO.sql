CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_PROGRAMA_PAGINADO]
(  
	@ID_INSTITUCION			INT,
	@ID_SEDE_INSTITUCION	INT,
	@PROGRAMA_ESTUDIO		VARCHAR(150)='',
	@ID_NIVEL_FORMACION		INT =0,
	@CODIGO_CATALOGO		VARCHAR(16)='',
	@ID_ESTADO_PROGRAMA		INT =0,
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
	 select 	DISTINCT 
	 --tcid.ID_CARRERAS_POR_INSTITUCION_DETALLE IdCarrerasPorInstitucionDetalle,
	 tci.ID_CARRERAS_POR_INSTITUCION IdCarreraPorInstitucion,  
	 mc.ID_CARRERA IdCarrera,
	 --tcid.ID_SEDE_INSTITUCION IdSedeInstitucion,
	 --msi.NOMBRE_SEDE SedeInstitucion,
	 mc.NOMBRE_CARRERA ProgramaEstudio, 
	 se2.ID_ENUMERADO IdTipoItinerario,
	 se2.VALOR_ENUMERADO TipoItinerario,
	 mc.CODIGO_CARRERA CodigoCatalogo,
	 --mc.ES_CATALOGO EsCatalogo,				--reemplazoPorVista
	 mnf.ID_NIVEL_FORMACION IdNivelFormacion,
	 mnf.NOMBRE_NIVEL_FORMACION NivelFormacion,
	 mnf.SEMESTRES_ACADEMICOS Semestres,
	 tci.FECHA_CREACION FechaRevision, 
	 --se.VALOR_ENUMERADO EstadoPrograma,
	 --se.ID_ENUMERADO IdEstadoPrograma,
	 ROW_NUMBER() OVER ( ORDER BY  mc.NOMBRE_CARRERA, se2.VALOR_ENUMERADO ASC ) AS Row ,
	 Total = COUNT(1) OVER ( )  
	     
	 from 
	 
	 transaccional.carreras_por_institucion tci 
	 INNER JOIN  transaccional.carreras_por_institucion_detalle tcid on tci.ID_CARRERAS_POR_INSTITUCION =tcid.ID_CARRERAS_POR_INSTITUCION
	 inner join db_auxiliar.dbo.UVW_CARRERA mc on mc.ID_CARRERA= tci.ID_CARRERA
	 --inner join maestro.sede_institucion msi on msi.ID_SEDE_INSTITUCION = tcid.ID_SEDE_INSTITUCION
	 inner join maestro.nivel_formacion mnf on mc.TIPO_NIVEL_FORMACION = mnf.CODIGO_TIPO --mc.ID_NIVEL_FORMACION = mnf.ID_NIVEL_FORMACION		--reemplazoPorVista
 	 --inner join sistema.enumerado se on se.ID_ENUMERADO =tcid.ID_ESTADO_PROGRAMA
	 inner join sistema.enumerado se2 on se2.ID_ENUMERADO =tci.ID_TIPO_ITINERARIO
	 where 
	 ((NOMBRE_CARRERA LIKE '%' + ISNULL(@PROGRAMA_ESTUDIO,'') + '%' COLLATE LATIN1_GENERAL_CI_AI) OR RTRIM(LTRIM(@PROGRAMA_ESTUDIO))='')
	 AND ((CODIGO_CARRERA LIKE '%' + ISNULL(@CODIGO_CATALOGO,'')+ '%' COLLATE LATIN1_GENERAL_CI_AI ) OR RTRIM(LTRIM(@CODIGO_CATALOGO)) ='' )
	 AND (mc.ID_NIVEL_FORMACION = @ID_NIVEL_FORMACION OR @ID_NIVEL_FORMACION = 0)  
	 AND (tcid.ID_ESTADO_PROGRAMA = @ID_ESTADO_PROGRAMA OR @ID_ESTADO_PROGRAMA = 0) 
	 AND (tcid.ID_SEDE_INSTITUCION=@ID_SEDE_INSTITUCION OR @ID_SEDE_INSTITUCION =0) 
	 and tci.ES_ACTIVO=1 AND tcid.ES_ACTIVO=1
	 AND tci.ID_INSTITUCION=@ID_INSTITUCION
	 GROUP BY tci.ID_CARRERAS_POR_INSTITUCION,mc.ID_CARRERA,
	 	 mc.NOMBRE_CARRERA,	
		 se2.ID_ENUMERADO,
		 	se2.VALOR_ENUMERADO,	mc.CODIGO_CARRERA,	 --mc.ES_CATALOGO,		--reemplazoPorVista
			mnf.ID_NIVEL_FORMACION,	mnf.NOMBRE_NIVEL_FORMACION,	mnf.SEMESTRES_ACADEMICOS,	tci.FECHA_CREACION

	 
)
SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
END
GO


