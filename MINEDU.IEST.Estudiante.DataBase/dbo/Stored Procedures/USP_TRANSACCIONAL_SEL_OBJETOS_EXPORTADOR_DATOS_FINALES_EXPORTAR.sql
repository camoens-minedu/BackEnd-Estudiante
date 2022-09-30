-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		07/06/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_3
--  DESCRIPCION:	OBTENER DATA PARA EXPORTAR DATOS SEGUN LA CONFIGURACION GUARDADA

--  TEST:			
/*
EXEC USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR_DATOS_FINALES_EXPORTAR 1
*/
-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR_DATOS_FINALES_EXPORTAR]
(
	@ID_EXPORTADOR_DATOS_CONFIGURACION	INT
)
/*
EXEC USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR_DATOS_FINALES_EXPORTAR 1
*/
AS
BEGIN
	BEGIN	--> DECLARACION DE VARIABLES 
	PRINT ''
		DECLARE @SqlDinamico NVARCHAR(MAX) = '';
		DECLARE @SqlSelectCabecera NVARCHAR(MAX) = '';		
		DECLARE @ListaColumnas VARCHAR(MAX) = '';
		DECLARE @IdExportadorDatos INT;
		DECLARE @NombreBaseDatos VARCHAR(200);
		DECLARE @NombreEsquema VARCHAR(200);
		DECLARE @NombreObjeto VARCHAR(200);

		DECLARE @CantidadColumnasExportar INT = 0;
		DECLARE @NombrePropiedadVisualStudio VARCHAR(100) = 'Columna_';
	END

	BEGIN	--> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS 
	PRINT ''	
		IF (OBJECT_ID('tempdb.dbo.#temp001','U')) IS NOT NULL DROP TABLE #temp001
		IF (OBJECT_ID('tempdb.dbo.#TempParaWhile','U')) IS NOT NULL DROP TABLE #TempParaWhile
	END
	
	BEGIN	--> OBTENER: ID / BASE DE DATOS / ESQUEMA / OBJETO 
	PRINT ''
		SET @IdExportadorDatos = (SELECT ID_EXPORTADOR_DATOS FROM transaccional.exportador_datos_configuracion edc WHERE ID_EXPORTADOR_DATOS_CONFIGURACION = @ID_EXPORTADOR_DATOS_CONFIGURACION)
--**
--SELECT @IdExportadorDatos;

		SET @NombreBaseDatos = (SELECT NOMBRE_BASE_DATOS FROM transaccional.exportador_datos ed WHERE ed.ID_EXPORTADOR_DATOS = @IdExportadorDatos)
		SET @NombreEsquema = (SELECT NOMBRE_ESQUEMA FROM transaccional.exportador_datos ed WHERE ed.ID_EXPORTADOR_DATOS = @IdExportadorDatos)
		SET @NombreObjeto = (SELECT NOMBRE_OBJETO FROM transaccional.exportador_datos ed WHERE ed.ID_EXPORTADOR_DATOS = @IdExportadorDatos)
		
	END

	BEGIN	--> OBTENER COLUMNAS 
	PRINT ''
		SELECT			
			ROW_NUMBER() OVER(ORDER BY edcd.ORDEN_COLUMNA_A_EXPORTAR ASC) AS Row,
			---*******************************			
			edcd.ORDEN_COLUMNA_A_EXPORTAR,
			edcd.MOSTRAR_COLUMNA_A_EXPORTAR, 			 
			--edcd.ES_ACTIVO, edcd.ESTADO, 	
			---*******************************		
			edd.NOMBRE_COLUMNA_OBJETO
			,edd.ALIAS_COLUMNA_OBJETO
			--,edd.ES_ACTIVO, edd.ESTADO
		INTO #temp001
		FROM			
			transaccional.exportador_datos_configuracion_detalle edcd
			INNER JOIN transaccional.exportador_datos_detalle edd ON edcd.ID_EXPORTADOR_DATOS_DETALLE = edd.ID_EXPORTADOR_DATOS_DETALLE
		WHERE	
			edcd.ID_EXPORTADOR_DATOS_CONFIGURACION = @ID_EXPORTADOR_DATOS_CONFIGURACION
			AND edcd.MOSTRAR_COLUMNA_A_EXPORTAR = 1
			AND edd.ES_ACTIVO = 1 AND edd.ESTADO = 1		

--**
--SELECT * FROM #temp001

	END

	BEGIN	--> CANTIDAD DE COLUMNAS A MOSTRAR
	PRINT ''
		SET @CantidadColumnasExportar = (SELECT COUNT(Row) FROM #temp001);
	END

	BEGIN	--> WHILE
	PRINT ''
			BEGIN	--> DECLARACION VARIABLES WHILE 
			PRINT ''				
			END	

			DECLARE @Id INT										
			SELECT Id = Row INTO #TempParaWhile FROM #temp001
							
			WHILE (SELECT COUNT(*) FROM #TempParaWhile) > 0
			Begin								
				SELECT TOP 1 @Id = Id FROM #TempParaWhile

				--INICIO BUCLE ###################################################################################################################################
				--Proceso a usar en el bucle
					--SELECT @Id AS '@Id' ;
					--SELECT NOMBRE_COLUMNA_OBJETO, ALIAS_COLUMNA_OBJETO FROM #temp001 WHERE Row = @Id
					SET @SqlSelectCabecera += (SELECT '''' + ALIAS_COLUMNA_OBJETO + '''' + ' AS ' + @NombrePropiedadVisualStudio + CAST(@Id AS NVARCHAR(2)) + ',' FROM #temp001 WHERE Row = @Id)
					SET @ListaColumnas += (SELECT 'CAST(' + NOMBRE_COLUMNA_OBJETO + ' AS VARCHAR(500)) AS ' + @NombrePropiedadVisualStudio + CAST(@Id AS NVARCHAR(2)) + ',' FROM #temp001 WHERE Row = @Id)					
				--
				--FIN BUCLE ######################################################################################################################################
							
				DELETE #TempParaWhile WHERE Id = @Id
			End

/*
EXEC USP_TRANSACCIONAL_SEL_OBJETOS_EXPORTADOR_DATOS_FINALES_EXPORTAR 1
*/
	END																													

	BEGIN	--> CREAR CABECERA / UNIR AL SQL DINAMICO / PREPARAR LISTA COLUMNAS
	PRINT ''
		IF @CantidadColumnasExportar > 0
		BEGIN
			SET @SqlSelectCabecera = (SUBSTRING (@SqlSelectCabecera, 1, Len(@SqlSelectCabecera) - 1 ));
			SET @SqlSelectCabecera = 'SELECT ' + @SqlSelectCabecera + ' UNION ALL '
			SET @ListaColumnas = (SUBSTRING (@ListaColumnas, 1, Len(@ListaColumnas) - 1 ));
		END
--**
--SELECT @CantidadColumnasExportar AS '@CantidadColumnasExportar'
--**
--SELECT @SqlSelectCabecera AS '@SqlSelectCabecera';
--**
--SELECT @ListaColumnas AS '@ListaColumnas';

	END

	BEGIN	--> EXECUTAR QUERY DINAMICO 
	PRINT ''		
		SET @SqlDinamico = @SqlSelectCabecera + 'SELECT ' + @ListaColumnas + ' FROM ' + @NombreBaseDatos + '.' + @NombreEsquema + '.' + @NombreObjeto

		IF @CantidadColumnasExportar = 0
		BEGIN
			SET @SqlDinamico = '';
		END

--**
--SELECT @SqlDinamico AS '@SqlDinamico';

		EXECUTE sp_executesql @SqlDinamico
	END
END
GO


