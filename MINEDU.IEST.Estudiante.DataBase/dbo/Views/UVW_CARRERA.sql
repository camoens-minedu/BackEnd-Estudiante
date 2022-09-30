CREATE VIEW [dbo].[UVW_CARRERA]
AS
SELECT        c.ID_CARRERA, ci.ID_CARRERAS_POR_INSTITUCION, ae.CODIGO_ACTIVIDAD_ECONOMICA, ae.NOMBRE_ACTIVIDAD_ECONOMICA, ae.ID_FAMILIA_PRODUCTIVA, fp.CODIGO_FAMILIA_PRODUCTIVA, 
                         fp.NOMBRE_FAMILIA_PRODUCTIVA, fp.ID_SECTOR, s.CODIGO_SECTOR, s.NOMBRE_SECTOR, c.CODIGO_CARRERA, c.NOMBRE_CARRERA, ci.ID_INSTITUCION, ci.ID_TIPO_ITINERARIO
FROM            transaccional.carreras_por_institucion AS ci INNER JOIN
                         db_auxiliar.dbo.UVW_CARRERA AS c ON ci.ID_CARRERA = c.ID_CARRERA LEFT OUTER JOIN
                         maestro.actividad_economica AS ae ON ae.CODIGO_ACTIVIDAD_ECONOMICA = c.CODIGO_ACTIVIDAD LEFT OUTER JOIN
                         maestro.familia_productiva AS fp ON fp.ID_FAMILIA_PRODUCTIVA = ae.ID_FAMILIA_PRODUCTIVA LEFT OUTER JOIN
                         maestro.sector AS s ON s.ID_SECTOR = fp.ID_SECTOR
WHERE        (ci.ES_ACTIVO = 1)