/**********************************************************************************************************
AUTOR:			FERNANDO RAMOS C.
CREACION:		03/09/2018
BASE DE DATOS:	DB_REGIA_1
DESCRIPCION:	VISUALIZA EN EL PLAN DE ESTUDIOS
---------------------------------------------------------------------------------------------------------
VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
---------------------------------------------------------------------------------------------------------
1.1			22/05/2020		MALVA			Adición de filas y unidades de competencia planes modular, transversal. 
1.3			12/06/2020		MALVA			INTEGRACIÓN PARA SOPORTE DE PLANES DE ESTUDIOS NIVEL PROFESIONAL, modular. 					
 
TEST:			
	EXEC USP_INSTITUCION_SEL_PLAN_ESTUDIO_VISUALIZAR 2381	
**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_SEL_PLAN_ESTUDIO_VISUALIZAR]
	--DECLARE @ID_PLAN_ESTUDIO INT = 4103;

	@ID_PLAN_ESTUDIO INT 
AS
BEGIN --> SP COMPLETO 

	Begin --> DECLARACION DE VARIABLES 

		--//TRANSVERSAL
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_02				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_03				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_04				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_05				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_06				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_07				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_08				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_09				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_10				INT
		DECLARE @ID_MODULO_TRANSVERSALES_GRUPO_ESP_11				INT
		--//
		DECLARE @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01				INT
		DECLARE @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02				INT
		DECLARE @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03				INT
		DECLARE @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04				INT
		
		--//MODULAR
		DECLARE @ID_MODULO_GRUPO_1									INT
		DECLARE @ID_MODULO_GRUPO_2									INT
		DECLARE @ID_MODULO_GRUPO_3									INT
		DECLARE @ID_MODULO_GRUPO_4									INT

		DECLARE @ID_MODULO_GRUPO_5									INT
		DECLARE @ID_MODULO_GRUPO_6									INT

		DECLARE @ID_TIPO_ITINERARIO									INT		
	
		DECLARE @CODIGO_ENUMERADO_TIPO_ITINERARIO					INT = 33				--//Itinerario en tabla enumerados es 33 
		DECLARE @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO			INT = 38				--//Semestre academico en tabla enumerados es 38
		DECLARE @CODIGO_ENUMERADO_TIPO_MODULO						INT = 47				--//Tipo Modulo en tabla enumerados es 47

		DECLARE @PERIODO_ACADEMICO_I								VARCHAR(3)	= 'I'		--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 38
		DECLARE @PERIODO_ACADEMICO_II								VARCHAR(3)	= 'II'		--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 38
		DECLARE @PERIODO_ACADEMICO_III								VARCHAR(3)	= 'III'		--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 38
		DECLARE @PERIODO_ACADEMICO_IV								VARCHAR(3)	= 'IV'		--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 38
		DECLARE @PERIODO_ACADEMICO_V								VARCHAR(3)	= 'V'		--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 38
		DECLARE @PERIODO_ACADEMICO_VI								VARCHAR(3)	= 'VI'		--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 38
		DECLARE @PERIODO_ACADEMICO_VII								VARCHAR(3)	= 'VII'		--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 38
		DECLARE @PERIODO_ACADEMICO_VIII								VARCHAR(4)	= 'VIII'	--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 38

		DECLARE @ITINERARIO_POR_ASIGNATURA							INT = 99				--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 33
		DECLARE @ITINERARIO_TRANSVERSAL								INT	= 100				--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 33
		DECLARE @ITINERARIO_MODULAR									INT	= 101				--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 33

		DECLARE @ID_TIPO_MODULO_PROFESIONAL							INT	= 159				--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 47	
		DECLARE @ID_TIPO_MODULO_TRANSVERSAL							INT	= 160				--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 47
		DECLARE @ID_TIPO_MODULO_TECNICO							    INT	= 10194;            --//JTOVAR Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 47		
		
		DECLARE @DELIMITADOR_CODIGO_PREDECESORA_EXCEL				VARCHAR(1)	= ';'		--//Extraido del excel itinerario Modular 2017 columna F

		DECLARE @NIVEL_FORMATIVO                                    INT = 0; -- JTOVAR
		
	End
	
	SELECT TOP 1
			@NIVEL_FORMATIVO = c.ID_NIVEL_FORMACION --JTOVAR
																			
		FROM
			transaccional.plan_estudio pestudio INNER JOIN transaccional.carreras_por_institucion cpins 
			ON pestudio.ID_CARRERAS_POR_INSTITUCION = cpins.ID_CARRERAS_POR_INSTITUCION INNER JOIN db_auxiliar.dbo.UVW_CARRERA c
			ON cpins.ID_CARRERA = c.ID_CARRERA
		WHERE
			pestudio.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO			
			AND cpins.ES_ACTIVO      =				1
			AND pestudio.ES_ACTIVO   =				1

	Begin --> CREACION Y INGRESO DE DATOS EN TABLA TEMPORAL DE TABLA MODULO PARA @ITINERARIO_TRANSVERSAL 

		IF @NIVEL_FORMATIVO = 1 -- TECNICO
		BEGIN

					SELECT m.ID_MODULO INTO #transaccional_modulo_transversal_grupo_especial_tec 
					FROM 
						transaccional.modulo m 
					WHERE 
						m.ID_PLAN_ESTUDIO	= @ID_PLAN_ESTUDIO AND m.ID_TIPO_MODULO = @ID_TIPO_MODULO_TRANSVERSAL
					ORDER BY m.ID_MODULO

		
					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_02 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_02

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_03 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_03

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_04 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_04

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_05 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_05

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_06 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_06

					--SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_07 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					--DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_07

					--SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_08 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					--DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_08

					--SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_09 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					--DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_09

					--SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_10 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					--DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_10

					--SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_11 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial_tec ORDER BY ID_MODULO
					--DELETE FROM #transaccional_modulo_transversal_grupo_especial_tec WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_11
				
					--SELECT @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_02, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_03, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_04, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_05, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_06
					--	  ,@ID_MODULO_TRANSVERSALES_GRUPO_ESP_07, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_08, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_09, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_10, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_11		

					--Eliminar TablaTemporal
					DROP TABLE #transaccional_modulo_transversal_grupo_especial_tec

					-------//

					SELECT m.ID_MODULO INTO #transaccional_modulo_transversal_grupo_estandar_tec 
					FROM 
						transaccional.modulo m 
					WHERE 
						m.ID_PLAN_ESTUDIO	= @ID_PLAN_ESTUDIO AND m.ID_TIPO_MODULO = @ID_TIPO_MODULO_TECNICO
					ORDER BY m.ID_MODULO

					SELECT TOP 1 @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_estandar_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_estandar_tec WHERE ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01		

					SELECT TOP 1 @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_estandar_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_estandar_tec WHERE ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02

					SELECT TOP 1 @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_estandar_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_estandar_tec WHERE ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03		

					SELECT TOP 1 @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_estandar_tec ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_estandar_tec WHERE ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04		
		
					--SELECT @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01, @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02, @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03, @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04

					--Eliminar TablaTemporal
					DROP TABLE #transaccional_modulo_transversal_grupo_estandar_tec


		END
		ELSE -- NIVEL TECNICO PROFESIONAL
		BEGIN

					SELECT m.ID_MODULO INTO #transaccional_modulo_transversal_grupo_especial 
					FROM 
						transaccional.modulo m 
					WHERE 
						m.ID_PLAN_ESTUDIO	= @ID_PLAN_ESTUDIO AND m.ID_TIPO_MODULO = @ID_TIPO_MODULO_TRANSVERSAL
					ORDER BY m.ID_MODULO

		
					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_02 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_02

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_03 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_03

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_04 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_04

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_05 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_05

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_06 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_06

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_07 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_07

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_08 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_08

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_09 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_09

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_10 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_10

					SELECT TOP 1 @ID_MODULO_TRANSVERSALES_GRUPO_ESP_11 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_especial ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_especial WHERE ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_11
				
					--SELECT @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_02, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_03, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_04, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_05, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_06
					--	  ,@ID_MODULO_TRANSVERSALES_GRUPO_ESP_07, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_08, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_09, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_10, @ID_MODULO_TRANSVERSALES_GRUPO_ESP_11		

					--Eliminar TablaTemporal
					DROP TABLE #transaccional_modulo_transversal_grupo_especial

					-------//

					SELECT m.ID_MODULO INTO #transaccional_modulo_transversal_grupo_estandar 
					FROM 
						transaccional.modulo m 
					WHERE 
						m.ID_PLAN_ESTUDIO	= @ID_PLAN_ESTUDIO AND m.ID_TIPO_MODULO = @ID_TIPO_MODULO_PROFESIONAL
					ORDER BY m.ID_MODULO

					SELECT TOP 1 @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_estandar ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_estandar WHERE ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01		

					SELECT TOP 1 @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_estandar ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_estandar WHERE ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02

					SELECT TOP 1 @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_estandar ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_estandar WHERE ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03		

					SELECT TOP 1 @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 = ID_MODULO FROM #transaccional_modulo_transversal_grupo_estandar ORDER BY ID_MODULO
					DELETE FROM #transaccional_modulo_transversal_grupo_estandar WHERE ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04		
		
					--SELECT @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01, @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02, @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03, @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04

					--Eliminar TablaTemporal
					DROP TABLE #transaccional_modulo_transversal_grupo_estandar



					END
		
		
		
		
		
	End

	Begin --> CREACION Y INGRESO DE DATOS EN TABLA TEMPORAL DE TABLA MODULO PARA @ITINERARIO_MODULAR Y @ITINERARIO_POR_ASIGNATURA 

		SELECT m.ID_MODULO INTO #transaccional_modulo 
		FROM 
			transaccional.modulo m 
		WHERE 
			m.ID_PLAN_ESTUDIO	= @ID_PLAN_ESTUDIO
		ORDER BY m.ID_MODULO

		SELECT TOP 1 @ID_MODULO_GRUPO_1 = ID_MODULO FROM #transaccional_modulo ORDER BY ID_MODULO
		DELETE FROM #transaccional_modulo WHERE ID_MODULO = @ID_MODULO_GRUPO_1		

		SELECT TOP 1 @ID_MODULO_GRUPO_2 = ID_MODULO FROM #transaccional_modulo ORDER BY ID_MODULO
		DELETE FROM #transaccional_modulo WHERE ID_MODULO = @ID_MODULO_GRUPO_2

		SELECT TOP 1 @ID_MODULO_GRUPO_3 = ID_MODULO FROM #transaccional_modulo ORDER BY ID_MODULO
		DELETE FROM #transaccional_modulo WHERE ID_MODULO = @ID_MODULO_GRUPO_3		

		SELECT TOP 1 @ID_MODULO_GRUPO_4 = ID_MODULO FROM #transaccional_modulo ORDER BY ID_MODULO
		DELETE FROM #transaccional_modulo WHERE ID_MODULO = @ID_MODULO_GRUPO_4		
		
		
		SELECT TOP 1 @ID_MODULO_GRUPO_5 = ID_MODULO FROM #transaccional_modulo ORDER BY ID_MODULO
		DELETE FROM #transaccional_modulo WHERE ID_MODULO = @ID_MODULO_GRUPO_5

		SELECT TOP 1 @ID_MODULO_GRUPO_6 = ID_MODULO FROM #transaccional_modulo ORDER BY ID_MODULO
		DELETE FROM #transaccional_modulo WHERE ID_MODULO = @ID_MODULO_GRUPO_6

		--Eliminar TablaTemporal
		DROP TABLE #transaccional_modulo
	End

	Begin 
				SELECT 
					@ID_TIPO_ITINERARIO = pe.ID_TIPO_ITINERARIO
				FROM					
					transaccional.plan_estudio pe
				WHERE 
					pe.ID_PLAN_ESTUDIO	= @ID_PLAN_ESTUDIO			
					AND pe.ES_ACTIVO	= 1		
	End

	Begin --> REGISTROS POR TIPO DE ITINERARIOS 

		Begin --> ITINERARIO POR_ASIGNATURA 

			IF @ID_TIPO_ITINERARIO = @ITINERARIO_POR_ASIGNATURA 
			Begin

			--Begin --> CABECERA 

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
			
					UNION ALL
			
					SELECT 
						"A" = 'Programa de estudios:'		,"B" = UPPER(c.NOMBRE_CARRERA)						,"C" = ''								,"D" = 'Plan de estudios:'			,"E" = UPPER(pe.NOMBRE_PLAN_ESTUDIOS)
												
					FROM
						transaccional.carreras_por_institucion cpi
						INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION
						INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA
						INNER JOIN maestro.nivel_formacion nf ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO  --c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION --reemplazoPorVista
						INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
					WHERE 1 = 1
						AND pe.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND enum.ID_TIPO_ENUMERADO	= @CODIGO_ENUMERADO_TIPO_ITINERARIO
						AND cpi.ES_ACTIVO			= 1
						AND pe.ES_ACTIVO			= 1
						--AND c.ESTADO				= 1	--reemplazoPorVista
						AND nf.ESTADO				= 1
			
					UNION ALL
			
					SELECT 
						"A" = 'Nivel de formación:'			,"B" = UPPER(nf.NOMBRE_NIVEL_FORMACION)				,"C" = ''								,"D" = 'Tipo itinerario:'			,"E" = UPPER(enum.VALOR_ENUMERADO)

					FROM
						transaccional.carreras_por_institucion cpi
						INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION
						INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA
						INNER JOIN maestro.nivel_formacion nf ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO  --c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION	--reemplazoPorVista
						INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
					WHERE 1 = 1
						AND pe.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND enum.ID_TIPO_ENUMERADO	= @CODIGO_ENUMERADO_TIPO_ITINERARIO
						AND cpi.ES_ACTIVO			= 1
						AND pe.ES_ACTIVO			= 1
						--AND c.ESTADO				= 1		--reemplazoPorVista
						AND nf.ESTADO				= 1

					UNION ALL
			--End 

			--Begin --> 1 ESPACIO EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''

					UNION ALL
			--End	

			--Begin --> GRUPO 1 

					SELECT
						"A" = m.NOMBRE_MODULO				,"B" = 'HORAS'										,"C" = ''								,"D" = ''							,"E" = ''
					FROM 
						transaccional.modulo m
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_1

					UNION ALL

					SELECT
						"A" = ud.NOMBRE_UNIDAD_DIDACTICA								
						,"B" = 
						CASE
							WHEN ud.HORAS IS NULL THEN ''
							WHEN CONVERT(VARCHAR,ud.HORAS) <> '' THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)							
						END												 
						,"C" = ''
						,"D" = ''
						,"E" = ''
					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO																						
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_1

					UNION ALL
			--End

			--Begin --> 2 ESPACIOs EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_2 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_2 IS NOT NULL

					UNION ALL

			--End

			--Begin --> GRUPO 2 

					SELECT
						"A" = m.NOMBRE_MODULO				,"B" = 'HORAS'										,"C" = ''								,"D" = ''							,"E" = ''
					FROM 
						transaccional.modulo m
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_2

					UNION ALL

					SELECT
						"A" = ud.NOMBRE_UNIDAD_DIDACTICA								
						,"B" = 
						CASE
							WHEN ud.HORAS IS NULL THEN ''
							WHEN CONVERT(VARCHAR,ud.HORAS) <> '' THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)							
						END												 
						,"C" = ''
						,"D" = ''
						,"E" = ''
					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO																						
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_2

					UNION ALL
			--End

			--Begin --> 2 ESPACIOs EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_3 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_3 IS NOT NULL

					UNION ALL

			--End

			--Begin --> GRUPO 3 

					SELECT
						"A" = m.NOMBRE_MODULO				,"B" = 'HORAS'										,"C" = ''								,"D" = ''							,"E" = ''
					FROM 
						transaccional.modulo m
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_3

					UNION ALL

					SELECT
						"A" = ud.NOMBRE_UNIDAD_DIDACTICA								
						,"B" = 
						CASE
							WHEN ud.HORAS IS NULL THEN ''
							WHEN CONVERT(VARCHAR,ud.HORAS) <> '' THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)							
						END												 
						,"C" = ''
						,"D" = ''
						,"E" = ''
					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO																						
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_3

					UNION ALL
			--End

			--Begin --> 2 ESPACIOs EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_4 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_4 IS NOT NULL

					UNION ALL

			--End

			--Begin --> GRUPO 4 

					SELECT
						"A" = m.NOMBRE_MODULO				,"B" = 'HORAS'										,"C" = ''								,"D" = ''							,"E" = ''
					FROM 
						transaccional.modulo m
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_4

					UNION ALL

					SELECT
						"A" = ud.NOMBRE_UNIDAD_DIDACTICA								
						,"B" = 
						CASE
							WHEN ud.HORAS IS NULL THEN ''
							WHEN CONVERT(VARCHAR,ud.HORAS) <> '' THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)							
						END												 
						,"C" = ''
						,"D" = ''
						,"E" = ''
					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO																						
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_4

					UNION ALL
			--End

			--Begin --> 2 ESPACIOs EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_5 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_5 IS NOT NULL

					UNION ALL

			--End

			--Begin --> GRUPO 5 

					SELECT
						"A" = m.NOMBRE_MODULO				,"B" = 'HORAS'										,"C" = ''								,"D" = ''							,"E" = ''
					FROM 
						transaccional.modulo m
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_5

					UNION ALL

					SELECT
						"A" = ud.NOMBRE_UNIDAD_DIDACTICA								
						,"B" = 
						CASE
							WHEN ud.HORAS IS NULL THEN ''
							WHEN CONVERT(VARCHAR,ud.HORAS) <> '' THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)							
						END												 
						,"C" = ''
						,"D" = ''
						,"E" = ''
					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO																						
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_5

					UNION ALL
			--End

			--Begin --> 2 ESPACIOs EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_6 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''
					WHERE
						@ID_MODULO_GRUPO_6 IS NOT NULL

					UNION ALL

			--End

			--Begin --> GRUPO 6 

					SELECT
						"A" = m.NOMBRE_MODULO				,"B" = 'HORAS'										,"C" = ''								,"D" = ''							,"E" = ''
					FROM 
						transaccional.modulo m
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_6

					UNION ALL

					SELECT
						"A" = ud.NOMBRE_UNIDAD_DIDACTICA								
						,"B" = 
						CASE
							WHEN ud.HORAS IS NULL THEN ''
							WHEN CONVERT(VARCHAR,ud.HORAS) <> '' THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)							
						END												 
						,"C" = ''
						,"D" = ''
						,"E" = ''
					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO																						
					WHERE
							m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_6

					--UNION ALL
			--End			

			End			

		End

		Begin --> ITINERARIO TRANSVERSAL 

			IF @ID_TIPO_ITINERARIO = @ITINERARIO_TRANSVERSAL
			Begin

			 IF @NIVEL_FORMATIVO = 1 -- NIVEL TECNICO
			 BEGIN
			       --Begin --> CABECERA 

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							

							UNION ALL

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
			
							UNION ALL
			
							SELECT 
								"A" = 'Programa de estudios:'		,"B" = UPPER(c.NOMBRE_CARRERA)						,"C" = ''								,"D" = 'Plan de estudios:'			,"E" = UPPER(pe.NOMBRE_PLAN_ESTUDIOS)			,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
							FROM
								transaccional.carreras_por_institucion cpi
								INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION
								INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA
								INNER JOIN maestro.nivel_formacion nf ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO  --c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION	--reemplazoPorVista
								INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
							WHERE 1 = 1
								AND pe.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
								AND enum.ID_TIPO_ENUMERADO	= @CODIGO_ENUMERADO_TIPO_ITINERARIO
								AND cpi.ES_ACTIVO			= 1
								AND pe.ES_ACTIVO			= 1
								--AND c.ESTADO				= 1	--reemplazoPorVista
								AND nf.ESTADO				= 1
			
							UNION ALL
			
							SELECT 
								"A" = 'Nivel de formación:'			,"B" = UPPER(nf.NOMBRE_NIVEL_FORMACION)				,"C" = ''								,"D" = 'Tipo itinerario:'			,"E" = UPPER(enum.VALOR_ENUMERADO)				,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
							FROM
								transaccional.carreras_por_institucion cpi
								INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION
								INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA
								INNER JOIN maestro.nivel_formacion nf ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO --c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION	--reemplazoPorVista
								INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
							WHERE 1 = 1
								AND pe.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
								AND enum.ID_TIPO_ENUMERADO	= @CODIGO_ENUMERADO_TIPO_ITINERARIO
								AND cpi.ES_ACTIVO			= 1
								AND pe.ES_ACTIVO			= 1
								--AND c.ESTADO				= 1	--reemplazoPorVista
								AND nf.ESTADO				= 1

							UNION ALL
			
					--End --> FIN CABECERA

					--Begin --> 1 ESPACIO EN BLANCO

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							

							UNION ALL

					--End --> FIN 1 ESPACIO EN BLANCO 

					--Begin --> GRUPO ESPECIAL

							SELECT
								"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
								,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							

							UNION ALL

							SELECT
								"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
								,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
								,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''

							UNION ALL				

							--Begin --> GRUPO ESP 1 

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_TRANSVERSAL	
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END
							
									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN
														CONVERT(VARCHAR, CONVERT(FLOAT, (SELECT SUM(msc.HORAS_ME) FROM transaccional.modulo msc WHERE msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_TRANSVERSAL)), 128 )
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01

							--End --> FIN GRUPO ESP 1   

							UNION ALL

							--Begin --> GRUPO ESP 2 

								SELECT
									"A" = '' 
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END
							
									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_02

							--End --> FIN GRUPO ESP 2 

							UNION ALL

							--Begin --> GRUPO ESP 3 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
						
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_03

							--End --> FIN GRUPO ESP 3  

							UNION ALL

							--Begin --> GRUPO ESP 4 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_04

							--End --> FIN GRUPO ESP 4 

							UNION ALL

							--Begin --> GRUPO ESP 5 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )
									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_05

							--End --> FIN GRUPO ESP 5 

							UNION ALL

							--Begin --> GRUPO ESP 6 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_06

							--End --> FIN GRUPO ESP 6 

							UNION ALL

							--Begin --> GRUPO ESP 7 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_07

							--End --> FIN GRUPO ESP 7 

							UNION ALL

							--Begin --> GRUPO ESP 8

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_08

							--End --> FIN GRUPO ESP 8

							UNION ALL

							--Begin --> GRUPO ESP 9 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_09

							--End --> FIN GRUPO ESP 9 

							UNION ALL

							--Begin --> GRUPO ESP 10 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_10

							--End --> FIN GRUPO ESP 10 

							UNION ALL

							--Begin --> GRUPO ESP 11 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END 

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_11

							--End --> FIN GRUPO ESP 11 

							UNION ALL

					--End


					--Begin --> 2 ESPACIO EN BLANCO

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 IS NOT NULL

							UNION ALL

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 IS NOT NULL
			
							UNION ALL

					--End --> FIN 2 ESPACIO EN BLANCO


					--Begin --> GRUPO ESTANDAR

							--Begin --> GRUPO 1 

								SELECT
									"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
									,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
									,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
									,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 IS NOT NULL

								UNION ALL

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_TECNICO
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					                         
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														(CASE WHEN m.HORAS_ME = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 ) END) 
													ELSE 
														'' 
													END					

									,"O" =	CONVERT(VARCHAR,ud.CREDITOS_ME)			

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.TOTAL_HORAS)
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 

								UNION ALL

							--End --> FIN GRUPO 1 

						--Begin --> 2 ESPACIO EN BLANCO

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 IS NOT NULL
			
								UNION ALL

						--End --> FIN 2 ESPACIO EN BLANCO

							--Begin --> GRUPO 2 

								SELECT
									"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
									,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
									,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
									,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 IS NOT NULL

								UNION ALL

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_TECNICO
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														(CASE WHEN m.HORAS_ME = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 ) END) 
													ELSE 
														'' 
													END					

									,"O" =	CONVERT(VARCHAR,ud.CREDITOS_ME)			

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.TOTAL_HORAS)
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02

								UNION ALL

							--End --> FIN GRUPO 2

						--Begin --> 2 ESPACIO EN BLANCO

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 IS NOT NULL
			
								UNION ALL

						--End --> FIN 2 ESPACIO EN BLANCO

							--Begin --> GRUPO 3 

								SELECT
									"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
									,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
									,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
									,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 IS NOT NULL

								UNION ALL

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_TECNICO
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														(CASE WHEN m.HORAS_ME = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 ) END) 
													ELSE 
														'' 
													END					

									,"O" =	CONVERT(VARCHAR,ud.CREDITOS_ME)			

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.TOTAL_HORAS)
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03
					
								UNION ALL

							--End --> FIN GRUPO 3

						--Begin --> 2 ESPACIO EN BLANCO

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 IS NOT NULL
			
								UNION ALL

						--End --> FIN 2 ESPACIO EN BLANCO

							--Begin --> GRUPO 4 

								SELECT
									"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
									,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
									,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
									,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 IS NOT NULL

								UNION ALL

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_TECNICO
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														(CASE WHEN m.HORAS_ME = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 ) END) 
													ELSE 
														'' 
													END					

									,"O" =	CONVERT(VARCHAR,ud.CREDITOS_ME)			

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.TOTAL_HORAS)
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04
					
								UNION ALL

							--End --> FIN GRUPO 4

						--Begin --> 2 ESPACIO EN BLANCO

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
			
								UNION ALL

						--End --> FIN 2 ESPACIO EN BLANCO


						--Begin --> CONSOLIDADO

			
								SELECT --ID_PLAN_ESTUDIO_DETALLE
									"A" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ped.ID_PLAN_ESTUDIO_DETALLE)) = '1' THEN 'Consolidado'	ELSE '' END					
									,"B" = ped.DESCRIPCION_CONSOLIDADO
									,"C" = ''								
									,"D" = ''							
									,"E" = ''
									,"F" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_I)		
									,"G" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_II)		
									,"H" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_III)		
									,"I" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_IV)		
									,"J" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_V)					
									,"K" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_VI)

									,"L" = CASE WHEN ped.COLUMNA_L IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_L = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_L), 128 ) END )	END 

									,"M" = CASE WHEN ped.COLUMNA_M IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_M = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_M), 128 ) END )	END 

									,"N" = CASE WHEN ped.COLUMNA_N IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_N = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_N), 128 ) END )	END 

									,"O" = CASE WHEN ped.COLUMNA_O IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_O = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_O), 128 ) END )	END 

									,"P" = CASE WHEN ped.COLUMNA_P IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_P = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_P), 128 ) END )	END 

								FROM
								transaccional.plan_estudio_detalle ped
								WHERE 1 = 1
									AND ped.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO


				  --End --> FIN CONSOLIDADO

					--End --> FIN GRUPO ESTANDAR


					--IF 1 = 0 SELECT 1 --Para que no se caiga el Begin End

			 END
			 ELSE -- NIVEL TECNICO PROFESIONAL
			 BEGIN
			      --Begin --> CABECERA 

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							

							UNION ALL

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
			
							UNION ALL
			
							SELECT 
								"A" = 'Programa de estudios:'		,"B" = UPPER(c.NOMBRE_CARRERA)						,"C" = ''								,"D" = 'Plan de estudios:'			,"E" = UPPER(pe.NOMBRE_PLAN_ESTUDIOS)			,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
							FROM
								transaccional.carreras_por_institucion cpi
								INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION
								INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA
								INNER JOIN maestro.nivel_formacion nf ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO  --c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION	--reemplazoPorVista
								INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
							WHERE 1 = 1
								AND pe.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
								AND enum.ID_TIPO_ENUMERADO	= @CODIGO_ENUMERADO_TIPO_ITINERARIO
								AND cpi.ES_ACTIVO			= 1
								AND pe.ES_ACTIVO			= 1
								--AND c.ESTADO				= 1	--reemplazoPorVista
								AND nf.ESTADO				= 1
			
							UNION ALL
			
							SELECT 
								"A" = 'Nivel de formación:'			,"B" = UPPER(nf.NOMBRE_NIVEL_FORMACION)				,"C" = ''								,"D" = 'Tipo itinerario:'			,"E" = UPPER(enum.VALOR_ENUMERADO)				,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
							FROM
								transaccional.carreras_por_institucion cpi
								INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION
								INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA
								INNER JOIN maestro.nivel_formacion nf ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO --c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION	--reemplazoPorVista
								INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
							WHERE 1 = 1
								AND pe.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
								AND enum.ID_TIPO_ENUMERADO	= @CODIGO_ENUMERADO_TIPO_ITINERARIO
								AND cpi.ES_ACTIVO			= 1
								AND pe.ES_ACTIVO			= 1
								--AND c.ESTADO				= 1	--reemplazoPorVista
								AND nf.ESTADO				= 1

							UNION ALL
			
					--End --> FIN CABECERA

					--Begin --> 1 ESPACIO EN BLANCO

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							

							UNION ALL

					--End --> FIN 1 ESPACIO EN BLANCO 

					--Begin --> GRUPO ESPECIAL

							SELECT
								"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
								,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							

							UNION ALL

							SELECT
								"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
								,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
								,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''

							UNION ALL				

							--Begin --> GRUPO ESP 1 

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_TRANSVERSAL	
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END
							
									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN
														CONVERT(VARCHAR, CONVERT(FLOAT, (SELECT SUM(msc.HORAS_ME) FROM transaccional.modulo msc WHERE msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_TRANSVERSAL)), 128 )
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_01

							--End --> FIN GRUPO ESP 1   

							UNION ALL

							--Begin --> GRUPO ESP 2 

								SELECT
									"A" = '' 
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END
							
									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_02

							--End --> FIN GRUPO ESP 2 

							UNION ALL

							--Begin --> GRUPO ESP 3 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
						
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_03

							--End --> FIN GRUPO ESP 3  

							UNION ALL

							--Begin --> GRUPO ESP 4 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_04

							--End --> FIN GRUPO ESP 4 

							UNION ALL

							--Begin --> GRUPO ESP 5 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )
									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_05

							--End --> FIN GRUPO ESP 5 

							UNION ALL

							--Begin --> GRUPO ESP 6 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_06

							--End --> FIN GRUPO ESP 6 

							UNION ALL

							--Begin --> GRUPO ESP 7 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_07

							--End --> FIN GRUPO ESP 7 

							UNION ALL

							--Begin --> GRUPO ESP 8

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_08

							--End --> FIN GRUPO ESP 8

							UNION ALL

							--Begin --> GRUPO ESP 9 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_09

							--End --> FIN GRUPO ESP 9 

							UNION ALL

							--Begin --> GRUPO ESP 10 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END					

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_10

							--End --> FIN GRUPO ESP 10 

							UNION ALL

							--Begin --> GRUPO ESP 11 

								SELECT
									"A" = ''													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 )
													ELSE 
														'' 
													END					

									,"O" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.CREDITOS_ME)
													ELSE 
														'' 
													END 

									,"P" = ''
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TRANSVERSALES_GRUPO_ESP_11

							--End --> FIN GRUPO ESP 11 

							UNION ALL

					--End


					--Begin --> 2 ESPACIO EN BLANCO

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 IS NOT NULL

							UNION ALL

							SELECT
								"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
								,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
								,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 IS NOT NULL
			
							UNION ALL

					--End --> FIN 2 ESPACIO EN BLANCO


					--Begin --> GRUPO ESTANDAR

							--Begin --> GRUPO 1 

								SELECT
									"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
									,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
									,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
									,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 IS NOT NULL

								UNION ALL

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_PROFESIONAL
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					                         
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														(CASE WHEN m.HORAS_ME = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 ) END) 
													ELSE 
														'' 
													END					

									,"O" =	CONVERT(VARCHAR,ud.CREDITOS_ME)			

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.TOTAL_HORAS)
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_01 

								UNION ALL

							--End --> FIN GRUPO 1 

						--Begin --> 2 ESPACIO EN BLANCO

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 IS NOT NULL
			
								UNION ALL

						--End --> FIN 2 ESPACIO EN BLANCO

							--Begin --> GRUPO 2 

								SELECT
									"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
									,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
									,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
									,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02 IS NOT NULL

								UNION ALL

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_PROFESIONAL
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														(CASE WHEN m.HORAS_ME = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 ) END) 
													ELSE 
														'' 
													END					

									,"O" =	CONVERT(VARCHAR,ud.CREDITOS_ME)			

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.TOTAL_HORAS)
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_02

								UNION ALL

							--End --> FIN GRUPO 2

						--Begin --> 2 ESPACIO EN BLANCO

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 IS NOT NULL
			
								UNION ALL

						--End --> FIN 2 ESPACIO EN BLANCO

							--Begin --> GRUPO 3 

								SELECT
									"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
									,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
									,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
									,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03 IS NOT NULL

								UNION ALL

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_PROFESIONAL
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														(CASE WHEN m.HORAS_ME = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 ) END) 
													ELSE 
														'' 
													END					

									,"O" =	CONVERT(VARCHAR,ud.CREDITOS_ME)			

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.TOTAL_HORAS)
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_03
					
								UNION ALL

							--End --> FIN GRUPO 3

						--Begin --> 2 ESPACIO EN BLANCO

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 IS NOT NULL
			
								UNION ALL

						--End --> FIN 2 ESPACIO EN BLANCO

							--Begin --> GRUPO 4 

								SELECT
									"A" = ''							,"B" = 'Módulos'									,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = 'Periodo académico'
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = 'Unidades Didácticas'
									,"M" = ''							,"N" = 'Módulo Educativos'							,"O" = ''								,"P" = 'Total de horas'							
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 IS NOT NULL

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'I'
									,"G" = 'II'							,"H" = 'III'										,"I" = 'IV'								,"J" = 'V'							,"K" = 'VI'										,"L" = 'Horas'
									,"M" = 'Créditos'					,"N" = 'Horas'										,"O" = 'Créditos'						,"P" = ''
								WHERE
									@ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04 IS NOT NULL

								UNION ALL

								SELECT
									"A" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,(
																	SELECT 
																		--TOP 1 
																		UPPER(ensc.VALOR_ENUMERADO)
																	FROM 
																		transaccional.modulo msc 
																		INNER JOIN sistema.enumerado ensc ON msc.ID_TIPO_MODULO = ensc.ID_ENUMERADO
																	WHERE 
																		msc.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
																		AND msc.ID_TIPO_MODULO = @ID_TIPO_MODULO_PROFESIONAL
																		AND ensc.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_MODULO
																		AND msc.ID_MODULO = @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04
																	))
													ELSE 
														'' 
													END
													
									,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
									,"C" = CONVERT(VARCHAR,tup.NOMBRE_TIPO_UNIDAD)
									,"D" = ud.CODIGO_UNIDAD_DIDACTICA	,"E" = ud.NOMBRE_UNIDAD_DIDACTICA
					
									,"F" =	CASE WHEN ud.PERIODO_ACADEMICO_I IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_I) END
									,"G" =	CASE WHEN ud.PERIODO_ACADEMICO_II IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_II) END
									,"H" =	CASE WHEN ud.PERIODO_ACADEMICO_III IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_III) END
									,"I" =	CASE WHEN ud.PERIODO_ACADEMICO_IV IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_IV) END
									,"J" =	CASE WHEN ud.PERIODO_ACADEMICO_V IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_V) END
									,"K" =	CASE WHEN ud.PERIODO_ACADEMICO_VI IS NULL THEN '' ELSE CONVERT(VARCHAR,ud.PERIODO_ACADEMICO_VI) END

									,"L" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128 )

									,"M" = CASE WHEN ud.CREDITOS = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128 ) END 
					
									,"N" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														(CASE WHEN m.HORAS_ME = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, m.HORAS_ME), 128 ) END) 
													ELSE 
														'' 
													END					

									,"O" =	CONVERT(VARCHAR,ud.CREDITOS_ME)			

									,"P" =	CASE		
												WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY m.ID_MODULO)) = '1' 
													THEN 
														CONVERT(VARCHAR,m.TOTAL_HORAS)
													ELSE 
														'' 
													END 
								FROM 
									transaccional.modulo m
									INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
									INNER JOIN maestro.tipo_unidad_didactica tup ON ud.ID_TIPO_UNIDAD_DIDACTICA = tup.ID_TIPO_UNIDAD_DIDACTICA

								WHERE 1 = 1
									AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
									AND m.ID_MODULO				= @ID_MODULO_TECNICO_PROFESIONAL_GRUPO_04
					
								UNION ALL

							--End --> FIN GRUPO 4

						--Begin --> 2 ESPACIO EN BLANCO

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							

								UNION ALL

								SELECT
									"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
									,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
									,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''							
			
								UNION ALL

						--End --> FIN 2 ESPACIO EN BLANCO


						--Begin --> CONSOLIDADO

			
								SELECT --ID_PLAN_ESTUDIO_DETALLE
									"A" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ped.ID_PLAN_ESTUDIO_DETALLE)) = '1' THEN 'Consolidado'	ELSE '' END					
									,"B" = ped.DESCRIPCION_CONSOLIDADO
									,"C" = ''								
									,"D" = ''							
									,"E" = ''
									,"F" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_I)		
									,"G" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_II)		
									,"H" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_III)		
									,"I" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_IV)		
									,"J" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_V)					
									,"K" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_VI)

									,"L" = CASE WHEN ped.COLUMNA_L IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_L = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_L), 128 ) END )	END 

									,"M" = CASE WHEN ped.COLUMNA_M IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_M = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_M), 128 ) END )	END 

									,"N" = CASE WHEN ped.COLUMNA_N IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_N = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_N), 128 ) END )	END 

									,"O" = CASE WHEN ped.COLUMNA_O IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_O = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_O), 128 ) END )	END 

									,"P" = CASE WHEN ped.COLUMNA_P IS NULL THEN '' ELSE ( CASE WHEN ped.COLUMNA_P = 0 THEN '0' ELSE CONVERT(VARCHAR, CONVERT(FLOAT, ped.COLUMNA_P), 128 ) END )	END 

								FROM
								transaccional.plan_estudio_detalle ped
								WHERE 1 = 1
									AND ped.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO


				  --End --> FIN CONSOLIDADO

					--End --> FIN GRUPO ESTANDAR


					--IF 1 = 0 SELECT 1 --Para que no se caiga el Begin End

			 END

					
			End --if			
			
			
			--IF 1 = 0 SELECT 1 --Para que no se caiga el Begin End
		End

		Begin --> ITINERARIO MODULAR 

			IF @ID_TIPO_ITINERARIO = @ITINERARIO_MODULAR 
			Begin 

			--Begin --> CABECERA 

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = '' 
						,"U" = ''							,"V" = '' --AGREGADO POR CARRERA NIVEL PROFESIONAL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = '' 
						,"U" = ''							,"V" = '' --AGREGADO POR CARRERA NIVEL PROFESIONAL
			
					UNION ALL
			
					SELECT 
						"A" = 'Programa de estudios:'		,"B" = UPPER(c.NOMBRE_CARRERA)						,"C" = ''								,"D" = 'Plan de estudios:'			,"E" = UPPER(pe.NOMBRE_PLAN_ESTUDIOS)			,"F" = ''
						,"G" = 'Tipo Modalidad:'				,"H" = UPPER(se_enf.VALOR_ENUMERADO)				,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = '' 
						,"U" = ''							,"V" = '' 	--AGREGADO POR CARRERA NIVEL PROFESIONAL					
					FROM
						transaccional.carreras_por_institucion cpi
						INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION
						inner join transaccional.enfoques_por_plan_estudio expe on expe.ID_PLAN_ESTUDIO= pe.ID_PLAN_ESTUDIO and expe.ES_ACTIVO=1 and pe.ES_ACTIVO=1
						inner join maestro.enfoque e on e.ID_ENFOQUE= expe.ID_ENFOQUE 
						inner join sistema.enumerado se_enf  on se_enf.ID_ENUMERADO = e.ID_MODALIDAD_ESTUDIO
						INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA
						INNER JOIN maestro.nivel_formacion nf ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO  --c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION	--reemplazoPorVista
						INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
					WHERE 1 = 1
						AND pe.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND enum.ID_TIPO_ENUMERADO	= @CODIGO_ENUMERADO_TIPO_ITINERARIO
						AND cpi.ES_ACTIVO			= 1
						AND pe.ES_ACTIVO			= 1
						--AND c.ESTADO				= 1	--reemplazoPorVista
						AND nf.ESTADO				= 1
			
					UNION ALL
			
					SELECT 
						"A" = 'Nivel de formación:'			,"B" = UPPER(nf.NOMBRE_NIVEL_FORMACION)				,"C" = ''								,"D" = 'Tipo itinerario:'			,"E" = UPPER(enum.VALOR_ENUMERADO)				,"F" = ''
						,"G" = 'Tipo Enfoque:'				,"H" = UPPER(e.NOMBRE_ENFOQUE)						,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''

						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = '' 
						,"U" = ''							,"V" = ''  --AGREGADO POR CARRERA NIVEL PROFESIONAL	
					FROM
						transaccional.carreras_por_institucion cpi
						INNER JOIN transaccional.plan_estudio pe ON cpi.ID_CARRERAS_POR_INSTITUCION = pe.ID_CARRERAS_POR_INSTITUCION
						inner join transaccional.enfoques_por_plan_estudio expe on expe.ID_PLAN_ESTUDIO= pe.ID_PLAN_ESTUDIO and expe.ES_ACTIVO=1 and pe.ES_ACTIVO=1
						inner join maestro.enfoque e on e.ID_ENFOQUE= expe.ID_ENFOQUE 
						inner join sistema.enumerado se_enf  on se_enf.ID_ENUMERADO = e.ID_MODALIDAD_ESTUDIO
						INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA
						INNER JOIN maestro.nivel_formacion nf ON c.TIPO_NIVEL_FORMACION = nf.CODIGO_TIPO  --c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION	--reemplazoPorVista
						INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
					WHERE 1 = 1
						AND pe.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND enum.ID_TIPO_ENUMERADO	= @CODIGO_ENUMERADO_TIPO_ITINERARIO
						AND cpi.ES_ACTIVO			= 1
						AND pe.ES_ACTIVO			= 1
						--AND c.ESTADO				= 1	--reemplazoPorVista
						AND nf.ESTADO				= 1

					UNION ALL
			--End 

			--Begin --> 1 ESPACIO EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''

						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = '' 
						,"U" = ''							,"V" = '' 
						WHERE
							@ID_MODULO_GRUPO_1 IS NOT NULL

					UNION ALL
			--End

			--Begin --> GRUPO 1 

					SELECT
						"A" = 'Unidades de competencia'		,"B" = 'Módulo Formativo'							,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = 'Periodo académico'			,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = 'Horas'							,"P" = ''							,"Q" = ''								,"R" = ''					
						,"S" = 'Créditos'							,"T" = '' --CONVERT(VARCHAR,@ID_MODULO_GRUPO_1) --''
						,"U" = ''							,"V" = '' 
						WHERE
							@ID_MODULO_GRUPO_1 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'Código de predecesores'
						,"G" = 'I'							,"H" = 'II'											,"I" = 'III'							,"J" = 'IV'							,"K" = 'V'										,"L" = 'VI'
						,"M" = 'VII'							,"N" = 'VIII'											,"O" = 'TP'						,"P" = 'P'			,"Q" = 'Horas U.D'										,"R" = 'Total Horas Módulo'					
						,"S" = 'T'				,"T" = 'P' 
						,"U" = 'Créditos U.D'							,"V" = 'Total Créditos U.D' 
						WHERE
							@ID_MODULO_GRUPO_1 IS NOT NULL

					UNION ALL

					SELECT
						"A" =	CASE
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 1 AND udm.ID_MODULO = @ID_MODULO_GRUPO_1) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 1 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_1
										) 
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 2 AND udm.ID_MODULO = @ID_MODULO_GRUPO_1) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '2'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 2 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_1
										)
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 3 AND udm.ID_MODULO = @ID_MODULO_GRUPO_1) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '3'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 3 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_1
										)
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 4 AND udm.ID_MODULO = @ID_MODULO_GRUPO_1) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '4'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 4 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_1
										)
									--//
									ELSE ''								
								END

						,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
						,"C" = CONVERT(VARCHAR, tud.NOMBRE_TIPO_UNIDAD)								
						,"D" = ud.CODIGO_UNIDAD_DIDACTICA	
						,"E" = ud.NOMBRE_UNIDAD_DIDACTICA						
						
						,"F" = CASE
									WHEN (SELECT COUNT(CODIGO_PREDECESORA) FROM transaccional.unidad_didactica_detalle WHERE ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA) = 0 THEN ''
									ELSE 
										(												
											SELECT
												STUFF( 
														(
															SELECT 
																@DELIMITADOR_CODIGO_PREDECESORA_EXCEL + udd.CODIGO_PREDECESORA 
															FROM 
																transaccional.unidad_didactica_detalle udd
															WHERE
																udd.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA

															FOR XML PATH('') 
															), 1, 1, ''
													)												
											)
								END

						,"G" = CASE WHEN @PERIODO_ACADEMICO_I		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END					
						,"H" = CASE WHEN @PERIODO_ACADEMICO_II		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"I" = CASE WHEN @PERIODO_ACADEMICO_III		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"J" = CASE WHEN @PERIODO_ACADEMICO_IV		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"K" = CASE WHEN @PERIODO_ACADEMICO_V		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"L" = CASE WHEN @PERIODO_ACADEMICO_VI		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"M" = CASE WHEN @PERIODO_ACADEMICO_VII		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"N" = CASE WHEN @PERIODO_ACADEMICO_VIII	= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"O" = CASE WHEN ud.TEORICO_PRACTICO_HORAS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.TEORICO_PRACTICO_HORAS_UD), 128) ELSE '0' END 
						,"P" = CASE WHEN ud.PRACTICO_HORAS_UD <> 0 THEN  CONVERT(VARCHAR, CONVERT(FLOAT, ud.PRACTICO_HORAS_UD), 128) ELSE '0' END																											
						,"Q" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)																																		

						,"R" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN CONVERT(VARCHAR, CONVERT(FLOAT, m.TOTAL_HORAS_UD), 128) ELSE '' END		

						,"S" = CASE WHEN ud.TEORICO_PRACTICO_CREDITOS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.TEORICO_PRACTICO_CREDITOS_UD), 128) ELSE '0' END
						,"T" = CASE WHEN ud.PRACTICO_CREDITOS_UD<>0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.PRACTICO_CREDITOS_UD), 128) ELSE '0' END

						,"U" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128)																													
						,"V" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY TOTAL_CREDITOS_UD)) = '1' THEN CONVERT(VARCHAR, CONVERT(FLOAT, m.TOTAL_CREDITOS_UD), 128) ELSE '' END			

					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
						INNER JOIN maestro.tipo_unidad_didactica tud ON ud.ID_TIPO_UNIDAD_DIDACTICA = tud.ID_TIPO_UNIDAD_DIDACTICA																	

					WHERE 1 = 1
						AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_1

					UNION ALL
			--End

			--Begin --> 2 ESPACIO EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = ''												
						,"U" = ''							,"V" = ''	
						WHERE
							@ID_MODULO_GRUPO_2 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = ''	
						,"U" = ''							,"V" = ''												
						WHERE
							@ID_MODULO_GRUPO_2 IS NOT NULL
			
					UNION ALL
			--End

			--Begin --> GRUPO 2 

					SELECT
						"A" = 'Unidades de competencia'		,"B" = 'Módulo Formativo'							,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = 'Periodo académico'			,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = 'Horas'							,"P" = ''							,"Q" = ''								,"R" = ''					
						,"S" = 'Créditos'					,"T" = '' --CONVERT(VARCHAR,@ID_MODULO_GRUPO_2) --''
						,"U" = ''							,"V" = ''	
						WHERE
							@ID_MODULO_GRUPO_2 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'Código de predecesores'
						,"G" = 'I'							,"H" = 'II'											,"I" = 'III'							,"J" = 'IV'							,"K" = 'V'										,"L" = 'VI'
						,"M" = 'VII'						,"N" = 'VIII'										,"O" = 'TP'								,"P" = 'P'							,"Q" = 'Horas U.D'								,"R" = 'Total Horas Módulo'					
						,"S" = 'T'							,"T" = 'P' 
						,"U" = 'Créditos U.D'				,"V" = 'Total créditos U.D'	
						WHERE
							@ID_MODULO_GRUPO_2 IS NOT NULL

					UNION ALL

					SELECT
						"A" =	CASE
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 1 AND udm.ID_MODULO = @ID_MODULO_GRUPO_2) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 1 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_2
										) 
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 2 AND udm.ID_MODULO = @ID_MODULO_GRUPO_2) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '2'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 2 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_2
										)
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 3 AND udm.ID_MODULO = @ID_MODULO_GRUPO_2) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '3'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 3 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_2
										)
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 4 AND udm.ID_MODULO = @ID_MODULO_GRUPO_2) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '4'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 4
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_2
										)
									--//
									ELSE ''								
								END						
														
						,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
						,"C" = CONVERT(VARCHAR, tud.NOMBRE_TIPO_UNIDAD)								
						,"D" = ud.CODIGO_UNIDAD_DIDACTICA	
						,"E" = ud.NOMBRE_UNIDAD_DIDACTICA						
						
						,"F" = CASE
									WHEN (SELECT COUNT(CODIGO_PREDECESORA) FROM transaccional.unidad_didactica_detalle WHERE ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA) = 0 THEN ''
									ELSE 
										(												
											SELECT
												STUFF( 
														(
															SELECT 
																@DELIMITADOR_CODIGO_PREDECESORA_EXCEL + udd.CODIGO_PREDECESORA 
															FROM 
																transaccional.unidad_didactica_detalle udd
															WHERE
																udd.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA

															FOR XML PATH('') 
															), 1, 1, ''
													)												
											)
								END

						,"G" = CASE WHEN @PERIODO_ACADEMICO_I		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END					
						,"H" = CASE WHEN @PERIODO_ACADEMICO_II		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"I" = CASE WHEN @PERIODO_ACADEMICO_III		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"J" = CASE WHEN @PERIODO_ACADEMICO_IV		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"K" = CASE WHEN @PERIODO_ACADEMICO_V		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"L" = CASE WHEN @PERIODO_ACADEMICO_VI		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"M" = CASE WHEN @PERIODO_ACADEMICO_VII		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"N" = CASE WHEN @PERIODO_ACADEMICO_VIII	= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"O" = CASE WHEN ud.TEORICO_PRACTICO_HORAS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.TEORICO_PRACTICO_HORAS_UD), 128) ELSE '0' END
						,"P" = CASE WHEN ud.PRACTICO_HORAS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.PRACTICO_HORAS_UD), 128)	ELSE '0' END
						,"Q" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)																																			

						,"R" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN CONVERT(VARCHAR, CONVERT(FLOAT, m.TOTAL_HORAS_UD), 128) ELSE '' END		

						,"S" = CASE WHEN ud.TEORICO_PRACTICO_CREDITOS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.TEORICO_PRACTICO_CREDITOS_UD), 128) ELSE '0' END
						,"T" = CASE WHEN ud.PRACTICO_CREDITOS_UD <>0  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.PRACTICO_CREDITOS_UD), 128) ELSE '0' END

						,"U" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128)																													
						,"V" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY TOTAL_CREDITOS_UD)) = '1' THEN CONVERT(VARCHAR, CONVERT(FLOAT, m.TOTAL_CREDITOS_UD), 128) ELSE '' END			

					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
						INNER JOIN maestro.tipo_unidad_didactica tud ON ud.ID_TIPO_UNIDAD_DIDACTICA = tud.ID_TIPO_UNIDAD_DIDACTICA																	

					WHERE 1 = 1
						AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_2

					UNION ALL
			--End

			--Begin --> 2 ESPACIO EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = ''	
						,"U" = ''							,"V" = ''												
						WHERE
							@ID_MODULO_GRUPO_3 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = ''	
						,"U" = ''							,"V" = ''												
						WHERE
							@ID_MODULO_GRUPO_3 IS NOT NULL
			
					UNION ALL
			--End

			--Begin --> GRUPO 3 

					SELECT
						"A" = 'Unidades de competencia'		,"B" = 'Módulo Formativo'							,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = 'Periodo académico'			,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = 'Horas'								,"P" = ''							,"Q" = ''								,"R" = ''					
						,"S" = 'Créditos'					,"T" = '' --CONVERT(VARCHAR,@ID_MODULO_GRUPO_3) --''
						,"U" = ''							,"V" = ''	
						WHERE
							@ID_MODULO_GRUPO_3 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'Código de predecesores'
						,"G" = 'I'							,"H" = 'II'											,"I" = 'III'							,"J" = 'IV'							,"K" = 'V'										,"L" = 'VI'
						,"M" = 'VII'						,"N" = 'VIII'											,"O" = 'TP'								,"P" = 'P'							,"Q" = 'Horas U.D'								,"R" = 'Total Horas Módulo'					
						,"S" = 'T'							,"T" = 'P' 
						,"U" = 'Créditos U.D'				,"V" = 'Total créditos U.D'	
						WHERE
							@ID_MODULO_GRUPO_3 IS NOT NULL

					UNION ALL

					SELECT
						"A" =	CASE
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 1 AND udm.ID_MODULO = @ID_MODULO_GRUPO_3) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 1 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_3
										) 
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 2 AND udm.ID_MODULO = @ID_MODULO_GRUPO_3) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '2'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 2 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_3
										)
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 3 AND udm.ID_MODULO = @ID_MODULO_GRUPO_3) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '3'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 3 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_3
										)
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 4 AND udm.ID_MODULO = @ID_MODULO_GRUPO_3) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '4'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 4
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_3
										)
									--//
									ELSE ''								
								END
													
						,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
						,"C" = CONVERT(VARCHAR, tud.NOMBRE_TIPO_UNIDAD)								
						,"D" = ud.CODIGO_UNIDAD_DIDACTICA	
						,"E" = ud.NOMBRE_UNIDAD_DIDACTICA						
						
						,"F" = CASE
									WHEN (SELECT COUNT(CODIGO_PREDECESORA) FROM transaccional.unidad_didactica_detalle WHERE ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA) = 0 THEN ''
									ELSE 
										(												
											SELECT
												STUFF( 
														(
															SELECT 
																@DELIMITADOR_CODIGO_PREDECESORA_EXCEL + udd.CODIGO_PREDECESORA 
															FROM 
																transaccional.unidad_didactica_detalle udd
															WHERE
																udd.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA

															FOR XML PATH('') 
															), 1, 1, ''
													)												
											)
								END

						,"G" = CASE WHEN @PERIODO_ACADEMICO_I		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END					
						,"H" = CASE WHEN @PERIODO_ACADEMICO_II		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"I" = CASE WHEN @PERIODO_ACADEMICO_III		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"J" = CASE WHEN @PERIODO_ACADEMICO_IV		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"K" = CASE WHEN @PERIODO_ACADEMICO_V		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"L" = CASE WHEN @PERIODO_ACADEMICO_VI		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"M" = CASE WHEN @PERIODO_ACADEMICO_VII		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"N" = CASE WHEN @PERIODO_ACADEMICO_VIII	= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"O" = CASE WHEN ud.TEORICO_PRACTICO_HORAS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.TEORICO_PRACTICO_HORAS_UD), 128)	ELSE '0' END 
						,"P" = CASE WHEN ud.PRACTICO_HORAS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.PRACTICO_HORAS_UD), 128) ELSE '0' END
						,"Q" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)																																			

						,"R" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN CONVERT(VARCHAR, CONVERT(FLOAT, m.TOTAL_HORAS_UD), 128) ELSE '' END		

						,"S" = CASE WHEN ud.TEORICO_PRACTICO_CREDITOS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.TEORICO_PRACTICO_CREDITOS_UD), 128) ELSE '0' END
						,"T" = CASE WHEN ud.PRACTICO_CREDITOS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.PRACTICO_CREDITOS_UD), 128) ELSE '0' END 

						,"U" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128)																													
						,"V" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY TOTAL_CREDITOS_UD)) = '1' THEN CONVERT(VARCHAR, CONVERT(FLOAT, m.TOTAL_CREDITOS_UD), 128) ELSE '' END			

					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
						INNER JOIN maestro.tipo_unidad_didactica tud ON ud.ID_TIPO_UNIDAD_DIDACTICA = tud.ID_TIPO_UNIDAD_DIDACTICA																	

					WHERE 1 = 1
						AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_3

					UNION ALL
			--End

			--Begin --> 2 ESPACIO EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = ''	
						,"U" = ''							,"V" = ''												
						WHERE
							@ID_MODULO_GRUPO_4 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = ''
						,"U" = ''							,"V" = ''													
						WHERE
							@ID_MODULO_GRUPO_4 IS NOT NULL
			
					UNION ALL
			--End

			--Begin --> GRUPO 4 

					SELECT
						"A" = 'Unidades de competencia'		,"B" = 'Módulo Formativo'							,"C" = 'Unidades Didácticas'			,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = 'Periodo académico'			,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = 'Horas'							,"P" = ''							,"Q" = ''										,"R" = ''					
						,"S" = 'Créditos'							,"T" = '' --CONVERT(VARCHAR,@ID_MODULO_GRUPO_4) --''
						,"U" = ''							,"V" = ''	
						WHERE
							@ID_MODULO_GRUPO_4 IS NOT NULL

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = 'Tipo'							,"D" = 'Código'						,"E" = 'Nombre de U.D'							,"F" = 'Código de predecesores'
						,"G" = 'I'							,"H" = 'II'											,"I" = 'III'							,"J" = 'IV'							,"K" = 'V'										,"L" = 'VI'
						,"M" = 'VII'						,"N" = 'VIII'										,"O" = 'TP'								,"P" = 'P'							,"Q" = 'Horas U.D'								,"R" = 'Total Horas Módulo'					
						,"S" = 'T'							,"T" = 'P' 
						,"U" = 'Créditos U.D'				,"V" = 'Total créditos U.D'	
						WHERE
							@ID_MODULO_GRUPO_4 IS NOT NULL

					UNION ALL

					SELECT
						"A" =	CASE
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 1 AND udm.ID_MODULO = @ID_MODULO_GRUPO_4) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 1 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_4
										) 
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 2 AND udm.ID_MODULO = @ID_MODULO_GRUPO_4) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '2'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 2 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_4
										)
									--//
									WHEN 
										(SELECT COUNT(udm.ID_UNIDAD_COMPETENCIAS_POR_MODULO) FROM transaccional.unidad_competencias_por_modulo udm WHERE udm.ORDEN_VISUALIZACION = 3 AND udm.ID_MODULO = @ID_MODULO_GRUPO_4) = 1
										AND CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '3'
									THEN 
										(
											SELECT
												ud.NOMBRE_UNIDAD_COMPETENCIA
											FROM
												maestro.unidad_competencia ud
												INNER JOIN transaccional.unidad_competencias_por_modulo udm ON ud.ID_UNIDAD_COMPETENCIA = udm.ID_UNIDAD_COMPETENCIA
											WHERE 
												udm.ORDEN_VISUALIZACION = 3 
												AND udm.ID_MODULO = @ID_MODULO_GRUPO_4
										)
									--//
									ELSE ''								
								END
														
						,"B" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN m.NOMBRE_MODULO ELSE '' END
						,"C" = CONVERT(VARCHAR, tud.NOMBRE_TIPO_UNIDAD)								
						,"D" = ud.CODIGO_UNIDAD_DIDACTICA	
						,"E" = ud.NOMBRE_UNIDAD_DIDACTICA						
						
						,"F" = CASE
									WHEN (SELECT COUNT(CODIGO_PREDECESORA) FROM transaccional.unidad_didactica_detalle WHERE ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA) = 0 THEN ''
									ELSE 
										(												
											SELECT
												STUFF( 
														(
															SELECT 
																@DELIMITADOR_CODIGO_PREDECESORA_EXCEL + udd.CODIGO_PREDECESORA 
															FROM 
																transaccional.unidad_didactica_detalle udd
															WHERE
																udd.ID_UNIDAD_DIDACTICA = ud.ID_UNIDAD_DIDACTICA

															FOR XML PATH('') 
															), 1, 1, ''
													)												
											)
								END

						,"G" = CASE WHEN @PERIODO_ACADEMICO_I		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END					
						,"H" = CASE WHEN @PERIODO_ACADEMICO_II		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"I" = CASE WHEN @PERIODO_ACADEMICO_III		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"J" = CASE WHEN @PERIODO_ACADEMICO_IV		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"K" = CASE WHEN @PERIODO_ACADEMICO_V		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"L" = CASE WHEN @PERIODO_ACADEMICO_VI		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"M" = CASE WHEN @PERIODO_ACADEMICO_VII		= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END
						,"N" = CASE WHEN @PERIODO_ACADEMICO_VIII	= (SELECT enum.VALOR_ENUMERADO FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO AND	enum.ID_ENUMERADO = ud.ID_SEMESTRE_ACADEMICO)  THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128) ELSE '' END

						,"O" = CASE WHEN ud.TEORICO_PRACTICO_HORAS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.TEORICO_PRACTICO_HORAS_UD), 128) ELSE '0' END
						,"P" = CASE WHEN ud.PRACTICO_HORAS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.PRACTICO_HORAS_UD), 128)	ELSE '0' END 
						,"Q" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.HORAS), 128)																																			

						,"R" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ud.ID_UNIDAD_DIDACTICA)) = '1' THEN CONVERT(VARCHAR, CONVERT(FLOAT, m.TOTAL_HORAS_UD), 128) ELSE '' END		

						,"S" = CASE WHEN ud.TEORICO_PRACTICO_CREDITOS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.TEORICO_PRACTICO_CREDITOS_UD), 128) ELSE '0' END
						,"T" = CASE WHEN ud.PRACTICO_CREDITOS_UD <> 0 THEN CONVERT(VARCHAR, CONVERT(FLOAT, ud.PRACTICO_CREDITOS_UD), 128) ELSE '0' END

						,"U" = CONVERT(VARCHAR, CONVERT(FLOAT, ud.CREDITOS), 128)																													
						,"V" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY TOTAL_CREDITOS_UD)) = '1' THEN CONVERT(VARCHAR, CONVERT(FLOAT, m.TOTAL_CREDITOS_UD), 128) ELSE '' END			

					FROM 
						transaccional.modulo m
						INNER JOIN transaccional.unidad_didactica ud ON m.ID_MODULO = ud.ID_MODULO
						INNER JOIN maestro.tipo_unidad_didactica tud ON ud.ID_TIPO_UNIDAD_DIDACTICA = tud.ID_TIPO_UNIDAD_DIDACTICA																	

					WHERE 1 = 1
						AND m.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO
						AND m.ID_MODULO				= @ID_MODULO_GRUPO_4

					UNION ALL
			--End

			--Begin --> 2 ESPACIO EN BLANCO

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = ''	
						,"U" = ''							,"V" = ''												

					UNION ALL

					SELECT
						"A" = ''							,"B" = ''											,"C" = ''								,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = ''							,"H" = ''											,"I" = ''								,"J" = ''							,"K" = ''										,"L" = ''
						,"M" = ''							,"N" = ''											,"O" = ''								,"P" = ''
					
						,"Q" = ''							,"R" = ''
						,"S" = ''							,"T" = ''	
						,"U" = ''							,"V" = ''												
			
					UNION ALL
			--End
					--

					SELECT --ID_PLAN_ESTUDIO_DETALLE
						"A" = CASE WHEN CONVERT(VARCHAR,ROW_NUMBER() OVER ( ORDER BY ped.ID_PLAN_ESTUDIO_DETALLE)) = '1' THEN 'Consolidado'	ELSE '' END					
						,"B" = ped.DESCRIPCION_CONSOLIDADO					
						,"C" = ''							,"D" = ''							,"E" = ''										,"F" = ''
						,"G" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_I)		
						,"H" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_II)		
						,"I" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_III)		
						,"J" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_IV)		
						,"K" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_V)					
						,"L" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_VI)
						,"M" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_VII)
						,"N" = CONVERT(VARCHAR,ped.PERIODO_ACADEMICO_VIII)
						,"O" = ''							
						,"P" = ''												
						,"Q" = ''												
						,"R" = CONVERT(VARCHAR,ped.SUMA_TOTAL_HORAS_POR_TIPO)					
						,"S" = ''							
						,"T" = ''
						,"U" = CASE WHEN ped.TOTAL_CREDITOS_UD = 0			THEN '' ELSE CONVERT(VARCHAR,ped.TOTAL_CREDITOS_UD)			END							
						,"V" = CASE WHEN ped.SUMA_TOTAL_CREDITOS_UD = 0		THEN '' ELSE CONVERT(VARCHAR,ped.SUMA_TOTAL_CREDITOS_UD)	END					
										
					FROM
					transaccional.plan_estudio_detalle ped
					WHERE 1 = 1
						AND ped.ID_PLAN_ESTUDIO		= @ID_PLAN_ESTUDIO								

			End

		End

	End

--IF 1 = 0 SELECT 1 --Para que no se caiga el Begin End
END
GO


