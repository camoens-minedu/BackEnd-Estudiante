/****** Object:  StoredProcedure [dbo].[USP_MAESTROS_SEL_CARRERA_PAGINADO]    Script Date: 29/09/2021 14:40:59 ******/

CREATE PROCEDURE [dbo].[USP_MAESTROS_SEL_CARRERA_PAGINADO]
(  
@ID_ACTIVIDAD_ECONOMICA INT,
@ID_NIVEL_FORMACION INT,
@NOMBRE_CARRERA VARCHAR(150),
@Pagina     int = 1,
@Registros    int = 3
)  
AS  
BEGIN  
 SET NOCOUNT ON;  
	 DECLARE @desde INT , @hasta INT;  
	 SET @desde = ( @Pagina - 1 ) * @Registros;  
	 SET @hasta = ( @Pagina * @Registros ) + 1;    
  
	 WITH    tempPaginado AS  
	 (    
			SELECT 
			mc.ID_CARRERA										IdCarrera,
			mc.NOMBRE_SECTOR									Sector,							--A.NOMBRE_SECTOR 
			mc.NOMBRE_FAMILIA_PRODUCTIVA						FamiliaProductiva,				--A.NOMBRE_FAMILIA_PRODUCTIVA
			mc.ACTIVIDAD_ECONOMICA								ActividadEconomica, 
			mc.NOMBRE_CARRERA									Carrera,
			mc.NIVEL_FORMACION									NivelFormacion,			
			mnf.ID_NIVEL_FORMACION								IdNivelFormacion,
			mc.CODIGO_CARRERA									CodigoCatalogo,
			ROW_NUMBER() OVER ( ORDER BY mc.NOMBRE_CARRERA) AS Row , 
			Total = COUNT(1) OVER ( )  
			FROM db_auxiliar.dbo.UVW_CARRERA mc
				INNER JOIN maestro.nivel_formacion mnf on mc.TIPO_NIVEL_FORMACION = mnf.CODIGO_TIPO --mnf.ID_NIVEL_FORMACION = mc.ID_NIVEL_FORMACION 	--reemplazoPorVista   
				--LEFT JOIN (	SELECT mae.ID_ACTIVIDAD_ECONOMICA, ms.NOMBRE_SECTOR, mfp.NOMBRE_FAMILIA_PRODUCTIVA, mae.NOMBRE_ACTIVIDAD_ECONOMICA  
				--			FROM maestro.actividad_economica mae 							
				--			INNER JOIN maestro.familia_productiva mfp on mfp.ID_FAMILIA_PRODUCTIVA = mae.ID_FAMILIA_PRODUCTIVA
				--			INNER JOIN maestro.sector ms on ms.ID_SECTOR = mfp.ID_SECTOR
				--		 ) A ON A.ID_ACTIVIDAD_ECONOMICA=mc.ID_ACTIVIDAD_ECONOMICA
			WHERE 
				--(mc.ID_ACTIVIDAD_ECONOMICA = @ID_ACTIVIDAD_ECONOMICA OR @ID_ACTIVIDAD_ECONOMICA=0)			
				--AND (mc.ID_NIVEL_FORMACION =@ID_NIVEL_FORMACION OR @ID_NIVEL_FORMACION=0)
				((mc.NOMBRE_CARRERA LIKE '%' + ISNULL(@NOMBRE_CARRERA,'') + '%' COLLATE LATIN1_GENERAL_CI_AI) OR RTRIM(LTRIM(@NOMBRE_CARRERA))='')
				--AND mc.ES_CATALOGO=1
				--AND mc.ID_NIVEL_FORMACION<>6
	 )
	  SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
END

--***************************************************************************************************************************************************************BK
--ALTER PROCEDURE [dbo].[USP_MAESTROS_SEL_CARRERA_PAGINADO]
--(  
--@ID_ACTIVIDAD_ECONOMICA INT,
--@ID_NIVEL_FORMACION INT,
--@NOMBRE_CARRERA VARCHAR(150),
--@Pagina     int = 1,
--@Registros    int = 3
--)  
--AS  
--BEGIN  
-- SET NOCOUNT ON;  
--	 DECLARE @desde INT , @hasta INT;  
--	 SET @desde = ( @Pagina - 1 ) * @Registros;  
--	 SET @hasta = ( @Pagina * @Registros ) + 1;    
  
--	 WITH    tempPaginado AS  
--	 (    
--			SELECT 
--			ID_CARRERA IdCarrera,
--			NOMBRE_SECTOR Sector, 
--			NOMBRE_FAMILIA_PRODUCTIVA FamiliaProductiva,
--			NOMBRE_ACTIVIDAD_ECONOMICA ActividadEconomica, 
--			NOMBRE_CARRERA Carrera,
--			NOMBRE_NIVEL_FORMACION NivelFormacion,
--			mc.ID_NIVEL_FORMACION IdNivelFormacion,
--			CODIGO_CARRERA CodigoCatalogo,
--			ROW_NUMBER() OVER ( ORDER BY mc.NOMBRE_CARRERA) AS Row , 
--			Total = COUNT(1) OVER ( )  
--			FROM maestro.carrera mc
--				INNER JOIN maestro.nivel_formacion mnf on mnf.ID_NIVEL_FORMACION = mc.ID_NIVEL_FORMACION    
--				LEFT JOIN (	SELECT mae.ID_ACTIVIDAD_ECONOMICA, ms.NOMBRE_SECTOR, mfp.NOMBRE_FAMILIA_PRODUCTIVA, mae.NOMBRE_ACTIVIDAD_ECONOMICA  
--							FROM maestro.actividad_economica mae 							
--							INNER JOIN maestro.familia_productiva mfp on mfp.ID_FAMILIA_PRODUCTIVA = mae.ID_FAMILIA_PRODUCTIVA
--							INNER JOIN maestro.sector ms on ms.ID_SECTOR = mfp.ID_SECTOR
--						 ) A ON A.ID_ACTIVIDAD_ECONOMICA=mc.ID_ACTIVIDAD_ECONOMICA
--			WHERE 
--				(mc.ID_ACTIVIDAD_ECONOMICA = @ID_ACTIVIDAD_ECONOMICA OR @ID_ACTIVIDAD_ECONOMICA=0)			
--				AND (mc.ID_NIVEL_FORMACION =@ID_NIVEL_FORMACION OR @ID_NIVEL_FORMACION=0)
--				AND ((mc.NOMBRE_CARRERA LIKE '%' + ISNULL(@NOMBRE_CARRERA,'') + '%' COLLATE LATIN1_GENERAL_CI_AI) OR RTRIM(LTRIM(@NOMBRE_CARRERA))='')
--				AND mc.ES_CATALOGO=1
--	 )
--	  SELECT  *    FROM    tempPaginado T    WHERE   ( T.Row > @desde  AND T.Row < @hasta) OR (@Registros = 0)   
--END
GO


