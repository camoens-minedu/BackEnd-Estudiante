﻿
CREATE PROCEDURE [dbo].[USP_SISTEMA_SEL_ENUMERADO_LISTA_ORDEN]
@ID_TIPO_ENUMERADO INT
AS
BEGIN
	SELECT e.ID_ENUMERADO AS Value, e.ORDEN_ENUMERADO AS Code, e.VALOR_ENUMERADO AS [Text]
	FROM sistema.enumerado e
	INNER JOIN sistema.tipo_enumerado te ON (te.ID_TIPO_ENUMERADO = e.ID_TIPO_ENUMERADO)
	WHERE te.ID_TIPO_ENUMERADO = @ID_TIPO_ENUMERADO
	AND e.ESTADO = 1
END
GO


