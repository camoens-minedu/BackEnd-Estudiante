
CREATE VIEW [dbo].[UVW_SEDE]
AS
SELECT        ID_INSTITUCION AS IdInstitucion, ID_SEDE_INSTITUCION AS IdSedeInstitucion, 
                         CASE WHEN ES_SEDE_PRINCIPAL = 1 THEN 'PRINCIPAL' WHEN ID_TIPO_SEDE = 204 THEN 'FILIAL' ELSE 'LOCAL' END AS TipoLocal, NOMBRE_SEDE AS NombreRef, DIRECCION_SEDE AS DireccionRef, 
                         ID_TIPO_SEDE AS IdTipoSede
FROM            maestro.sede_institucion
WHERE        (ES_ACTIVO = 1)