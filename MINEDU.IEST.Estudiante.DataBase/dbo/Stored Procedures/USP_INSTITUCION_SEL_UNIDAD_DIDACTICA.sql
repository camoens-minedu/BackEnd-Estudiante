
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_UNIDAD_DIDACTICA]
(
	@ID_TIPOITINERARIO INT
)
AS


IF @ID_TIPOITINERARIO = 100 --TRASNVERSAL
  SELECT
		ID_TIPO_UNIDAD_DIDACTICA  IdTipoUDidactica,
		NOMBRE_TIPO_UNIDAD        TipoUDidactica
		 FROM
		 maestro.tipo_unidad_didactica 
		 WHERE ID_TIPO_UNIDAD_DIDACTICA IN (5)
ELSE
BEGIN
   IF @ID_TIPOITINERARIO = 101 -- MODULAR
   SELECT
        ID_TIPO_UNIDAD_DIDACTICA  IdTipoUDidactica,
		NOMBRE_TIPO_UNIDAD        TipoUDidactica
		 FROM
		 maestro.tipo_unidad_didactica 
		 WHERE ID_TIPO_UNIDAD_DIDACTICA IN (1)
   ELSE
      SELECT
        ID_TIPO_UNIDAD_DIDACTICA  IdTipoUDidactica,
		NOMBRE_TIPO_UNIDAD        TipoUDidactica
		 FROM
		 maestro.tipo_unidad_didactica 
		 WHERE ID_TIPO_UNIDAD_DIDACTICA IN (7)
  
END;
GO


