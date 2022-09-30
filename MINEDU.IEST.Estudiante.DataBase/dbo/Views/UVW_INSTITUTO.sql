CREATE VIEW [dbo].[UVW_INSTITUTO]
AS
SELECT        ID_INSTITUCION AS IdInstitucion, CODIGO_MODULAR AS CodigoModularIe, NULL AS FechaCreacionAutorizacion, NULL AS NroResolucionCreacionAutorizacion, NULL 
                         AS TipoResolucionCreacionAutorizacion, NULL AS PeriodoCreacionAutorizacion, NULL AS FechaRevalidacion, NULL AS NroResolucionRevalidacion, NULL AS TipoResolucionRevalidacion, NULL 
                         AS PeriodoRevalidacion, NULL AS CodigoTipoInstitucion, NOMBRE_INSTITUCION AS NombreInstituto, NULL AS NombreGestion, DRE_GRE AS DireccionRegional, NULL AS NombreTipoInstitucion, 
                         TIPO_GESTION AS IdTipoGestionIe, NOMBRE_INSTITUCION AS NombreInstitucion, CENTRO_POBLADO AS CentroPoblado, NULL AS CodigoArea, NULL AS Area, NULL AS CodigoTurno, NULL 
                         AS CantidadCarreras, NULL AS PaginaWeb, NULL AS Correo, NULL AS EXPR1, NULL AS DireccionIe, NULL AS TieneAdmision
FROM            db_auxiliar.dbo.UVW_INSTITUCION AS i