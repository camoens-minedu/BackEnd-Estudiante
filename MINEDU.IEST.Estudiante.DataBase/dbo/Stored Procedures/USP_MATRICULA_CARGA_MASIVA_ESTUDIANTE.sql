-------------------------------------------------------------------------------------------------------------------
-- ===============================================================================================================
--  AUTOR:			FERNANDO RAMOS C.
--  CREACION:		08/05/2019
--  ACTUALIZACION:	
--  BASE DE DATOS:	DB_REGIA_2
--  DESCRIPCION:	INSERTA EN EL FORMATO DESCARGADO EXCEL DE CARGA MASIVA ESTUDIANTE LISTA, DATOS EXTRAS

--  TEST:			EXEC USP_MATRICULA_CARGA_MASIVA_ESTUDIANTE

-- ===============================================================================================================
-------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_MATRICULA_CARGA_MASIVA_ESTUDIANTE]
(
	@ID_INSTITUCION INT
)
AS

BEGIN
	--DECLARE @ID_INSTITUCION INT = 443;	

	BEGIN  --> DECLARACION DE VARIABLES 
			--> Todo los valores salen de enumerados, excepto Pais, Sede.	
		DECLARE @TIPO_DOCUMENTO		INT = 9;
		DECLARE @TIPO_SEXO			INT = 12;
		DECLARE @TIPO_ESTADO_CIVIL	INT = 11;
		DECLARE @LENGUA				INT = 21;	
		DECLARE @TIPO_DISCAPACIDAD	INT = 26;		
		
		DECLARE @PAIS				INT = 200;
		
		DECLARE @TIPO_TURNO			INT = 5;		
		DECLARE @TIPO_ESTUDIANTE	INT = 60;		
		DECLARE @SEMESTRE			INT = 38;	
		
		DECLARE @SEDE				INT = 201;	
	END

	BEGIN  --> ELIMINA TABLA TEMPORAL SI EXISTIERA PARA EVITAR CAIDAS 
		IF (OBJECT_ID('tempdb.dbo.#tmpPaisOrdenados','U')) IS NOT NULL DROP TABLE #tmpPaisOrdenados
		IF (OBJECT_ID('tempdb.dbo.#tmpTurnoOrdenados','U')) IS NOT NULL DROP TABLE #tmpTurnoOrdenados
		IF (OBJECT_ID('tempdb.dbo.#tmpSedeOrdenados','U')) IS NOT NULL DROP TABLE #tmpSedeOrdenados
	END

	BEGIN  --> TEMPORAL PARA ORDENAR TODOS LOS PAISES SIN PERU 

		CREATE TABLE #tmpPaisOrdenados (
			Id INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, 
			DSCPAIS VARCHAR(100)
		);

		INSERT INTO #tmpPaisOrdenados(DSCPAIS)
		SELECT
			DSCPAIS
		FROM
			db_auxiliar.dbo.UVW_PAIS vv
		WHERE vv.CODIGO <> 9233000000
		ORDER BY vv.DSCPAIS ASC;

		--SELECT p.DSCPAIS FROM #tmpPaisOrdenados p

    END

	BEGIN  --> TEMPORAL PARA ORDENAR TODOS LOS TURNOS POR INSTITUCION 

		CREATE TABLE #tmpTurnoOrdenados (
			Id INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, 
			VALOR_ENUMERADO VARCHAR(200)
		);

		INSERT INTO #tmpTurnoOrdenados(VALOR_ENUMERADO)
		SELECT 					
			Valor = e.VALOR_ENUMERADO
		FROM 
			maestro.turnos_por_institucion ti 
			INNER JOIN maestro.turno_equivalencia te	ON te.ID_TURNO_EQUIVALENCIA = ti.ID_TURNO_EQUIVALENCIA
			INNER JOIN sistema.enumerado e				ON te.ID_TURNO = e.ID_ENUMERADO		
		WHERE 
			ti.ID_INSTITUCION = @ID_INSTITUCION
		ORDER BY e.ID_ENUMERADO ASC

		--SELECT * FROM #tmpTurnoOrdenados p

	END
	
	BEGIN  --> TEMPORAL PARA ORDENAR TODAS LAS SEDES POR INSTITUCION 
	
		CREATE TABLE #tmpSedeOrdenados (
			Id INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, 
			VALOR_ENUMERADO VARCHAR(200)
		);

		INSERT INTO #tmpSedeOrdenados(VALOR_ENUMERADO)
		SELECT 					
			Valor = S.TipoLocal + ' - ' + S.NombreRef	
		FROM 
				UVW_SEDE S		
		WHERE
				S.IdInstitucion = @ID_INSTITUCION
		ORDER BY S.IdTipoSede ASC

		--SELECT * FROM #tmpSedeOrdenados p

	END


	BEGIN  --> OBTENER DATOS 

		SELECT
			Identificador = e.ID_TIPO_ENUMERADO,
			--te.DESCRIPCION_TIPO_ENUMERADO,	
			--e.ID_ENUMERADO, 
			Valor = e.VALOR_ENUMERADO			
		FROM 
			sistema.enumerado e 
			INNER JOIN sistema.tipo_enumerado te ON e.ID_TIPO_ENUMERADO = te.ID_TIPO_ENUMERADO
		WHERE
			e.ID_TIPO_ENUMERADO = @TIPO_DOCUMENTO AND e.ESTADO = 1
		
		UNION ALL

		SELECT 
			Identificador = e.ID_TIPO_ENUMERADO,
			--te.DESCRIPCION_TIPO_ENUMERADO,	
			--e.ID_ENUMERADO, 
			Valor = e.VALOR_ENUMERADO			
		FROM 
			sistema.enumerado e 
			INNER JOIN sistema.tipo_enumerado te ON e.ID_TIPO_ENUMERADO = te.ID_TIPO_ENUMERADO
		WHERE
			e.ID_TIPO_ENUMERADO = @TIPO_SEXO AND e.ESTADO = 1

		UNION ALL

		SELECT 
			Identificador = e.ID_TIPO_ENUMERADO,
			--te.DESCRIPCION_TIPO_ENUMERADO,	
			--e.ID_ENUMERADO, 
			Valor = e.VALOR_ENUMERADO			
		FROM 
			sistema.enumerado e 
			INNER JOIN sistema.tipo_enumerado te ON e.ID_TIPO_ENUMERADO = te.ID_TIPO_ENUMERADO
		WHERE
			e.ID_TIPO_ENUMERADO = @TIPO_ESTADO_CIVIL AND e.ESTADO = 1

		UNION ALL

		SELECT 
			Identificador = e.ID_TIPO_ENUMERADO,
			--te.DESCRIPCION_TIPO_ENUMERADO,	
			--e.ID_ENUMERADO, 
			Valor = e.VALOR_ENUMERADO			
		FROM 
			sistema.enumerado e 
			INNER JOIN sistema.tipo_enumerado te ON e.ID_TIPO_ENUMERADO = te.ID_TIPO_ENUMERADO
		WHERE
			e.ID_TIPO_ENUMERADO = @LENGUA AND e.ESTADO = 1		

		UNION ALL

		SELECT 
			Identificador = 26,
			--te.DESCRIPCION_TIPO_ENUMERADO,	
			--e.ID_ENUMERADO, 
			Valor = 'NINGUNA'

		UNION ALL

		SELECT 
			Identificador = e.ID_TIPO_ENUMERADO,
			--te.DESCRIPCION_TIPO_ENUMERADO,	
			--e.ID_ENUMERADO, 
			Valor = e.VALOR_ENUMERADO			
		FROM 
			sistema.enumerado e 
			INNER JOIN sistema.tipo_enumerado te ON e.ID_TIPO_ENUMERADO = te.ID_TIPO_ENUMERADO
		WHERE
			e.ID_TIPO_ENUMERADO = @TIPO_DISCAPACIDAD AND e.ESTADO = 1
		
		UNION ALL

		SELECT 
			Identificador = @PAIS,		
			Valor = up.DSCPAIS
		FROM 
			db_auxiliar.dbo.UVW_PAIS up
		WHERE up.CODIGO = 9233000000		

		UNION ALL

		SELECT 
			Identificador = @PAIS,		
			Valor = up.DSCPAIS
		FROM 
			#tmpPaisOrdenados up				
		
		UNION ALL

		SELECT 
			Identificador = @TIPO_TURNO,			
			Valor = tu.VALOR_ENUMERADO
		FROM 
			#tmpTurnoOrdenados tu		

		UNION ALL

		SELECT 
			Identificador = e.ID_TIPO_ENUMERADO,
			--te.DESCRIPCION_TIPO_ENUMERADO,	
			--e.ID_ENUMERADO, 
			Valor = e.VALOR_ENUMERADO			
		FROM 
			sistema.enumerado e 
			INNER JOIN sistema.tipo_enumerado te ON e.ID_TIPO_ENUMERADO = te.ID_TIPO_ENUMERADO
		WHERE
			e.ID_TIPO_ENUMERADO = @TIPO_ESTUDIANTE AND e.ESTADO = 1
			
		UNION ALL

		SELECT 
			Identificador = e.ID_TIPO_ENUMERADO,
			--te.DESCRIPCION_TIPO_ENUMERADO,	
			--e.ID_ENUMERADO, 
			Valor = e.VALOR_ENUMERADO			
		FROM 
			sistema.enumerado e 
			INNER JOIN sistema.tipo_enumerado te ON e.ID_TIPO_ENUMERADO = te.ID_TIPO_ENUMERADO
		WHERE
			e.ID_TIPO_ENUMERADO = @SEMESTRE AND e.ESTADO = 1				

		UNION ALL

		SELECT 
			Identificador = @SEDE,			
			Valor = so.VALOR_ENUMERADO
		FROM 
			#tmpSedeOrdenados so

	END

END


------------------------------------------------------------------------------------------------bk

	--BEGIN	--> OBTENER UNIDAD DIDACTICA
			
	--				SELECT
	--					 IdUnidadDidactica		= TUD.ID_UNIDAD_DIDACTICA
	--					,NombreUnidadDidactica	= UPPER(TUD.NOMBRE_UNIDAD_DIDACTICA) 	
	--				FROM 
	--					transaccional.unidad_didactica TUD
	--				INNER JOIN transaccional.modulo TM						ON TM.ID_MODULO= TUD.ID_MODULO
	--				INNER JOIN transaccional.plan_estudio TPE				ON TPE.ID_PLAN_ESTUDIO = TM.ID_PLAN_ESTUDIO
	--				INNER JOIN transaccional.carreras_por_institucion TCI	ON TCI.ID_CARRERAS_POR_INSTITUCION= TPE.ID_CARRERAS_POR_INSTITUCION
	--				WHERE 1 = 1
	--					AND TCI.ID_CARRERA				= @ID_CARRERA	 
	--					AND TCI.ID_TIPO_ITINERARIO		= @ID_TIPO_ITINERARIO
	--					AND TUD.ID_SEMESTRE_ACADEMICO	= @ID_SEMESTRE_ACADEMICO

	--					AND TUD.ES_ACTIVO=1 
	--					AND  TM.ES_ACTIVO=1
	--					AND TPE.ES_ACTIVO=1
	--					AND TCI.ES_ACTIVO=1
	--				ORDER BY TUD.ID_UNIDAD_DIDACTICA ASC
			
	--END	
GO


