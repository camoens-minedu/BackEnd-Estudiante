/**********************************************************************************************************
  AUTOR:			FERNANDO RAMOS C.
  CREACION:			07/08/2018
  BASE DE DATOS:	DB_REGIA_2
  DESCRIPCION:		CREACION DE PLAN DE ESTUDIO POR EXCEL
---------------------------------------------------------------------------------------------------------
	VERSIÓN		FECHA MODIF.	USUARIO			DESCRIPCIÓN
---------------------------------------------------------------------------------------------------------
	1.1			18/02/2019		MALVA			Modificación de inserción por asignatura, agregar ID_SEMESTRE_ACADEMICO.
	1.2			16/09/2019		MALVA			Modificacion de campos de un valor VARCHAR(150) A UN VALOR VARCHAR(MAX) PARA LOS MODULOS Y UNIDAD DE COMPETENCIA.
	1.3			22/05/2020		MALVA			Adción de filas planes modulares y transversales
	1.3			12/06/2020		MALVA			INTEGRACIÓN PARA SOPORTE DE PLANES DE ESTUDIOS NIVEL PROFESIONAL, modular. 		
	1.4			01/12/2021		JTOVAR			INTEGRACIÓN PLAN TRANSVERSAL DE NIVEL TECNICO 		
	
	TEST:			

**********************************************************************************************************/
CREATE PROCEDURE [dbo].[USP_INSTITUCION_INS_PLAN_ESTUDIO]
(	
	@QUERY_EXCEL NVARCHAR(MAX),	
	--//
	@ID_INSTITUCION			INT,
	@PROGRAMA_ESTUDIOS		VARCHAR(200),
	@TIPO_ITINERARIO		VARCHAR(200),
	--//
	@TIPO_MODALIDAD			VARCHAR(200),
	@TIPO_ENFOQUE			VARCHAR(200),
	--//
    @ES_ACTIVO				BIT,						
    @ESTADO					SMALLINT,				
    @USUARIO_CREACION		NVARCHAR(20)
/*
--	DECLARE @QUERY_EXCEL NVARCHAR(MAX)='[INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''1''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''2''[FIN] [INICIO]''Programa de estudios:'',''ABASTECIMIENTO'','' '',''Plan de estudios:'',''PLAN 2020'','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''3''[FIN] [INICIO]''Nivel de formación'',''PROFESIONAL TÉCNICO'','' '',''Tipo itinerario:'',''TRANSVERSAL'','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''4''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''5''[FIN] [INICIO]''Tipo de Módulos'',''Módulos'',''Unidades Didácticas'','' '','' '',''Horas del Periodo Académico'','' '','' '','' '','' '','' '',''Unidades Didácticas'','' '',''Módulos Educativos'','' '',''Total de horas'','' '','' '','' '','' '','' '','' '',''6''[FIN] [INICIO]'' '','' '',''Tipo'',''Código correlativo de U.D.'',''Nombre de U.D'',''I'',''II'',''III'',''IV'',''V'',''VI'',''Horas'',''Créditos'',''Horas'',''Créditos'','' '','' '','' '','' '','' '','' '','' '',''7''[FIN] [INICIO]''MODULOS TRANSVERSALES'',''COMUNICACIÓN'',''Transversal'',''1'',''Técnicas de comunicación'',''2'','' '','' '','' '','' '','' '',''36'',''1,5'',''72'',''3'',''810'','' '','' '','' '','' '','' '','' '',''8''[FIN] [INICIO]'' '','' '',''Transversal'',''2'',''Interpretación y producción de textos'','' '',''2'','' '','' '','' '','' '',''36'',''1,5'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''9''[FIN] [INICIO]'' '',''MATEMATICA'',''Transversal'',''3'',''Lógica y funciones'',''2'','' '','' '','' '','' '','' '',''36'',''1,5'',''72'',''3'','' '','' '','' '','' '','' '','' '','' '',''10''[FIN] [INICIO]'' '','' 
--'',''Transversal'',''4'',''Estadística general'','' '',''2'','' '','' '','' '','' '',''36'',''1,5'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''11''[FIN] [INICIO]'' '',''SOCIEDAD Y ECONOMIA'',''Transversal'',''5'',''Sociedad y economía  en la 
--globalización'','' '','' '',''3'','' '','' '','' '',''54'',''2'',''54'',''2'','' '','' '','' '','' '','' '','' '','' '',''12''[FIN] [INICIO]'' '',''MEDIO AMBIENTE Y DESARROLLO SOSTENIDO'',''Transversal'',''6'',''Medio ambiente y desarrollo sostenible'','' '','' '',''3'','' '','' '','' '',''54'',''2'',''54'',''2'','' '','' '','' '','' '','' '','' '','' '',''13''[FIN] [INICIO]'' '',''ACTIVIDADES'',''Transversal'',''7'',''Cultura física y deporte'',''2'','' '','' '','' '','' '','' '',''36'',''1,5'',''72'',''3'','' '','' '','' 
--'','' '','' '','' '','' '',''14''[FIN] [INICIO]'' '','' '',''Transversal'',''8'',''Cultura artística'','' '',''2'','' '','' '','' '','' '',''36'',''1,5'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''15''[FIN] [INICIO]'' 
--'',''INFORMATICA'',''Transversal'',''9'',''Informática e internet'',''2'','' '','' '','' '','' '','' '',''36'',''1,5'',''72'',''3'','' '','' '','' '','' '','' '','' '','' '',''16''[FIN] [INICIO]'' '','' '',''Transversal'',''10'',''Ofimática'','' '',''2'','' '','' '','' '','' '',''36'',''1,5'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''17''[FIN] [INICIO]'' '',''IDIOMA EXTRANJERO'',''Transversal'',''11'',''Comunicación interpersonal'','' '','' '','' '',''2'','' '','' '',''36'',''1,5'',''72'',''3'','' '','' '','' '','' 
--'','' '','' '','' '',''18''[FIN] [INICIO]'' '','' '',''Transversal'',''12'',''Comunicación empresarial'','' '','' '','' '','' '',''2'','' '',''36'',''1,5'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''19''[FIN] [INICIO]'' '',''INVESTIGACION 
--TECNOLOGICA'',''Transversal'',''13'',''Fundamentos de investigación'','' '',''2'','' '','' '','' '','' '',''36'',''1,5'',''144'',''6'','' '','' '','' '','' '','' '','' '','' '',''20''[FIN] [INICIO]'' '','' '',''Transversal'',''14'',''Investigación e innovación tecnológica'','' '','' '',''2'','' '','' '','' '',''36'',''1,5'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''21''[FIN] [INICIO]'' '','' '',''Transversal'',''15'',''Proyectos de investigación e innovación tecnológica'','' '','' '','' '',''4'','' '','' '',''72'',''3'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''22''[FIN] [INICIO]'' '',''RELACIONES EN EL ENTORNO DEL TRABAJO'',''Transversal'',''16'',''Comportamiento  ético'','' '','' '','' '','' '',''2'','' '',''36'',''1,5'',''72'',''3'','' '','' '','' '','' '','' '','' '','' '',''23''[FIN] [INICIO]'' '','' '',''Transversal'',''17'',''Liderazgo y trabajo en equipo'','' '','' '','' '','' '','' '',''2'',''36'',''1,5'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''24''[FIN] [INICIO]'' '',''GESTION EMPRESARIAL'',''Transversal'',''18'',''Organización y constitución  de empresas'','' '','' '','' '','' '',''2'','' '',''36'',''1,5'',''72'',''3'','' '','' '','' '','' '','' '','' '','' '',''25''[FIN] [INICIO]'' '','' '',''Transversal'',''19'',''Proyecto empresarial'','' '','' '','' '','' '','' '',''2'',''36'',''1,5'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''26''[FIN] [INICIO]'' '',''FORMACION EMPRESARIAL'',''Transversal'',''20'',''Legislación e inserción laboral'','' '','' '','' '','' '','' '',''3'',''54'',''2'',''54'',''2'','' '','' '','' '','' '','' '','' '','' '',''27''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''28''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''29''[FIN] [INICIO]''Tipo de Módulos'',''Módulos
--(Completar con módulos profesionales)'',''Unidades Didácticas'','' '','' '',''Horas del Periodo Académico 
--(Llenar la cantidad de horas por semana asignadas a la U.D)'','' '','' '','' '','' '','' '',''Unidades Didácticas'','' '',''Módulos Educativos'','' '',''Total de horas'','' '','' '','' '','' '','' '','' '',''30''[FIN] [INICIO]'' '','' '',''Tipo'',''Código correlativo de U.D. 
--(Asignar un número correlativo a ser utilizado por el sistema)'',''Nombre de U.D'',''I'',''II'',''III'',''IV'',''V'',''VI'',''Horas 
--(Llenado automático en base a horas del periodo académico)'',''Créditos 
--(Llenar)'',''Total de créditos 
--(Llenado automático en base a los créditos asignados a las U.D.)'',''Horas 
--(Llenado automático en base a horas de la U.D.)'','' '','' '','' '','' '','' '','' '','' '',''31''[FIN] [INICIO]''PROFESIONAL TECNICO'',''MOD 1'',''Profesional'',''21'',''Dibujo Técnico'',''4'','' '','' '','' '','' '','' '',''72'',''3'',''30'',''72'',''756'','' '','' '','' '','' '','' '','' '',''32''[FIN] [INICIO]'' '','' '',''Profesional'',''22'',''Materiales Industriales'',''3'','' '','' '','' '','' '','' '',''54'',''2'','' '',''54'','' '','' '','' '','' '','' '','' '','' '',''33''[FIN] [INICIO]'' '','' '',''Profesional'',''23'',''Mecánica deBanco'',''7'','' '','' '','' '','' '','' '',''126'',''5'','' '',''126'','' '','' '','' '','' '','' '','' '','' '',''34''[FIN] [INICIO]'' '','' '',''Profesional'',''24'',''Dibujo y Cálculo de Soldadura'',''3'','' '','' '','' '','' '','' '',''54'',''2'','' '',''54'','' '','' '','' '','' '','' '','' '','' '',''35''[FIN] [INICIO]'' '','' '',''Profesional'',''25'',''Soldadura Oxigas'',''5'','' '','' '','' '','' '','' '',''90'',''4'','' '',''90'','' '','' '','' '','' '','' '','' '','' '',''36''[FIN] 
--[INICIO]'' '','' '',''Profesional'',''26'',''Máquinas Básicas'','' '',''4'','' '','' '','' '','' '',''72'',''3'','' '',''72'','' '','' '','' '','' '','' '','' '','' '',''37''[FIN] [INICIO]'' '','' '',''Profesional'',''27'',''Dibujo Asistido por Ordenador'','' 
--'',''4'','' '','' '','' '','' '',''72'',''3'','' '',''72'','' '','' '','' '','' '','' '','' '','' '',''38''[FIN] [INICIO]'' '','' '',''Profesional'',''28'',''Cálculo de Elementos deMáquinas'','' '',''3'','' '','' '','' '','' '',''54'',''2'','' '',''54'','' '','' '','' 
--'','' '','' '','' '','' '',''39''[FIN] [INICIO]'' '','' '',''Profesional'',''29'',''Soldadura Eléctrica'','' '',''6'','' '','' '','' '','' '',''108'',''4'','' '',''108'','' '','' '','' '','' '','' '','' '','' '',''40''[FIN] [INICIO]'' '','' 
--'',''Profesional'',''30'',''Soldadura Mixta'','' '',''3'','' '','' '','' '','' '',''54'',''2'','' '',''54'','' '','' '','' '','' '','' '','' '','' '',''41''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' 
--'','' '','' '','' '','' '','' '',''42''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''43''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' 
--'',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''44''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''45''[FIN] [INICIO]'' '','' '','' '','' '','' 
--'','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''46''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''47''[FIN] 
--[INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''48''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''49''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''50''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''51''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''52''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''53''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''54''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''55''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''56''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''57''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''58''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''59''[FIN] [INICIO]''Tipo de Módulos'',''Módulos
--(Completar con módulos profesionales)'',''Unidades Didácticas'','' '','' '',''Horas del Periodo Académico 
--(Llenar la cantidad de horas por semana asignadas a la U.D)'','' '','' '','' '','' '','' '',''Unidades Didácticas'','' '',''Módulos Educativos'','' '',''Total de horas'','' '','' '','' '','' '','' '','' '',''60''[FIN] [INICIO]'' '','' '',''Tipo'',''Código correlativo de U.D. 
--(Asignar un número correlativo a ser utilizado por el sistema)'',''Nombre de U.D'',''I'',''II'',''III'',''IV'',''V'',''VI'',''Horas 
--(Llenado automático en base a horas del periodo académico)'',''Créditos 
--(Llenar)'',''Total de créditos 
--(Llenado automático en base a los créditos asignados a las U.D.)'',''Horas 
--(Llenado automático en base a horas de la U.D.)'','' '','' '','' '','' '','' '','' '','' '',''61''[FIN] [INICIO]''PROFESIONAL TECNICO'',''MOD 2'',''Profesional'',''31'',''Máquinas Convencionales I'','' '','' '',''12'','' '','' '','' '',''216'',''9'',''35'',''216'',''828'','' '','' '','' '','' '','' '','' '',''62''[FIN] [INICIO]'' '','' '',''Profesional'',''32'',''Máquinas Convencionales II'','' '','' '','' '',''12'','' '','' '',''216'',''9'','' '',''216'','' '','' '','' '','' '','' '','' '','' '',''63''[FIN] [INICIO]'' '','' '',''Profesional'',''33'',''Máquinas Especiales'','' '','' '',''5'','' '','' '','' '',''90'',''4'','' '',''90'','' '','' '','' '','' '','' '','' '','' '',''64''[FIN] [INICIO]'' '','' '',''Profesional'',''34'',''Máquinas de Control Numérico Computarizado'','' '','' '','' '',''7'','' '','' '',''126'',''5'','' '',''126'','' '','' '','' '','' '','' '','' '','' '',''65''[FIN] [INICIO]'' '','' '',''Profesional'',''35'',''Técnicas de Producción I'','' '','' '',''5'','' '','' '','' '',''90'',''4'','' 
--'',''90'','' '','' '','' '','' '','' '','' '','' '',''66''[FIN] [INICIO]'' '','' '',''Profesional'',''36'',''Técnicas de Producción II'','' '','' '','' '',''5'','' '','' '',''90'',''4'','' '',''90'','' '','' '','' '','' '','' '','' '','' '',''67''[FIN] [INICIO]'' '','' 
--'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''68''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' 
--'','' '',''69''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''70''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' 
--'',''0'','' '','' '','' '','' '','' '','' '','' '',''71''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''72''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' 
--'','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''73''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''74''[FIN] [INICIO]'' '','' 
--'','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''75''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' 
--'','' '',''76''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''77''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' 
--'',''0'','' '','' '','' '','' '','' '','' '','' '',''78''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''79''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''80''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''81''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''82''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''83''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''84''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''85''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''86''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''87''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''88''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''89''[FIN] [INICIO]''Tipo de Módulos'',''Módulos
--(Completar con módulos profesionales)'',''Unidades Didácticas'','' '','' '',''Horas del Periodo Académico 
--(Llenar la cantidad de horas por semana asignadas a la U.D)'','' '','' '','' '','' '','' '',''Unidades Didácticas'','' '',''Módulos Educativos'','' '',''Total de horas'','' '','' '','' '','' '','' '','' '',''90''[FIN] [INICIO]'' '','' '',''Tipo'',''Código correlativo de U.D. 
--(Asignar un número correlativo a ser utilizado por el sistema)'',''Nombre de U.D'',''I'',''II'',''III'',''IV'',''V'',''VI'',''Horas 
--(Llenado automático en base a horas del periodo académico)'',''Créditos 
--(Llenar)'',''Total de créditos 
--(Llenado automático en base a los créditos asignados a las U.D.)'',''Horas 
--(Llenado automático en base a horas de la U.D.)'','' '','' '','' '','' '','' '','' '','' '',''91''[FIN] [INICIO]''PROFESIONAL TECNICO'',''MOD 3'',''Profesional'',''37'',''Modelería y Fundición'','' '','' '','' '','' '',''7'','' '',''126'',''5'',''36'',''126'',''846'','' '','' '','' '','' '','' '','' '',''92''[FIN] [INICIO]'' '','' '',''Profesional'',''38'',''Moldes Permanentes'','' '','' '','' '','' '',''5'','' '',''90'',''4'','' '',''90'','' '','' '','' '','' '','' '','' '','' '',''93''[FIN] 
--[INICIO]'' '','' '',''Profesional'',''39'',''Matrices de Chapas'','' '','' '','' '','' '',''8'','' '',''144'',''6'','' '',''144'','' '','' '','' '','' '','' '','' '','' '',''94''[FIN] [INICIO]'' '','' '',''Profesional'',''40'',''Tratamientos Térmicos y Ensayos'','' '','' '','' '','' '',''4'','''',''72'',''3'','' '',''72'','' '','' '','' '','' '','' '','' '','' '',''95''[FIN] [INICIO]'' '','' '',''Profesional'',''41'',''Gestión del Mantenimiento'','' '','' '','' '','' '','' '',''2'',''36'',''2'','' '',''36'','' '','' '','' '','' '','' '','' '','' '',''96''[FIN] [INICIO]'' '','' '',''Profesional'',''42'',''Seguridad e Higiene Industrial'','' '','' '','' '','' '','' '',''2'',''36'',''2'','' '',''36'','' '','' '','' '','' '','' '','' '','' '',''97''[FIN] [INICIO]'' '','' '',''Profesional'',''43'',''Mantenimiento Mecánico'','' '','' '','' '','' '','' '',''8'',''144'',''6'','' '',''144'','' '','' '','' '','' '','' '','' '','' '',''98''[FIN] [INICIO]'' '','' '',''Profesional'',''44'',''Automatización'','' '','' '','' '','' '','' '',''8'',''144'',''6'','' '',''144'','' '','' '','' '','' '','' '','' '','' '',''99''[FIN] [INICIO]'' '','' '',''Profesional'',''45'',''Mantenimiento Eléctrico'','' '','' '','' '','' '','' '',''3'',''54'',''2'','' '',''54'','' '','' '','' '','' '','' '','' '','' '',''100''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''101''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''102''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''103''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''104''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''105''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''106''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' 
--'',''107''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''108''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' 
--'','' '','' '','' '','' '','' '','' '',''109''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''110''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' 
--'','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''111''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''112''[FIN] [INICIO]'' '','' '','' '','' 
--'','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''113''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' 
--'',''114''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''115''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' 
--'','' '','' '','' '','' '','' '','' '',''116''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''0'','' '','' '',''0'','' '','' '','' '','' '','' '','' '','' '',''117''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' 
--'','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''118''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''119''[FIN] 
--[INICIO]''Consolidado'',''Total horas modulos tecnico profesionales'','' '','' '','' '',''22'',''20'',''22'',''24'',''24'',''23'',''2430'',''101'',''101'',''2430'','' '','' '','' '','' '','' '','' '','' '',''120''[FIN] [INICIO]'' '',''Total horas modulos transversales'','' '','' '','' '',''8'',''10'',''8'',''6'',''6'',''7'',''810'',''33'',''33'',''810'','' '','' '','' '','' '','' '','' '','' '',''121''[FIN] [INICIO]'' '',''Total horas semanales'','' '','' '','' '',''30'',''30'',''30'',''30'',''30'',''30'','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''122''[FIN] [INICIO]'' '',''Total horas y creditos'','' '','' '','' '',''540'',''540'',''540'',''540'',''540'',''612'',''3240'',''134'',''134'',''3240'',''3240'','' '','' '','' '','' '','' '','' '',''123''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''124''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''125''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''126''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''127''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''128''[FIN] [INICIO]'' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '','' '',''129''[FIN]'
--	--//
	--DECLARE @ID_INSTITUCION			INT=3758
	--DECLARE @PROGRAMA_ESTUDIOS		VARCHAR(200)='ABASTECIMIENTO'
	--DECLARE @TIPO_ITINERARIO		VARCHAR(200)='TRANSVERSAL'
	----//
	--DECLARE @TIPO_MODALIDAD			VARCHAR(200)=''
	--DECLARE @TIPO_ENFOQUE			VARCHAR(200)=''
	----//
 --   DECLARE @ES_ACTIVO				BIT=1						
 --   DECLARE @ESTADO					SMALLINT=1				
 --   DECLARE @USUARIO_CREACION		NVARCHAR(20)='42122536'*/
)
AS

BEGIN TRY
	BEGIN TRAN InsertarPlanEstudios
	
	Begin --> DECLARACION DE VARIABLES 
		
	DECLARE @QUERY_FN											NVARCHAR(MAX)	
	DECLARE @RESPUETA_MENSAJE									NVARCHAR(MAX)

	DECLARE @VALIDAR_ITINERARIO_NOMBRE							VARCHAR(200)
	DECLARE @ID_TIPO_ITINERARIO									INT
	DECLARE @ID_CARRERA											INT							

	DECLARE @ID_TIPO_MODALIDAD									INT
	DECLARE @ID_TIPO_ENFOQUE									INT

	DECLARE @ID_PLAN_ESTUDIO									INT							--//Almancena la ID_PLAN_ESTUDIO recien registrado

	DECLARE @UNIDAD_DE_COMPETENCIA								VARCHAR(max);				--//Valida si existe unidad de competencia en el modulo

	DECLARE @INDEX_TEMPORAL										VARCHAR(MAX) = '';			--//Almacena solo numero de fila separado por (,) "comas"

	DECLARE @INDEX_NO_REGISTRADOS_ID_TIPO_ENFOQUE				VARCHAR(MAX) = '';			--//Fila y Columna "4H" no registradas por (Tipo Enfoque = esta vacio en el excel)

	DECLARE @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO				VARCHAR(MAX) = '';			--//Fila no registradas por (Nombre de U.D = vacio)

	DECLARE @INDEX_NO_REGISTRADOS_UNIDAD_DE_COMPETENCIA_VACIO	VARCHAR(MAX) = '';			--//Fila no registradas por (Unidad de Competencia = vacio)

	DECLARE @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO		VARCHAR(MAX) = '';			--//Fila registradas por (ID_SEMESTRE_ACADEMICO = 0)

	DECLARE @INDEX_REGISTRADOS_HORAS_VACIO						VARCHAR(MAX) = '';			--//Fila registradas con (HORAS = NULL)

	DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR		VARCHAR(MAX) = '';			--//Fila no registradas por (CODIGO_PREDECESORA = no es un numero)
	DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO		VARCHAR(MAX) = '';			--//Fila no registradas por (CODIGO_PREDECESORA = esta vacio en excel)

	DECLARE @INDEX_VALIDAR_GRUPO_VACIO							VARCHAR(MAX) = '';			--//Filas no registradas si el grupo se encuentra vacio.

	DECLARE @INDEX_REGISTRADOS_CONSOLIDADOS_CERO				VARCHAR(MAX) = '';			--//Fila no registradas por (ID_SEMESTRE_ACADEMICO = 0)

	DECLARE @CODIGO_ENUMERADO_TIPO_ITINERARIO					INT = 33					--//Itinerario en tabla enumerados es 33 
	DECLARE @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO			INT = 38					--//Semestre academico en tabla enumerados es 38
	DECLARE @CODIGO_ENUMERADO_TIPO_MODULO						INT = 47					--//Tipo Modulo en tabla enumerados es 47
	DECLARE @CODIGO_ENUMERADO_MODALIDAD_ESTUDIO					INT = 37					--//Tipo Modalidad en tabla enumerados es 37
	
	DECLARE @ID_TIPO_UNIDAD_DIDACTICA_ESPECIFICA				INT = 1						--//Extraido de la base de dato tbl: maestro.tipo_unidad_didactica
	DECLARE @ID_TIPO_UNIDAD_DIDACTICA_EMPLEABILIDAD				INT = 2						--//Extraido de la base de dato tbl: maestro.tipo_unidad_didactica
	DECLARE @ID_TIPO_UNIDAD_DIDACTICA_EXPERIENCIA_FORMATIVA		INT = 3						--//Extraido de la base de dato tbl: maestro.tipo_unidad_didactica
	DECLARE @ID_TIPO_UNIDAD_DIDACTICA_PROFESIONAL				INT = 5						--//Extraido de la base de dato tbl: maestro.tipo_unidad_didactica
	DECLARE @ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL				INT = 6						--//Extraido de la base de dato tbl: maestro.tipo_unidad_didactica

	DECLARE @ITINERARIO_POR_ASIGNATURA							INT = 99					--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 33
	DECLARE @ITINERARIO_TRANSVERSAL								INT	= 100					--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 33
	DECLARE @ITINERARIO_MODULAR									INT	= 101					--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 33

	DECLARE @ID_TIPO_MODULO_PROFESIONAL							INT	= 159					--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 47	
	DECLARE @ID_TIPO_MODULO_TRANSVERSAL							INT	= 160					--//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 47	
	
	DECLARE @NOMBRE_TIPO_UNIDAD_ESPECIFICA_EXCEL				VARCHAR(60)	= 'Esp'			--//Extraido del excel itinerario Modular 2017 columna C
	DECLARE @NOMBRE_TIPO_UNIDAD_EMPLEABILIDAD_EXCEL				VARCHAR(60)	= 'Emp'			--//Extraido del excel itinerario Modular 2017 columna C
	DECLARE @NOMBRE_TIPO_UNIDAD_EXPERIENCIA_FORMATIVA_EXCEL		VARCHAR(60)	= 'EF'			--//Extraido del excel itinerario Modular 2017 columna C
	
	DECLARE @DELIMITADOR_CODIGO_PREDECESORA_EXCEL				VARCHAR(1)	= ';'			--//Extraido del excel itinerario Modular 2017 columna F

	DECLARE @CODIGO_PREDECESORA_EXCEL							VARCHAR(10) = '';			--//Para insertar codigo predecesor
	DECLARE @VALIDAR_CODIGO_PREDECESORA_EXCEL					VARCHAR(10) = '';			--//Para insertar codigo predecesor
	DECLARE @ROW_INDEX_CODIGO_PREDECESORA_EXCEL					INT	= 0;					--//Para insertar codigo predecesor
	DECLARE @ID_UNIDAD_DIDACTICA_TMP							INT	= 0;					--//Para insertar codigo predecesor
	DECLARE @CANTIDAD_FILAS_GRUPO_VALIDAS						INT = 0;					--//Contador de registros validos, obligatorios para registrar un grupo

	DECLARE @NOMBRE_TABLA_TEMPORAL								VARCHAR(10) = '#tmp';		--//Nombre tabla temporal para asignar al query INSERT INTO de los datos del excel recibidos
		
	DECLARE @LINEA_ERROR										VARCHAR(MAX) = '0';			--//DECLARE LINEA ERROR
									
	DECLARE @row_repeticiones									VARCHAR(MAX) = '';			--//Filas repetidas
	DECLARE @INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO			VARCHAR(MAX) = '';			--//Fila que no se registra porque el código de ud se repite
	DECLARE @rowIndexIni_A_g1									int = 7
	DECLARE @rowIndexFin_A_g1									int = 26
	DECLARE @rowIndexIni_A_g2									int = 30
	DECLARE @rowIndexFin_A_g2									int = 49
	DECLARE @rowIndexIni_A_g3									int = 53
	DECLARE @rowIndexFin_A_g3									int = 72
	DECLARE @rowIndexIni_A_g4									int = 76
	DECLARE @rowIndexFin_A_g4									int = 95
	DECLARE @rowIndexIni_A_g5									int = 99
	DECLARE @rowIndexFin_A_g5									int = 118
	DECLARE @rowIndexIni_A_g6									int = 122
	DECLARE @rowIndexFin_A_g6									int = 141
	DECLARE @rowIndexIni_T_g1									int = 32
	DECLARE @rowIndexFin_T_g1									int = 57
	DECLARE @rowIndexIni_T_g2									int = 62
	DECLARE @rowIndexFin_T_g2									int = 87
	DECLARE @rowIndexIni_T_g3									int = 92
	DECLARE @rowIndexFin_T_g3									int = 117
	DECLARE @rowIndexIni_g1										int = 8
	DECLARE @rowIndexFin_g1										int = 33
	DECLARE @rowIndexIni_g2										int = 38
	DECLARE @rowIndexFin_g2										int = 63		
	DECLARE @rowIndexIni_g3										int = 68
	DECLARE @rowIndexFin_g3										int = 93	
	DECLARE @rowIndexIni_g4										int = 98
	DECLARE @rowIndexFin_g4										int = 123	
	DECLARE @rowIndex_tmp										int = 0;					--Variable de inicio temporal para recorrido de las filas por evaluación de repeticiones. 
	DECLARE @codEval											varchar(10)=''
	DECLARE @cod_ud_long_max									int =2;						--Longitud máxima del código de la U.D.
	DECLARE @horas_long_max									int =3;						--Longitud máxima de las horas.
	DECLARE @rowindex_existe									int =0;	
	DECLARE @row_cod_uds_vacios									VARCHAR(MAX) = '';
	DECLARE @row_cod_uds_invalidos								VARCHAR(MAX) = '';	
	DECLARE @INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO				VARCHAR(MAX) = '';			--//Fila que no se registra porque el código de ud es vacío
	DECLARE @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO			VARCHAR(MAX) = '';			--//Fila que no se registra porque el código de ud es inválido
	DECLARE @ID_SEMESTRE_ACADEMICO_TMP							INT =0; 					--Id semestre académico de la unidad didáctica seleccionada. 
	DECLARE @row_cod_uds_precedesores_no_existen				VARCHAR(MAX) = '';			--Código de unidad didáctica con uno o varios predecesores inexistentes. 
	DECLARE @cont_predecesores_validos_ud						INT =0;						--Contador de código de predecesores válidos por ud
	DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_NOEXISTE_NOVALIDO		VARCHAR(MAX) = '';			--Fila que no registra código de predecesoras porque uno o varios códigos no existente	DECLARE @cont_predecesores_validos_ud						INT=0;						--Contador de predecesores válidos por unidad didáctica			
	DECLARE @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO		VARCHAR(MAX) = '';			--Fila que no se registra porque se encontró datos no numéricos en periodo académico
	DECLARE @row_no_numerico_periodo_academico								VARCHAR(MAX) ='';
	DECLARE @row_no_valor_unico_periodo_academico							VARCHAR(MAX) =''; --??
	DECLARE @row_horas_vacias_periodo_academico								VARCHAR(MAX) ='';
	DECLARE @row_horas_multiples_periodo_academico						    VARCHAR(MAX) ='';
	DECLARE @INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO			VARCHAR(MAX) = ''; --??	
	DECLARE	@INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS						VARCHAR(MAX) ='';
	DECLARE	@INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES						VARCHAR(MAX) ='';
	DECLARE @row_vacio_horas												VARCHAR(MAX) ='';
	DECLARE @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS						VARCHAR(MAX) = '';			--Fila que no se registra porque se encontró datos vacíos en horas.
	DECLARE @row_no_numerico_horas											VARCHAR(MAX) ='';
	DECLARE @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS					VARCHAR(MAX) = '';			--Fila que no se registra porque se encontró datos no enteros en horas
	DECLARE @row_no_suma_igual_horas										VARCHAR(MAX) = '';			
	DECLARE @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS					VARCHAR(MAX) = '';			--Fila que no se registra porque se encontró que la suma de las columnas M y N no es igual a O
	DECLARE @row_vacio_creditos												VARCHAR(MAX) ='';
	DECLARE @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS						VARCHAR(MAX) = '';			--Fila que no se registra porque se encontró datos vacíos en créditos.
	DECLARE @row_no_numerico_creditos										VARCHAR(MAX) ='';				
	DECLARE @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS				VARCHAR(MAX) = '';			--Fila que no se registra porque se encontró datos no numéricos en créditos.
	DECLARE @row_no_suma_igual_creditos										VARCHAR(MAX) = '';			
	DECLARE @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS				VARCHAR(MAX) = '';			--Fila que no se registra porque se encontró que la suma de las columnas M y N no es igual a O
	DECLARE @MSG_INFO														VARCHAR(30)=' (Informativo)';
	DECLARE @MSG_ERROR														VARCHAR(30)=' (Error)';

	DECLARE @NIVEL_FORMATIVO                                                INT = 0; -- JTOVAR
	DECLARE @ID_NIVEL_FORMATIVO_TECNICO				                        INT = 1; -- JTOVAR Valor del nivel_formativo Técnico
	DECLARE @rowIndexIni_T_g1_tec									        int = 24; -- rango de inicio del primer bloque del modulo estandar del nivel_formativo Técnico
	DECLARE @rowIndexFin_T_g1_tec									        int = 49; -- rango de fin del primer bloque del modulo estandar del nivel_formativo Técnico
	DECLARE @rowIndexIni_T_g2_tec									        int = 54; -- rango de inicio del segundo bloque del modulo estandar del nivel_formativo Técnico
	DECLARE @rowIndexFin_T_g2_tec									        int = 79; -- rango de fin del segundo bloque del modulo estandar del nivel_formativo Técnico
	DECLARE @rowIndexIni_T_g3_tec									        int = 84; -- rango de inicio del tecer bloque del modulo estandar del nivel_formativo Técnico
	DECLARE @rowIndexFin_T_g3_tec									        int = 109; -- rango de fin del tercer bloque del modulo estandar del nivel_formativo Técnico
	DECLARE @ID_TIPO_MODULO_TECNICO							                INT	= 10194; --//Extraido de la base de dato tbl: sistema.enumerado con ID_TIPO_ENUMERADO = 47	
	DECLARE @ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL_TECNICO				    INT = 8		 --//Extraido de la base de dato tbl: maestro.tipo_unidad_didactica

	End

		
	Begin --> PROCESANDO INSERT INTO POR SEGURIDAD 

	--SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'INICIO','INSERT INTO #tmp VALUES ('));

	SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'[INICIO]','INSERT INTO ' + @NOMBRE_TABLA_TEMPORAL + ' VALUES ('));
	SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'','INSERT INTO'));
	SET @QUERY_EXCEL = (SELECT REPLACE(@QUERY_EXCEL,'[FIN]',')'));

	End
		
	Begin --> CREAR TABLA TEMPORAL 
	CREATE TABLE
	#tmp
	( 		
		A NVARCHAR(max),
		B NVARCHAR(max),
		C NVARCHAR(400),
		D NVARCHAR(400),
		E NVARCHAR(400),
		F NVARCHAR(400),
		G NVARCHAR(400),
		H NVARCHAR(400),
		I NVARCHAR(400),
		J NVARCHAR(400),
		K NVARCHAR(400),
		L NVARCHAR(400),
		M NVARCHAR(400),
		N NVARCHAR(400),
		O NVARCHAR(400),
		P NVARCHAR(400),

		Q NVARCHAR(400),
		R NVARCHAR(400),
		S NVARCHAR(400),
		T NVARCHAR(400),
		U NVARCHAR(400),
		V NVARCHAR(400),

		rowIndex NVARCHAR(400)	
	)
	End
		
	Begin --> INSERTAR EXCEL A TABLA TEMPORAL 
	
		EXECUTE (@QUERY_EXCEL);

	End
	
	Begin --> CONSULTAR TABLA TEMPORAL SI ESTA LLENA 
		--SELECT rowIndex as ' ',* FROM #tmp
		IF 1 = 0 SELECT 1 --Para que no se caiga el Begin End
	End
		
	Begin --> OBTENER ID_TIPO_ITINERARIO 	
	SET @LINEA_ERROR= 'AQUÍ1:' + @PROGRAMA_ESTUDIOS
		SELECT TOP 1
			@ID_CARRERA = c.ID_CARRERA
			,@ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
			,@NIVEL_FORMATIVO = c.ID_NIVEL_FORMACION --JTOVAR
																			
		FROM
			transaccional.carreras_por_institucion cpi
			INNER JOIN db_auxiliar.dbo.UVW_CARRERA c ON cpi.ID_CARRERA = c.ID_CARRERA							
			INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
		WHERE 1 = 1 

			AND	cpi.ID_INSTITUCION =		@ID_INSTITUCION							
			AND RTRIM(LTRIM(UPPER(c.NOMBRE_CARRERA))) =	UPPER(@PROGRAMA_ESTUDIOS)
			AND enum.ID_TIPO_ENUMERADO =	@CODIGO_ENUMERADO_TIPO_ITINERARIO
			AND enum.VALOR_ENUMERADO	=   @TIPO_ITINERARIO
			AND cpi.ES_ACTIVO =				1
			--AND c.ESTADO =					1		--reemplazoPorVista					
			AND enum.ESTADO =				1
			SET @LINEA_ERROR= 'AQUÍ2:' + CONVERT(VARCHAR(20),@ID_TIPO_ITINERARIO)
	End
		
	Begin --> VALIDAR ID_TIPO_ITINERARIO 
		SET @VALIDAR_ITINERARIO_NOMBRE = (SELECT UPPER(VALOR_ENUMERADO) FROM sistema.enumerado enum WHERE enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_ITINERARIO AND ID_ENUMERADO = @ID_TIPO_ITINERARIO);
	End
	
	Begin --> OBTENER ID_TIPO_MODALIDAD 
		
		IF @TIPO_MODALIDAD <> ''
			Begin 
				SET @ID_TIPO_MODALIDAD = (SELECT en.ID_ENUMERADO FROM sistema.enumerado en WHERE en.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_MODALIDAD_ESTUDIO AND en.VALOR_ENUMERADO = @TIPO_MODALIDAD)				
				--IF 1 = 0 SELECT 1
			End
	End

	Begin --> OBTENER ID_TIPO_ENFOQUE 
		
		IF @TIPO_MODALIDAD <> '' AND @TIPO_ENFOQUE <> ''
			Begin 
				SET @ID_TIPO_ENFOQUE = (SELECT en.ID_ENFOQUE FROM maestro.enfoque en WHERE en.ID_MODALIDAD_ESTUDIO = @ID_TIPO_MODALIDAD AND en.NOMBRE_ENFOQUE = @TIPO_ENFOQUE)
				IF 1 = 0 SELECT 1
			End
	End

	Begin --> DECLARACION DE VARIABLES DE TABLA 
			
			DECLARE @tblPlanEstudio_NuevoIdRegistrado TABLE (ID_PLAN_ESTUDIO INT)	

			--********************

			DECLARE @tblModulo_NuevoIdRegistrado_GE1 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE1 TABLE (ID_UNIDAD_DIDACTICA INT)		
			
			DECLARE @tblModulo_NuevoIdRegistrado_GE2 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE2 TABLE (ID_UNIDAD_DIDACTICA INT)		

			DECLARE @tblModulo_NuevoIdRegistrado_GE3 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE3 TABLE (ID_UNIDAD_DIDACTICA INT)		

			DECLARE @tblModulo_NuevoIdRegistrado_GE4 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE4 TABLE (ID_UNIDAD_DIDACTICA INT)		

			DECLARE @tblModulo_NuevoIdRegistrado_GE5 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE5 TABLE (ID_UNIDAD_DIDACTICA INT)		

			DECLARE @tblModulo_NuevoIdRegistrado_GE6 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE6 TABLE (ID_UNIDAD_DIDACTICA INT)		

			DECLARE @tblModulo_NuevoIdRegistrado_GE7 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE7 TABLE (ID_UNIDAD_DIDACTICA INT)		

			DECLARE @tblModulo_NuevoIdRegistrado_GE8 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE8 TABLE (ID_UNIDAD_DIDACTICA INT)		

			DECLARE @tblModulo_NuevoIdRegistrado_GE9 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE9 TABLE (ID_UNIDAD_DIDACTICA INT)		

			DECLARE @tblModulo_NuevoIdRegistrado_GE10 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE10 TABLE (ID_UNIDAD_DIDACTICA INT)		

			DECLARE @tblModulo_NuevoIdRegistrado_GE11 TABLE (ID_MODULO INT)							
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_GE11 TABLE (ID_UNIDAD_DIDACTICA INT)		

			--********************

			DECLARE @tblModulo_NuevoIdRegistrado_G1 TABLE (ID_MODULO INT)	
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_G1 TABLE (ID_UNIDAD_DIDACTICA INT)
			
			DECLARE @tblModulo_NuevoIdRegistrado_G2 TABLE (ID_MODULO INT)	
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_G2 TABLE (ID_UNIDAD_DIDACTICA INT)	
			
			DECLARE @tblModulo_NuevoIdRegistrado_G3 TABLE (ID_MODULO INT)
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_G3 TABLE (ID_UNIDAD_DIDACTICA INT)	
			
			DECLARE @tblModulo_NuevoIdRegistrado_G4 TABLE (ID_MODULO INT)	
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_G4 TABLE (ID_UNIDAD_DIDACTICA INT)

			/***/--PARA POR ASIGNATURA

			DECLARE @tblModulo_NuevoIdRegistrado_G5 TABLE (ID_MODULO INT)	
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_G5 TABLE (ID_UNIDAD_DIDACTICA INT)

			DECLARE @tblModulo_NuevoIdRegistrado_G6 TABLE (ID_MODULO INT)	
			DECLARE @tblUnidadDidactica_NuevoIdRegistrado_G6 TABLE (ID_UNIDAD_DIDACTICA INT)			

			/***/--FIN - PARA POR ASIGNATURA

			DECLARE @tblPlanEstudioDetalle_NuevoIdRegistrado TABLE (ID_PLAN_ESTUDIO_DETALLE INT)	
			
			DECLARE @tblUnidadCompetencia_NuevoIdRegistrado TABLE (ID_UNIDAD_COMPETENCIA INT)				
	
	End
	
--*******************************************************************************************************************************************************************************************************************	

	Begin --> REGISTROS POR TIPO DE ITINERARIOS 
	
		Begin --> ITINERARIO POR_ASIGNATURA 
		IF @VALIDAR_ITINERARIO_NOMBRE = UPPER(@TIPO_ITINERARIO) AND @ID_TIPO_ITINERARIO = @ITINERARIO_POR_ASIGNATURA

			Begin --> REGISTRAR EN LA BASE DE DATOS 

				Begin --> REGISTRO BASE 

					Begin --> transaccional.plan_estudio 
						
						INSERT INTO transaccional.plan_estudio
						(
							ID_CARRERAS_POR_INSTITUCION
							,ID_TIPO_ITINERARIO
							,CODIGO_PLAN_ESTUDIOS
							,NOMBRE_PLAN_ESTUDIOS
							,ES_ACTIVO,	ESTADO,	USUARIO_CREACION,	FECHA_CREACION
						)

						OUTPUT INSERTED.ID_PLAN_ESTUDIO INTO @tblPlanEstudio_NuevoIdRegistrado(ID_PLAN_ESTUDIO)

						VALUES
						(
							(	--//ID_CARRERAS_POR_INSTITUCION
								SELECT cpi.ID_CARRERAS_POR_INSTITUCION 
								FROM transaccional.carreras_por_institucion cpi WHERE cpi.ID_INSTITUCION = @ID_INSTITUCION AND cpi.ID_CARRERA = @ID_CARRERA
								and cpi.ID_TIPO_ITINERARIO=@ID_TIPO_ITINERARIO
								 AND cpi.ES_ACTIVO = 1 AND cpi.ESTADO = 1)
							,(	@ID_TIPO_ITINERARIO--//ID_TIPO_ITINERARIO
								/*SELECT enum.ID_ENUMERADO 		
								FROM
									transaccional.carreras_por_institucion cpi
									INNER JOIN maestro.carrera c ON cpi.ID_CARRERA = c.ID_CARRERA
									INNER JOIN maestro.nivel_formacion nf ON c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION
									INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
								WHERE --1 = 1 AND
										cpi.ID_INSTITUCION =		@ID_INSTITUCION
									AND cpi.ID_CARRERA =			@ID_CARRERA
									AND enum.ID_TIPO_ENUMERADO =	@CODIGO_ENUMERADO_TIPO_ITINERARIO

									AND cpi.ES_ACTIVO =				1
									AND c.ESTADO =					1
									AND nf.ESTADO =					1
									AND enum.ESTADO =				1*/ -->ya no se utiliza
							)
							,(--//CODIGO_PLAN_ESTUDIOS - Vacio por ahora hasta definir
								'ConsultarJtovar'	
							)
							,(--//NOMBRE_PLAN_ESTUDIOS
								SELECT E FROM #tmp WHERE rowIndex = 3						
							)
							,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
						)

						--//
						SET @ID_PLAN_ESTUDIO = (SELECT ID_PLAN_ESTUDIO as 'ID_PLAN_ESTUDIO recien registrado' FROM @tblPlanEstudio_NuevoIdRegistrado);

					End
					
				End --> FIN: REGISTRO BASE

				Begin --> GRUPO ESTANDAR 


					Begin --> GRUPO - 1 

						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE
							A <> ''
						AND rowIndex BETWEEN 7 AND 26 --FILAS DEL PRIMER BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS > 0
						Begin --> Validacion si existen datos
						
							Begin --> transaccional.modulo - GRUPO 1 
												
								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G1(ID_MODULO)													--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT A FROM #tmp WHERE rowIndex = 6																				--//FRAMOS CAMBIAR AQUI
									)								

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)
							
							End

							BEGIN -->Validar horas no vacías
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										B=''
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g1 and @rowIndexFin_A_g1 
									and A<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '') 
							End

							BEGIN -->Validar horas válidas (ENTERO)								
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((B like '%[^0-9]%' or ISNUMERIC(B)=0 or B= 0 or LEN(B)>@horas_long_max) AND B<>'' )  										
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g1 and @rowIndexFin_A_g1 
									and A<>''									
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') 
							End
					
							Begin --> transaccional.unidad_didactica - GRUPO 1 
						
								INSERT INTO transaccional.unidad_didactica 
								(
									ID_MODULO	
									,ID_SEMESTRE_ACADEMICO							
									,NOMBRE_UNIDAD_DIDACTICA								
									,HORAS 
									
									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G1(ID_UNIDAD_DIDACTICA)								--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G1)										--//FRAMOS CAMBIAR AQUI	
			
									--ID_SEMESTRE_ACADEMICO
									, 111
									--NOMBRE_UNIDAD_DIDACTICA								
									,CASE WHEN A <> '' THEN A WHEN A = '' THEN A END AS NOMBRE_UNIDAD_DIDACTICA

									--HORAS
									,CASE WHEN B <> '' THEN B END AS HORAS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 
									A <> ''							
								AND rowIndex BETWEEN 7 AND 26 --RANGO DE FILAS DEL PRIMER BLOQUE	
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_vacio_horas + ',' +@row_no_numerico_horas ,','))														--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 
									A = ''							
								AND rowIndex BETWEEN 7 AND 26 --RANGO DE FILAS DEL PRIMER BLOQUE																	--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' +@MSG_INFO +'|'
								END
															
								----//Filas registradas pero con HORAS = NULL		
								SELECT @INDEX_REGISTRADOS_HORAS_VACIO = COALESCE(@INDEX_REGISTRADOS_HORAS_VACIO,'') 							
								+ 'Fila: ' + rowIndex + ' registrada pero posiblemente con error' + ' en la Columna B.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud							
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.A
								WHERE ud.HORAS IS NULL
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G1)						--//FRAMOS CAMBIAR AQUI
								AND tmp.rowIndex BETWEEN 7 AND 26 --RANGO DE FILAS DEL PRIMER BLOQUE

								--Fila no registra por columnas vacías de horas 
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).'+@MSG_ERROR+'|'	
							

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque la sección Horas no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'								
							End						
					
						End
						ELSE
							Begin
								SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 7 hasta Fila 26 no registrada(s) porque no cuentan con ningun Nombre de U.D.'+@MSG_INFO+'|';
							End

					End --> FIN: GRUPO - 1
					

					Begin --> GRUPO - 2 

						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE
							A <> ''
						AND rowIndex BETWEEN 30 AND 49 --FILAS DEL SEGUNDO BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS > 0
						Begin --> Validacion si existen datos

							Begin --> transaccional.modulo - GRUPO 2 
												
								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G2(ID_MODULO)															--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT A FROM #tmp WHERE rowIndex = 29																						--//FRAMOS CAMBIAR AQUI
									)								

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)
							
							End
							
							BEGIN -->Validar horas no vacías
								set @row_vacio_horas =''
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										B=''
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g2 and @rowIndexFin_A_g2 
									and A<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '') 
							End

							BEGIN -->Validar horas válidas (ENTERO)								
								set @row_no_numerico_horas=''
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((B like '%[^0-9]%' or ISNUMERIC(B)=0 or B= 0 or LEN(B)>@horas_long_max) AND B<>'' )  										
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g2 and @rowIndexFin_A_g2 
									and A<>''									
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') 
							End
							Begin --> transaccional.unidad_didactica - GRUPO 2 
						
								INSERT INTO transaccional.unidad_didactica 
								(
									ID_MODULO	
									,ID_SEMESTRE_ACADEMICO						
									,NOMBRE_UNIDAD_DIDACTICA								
									,HORAS 

									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G2(ID_UNIDAD_DIDACTICA)									--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G2)											--//FRAMOS CAMBIAR AQUI	
									--ID_SEMESTRE_ACADEMICO
									, 112
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN A <> '' THEN A WHEN A = '' THEN A END AS NOMBRE_UNIDAD_DIDACTICA

									--HORAS
									,CASE WHEN B <> '' THEN B END AS HORAS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 
									A <> ''							
								AND rowIndex BETWEEN 30 AND 49 --RANGO DE FILAS DEL SEGUNDO BLOQUE			
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_vacio_horas + ',' +@row_no_numerico_horas ,','))															--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica	
								SET @INDEX_TEMPORAL = '';
									
								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 
									A = ''							
								AND rowIndex BETWEEN 30 AND 49 --RANGO DE FILAS DEL SEGUNDO BLOQUE																		--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC	
								
								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' +@MSG_INFO+ '|'
								END 

								----//Filas registradas pero con HORAS = NULL		
								SELECT @INDEX_REGISTRADOS_HORAS_VACIO = COALESCE(@INDEX_REGISTRADOS_HORAS_VACIO,'') 							
								+ 'Fila: ' + rowIndex + ' registrada pero posiblemente con error' + ' en la Columna B.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud							
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.A
								WHERE ud.HORAS IS NULL
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G2)							--//FRAMOS CAMBIAR AQUI
								AND tmp.rowIndex BETWEEN 30 AND 49 --RANGO DE FILAS DEL SEGUNDO BLOQUE																	--//FRAMOS CAMBIAR AQUI

								--Fila no registra por columnas vacías de horas 								
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).'+@MSG_ERROR+'|'	
							

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque la sección Horas no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'								
							End						

						End
						ELSE
							Begin
								SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 30 hasta Fila 49 no registrada(s) porque no cuentan con ningun Nombre de U.D.'+@MSG_INFO+'|';								
							End

					End --> FIN: GRUPO - 2 
					

					Begin --> GRUPO - 3 
					
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE
							A <> ''
						AND rowIndex BETWEEN 53 AND 72 --FILAS DEL TERCER BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS > 0
						Begin --> Validacion si existen datos

							Begin --> transaccional.modulo - GRUPO 3 
												
								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G3(ID_MODULO)															--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT A FROM #tmp WHERE rowIndex = 52																						--//FRAMOS CAMBIAR AQUI
									)								

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)
							
							End
							BEGIN -->Validar horas no vacías
								set @row_vacio_horas =''
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										B=''
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g3 and @rowIndexFin_A_g3 
									and A<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '') 
							End

							BEGIN -->Validar horas válidas (ENTERO)								
								set @row_no_numerico_horas=''
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((B like '%[^0-9]%' or ISNUMERIC(B)=0 or B= 0 or LEN(B)>@horas_long_max) AND B<>'' )  										
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g3 and @rowIndexFin_A_g3 
									and A<>''									
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') 
							End
							Begin --> transaccional.unidad_didactica - GRUPO 3 
						
								INSERT INTO transaccional.unidad_didactica 
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO								
									,NOMBRE_UNIDAD_DIDACTICA								
									,HORAS 

									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G3(ID_UNIDAD_DIDACTICA)									--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G3)											--//FRAMOS CAMBIAR AQUI	
									--ID_SEMESTRE_ACADEMICO
									, 113
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN A <> '' THEN A WHEN A = '' THEN A END AS NOMBRE_UNIDAD_DIDACTICA

									--HORAS
									,CASE WHEN B <> '' THEN B END AS HORAS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 
									A <> ''							
								AND rowIndex BETWEEN 53 AND 72 --RANGO DE FILAS DEL TERCER BLOQUE	
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_vacio_horas + ',' +@row_no_numerico_horas ,','))																	--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica		
								SET @INDEX_TEMPORAL = '';
									
								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 
									A = ''							
								AND rowIndex BETWEEN 53 AND 72 --RANGO DE FILAS DEL TERCER BLOQUE																		--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' + '|'
								END		

								----//Filas registradas pero con HORAS = NULL		
								SELECT @INDEX_REGISTRADOS_HORAS_VACIO = COALESCE(@INDEX_REGISTRADOS_HORAS_VACIO,'') 							
								+ 'Fila: ' + rowIndex + ' registrada pero posiblemente con error' + ' en la Columna B.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud							
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.A
								WHERE ud.HORAS IS NULL
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G3)							--//FRAMOS CAMBIAR AQUI
								AND tmp.rowIndex BETWEEN 53 AND 72 --RANGO DE FILAS DEL TERCER BLOQUE																	--//FRAMOS CAMBIAR AQUI

								--Fila no registra por columnas vacías de horas 								
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).|'								

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque la sección Horas no tiene dato(s) de tipo entero entre 1 y 999.|'								
							End						
						
						End
						ELSE
							Begin
								SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 53 hasta Fila 72 no registrada(s) porque no cuentan con ningun Nombre de U.D.'+@MSG_INFO+'|';								
							End

					End --> FIN: GRUPO - 3 
					

					Begin --> GRUPO - 4 

						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE
							A <> ''
						AND rowIndex BETWEEN 76 AND 95 --FILAS DEL CUARTO BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS > 0
						Begin --> Validacion si existen datos

							Begin --> transaccional.modulo - GRUPO 4 
												
								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G4(ID_MODULO)															--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT A FROM #tmp WHERE rowIndex = 75																						--//FRAMOS CAMBIAR AQUI
									)								

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)
							
							End
							BEGIN -->Validar horas no vacías
								set @row_vacio_horas =''
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										B=''
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g4 and @rowIndexFin_A_g4 
									and A<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '') 
							End

							BEGIN -->Validar horas válidas (ENTERO)								
								set @row_no_numerico_horas=''
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((B like '%[^0-9]%' or ISNUMERIC(B)=0 or B= 0 or LEN(B)>@horas_long_max) AND B<>'' )  										
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g4 and @rowIndexFin_A_g4 
									and A<>''									
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') -- para impedir comparación con nulo 									
							End
							Begin --> transaccional.unidad_didactica - GRUPO 4 
						
								INSERT INTO transaccional.unidad_didactica 
								(
									ID_MODULO	
									,ID_SEMESTRE_ACADEMICO							
									,NOMBRE_UNIDAD_DIDACTICA								
									,HORAS 

									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G4(ID_UNIDAD_DIDACTICA)									--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G4)											--//FRAMOS CAMBIAR AQUI	
									--ID_SEMESTRE_ACADEMICO
									, 114
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN A <> '' THEN A WHEN A = '' THEN A END AS NOMBRE_UNIDAD_DIDACTICA

									--HORAS
									,CASE WHEN B <> '' THEN B END AS HORAS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 
									A <> ''							
								AND rowIndex BETWEEN 76 AND 95 --RANGO DE FILAS DEL CUARTO BLOQUE	
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_vacio_horas + ',' +@row_no_numerico_horas ,','))																	--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica		
								SET @INDEX_TEMPORAL = '';
									
								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 
									A = ''							
								AND rowIndex BETWEEN 76 AND 95 --RANGO DE FILAS DEL CUARTO BLOQUE																		--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).'+@MSG_INFO+'' + '|'
								END

								----//Filas registradas pero con HORAS = NULL		
								SELECT @INDEX_REGISTRADOS_HORAS_VACIO = COALESCE(@INDEX_REGISTRADOS_HORAS_VACIO,'') 							
								+ 'Fila: ' + rowIndex + ' registrada pero posiblemente con error' + ' en la Columna B.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud							
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.A
								WHERE ud.HORAS IS NULL
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G4)							--//FRAMOS CAMBIAR AQUI
								AND tmp.rowIndex BETWEEN 76 AND 95 --RANGO DE FILAS DEL CUARTO BLOQUE																	--//FRAMOS CAMBIAR AQUI

								--Fila no registra por columnas vacías de horas 								
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).'+@MSG_ERROR+'|'	
							

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque la sección Horas no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'								
							End						

						End
						ELSE
							Begin
								SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 76 hasta Fila 95 no registrada(s) porque no cuentan con ningun Nombre de U.D.'+@MSG_INFO+'|';								
							End

					End --> FIN: GRUPO - 4 
					

					Begin --> GRUPO - 5 

						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE
							A <> ''
						AND rowIndex BETWEEN 99 AND 118 --FILAS DEL QUINTO BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS > 0
						Begin --> Validacion si existen datos

							Begin --> transaccional.modulo - GRUPO 5 
												
								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G5(ID_MODULO)															--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT A FROM #tmp WHERE rowIndex = 98																						--//FRAMOS CAMBIAR AQUI
									)								

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)
							
							End
							BEGIN -->Validar horas no vacías
								set @row_vacio_horas =''
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										B=''
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g5 and @rowIndexFin_A_g5 
									and A<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '')
							End

							BEGIN -->Validar horas válidas (ENTERO)								
								set @row_no_numerico_horas=''
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((B like '%[^0-9]%' or ISNUMERIC(B)=0 or B= 0 or LEN(B)>@horas_long_max) AND B<>'' )  										
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g5 and @rowIndexFin_A_g5 
									and A<>''
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') 
							End
							Begin --> transaccional.unidad_didactica - GRUPO 5 
						
								INSERT INTO transaccional.unidad_didactica 
								(
									ID_MODULO	
									,ID_SEMESTRE_ACADEMICO							
									,NOMBRE_UNIDAD_DIDACTICA								
									,HORAS 

									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G5(ID_UNIDAD_DIDACTICA)									--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G5)											--//FRAMOS CAMBIAR AQUI	
									--ID_SEMESTRE_ACADEMICO
									, 115
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN A <> '' THEN A WHEN A = '' THEN A END AS NOMBRE_UNIDAD_DIDACTICA

									--HORAS
									,CASE WHEN B <> '' THEN B END AS HORAS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 
									A <> ''							
								AND rowIndex BETWEEN 99 AND 118 --RANGO DE FILAS DEL QUINTO BLOQUE		
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_vacio_horas + ',' +@row_no_numerico_horas ,','))																--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC
								
								--//Filas no registradas porque no tienen nombre de la unidad didactica		
								SET @INDEX_TEMPORAL = '';
									
								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 
									A = ''							
								AND rowIndex BETWEEN 99 AND 118 --RANGO DE FILAS DEL QUINTO BLOQUE																		--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' +@MSG_INFO+'|'
								END

								----//Filas registradas pero con HORAS = NULL		
								SELECT @INDEX_REGISTRADOS_HORAS_VACIO = COALESCE(@INDEX_REGISTRADOS_HORAS_VACIO,'') 							
								+ 'Fila: ' + rowIndex + ' registrada pero posiblemente con error' + ' en la Columna B.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud							
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.A
								WHERE ud.HORAS IS NULL
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G5)							--//FRAMOS CAMBIAR AQUI
								AND tmp.rowIndex BETWEEN 99 AND 118 --RANGO DE FILAS DEL QUINTO BLOQUE																	--//FRAMOS CAMBIAR AQUI

								--Fila no registra por columnas vacías de horas 								
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).'+@MSG_ERROR+'|'	
							

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque la sección Horas no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'								

							End						

						End
						ELSE
							Begin
								SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 99 hasta Fila 118 no registrada(s) porque no cuentan con ningun Nombre de U.D.'+@MSG_INFO+'|';								
							End

					End --> FIN: GRUPO - 5


					Begin --> GRUPO - 6 

						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE
							A <> ''
						AND rowIndex BETWEEN 122 AND 141 --FILAS DEL SEXTO BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS > 0
						Begin --> Validacion si existen datos

							Begin --> transaccional.modulo - GRUPO 6 
												
								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G6(ID_MODULO)															--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT A FROM #tmp WHERE rowIndex = 121																						--//FRAMOS CAMBIAR AQUI
									)								

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)
							
							End

							BEGIN -->Validar horas no vacías
								set @row_vacio_horas =''
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										B=''
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g6 and @rowIndexFin_A_g6 
									and A<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '') 
							End

							BEGIN -->Validar horas válidas (ENTERO)								
								set @row_no_numerico_horas=''
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((B like '%[^0-9]%' or ISNUMERIC(B)=0 or B= 0 or LEN(B)>@horas_long_max) AND B<>'' )  										
									)	and 
									rowIndex BETWEEN @rowIndexIni_A_g6 and @rowIndexFin_A_g6 
									and A<>''									
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') 
							End

							Begin --> transaccional.unidad_didactica - GRUPO 6 
						
								INSERT INTO transaccional.unidad_didactica 
								(
									ID_MODULO	
									,ID_SEMESTRE_ACADEMICO							
									,NOMBRE_UNIDAD_DIDACTICA								
									,HORAS 

									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G6(ID_UNIDAD_DIDACTICA)									--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G6)											--//FRAMOS CAMBIAR AQUI	
									--ID_SEMESTRE_ACADEMICO
									, 138
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN A <> '' THEN A WHEN A = '' THEN A END AS NOMBRE_UNIDAD_DIDACTICA

									--HORAS
									,CASE WHEN B <> '' THEN B END AS HORAS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 
									A <> ''							
								AND rowIndex BETWEEN 122 AND 141 --RANGO DE FILAS DEL SEXTO BLOQUE		
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_vacio_horas + ',' +@row_no_numerico_horas ,','))																--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica		
								SET @INDEX_TEMPORAL = '';
									
								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 
									A = ''							
								AND rowIndex BETWEEN 122 AND 141 --RANGO DE FILAS DEL SEXTO BLOQUE																		--//FRAMOS CAMBIAR AQUI
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' +@MSG_INFO+ '|'
								END

								----//Filas registradas pero con HORAS = NULL		
								SELECT @INDEX_REGISTRADOS_HORAS_VACIO = COALESCE(@INDEX_REGISTRADOS_HORAS_VACIO,'') 							
								+ 'Fila: ' + rowIndex + ' registrada pero posiblemente con error' + ' en la Columna B.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud							
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.A
								WHERE ud.HORAS IS NULL
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G6)							--//FRAMOS CAMBIAR AQUI
								AND tmp.rowIndex BETWEEN 122 AND 141 --RANGO DE FILAS DEL SEXTO BLOQUE																	--//FRAMOS CAMBIAR AQUI

								--Fila no registra por columnas vacías de horas 								
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).'+@MSG_ERROR+'|'	
							

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque la sección Horas no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'								

							End						

						End
						ELSE
							Begin
								SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 122 hasta Fila 141 no registradas porque no cuentan con ningun Nombre de U.D.'+@MSG_INFO+'|';								
							End

					End --> FIN: GRUPO - 6


				End --> FIN: GRUPO ESTANDAR
								
			End --> FIN: REGISTRAR EN LA BASE DE DATOS 

		End
			
		Begin --> ITINERARIO TRANSVERSAL 

		IF @VALIDAR_ITINERARIO_NOMBRE = UPPER(@TIPO_ITINERARIO) AND @ID_TIPO_ITINERARIO = @ITINERARIO_TRANSVERSAL 

			IF @NIVEL_FORMATIVO = 1 --@ID_NIVEL_FORMATIVO_TECNICO --JTOVAR ACA HACE TECNICO
			
			 Begin --> REGISTRAR EN LA BASE DE DATOS 

				Begin --> REGISTRO BASE 

					Begin --> transaccional.plan_estudio 
					
						INSERT INTO transaccional.plan_estudio
						(
							ID_CARRERAS_POR_INSTITUCION
							,ID_TIPO_ITINERARIO
							,CODIGO_PLAN_ESTUDIOS
							,NOMBRE_PLAN_ESTUDIOS
							,ES_ACTIVO,	ESTADO,	USUARIO_CREACION,	FECHA_CREACION
						)

						OUTPUT INSERTED.ID_PLAN_ESTUDIO INTO @tblPlanEstudio_NuevoIdRegistrado(ID_PLAN_ESTUDIO)

						VALUES
						(
							(	--//ID_CARRERAS_POR_INSTITUCION
								SELECT cpi.ID_CARRERAS_POR_INSTITUCION 
								FROM transaccional.carreras_por_institucion cpi WHERE cpi.ID_INSTITUCION = @ID_INSTITUCION AND cpi.ID_CARRERA = @ID_CARRERA 
								and cpi.ID_TIPO_ITINERARIO= @ID_TIPO_ITINERARIO
								AND cpi.ES_ACTIVO = 1 AND cpi.ESTADO = 1)

							,(	@ID_TIPO_ITINERARIO--//ID_TIPO_ITINERARIO
								/*SELECT enum.ID_ENUMERADO 		
								FROM
									transaccional.carreras_por_institucion cpi
									INNER JOIN maestro.carrera c ON cpi.ID_CARRERA = c.ID_CARRERA
									INNER JOIN maestro.nivel_formacion nf ON c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION
									INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
								WHERE --1 = 1 AND
										cpi.ID_INSTITUCION =		@ID_INSTITUCION
									AND cpi.ID_CARRERA =			@ID_CARRERA
									AND enum.ID_TIPO_ENUMERADO =	@CODIGO_ENUMERADO_TIPO_ITINERARIO

									AND cpi.ES_ACTIVO =				1
									AND c.ESTADO =					1
									AND nf.ESTADO =					1
									AND enum.ESTADO =				1*/-->no se utiliza
							)
							,(--//CODIGO_PLAN_ESTUDIOS - Vacio por ahora hasta definir
								'ConsultarJtovar'	
							)
							,(--//NOMBRE_PLAN_ESTUDIOS
								SELECT E FROM #tmp WHERE rowIndex = 3						
							)
							,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
						)
										
						SET @ID_PLAN_ESTUDIO = (SELECT ID_PLAN_ESTUDIO as 'ID_PLAN_ESTUDIO recien registrado' FROM @tblPlanEstudio_NuevoIdRegistrado);

					End

				End --> FIN: REGISTRO BASE 

				Begin --> GRUPO ESPECIAL 
					
					Begin --> GRUPO ESPECIAL 1 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????                ???

					--???????? ???????????   ????????????????????    ????????????????????????              ????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????     ???

					--????????????  ???????????????     ?????????    ???????????????????                    ???

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                    ???

											
						Begin --> transaccional.modulo - GRUPO ESPECIAL 1 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE1(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 8
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 8 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 8 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
															
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 1 
																			
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO								
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE1(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE1)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA								
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' and F IS NOT NULL THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' and G IS NOT NULL THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' and H IS NOT NULL THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' and I IS NOT NULL THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' and J IS NOT NULL THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL  THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN (cast(M as DECIMAL(5,1))) END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --AÑADI JTOVAR

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 8 AND 9 --RANGO DE FILAS DEL PRIMER BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 8 AND 9 --RANGO DE FILAS DEL PRIMER BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE1)
							AND tmp.rowIndex BETWEEN 8 AND 9 --RANGO DE FILAS DEL PRIMER BLOQUE ESPECIAL
							
						End

					End

					Begin --> GRUPO ESPECIAL 2 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????               ??????? 
					--???????? ???????????   ????????????????????    ????????????????????????              ????????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????     ???????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????    ??????? 
					--????????????  ???????????????     ?????????    ???????????????????                   ????????

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                   ????????


						Begin --> transaccional.modulo - GRUPO ESPECIAL 2
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE2(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 10
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 10 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 10 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End

						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 2 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE2(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE2)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI    

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS  --JTOVAR
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 10 AND 11 --RANGO DE FILAS DEL SEGUNDO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 10 AND 11 --RANGO DE FILAS DEL SEGUNDO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE2)
							AND tmp.rowIndex BETWEEN 10 AND 11 --RANGO DE FILAS DEL SEGUNDO BLOQUE ESPECIAL
							
						End
					
					End

					Begin --> GRUPO ESPECIAL 3 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????               ???????     
					--???????? ???????????   ????????????????????    ????????????????????????              ????????    
					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????     ???????    
					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????     ???????    
					--????????????  ???????????????     ?????????    ???????????????????                   ????????    
					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                   ???????     
 
						Begin --> transaccional.modulo - GRUPO ESPECIAL 3
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE3(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 12
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 12 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 12 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End

						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 3 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO								
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE3(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE3)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS --JTOVAR SE COMENTO
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR SE AÑADIO

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 12 AND 13 --RANGO DE FILAS DEL TERCER BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 12 AND 13 --RANGO DE FILAS DEL TERCER BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE3)
							AND tmp.rowIndex BETWEEN 12 AND 13 --RANGO DE FILAS DEL TERCER BLOQUE ESPECIAL
							
						End
					
					End

					Begin --> GRUPO ESPECIAL 4 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????               ???  ???

					--???????? ???????????   ????????????????????    ????????????????????????              ???  ???

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ????????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????    ????????

					--????????????  ???????????????     ?????????    ???????????????????                        ???

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                        ???                                                                                             

						Begin --> transaccional.modulo - GRUPO ESPECIAL 4 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE4(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 14
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 14 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 14 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End

						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 4  
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE4(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE4)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR SE AÑADIO

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 14 AND 15 --RANGO DE FILAS DEL CUARTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 14 AND 15 --RANGO DE FILAS DEL CUARTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE4)
							AND tmp.rowIndex BETWEEN 14 AND 15 --RANGO DE FILAS DEL CUARTO BLOQUE ESPECIAL
							
						End
					
					End

					Begin --> GRUPO ESPECIAL 5 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????               ????????

					--???????? ???????????   ????????????????????    ????????????????????????              ????????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ????????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????    ????????

					--????????????  ???????????????     ?????????    ???????????????????                   ????????

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                   ????????

											
						Begin --> transaccional.modulo - GRUPO ESPECIAL 5 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE5(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 14
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 14 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 14 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
												
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 5 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE5(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE5)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL  THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR SE AÑADIO

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 15 AND 16 --RANGO DE FILAS DEL QUINTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 15 AND 16 --RANGO DE FILAS DEL QUINTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE5)
							AND tmp.rowIndex BETWEEN 15 AND 16 --RANGO DE FILAS DEL QUINTO BLOQUE ESPECIAL
							
						End

					End

					Begin --> GRUPO ESPECIAL 6 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????                ??????? 
					--???????? ???????????   ????????????????????    ????????????????????????              ???????? 
					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ???????? 
					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????    ?????????

					--????????????  ???????????????     ?????????    ???????????????????                   ?????????

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                    ???????                                                                                              
					 				
						Begin --> transaccional.modulo - GRUPO ESPECIAL 6 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE6(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 16
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 16 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 16 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
												
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 6 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE6(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE6)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR SE AÑADIO

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 18 AND 19 --RANGO DE FILAS DEL SEXTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 18 AND 19 --RANGO DE FILAS DEL SEXTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE6)
							AND tmp.rowIndex BETWEEN 18 AND 19 --RANGO DE FILAS DEL SEXTO BLOQUE ESPECIAL
							
						End

					End
					

				End --> FIN: GRUPO ESPECIAL 
				
				Begin --> GRUPO ESTANDAR 


					Begin --> GRUPO - 1 
						
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
							@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE 1 = 1
						AND	A <> ''
						AND	B <> '' 						
						AND	E <> '' 						
						AND (N <> '' OR N <> 0) 
						AND (P <> '' OR P <> 0)
						AND rowIndex BETWEEN @rowIndexIni_T_g1_tec AND @rowIndexIni_T_g1_tec --PRIMERA FILA DEL GRUPO REGULAR 1

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos					
							Begin --> transaccional.modulo - GRUPO 1 
							
								INSERT INTO transaccional.modulo
								(
								ID_PLAN_ESTUDIO
								,ID_TIPO_MODULO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,HORAS_ME							
								,TOTAL_HORAS

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G1(ID_MODULO)

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO										
										@ID_PLAN_ESTUDIO
									)

									--ID_TIPO_MODULO
									,@ID_TIPO_MODULO_TECNICO

									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_T_g1_tec
									)

									--HORAS_ME
									,( SELECT N FROM #tmp WHERE rowIndex = @rowIndexIni_T_g1_tec )

									--TOTAL_HORAS
									,( SELECT P FROM #tmp WHERE rowIndex = @rowIndexIni_T_g1_tec )
								
									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End
							
							Begin -->Validar inválidos
							select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_T_g1_tec  and @rowIndexFin_T_g1_tec and E<>''
							End

							Begin -->Validar periodo académico válido (número entero)
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((F like '%[^0-9]%' or ISNUMERIC(F)=0 or F =0 OR LEN(F)>@horas_long_max) AND F<>'') OR ((G like '%[^0-9]%' or ISNUMERIC(G)=0 OR G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR
										((H like '%[^0-9]%' or ISNUMERIC(H)=0 or H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR ((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR
										((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR ((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'')										
									)	and 
									rowIndex BETWEEN @rowIndexIni_T_g1_tec and @rowIndexFin_T_g1_tec 
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 

							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g1 and @rowIndexFin_T_g1
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/
							Begin -->Validar que se haya consignado información de horas 
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F = '' THEN 1 ELSE 0 END) + (CASE WHEN G = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H = ''THEN 1 ELSE 0 END) + (CASE WHEN I = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J = ''THEN 1 ELSE 0 END) + (CASE WHEN K = ''THEN 1 ELSE 0 END) 
										   = 6 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g1_tec and @rowIndexFin_T_g1_tec
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que NO se haya consignado más de un valor como información de horas 
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g1_tec and @rowIndexFin_T_g1_tec
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End
							BEGIN -->Validar créditos no vacíos							
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (M='')	and 
									rowIndex BETWEEN @rowIndexIni_T_g1_tec and @rowIndexFin_T_g1_tec --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ @row_horas_multiples_periodo_academico
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') 	
							End
							
							BEGIN -->Validar créditos válidos (numéricos), incluye decimal							
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									( ISNUMERIC(M)=0 AND M<>'')									
									and 
									rowIndex BETWEEN @rowIndexIni_T_g1_tec and @rowIndexFin_T_g1_tec --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ @row_horas_multiples_periodo_academico+ ','
									+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End										
							Begin --> transaccional.unidad_didactica - GRUPO 1 
												
								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
									,ID_TIPO_UNIDAD_DIDACTICA
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION																
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI
									,HORAS
									,CREDITOS
									,CREDITOS_ME

									,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G1(ID_UNIDAD_DIDACTICA)

								SELECT	
									--ID_MODULO		
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G1)			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 								  
										WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
										WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
									END	AS ID_SEMESTRE_ACADEMICO			
								
									--ID_TIPO_UNIDAD_DIDACTICA								
									,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL_TECNICO AS ID_TIPO_UNIDAD_DIDACTICA								
																							

									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION

									--PERIODO_ACADEMICO_I
									,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

									------PERIODO_ACADEMICO_II
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

									------PERIODO_ACADEMICO_III
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

									------PERIODO_ACADEMICO_IV
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

									------PERIODO_ACADEMICO_V
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

									------PERIODO_ACADEMICO_VI
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_VI

									--HORAS
									,CASE WHEN L <> '' THEN L END AS HORAS

									--CREDITOS
									,CASE WHEN M <> '' THEN M END AS CREDITOS

									--CREDITOS_ME
									,CASE WHEN O <> '' THEN O END AS CREDITOS_ME

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_T_g1_tec AND @rowIndexFin_T_g1_tec --RANGO DE FILAS DEL PRIMER BLOQUE ESTANDAR
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_invalidos + ',' +@row_no_numerico_periodo_academico +','+ 
								@row_horas_vacias_periodo_academico + ','+@row_horas_multiples_periodo_academico + ',' + @row_vacio_creditos + ',' + @row_no_numerico_creditos, ','))
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_T_g1_tec AND @rowIndexFin_T_g1_tec --RANGO DE FILAS DEL PRIMER BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' +@MSG_INFO+ '|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G1)
								AND tmp.rowIndex BETWEEN @rowIndexIni_T_g1_tec AND @rowIndexFin_T_g1_tec --RANGO DE FILAS DEL PRIMER BLOQUE ESTANDAR

								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
								
								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+@MSG_ERROR+'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+@MSG_ERROR+'|'								
							End
						End
						ELSE
						Begin
							--if 1 = 0 select 1
							SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila 24 hasta la Fila 49 no registradas porque no cuentan con Módulo o Horas o Total de horas.'+@MSG_INFO+'|';
						End

					End


					Begin --> GRUPO - 2 
						
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
							@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE 1 = 1
						AND	A <> ''
						AND	B <> '' 						
						AND	E <> '' 						
						AND (N <> '' OR N <> 0) 
						AND (P <> '' OR P <> 0)						
						AND rowIndex BETWEEN @rowIndexIni_T_g2_tec AND @rowIndexIni_T_g2_tec --PRIMERA FILA DEL GRUPO REGULAR 2

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos											
							Begin --> transaccional.modulo - GRUPO 2 
							
								INSERT INTO transaccional.modulo
								(
								ID_PLAN_ESTUDIO
								,ID_TIPO_MODULO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,HORAS_ME							
								,TOTAL_HORAS

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G2(ID_MODULO)

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO										
										@ID_PLAN_ESTUDIO
									)

									--ID_TIPO_MODULO
									,@ID_TIPO_MODULO_TECNICO

									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_T_g2_tec
									)

									--HORAS_ME
									,( SELECT N FROM #tmp WHERE rowIndex = @rowIndexIni_T_g2_tec )

									--TOTAL_HORAS
									,( SELECT P FROM #tmp WHERE rowIndex = @rowIndexIni_T_g2_tec )
								
									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End

							Begin -->Validar inválidos
									SET @row_cod_uds_invalidos =''
									select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_T_g2_tec  and @rowIndexFin_T_g2_tec and E<>''
							End

							Begin -->Validar periodo académico válido (número entero)
									SET @row_no_numerico_periodo_academico=''
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((F like '%[^0-9]%' or ISNUMERIC(F)=0 or F =0 OR LEN(F)>@horas_long_max) AND F<>'') OR ((G like '%[^0-9]%' or ISNUMERIC(G)=0 OR G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR
										((H like '%[^0-9]%' or ISNUMERIC(H)=0 or H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR ((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR
										((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR ((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'')										
									)	and 
									rowIndex BETWEEN @rowIndexIni_T_g2_tec and @rowIndexFin_T_g2_tec 
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 

							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									SET @row_no_valor_unico_periodo_academico =''
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g2 and @rowIndexFin_T_g2
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/
							Begin -->Validar que se haya consignado información de horas 
									SET @row_horas_vacias_periodo_academico =''
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F = '' THEN 1 ELSE 0 END) + (CASE WHEN G = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H = ''THEN 1 ELSE 0 END) + (CASE WHEN I = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J = ''THEN 1 ELSE 0 END) + (CASE WHEN K = ''THEN 1 ELSE 0 END) 
										   = 6 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g2_tec and @rowIndexFin_T_g2_tec
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que se haya consignado más de un valor como información de horas 
									SET @row_horas_multiples_periodo_academico =''
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g2_tec and @rowIndexFin_T_g2_tec
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End

							BEGIN -->Validar créditos no vacíos	
								SET @row_vacio_creditos =''						
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (M='')	and 
									rowIndex BETWEEN @rowIndexIni_T_g2_tec and @rowIndexFin_T_g2_tec --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ @row_horas_multiples_periodo_academico
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') 	
							End
							
							BEGIN -->Validar créditos válidos (numéricos), incluye decimal								
								SET @row_no_numerico_creditos =''
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									( ISNUMERIC(M)=0 AND M<>'')									
									and 
									rowIndex BETWEEN @rowIndexIni_T_g2_tec and @rowIndexFin_T_g2_tec --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ @row_horas_multiples_periodo_academico+ ','
									+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End	
												
							Begin --> transaccional.unidad_didactica - GRUPO 2 
												
								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
									,ID_TIPO_UNIDAD_DIDACTICA
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION																
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI
									,HORAS
									,CREDITOS
									,CREDITOS_ME

									,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G2(ID_UNIDAD_DIDACTICA)

								SELECT	
									--ID_MODULO		
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G2)			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 								  
										WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
										WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
									END	AS ID_SEMESTRE_ACADEMICO			
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL_TECNICO AS ID_TIPO_UNIDAD_DIDACTICA 

									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION

									--PERIODO_ACADEMICO_I
									,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

									------PERIODO_ACADEMICO_II
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

									------PERIODO_ACADEMICO_III
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

									------PERIODO_ACADEMICO_IV
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

									------PERIODO_ACADEMICO_V
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

									------PERIODO_ACADEMICO_VI
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_VI

									--HORAS
									,CASE WHEN L <> '' THEN L END AS HORAS

									--CREDITOS
									,CASE WHEN M <> '' THEN M END AS CREDITOS

									--CREDITOS_ME
									,CASE WHEN O <> '' THEN O END AS CREDITOS_ME

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_T_g2_tec AND @rowIndexFin_T_g2_tec --RANGO DE FILAS DEL SEGUNDO BLOQUE ESTANDAR
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_invalidos + ',' +@row_no_numerico_periodo_academico +','+ 
								@row_horas_vacias_periodo_academico + ','+@row_horas_multiples_periodo_academico  + ',' + @row_vacio_creditos + ',' + @row_no_numerico_creditos, ','))
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_T_g2_tec AND @rowIndexFin_T_g2_tec --RANGO DE FILAS DEL SEGUNDO BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' + @MSG_INFO + '|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G2)
								AND tmp.rowIndex BETWEEN @rowIndexIni_T_g2_tec AND @rowIndexFin_T_g2_tec --RANGO DE FILAS DEL SEGUNDO BLOQUE ESTANDAR

								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
								
								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+@MSG_ERROR+'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+@MSG_ERROR+'|'								
							
							End
						End
						ELSE
						Begin
							--if 1 = 0 select 1
							SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila 54 hasta la Fila 79 no registradas porque no cuentan con Módulo o Horas o Total de horas.'+@MSG_INFO+'|';
						End

					End


					Begin --> GRUPO - 3 
						
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
							@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE 1 = 1
						AND	A <> ''
						AND	B <> '' 						
						AND	E <> '' 						
						AND (N <> '' OR N <> 0) 
						AND (P <> '' OR P <> 0)						
						AND rowIndex BETWEEN @rowIndexIni_T_g3_tec AND @rowIndexIni_T_g3_tec --PRIMERA FILA DEL GRUPO REGULAR 3

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos											
							Begin --> transaccional.modulo - GRUPO 3 
							
								INSERT INTO transaccional.modulo
								(
								ID_PLAN_ESTUDIO
								,ID_TIPO_MODULO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,HORAS_ME							
								,TOTAL_HORAS

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G3(ID_MODULO)

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO										
										@ID_PLAN_ESTUDIO
									)

									--ID_TIPO_MODULO
									,@ID_TIPO_MODULO_TECNICO

									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_T_g3_tec
									)

									--HORAS_ME
									,( SELECT N FROM #tmp WHERE rowIndex = @rowIndexIni_T_g3_tec )

									--TOTAL_HORAS
									,( SELECT P FROM #tmp WHERE rowIndex = @rowIndexIni_T_g3_tec )
								
									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End

							Begin -->Validar inválidos
									SET @row_cod_uds_invalidos =''
									select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_T_g3_tec  and @rowIndexIni_T_g3_tec and E<>''
							End

							Begin -->Validar periodo académico válido (número entero)
									SET @row_no_numerico_periodo_academico=''
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((F like '%[^0-9]%' or ISNUMERIC(F)=0 or F =0 OR LEN(F)>@horas_long_max) AND F<>'') OR ((G like '%[^0-9]%' or ISNUMERIC(G)=0 OR G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR
										((H like '%[^0-9]%' or ISNUMERIC(H)=0 or H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR ((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR
										((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR ((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'')										
									)	and 
									rowIndex BETWEEN @rowIndexIni_T_g3_tec and @rowIndexFin_T_g3_tec 
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 

							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									SET @row_no_valor_unico_periodo_academico =''
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g3 and @rowIndexFin_T_g3
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/

							Begin -->Validar que se haya consignado información de horas 
									SET @row_horas_vacias_periodo_academico =''
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F = '' THEN 1 ELSE 0 END) + (CASE WHEN G = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H = ''THEN 1 ELSE 0 END) + (CASE WHEN I = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J = ''THEN 1 ELSE 0 END) + (CASE WHEN K = ''THEN 1 ELSE 0 END) 
										   = 6 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g3_tec and @rowIndexFin_T_g3_tec
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que se haya consignado más de un valor como información de horas 
									SET @row_horas_multiples_periodo_academico =''
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g3_tec and @rowIndexFin_T_g3_tec
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End

							BEGIN -->Validar créditos no vacíos	
								SET @row_vacio_creditos =''						
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (M='')	and 
									rowIndex BETWEEN @rowIndexIni_T_g3_tec and @rowIndexFin_T_g3_tec --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ 	@row_horas_multiples_periodo_academico								
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') 	
							End
							
							BEGIN -->Validar créditos válidos (numéricos), incluye decimal								
								SET @row_no_numerico_creditos =''
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									( ISNUMERIC(M)=0 AND M<>'')									
									and 
									rowIndex BETWEEN @rowIndexIni_T_g3_tec and @rowIndexFin_T_g3_tec --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ 	@row_horas_multiples_periodo_academico	 + ','
									+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End	
												
							Begin --> transaccional.unidad_didactica - GRUPO 3 
												
								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
									,ID_TIPO_UNIDAD_DIDACTICA
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION																

									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II

									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV

									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI

									,HORAS
									,CREDITOS
									,CREDITOS_ME

									,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G3(ID_UNIDAD_DIDACTICA)

								SELECT	
									--ID_MODULO		
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G3)			
								
									--ID_SEMESTRE_ACADEMICO								
									,CASE 								  
										WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
										WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
									END	AS ID_SEMESTRE_ACADEMICO
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL_TECNICO AS ID_TIPO_UNIDAD_DIDACTICA 

									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION

									----PERIODO_ACADEMICO_I
									,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

									--------PERIODO_ACADEMICO_II
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

									--------PERIODO_ACADEMICO_III
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

									--------PERIODO_ACADEMICO_IV
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

									--------PERIODO_ACADEMICO_V
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

									--------PERIODO_ACADEMICO_VI
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_VI

									--HORAS
									,CASE WHEN L <> '' THEN L END AS HORAS

									--CREDITOS
									,CASE WHEN M <> '' THEN M END AS CREDITOS

									--CREDITOS_ME
									,CASE WHEN O <> '' THEN O END AS CREDITOS_ME

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_T_g3_tec AND @rowIndexFin_T_g3_tec --RANGO DE FILAS DEL TERCER BLOQUE ESTANDAR
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_invalidos + ',' +@row_no_numerico_periodo_academico +','+ 
								@row_horas_vacias_periodo_academico + ','+ 	@row_horas_multiples_periodo_academico	 + ',' + @row_vacio_creditos + ',' + @row_no_numerico_creditos, ','))

								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_T_g3_tec AND @rowIndexFin_T_g3_tec --RANGO DE FILAS DEL TERCER BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).'+@MSG_INFO+'' + '|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G3)
								AND tmp.rowIndex BETWEEN @rowIndexIni_T_g3_tec AND @rowIndexFin_T_g3_tec --RANGO DE FILAS DEL TERCER BLOQUE ESTANDAR								
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_invalidos + ',' +@row_no_numerico_periodo_academico +','+ 
								@row_horas_vacias_periodo_academico + ','+ 	@row_horas_multiples_periodo_academico	 + ',' + @row_vacio_creditos + ',' + @row_no_numerico_creditos, ','))

							
								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
								
								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+@MSG_ERROR+'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+@MSG_ERROR+'|'								
							End
						End
						ELSE
						Begin
							--if 1 = 0 select 1
							SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila 84 hasta la Fila 109 no registradas porque no cuentan con Módulo o Horas o Total de horas.'+@MSG_INFO+'|';
						End

					End


					/*Begin --> GRUPO - 4 
					
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
							@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE 1 = 1
						AND	A <> ''
						AND	B <> '' 						
						AND	E <> '' 						
						AND (N <> '' OR N <> 0) 
						AND (P <> '' OR P <> 0)					
						AND rowIndex BETWEEN 104 AND 104 --PRIMERA FILA DEL CUARTO BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos						
							Begin --> transaccional.modulo - GRUPO 4 
							
								INSERT INTO transaccional.modulo
								(
								ID_PLAN_ESTUDIO
								,ID_TIPO_MODULO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,HORAS_ME							
								,TOTAL_HORAS

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G4(ID_MODULO)

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO										
										@ID_PLAN_ESTUDIO
									)

									--ID_TIPO_MODULO
									,@ID_TIPO_MODULO_PROFESIONAL

									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = 104
									)

									--HORAS_ME
									,( SELECT N FROM #tmp WHERE rowIndex = 104 )

									--TOTAL_HORAS
									,( SELECT P FROM #tmp WHERE rowIndex = 104 )
								
									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End
												
							Begin --> transaccional.unidad_didactica - GRUPO 4 
												
								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
									,ID_TIPO_UNIDAD_DIDACTICA
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION																
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI
									,HORAS
									,CREDITOS
									,CREDITOS_ME

									,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G4(ID_UNIDAD_DIDACTICA)

								SELECT	
									--ID_MODULO		
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G4)			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 								  
										WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
										WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
									END	AS ID_SEMESTRE_ACADEMICO			
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,@ID_TIPO_UNIDAD_DIDACTICA_PROFESIONAL AS ID_TIPO_UNIDAD_DIDACTICA 

									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION

									--PERIODO_ACADEMICO_I
									,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

									------PERIODO_ACADEMICO_II
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

									------PERIODO_ACADEMICO_III
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

									------PERIODO_ACADEMICO_IV
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

									------PERIODO_ACADEMICO_V
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

									------PERIODO_ACADEMICO_VI
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_VI

									--HORAS
									,CASE WHEN L <> '' THEN L END AS HORAS

									--CREDITOS
									,CASE WHEN M <> '' THEN M END AS CREDITOS

									--CREDITOS_ME
									,CASE WHEN O <> '' THEN O END AS CREDITOS_ME

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN 104 AND 123 --RANGO DE FILAS DEL CUARTO BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN 104 AND 123 --RANGO DE FILAS DEL CUARTO BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' + '|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G4)
								AND tmp.rowIndex BETWEEN 104 AND 123 --RANGO DE FILAS DEL CUARTO BLOQUE ESTANDAR
							
							End
						End						
						ELSE						
						Begin							
							 SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila 104 hasta la Fila 123 no registradas porque no cuentan con Módulo o Horas o Total de horas.|';
						End
						
					End*/


				End --> FIN: GRUPO ESTANDAR 

				Begin --> GRUPO - CONSOLIDADO 

					Begin --> transaccional.plan_estudio_detalle - CONSOLIDADO
		
						--//Insert datos
						INSERT INTO transaccional.plan_estudio_detalle
						(
							ID_PLAN_ESTUDIO
							,ID_TIPO_UNIDAD_DIDACTICA
							,DESCRIPCION_CONSOLIDADO

							,PERIODO_ACADEMICO_I
							,PERIODO_ACADEMICO_II
							,PERIODO_ACADEMICO_III
							,PERIODO_ACADEMICO_IV
							,PERIODO_ACADEMICO_V
							,PERIODO_ACADEMICO_VI

							,COLUMNA_L
							,COLUMNA_M
							,COLUMNA_N
							,COLUMNA_O
							,COLUMNA_P

							,ORDEN_VISUALIZACION

							,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
						)

						OUTPUT INSERTED.ID_PLAN_ESTUDIO_DETALLE INTO @tblPlanEstudioDetalle_NuevoIdRegistrado(ID_PLAN_ESTUDIO_DETALLE)

						SELECT										
							(--ID_PLAN_ESTUDIO								
								@ID_PLAN_ESTUDIO
							)

							--ID_TIPO_UNIDAD_DIDACTICA			--102,103,104
							,CASE				
								WHEN (SELECT B FROM #tmp WHERE rowIndex = 78) = B THEN (SELECT ID_TIPO_UNIDAD_DIDACTICA FROM maestro.tipo_unidad_didactica ud WHERE ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA_ESPECIFICA)
								WHEN (SELECT B FROM #tmp WHERE rowIndex = 79) = B THEN (SELECT ID_TIPO_UNIDAD_DIDACTICA FROM maestro.tipo_unidad_didactica ud WHERE ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA_EMPLEABILIDAD)
								WHEN (SELECT B FROM #tmp WHERE rowIndex = 80) = B THEN (SELECT ID_TIPO_UNIDAD_DIDACTICA FROM maestro.tipo_unidad_didactica ud WHERE ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA_EXPERIENCIA_FORMATIVA)
								--ELSE ''
							END AS ID_TIPO_UNIDAD_DIDACTICA
								
							--DESCRIPCION_CONSOLIDADO			
							,CASE 
								WHEN B = '' THEN '0' --'ERROR' 
								WHEN B <> '' THEN B 
							END AS DESCRIPCION_CONSOLIDADO

							--PERIODO_ACADEMICO_I
							,CASE 
								WHEN F = '' THEN 0 --'ERROR' 
								WHEN F <> '' THEN convert(int,( convert(decimal, F)))
							END AS PERIODO_ACADEMICO_I

							--PERIODO_ACADEMICO_II
							,CASE 
								WHEN G = '' THEN 0 --'ERROR' 
								WHEN G <> '' THEN convert(int,( convert(decimal, G))) 
							END AS PERIODO_ACADEMICO_II

							--PERIODO_ACADEMICO_III
							,CASE 
								WHEN H = '' THEN 0 --'ERROR' 
								WHEN H <> '' THEN convert(int,( convert(decimal, H))) 
							END AS PERIODO_ACADEMICO_III
				
							--PERIODO_ACADEMICO_IV
							,CASE 
								WHEN I = '' THEN 0 --'ERROR' 
								WHEN I <> '' THEN convert(int,( convert(decimal, I)))
							END AS PERIODO_ACADEMICO_IV
				
							--PERIODO_ACADEMICO_V
							,CASE 
								WHEN J = '' THEN 0 --'ERROR' 
								WHEN J <> '' THEN convert(int,( convert(decimal, J)))
							END AS PERIODO_ACADEMICO_V
				
							--PERIODO_ACADEMICO_VI
							,CASE 
								WHEN K = '' THEN 0 --'ERROR' 
								WHEN K <> '' THEN convert(int,( convert(decimal, K)))
							END AS PERIODO_ACADEMICO_VI

							--COLUMNA_L
							,CASE 							
								WHEN L <> '' THEN CAST(L as decimal(10,2))
							END AS COLUMNA_L

							--COLUMNA_M
							,CASE 							
								WHEN M <> '' THEN CAST(M as decimal(10,2))
							END AS COLUMNA_M

							--COLUMNA_N
							,CASE 							
								WHEN N <> '' THEN CAST(N as decimal(10,2))
							END AS COLUMNA_N

							--COLUMNA_O
							,CASE 							
								WHEN O <> '' THEN CAST(O as decimal(10,2))
							END AS COLUMNA_O

							--COLUMNA_P
							,CASE 							
								WHEN P <> '' THEN CAST(P as decimal(10,2))
							END AS COLUMNA_P



							--ORDEN_VISUALIZACION
							,ROW_NUMBER() OVER (ORDER BY rowIndex)  
							AS ORDEN_VISUALIZACION

							,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
						FROM #tmp
						WHERE 1 = 1		
						AND rowIndex BETWEEN 120 AND 123		--RANGO DE FILAS DEL CONSOLIDADDO --126 AND 129
						ORDER BY CONVERT(INT, rowIndex) ASC

						--//Filas registradas pero con algun VALOR en = 0		
						SELECT @INDEX_REGISTRADOS_CONSOLIDADOS_CERO = COALESCE(@INDEX_REGISTRADOS_CONSOLIDADOS_CERO,'') + 'Fila ' + rowIndex + ' registrada pero uno de sus valores es igual a 0.'+@MSG_INFO+'|'
						FROM transaccional.plan_estudio_detalle ped
						inner join #tmp tmp ON ped.DESCRIPCION_CONSOLIDADO = tmp.B
						WHERE --1 = 1
						( ped.PERIODO_ACADEMICO_I = 0
						OR ped.PERIODO_ACADEMICO_II = 0
						OR ped.PERIODO_ACADEMICO_III = 0
						OR ped.PERIODO_ACADEMICO_IV = 0
						OR ped.PERIODO_ACADEMICO_V = 0
						OR ped.PERIODO_ACADEMICO_VI = 0
						OR ped.SUMA_TOTAL_HORAS_POR_TIPO = 0 )
						AND ped.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
						AND tmp.rowIndex BETWEEN 120 AND 123		--RANGO DE FILAS DEL CONSOLIDADDO  --126 AND 129

						--//Filas registradas pero con algun VALOR en = 0
						SELECT @INDEX_REGISTRADOS_CONSOLIDADOS_CERO = COALESCE(@INDEX_REGISTRADOS_CONSOLIDADOS_CERO,'') + 'Fila ' + rowIndex + ' registrada pero uno de sus valores es igual a 0.'+@MSG_INFO+'|'
						FROM transaccional.plan_estudio_detalle ped
						inner join #tmp tmp ON ped.DESCRIPCION_CONSOLIDADO = tmp.B
						WHERE 1 = 1
						AND ped.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
						AND tmp.rowIndex BETWEEN 120 AND 123			--RANGO DE FILAS DEL CONSOLIDADO  --129 AND 129
						AND (ped.TOTAL_CREDITOS_UD = 0 OR ped.SUMA_TOTAL_CREDITOS_UD = 0)

					End

				End --> FIN: GRUPO - CONSOLIDADO

			  End


			ELSE --JTOVAR ACA HACE TECNICO PROFESIONAL
			

			   Begin --> REGISTRAR EN LA BASE DE DATOS 

				Begin --> REGISTRO BASE 

					Begin --> transaccional.plan_estudio 
					
						INSERT INTO transaccional.plan_estudio
						(
							ID_CARRERAS_POR_INSTITUCION
							,ID_TIPO_ITINERARIO
							,CODIGO_PLAN_ESTUDIOS
							,NOMBRE_PLAN_ESTUDIOS
							,ES_ACTIVO,	ESTADO,	USUARIO_CREACION,	FECHA_CREACION
						)

						OUTPUT INSERTED.ID_PLAN_ESTUDIO INTO @tblPlanEstudio_NuevoIdRegistrado(ID_PLAN_ESTUDIO)

						VALUES
						(
							(	--//ID_CARRERAS_POR_INSTITUCION
								SELECT cpi.ID_CARRERAS_POR_INSTITUCION 
								FROM transaccional.carreras_por_institucion cpi WHERE cpi.ID_INSTITUCION = @ID_INSTITUCION AND cpi.ID_CARRERA = @ID_CARRERA 
								and cpi.ID_TIPO_ITINERARIO= @ID_TIPO_ITINERARIO
								AND cpi.ES_ACTIVO = 1 AND cpi.ESTADO = 1)

							,(	@ID_TIPO_ITINERARIO--//ID_TIPO_ITINERARIO
								/*SELECT enum.ID_ENUMERADO 		
								FROM
									transaccional.carreras_por_institucion cpi
									INNER JOIN maestro.carrera c ON cpi.ID_CARRERA = c.ID_CARRERA
									INNER JOIN maestro.nivel_formacion nf ON c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION
									INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
								WHERE --1 = 1 AND
										cpi.ID_INSTITUCION =		@ID_INSTITUCION
									AND cpi.ID_CARRERA =			@ID_CARRERA
									AND enum.ID_TIPO_ENUMERADO =	@CODIGO_ENUMERADO_TIPO_ITINERARIO

									AND cpi.ES_ACTIVO =				1
									AND c.ESTADO =					1
									AND nf.ESTADO =					1
									AND enum.ESTADO =				1*/-->no se utiliza
							)
							,(--//CODIGO_PLAN_ESTUDIOS - Vacio por ahora hasta definir
								'ConsultarJtovar'	
							)
							,(--//NOMBRE_PLAN_ESTUDIOS
								SELECT E FROM #tmp WHERE rowIndex = 3						
							)
							,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
						)
										
						SET @ID_PLAN_ESTUDIO = (SELECT ID_PLAN_ESTUDIO as 'ID_PLAN_ESTUDIO recien registrado' FROM @tblPlanEstudio_NuevoIdRegistrado);

					End

				End --> FIN: REGISTRO BASE 

				Begin --> GRUPO ESPECIAL 
					
					Begin --> GRUPO ESPECIAL 1 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????                ???

					--???????? ???????????   ????????????????????    ????????????????????????              ????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????     ???

					--????????????  ???????????????     ?????????    ???????????????????                    ???

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                    ???

											
						Begin --> transaccional.modulo - GRUPO ESPECIAL 1 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE1(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 8
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 8 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 8 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
															
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 1 
																			
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO								
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE1(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE1)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA								
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' and F IS NOT NULL THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' and G IS NOT NULL THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' and H IS NOT NULL THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' and I IS NOT NULL THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' and J IS NOT NULL THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL  THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN (cast(M as DECIMAL(5,1))) END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --AÑADI JTOVAR

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 8 AND 9 --RANGO DE FILAS DEL PRIMER BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 8 AND 9 --RANGO DE FILAS DEL PRIMER BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE1)
							AND tmp.rowIndex BETWEEN 8 AND 9 --RANGO DE FILAS DEL PRIMER BLOQUE ESPECIAL
							
						End

					End

					Begin --> GRUPO ESPECIAL 2 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????               ??????? 
					--???????? ???????????   ????????????????????    ????????????????????????              ????????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????     ???????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????    ??????? 
					--????????????  ???????????????     ?????????    ???????????????????                   ????????

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                   ????????


						Begin --> transaccional.modulo - GRUPO ESPECIAL 2
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE2(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 10
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 10 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 10 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End

						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 2 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE2(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE2)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI    

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS  --JTOVAR
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 10 AND 11 --RANGO DE FILAS DEL SEGUNDO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 10 AND 11 --RANGO DE FILAS DEL SEGUNDO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE2)
							AND tmp.rowIndex BETWEEN 10 AND 11 --RANGO DE FILAS DEL SEGUNDO BLOQUE ESPECIAL
							
						End
					
					End

					Begin --> GRUPO ESPECIAL 3 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????               ???????     
					--???????? ???????????   ????????????????????    ????????????????????????              ????????    
					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????     ???????    
					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????     ???????    
					--????????????  ???????????????     ?????????    ???????????????????                   ????????    
					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                   ???????     
 
						Begin --> transaccional.modulo - GRUPO ESPECIAL 2
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE3(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 12
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 12 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 12 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End

						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 3 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO								
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE3(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE3)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								,CASE WHEN M <> '' THEN M END AS CREDITOS --JTOVAR SE COMENTO
								--,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR SE AÑADIO

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 12 AND 12 --RANGO DE FILAS DEL TERCER BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 12 AND 12 --RANGO DE FILAS DEL TERCER BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE3)
							AND tmp.rowIndex BETWEEN 12 AND 12 --RANGO DE FILAS DEL TERCER BLOQUE ESPECIAL
							
						End
					
					End

					Begin --> GRUPO ESPECIAL 4 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????               ???  ???

					--???????? ???????????   ????????????????????    ????????????????????????              ???  ???

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ????????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????    ????????

					--????????????  ???????????????     ?????????    ???????????????????                        ???

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                        ???                                                                                             

						Begin --> transaccional.modulo - GRUPO ESPECIAL 4 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE4(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 13
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 13 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 13 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End

						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 4  

							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE4(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE4)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO	
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II
								
								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 13 AND 13 --RANGO DE FILAS DEL CUARTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 13 AND 13 --RANGO DE FILAS DEL CUARTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE4)
							AND tmp.rowIndex BETWEEN 13 AND 13 --RANGO DE FILAS DEL CUARTO BLOQUE ESPECIAL
							
						End
					
					End

					Begin --> GRUPO ESPECIAL 5 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????               ????????

					--???????? ???????????   ????????????????????    ????????????????????????              ????????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ????????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????    ????????

					--????????????  ???????????????     ?????????    ???????????????????                   ????????

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                   ????????

											
						Begin --> transaccional.modulo - GRUPO ESPECIAL 5 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE5(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 14
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 14 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 14 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
												
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 5 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE5(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE5)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL  THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 14 AND 15 --RANGO DE FILAS DEL QUINTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 14 AND 15 --RANGO DE FILAS DEL QUINTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE5)
							AND tmp.rowIndex BETWEEN 14 AND 15 --RANGO DE FILAS DEL QUINTO BLOQUE ESPECIAL
							
						End

					End

					Begin --> GRUPO ESPECIAL 6 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????                ??????? 
					--???????? ???????????   ????????????????????    ????????????????????????              ???????? 
					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ???????? 
					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????    ?????????

					--????????????  ???????????????     ?????????    ???????????????????                   ?????????

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                    ???????                                                                                              
					 				
						Begin --> transaccional.modulo - GRUPO ESPECIAL 6 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE6(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 16
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 16 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 16 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
												
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 6 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE6(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE6)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR

								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 16 AND 17 --RANGO DE FILAS DEL SEXTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 16 AND 17 --RANGO DE FILAS DEL SEXTO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE6)
							AND tmp.rowIndex BETWEEN 16 AND 17 --RANGO DE FILAS DEL SEXTO BLOQUE ESPECIAL
							
						End

					End

					Begin --> GRUPO ESPECIAL 7 
					
					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????               ????????

					--???????? ???????????   ????????????????????    ????????????????????????              ????????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????        ????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????       ???? 
					--????????????  ???????????????     ?????????    ???????????????????                      ???  
					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                      ???  					 
											
						Begin --> transaccional.modulo - GRUPO ESPECIAL 7 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE7(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 18
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 18 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 18 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
												
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 7 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE7(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE7)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL  THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR


								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 18 AND 19 --RANGO DE FILAS DEL SETIMO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 18 AND 19 --RANGO DE FILAS DEL SETIMO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE7)
							AND tmp.rowIndex BETWEEN 18 AND 19 --RANGO DE FILAS DEL SETIMO BLOQUE ESPECIAL
							
						End

					End
					
					Begin --> GRUPO ESPECIAL 8 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????                ?????? 
					--???????? ???????????   ????????????????????    ????????????????????????              ????????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ????????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????    ????????

					--????????????  ???????????????     ?????????    ???????????????????                   ????????

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                    ??????                                                                                              
						
						Begin --> transaccional.modulo - GRUPO ESPECIAL 8 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE8(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 20
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 20 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 20 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
												
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 8 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE8(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE8)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL  THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR


								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 20 AND 22 --RANGO DE FILAS DEL OCTAVO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 20 AND 22 --RANGO DE FILAS DEL OCTAVO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE8)
							AND tmp.rowIndex BETWEEN 20 AND 22 --RANGO DE FILAS DEL OCTAVO BLOQUE ESPECIAL
							
						End

					End

					Begin --> GRUPO ESPECIAL 9 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????                ?????? 
					--???????? ???????????   ????????????????????    ????????????????????????              ????????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ????????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????     ???????

					--????????????  ???????????????     ?????????    ???????????????????                    ???????

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                    ??????                                                                                              
											
						Begin --> transaccional.modulo - GRUPO ESPECIAL 9 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE9(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 23
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 23 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 23 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
												
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 9 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE9(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE9)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR


								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 23 AND 24 --RANGO DE FILAS DEL NOVENO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 23 AND 24 --RANGO DE FILAS DEL NOVENO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE9)
							AND tmp.rowIndex BETWEEN 23 AND 24 --RANGO DE FILAS DEL NOVENO BLOQUE ESPECIAL
							
						End

					End

					Begin --> GRUPO ESPECIAL 10 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????                ??? ??????? 
					--???????? ???????????   ????????????????????    ????????????????????????              ?????????????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ?????????????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????     ????????????

					--????????????  ???????????????     ?????????    ???????????????????                    ????????????

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                    ??? ???????  
					
						Begin --> transaccional.modulo - GRUPO ESPECIAL 10 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE10(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 25
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 25 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 25 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
												
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 10 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE10(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE10)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR


								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 25 AND 26 --RANGO DE FILAS DEL DECIMO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 25 AND 26 --RANGO DE FILAS DEL DECIMO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE10)
							AND tmp.rowIndex BETWEEN 25 AND 26 --RANGO DE FILAS DEL DECIMO BLOQUE ESPECIAL
							
						End

					End

					Begin --> GRUPO ESPECIAL 11 

					-- ??????? ??????? ???   ??????????  ???????     ???????????????????????                ??? ???

					--???????? ???????????   ????????????????????    ????????????????????????              ????????

					--???  ???????????????   ??????????????   ???    ??????  ????????????????    ??????    ????????

					--???   ??????????????   ?????????? ???   ???    ??????  ???????????????     ??????     ??? ???

					--????????????  ???????????????     ?????????    ???????????????????                    ??? ???

					-- ??????? ???  ??? ??????? ???      ???????     ???????????????????                    ??? ???					
						
						Begin --> transaccional.modulo - GRUPO ESPECIAL 11 
							
							INSERT INTO transaccional.modulo
							(
							ID_PLAN_ESTUDIO
							,ID_TIPO_MODULO
							,CODIGO_MODULO
							,NOMBRE_MODULO

							,HORAS_ME
							,CREDITOS_ME

							,ES_ACTIVO
							,ESTADO
							,USUARIO_CREACION
							,FECHA_CREACION
							)

							OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_GE11(ID_MODULO)

							VALUES	--ID_MODULO
							(
								(--//ID_PLAN_ESTUDIO									
									@ID_PLAN_ESTUDIO
								)

								--ID_TIPO_MODULO
								,@ID_TIPO_MODULO_TRANSVERSAL

								,(--CODIGO_MODULO - Vacio por ahora hasta definir
								'ConsultarJtovar'	
								)
								,(--NOMBRE_MODULO
									SELECT B FROM #tmp WHERE rowIndex = 27
								)

								--HORAS_ME
								,( SELECT N FROM #tmp WHERE rowIndex = 27 )

								--CREDITOS_ME
								,( SELECT O FROM #tmp WHERE rowIndex = 27 )
								
								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							)

						End
												
						Begin --> transaccional.unidad_didactica - GRUPO ESPECIAL 11 
												
							INSERT INTO transaccional.unidad_didactica
							(
								ID_MODULO
								,ID_SEMESTRE_ACADEMICO
								,ID_TIPO_UNIDAD_DIDACTICA
								,CODIGO_UNIDAD_DIDACTICA
								,NOMBRE_UNIDAD_DIDACTICA
								,DESCRIPCION																
								,PERIODO_ACADEMICO_I
								,PERIODO_ACADEMICO_II
								,PERIODO_ACADEMICO_III
								,PERIODO_ACADEMICO_IV
								,PERIODO_ACADEMICO_V
								,PERIODO_ACADEMICO_VI
								,HORAS
								,CREDITOS

								,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
							)

							OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_GE11(ID_UNIDAD_DIDACTICA)

							SELECT	
								--ID_MODULO		
								(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE11)			
								
								--ID_SEMESTRE_ACADEMICO
								,CASE 								  
									WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
									WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
									WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
									WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
								END	AS ID_SEMESTRE_ACADEMICO			
								
								--ID_TIPO_UNIDAD_DIDACTICA
								,@ID_TIPO_UNIDAD_DIDACTICA_TRANSVERSAL AS ID_TIPO_UNIDAD_DIDACTICA

								--CODIGO_UNIDAD_DIDACTICA
								,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
								--NOMBRE_UNIDAD_DIDACTICA
								,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
								--DESCRIPCION
								,'ConsultarJtovar'	AS DESCRIPCION

								--PERIODO_ACADEMICO_I
								,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

								------PERIODO_ACADEMICO_II
								,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

								------PERIODO_ACADEMICO_III
								,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

								------PERIODO_ACADEMICO_IV
								,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

								------PERIODO_ACADEMICO_V
								,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

								------PERIODO_ACADEMICO_VI
								,CASE WHEN TRY_PARSE(K AS int) IS NOT NULL  THEN K END AS PERIODO_ACADEMICO_VI

								--HORAS
								,CASE WHEN L <> '' THEN L END AS HORAS

								--CREDITOS
								--,CASE WHEN M <> '' THEN M END AS CREDITOS
								,CASE WHEN M <> '' THEN (cast(REPLACE(M,',','.') as DECIMAL(5,1))) END AS CREDITOS --JTOVAR


								,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
							FROM #tmp
							WHERE 1 = 1
							AND E <> ''
							AND rowIndex BETWEEN 27 AND 27 --RANGO DE FILAS DEL ONCEAVO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas no registradas porque no tienen nombre de la unidad didactica		
							SELECT @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = COALESCE(@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO,'') + 'Fila ' + rowIndex + ' no registrada.'+@MSG_INFO+'|'
							FROM #tmp
							WHERE 1 = 1
							AND E = ''
							AND rowIndex BETWEEN 27 AND 27 --RANGO DE FILAS DEL ONCEAVO BLOQUE ESPECIAL
							ORDER BY CONVERT(INT, rowIndex) ASC

							--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
							SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
							FROM transaccional.unidad_didactica ud
							inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
							WHERE ud.ID_SEMESTRE_ACADEMICO = 0
							AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_GE11)
							AND tmp.rowIndex BETWEEN 27 AND 27 --RANGO DE FILAS DEL ONCEAVO BLOQUE ESPECIAL
							
						End

					End

				End --> FIN: GRUPO ESPECIAL 
				
				Begin --> GRUPO ESTANDAR 


					Begin --> GRUPO - 1 
						
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
							@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE 1 = 1
						AND	A <> ''
						AND	B <> '' 						
						AND	E <> '' 						
						AND (N <> '' OR N <> 0) 
						AND (P <> '' OR P <> 0)
						AND rowIndex BETWEEN @rowIndexIni_T_g1 AND @rowIndexIni_T_g1 --PRIMERA FILA DEL GRUPO REGULAR 1

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos					
							Begin --> transaccional.modulo - GRUPO 1 
							
								INSERT INTO transaccional.modulo
								(
								ID_PLAN_ESTUDIO
								,ID_TIPO_MODULO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,HORAS_ME							
								,TOTAL_HORAS

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G1(ID_MODULO)

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO										
										@ID_PLAN_ESTUDIO
									)

									--ID_TIPO_MODULO
									,@ID_TIPO_MODULO_PROFESIONAL

									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_T_g1
									)

									--HORAS_ME
									,( SELECT N FROM #tmp WHERE rowIndex = @rowIndexIni_T_g1 )

									--TOTAL_HORAS
									,( SELECT P FROM #tmp WHERE rowIndex = @rowIndexIni_T_g1 )
								
									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End
							
							Begin -->Validar inválidos
							select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_T_g1  and @rowIndexFin_T_g1 and E<>''
							End

							Begin -->Validar periodo académico válido (número entero)
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((F like '%[^0-9]%' or ISNUMERIC(F)=0 or F =0 OR LEN(F)>@horas_long_max) AND F<>'') OR ((G like '%[^0-9]%' or ISNUMERIC(G)=0 OR G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR
										((H like '%[^0-9]%' or ISNUMERIC(H)=0 or H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR ((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR
										((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR ((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'')										
									)	and 
									rowIndex BETWEEN @rowIndexIni_T_g1 and @rowIndexFin_T_g1 
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 

							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g1 and @rowIndexFin_T_g1
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/
							Begin -->Validar que se haya consignado información de horas 
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F = '' THEN 1 ELSE 0 END) + (CASE WHEN G = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H = ''THEN 1 ELSE 0 END) + (CASE WHEN I = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J = ''THEN 1 ELSE 0 END) + (CASE WHEN K = ''THEN 1 ELSE 0 END) 
										   = 6 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g1 and @rowIndexFin_T_g1
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que NO se haya consignado más de un valor como información de horas 
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g1 and @rowIndexFin_T_g1
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End
							BEGIN -->Validar créditos no vacíos							
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (M='')	and 
									rowIndex BETWEEN @rowIndexIni_T_g1 and @rowIndexFin_T_g1 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ @row_horas_multiples_periodo_academico
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') 	
							End
							
							BEGIN -->Validar créditos válidos (numéricos), incluye decimal							
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									( ISNUMERIC(M)=0 AND M<>'')									
									and 
									rowIndex BETWEEN @rowIndexIni_T_g1 and @rowIndexFin_T_g1 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ @row_horas_multiples_periodo_academico+ ','
									+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End										
							Begin --> transaccional.unidad_didactica - GRUPO 1 
												
								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
									,ID_TIPO_UNIDAD_DIDACTICA
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION																
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI
									,HORAS
									,CREDITOS
									,CREDITOS_ME

									,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G1(ID_UNIDAD_DIDACTICA)

								SELECT	
									--ID_MODULO		
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G1)			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 								  
										WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
										WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
									END	AS ID_SEMESTRE_ACADEMICO			
								
									--ID_TIPO_UNIDAD_DIDACTICA								
									,@ID_TIPO_UNIDAD_DIDACTICA_PROFESIONAL AS ID_TIPO_UNIDAD_DIDACTICA								
																							

									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION

									--PERIODO_ACADEMICO_I
									,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

									------PERIODO_ACADEMICO_II
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

									------PERIODO_ACADEMICO_III
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

									------PERIODO_ACADEMICO_IV
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

									------PERIODO_ACADEMICO_V
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

									------PERIODO_ACADEMICO_VI
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_VI

									--HORAS
									,CASE WHEN L <> '' THEN L END AS HORAS

									--CREDITOS
									,CASE WHEN M <> '' THEN M END AS CREDITOS

									--CREDITOS_ME
									,CASE WHEN O <> '' THEN O END AS CREDITOS_ME

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_T_g1 AND @rowIndexFin_T_g1 --RANGO DE FILAS DEL PRIMER BLOQUE ESTANDAR
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_invalidos + ',' +@row_no_numerico_periodo_academico +','+ 
								@row_horas_vacias_periodo_academico + ','+@row_horas_multiples_periodo_academico + ',' + @row_vacio_creditos + ',' + @row_no_numerico_creditos, ','))
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_T_g1 AND @rowIndexFin_T_g1 --RANGO DE FILAS DEL PRIMER BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' +@MSG_INFO+ '|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G1)
								AND tmp.rowIndex BETWEEN @rowIndexIni_T_g1 AND @rowIndexFin_T_g1 --RANGO DE FILAS DEL PRIMER BLOQUE ESTANDAR

								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
								
								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+@MSG_ERROR+'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+@MSG_ERROR+'|'								
							End
						End
						ELSE
						Begin
							--if 1 = 0 select 1
							SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila 32 hasta la Fila 57 no registradas porque no cuentan con Módulo o Horas o Total de horas.'+@MSG_INFO+'|';
						End

					End


					Begin --> GRUPO - 2 
						
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
							@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE 1 = 1
						AND	A <> ''
						AND	B <> '' 						
						AND	E <> '' 						
						AND (N <> '' OR N <> 0) 
						AND (P <> '' OR P <> 0)						
						AND rowIndex BETWEEN @rowIndexIni_T_g2 AND @rowIndexIni_T_g2 --PRIMERA FILA DEL GRUPO REGULAR 2

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos											
							Begin --> transaccional.modulo - GRUPO 2 
							
								INSERT INTO transaccional.modulo
								(
								ID_PLAN_ESTUDIO
								,ID_TIPO_MODULO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,HORAS_ME							
								,TOTAL_HORAS

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G2(ID_MODULO)

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO										
										@ID_PLAN_ESTUDIO
									)

									--ID_TIPO_MODULO
									,@ID_TIPO_MODULO_PROFESIONAL

									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_T_g2
									)

									--HORAS_ME
									,( SELECT N FROM #tmp WHERE rowIndex = @rowIndexIni_T_g2 )

									--TOTAL_HORAS
									,( SELECT P FROM #tmp WHERE rowIndex = @rowIndexIni_T_g2 )
								
									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End

							Begin -->Validar inválidos
									SET @row_cod_uds_invalidos =''
									select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_T_g2  and @rowIndexFin_T_g2 and E<>''
							End

							Begin -->Validar periodo académico válido (número entero)
									SET @row_no_numerico_periodo_academico=''
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((F like '%[^0-9]%' or ISNUMERIC(F)=0 or F =0 OR LEN(F)>@horas_long_max) AND F<>'') OR ((G like '%[^0-9]%' or ISNUMERIC(G)=0 OR G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR
										((H like '%[^0-9]%' or ISNUMERIC(H)=0 or H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR ((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR
										((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR ((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'')										
									)	and 
									rowIndex BETWEEN @rowIndexIni_T_g2 and @rowIndexFin_T_g2 
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 

							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									SET @row_no_valor_unico_periodo_academico =''
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g2 and @rowIndexFin_T_g2
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/
							Begin -->Validar que se haya consignado información de horas 
									SET @row_horas_vacias_periodo_academico =''
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F = '' THEN 1 ELSE 0 END) + (CASE WHEN G = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H = ''THEN 1 ELSE 0 END) + (CASE WHEN I = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J = ''THEN 1 ELSE 0 END) + (CASE WHEN K = ''THEN 1 ELSE 0 END) 
										   = 6 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g2 and @rowIndexFin_T_g2
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que se haya consignado más de un valor como información de horas 
									SET @row_horas_multiples_periodo_academico =''
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g2 and @rowIndexFin_T_g2
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End

							BEGIN -->Validar créditos no vacíos	
								SET @row_vacio_creditos =''						
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (M='')	and 
									rowIndex BETWEEN @rowIndexIni_T_g2 and @rowIndexFin_T_g2 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ @row_horas_multiples_periodo_academico
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') 	
							End
							
							BEGIN -->Validar créditos válidos (numéricos), incluye decimal								
								SET @row_no_numerico_creditos =''
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									( ISNUMERIC(M)=0 AND M<>'')									
									and 
									rowIndex BETWEEN @rowIndexIni_T_g2 and @rowIndexFin_T_g2 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ @row_horas_multiples_periodo_academico+ ','
									+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End	
												
							Begin --> transaccional.unidad_didactica - GRUPO 2 
												
								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
									,ID_TIPO_UNIDAD_DIDACTICA
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION																
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI
									,HORAS
									,CREDITOS
									,CREDITOS_ME

									,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G2(ID_UNIDAD_DIDACTICA)

								SELECT	
									--ID_MODULO		
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G2)			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 								  
										WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
										WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
									END	AS ID_SEMESTRE_ACADEMICO			
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,@ID_TIPO_UNIDAD_DIDACTICA_PROFESIONAL AS ID_TIPO_UNIDAD_DIDACTICA 

									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION

									--PERIODO_ACADEMICO_I
									,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

									------PERIODO_ACADEMICO_II
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

									------PERIODO_ACADEMICO_III
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

									------PERIODO_ACADEMICO_IV
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

									------PERIODO_ACADEMICO_V
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

									------PERIODO_ACADEMICO_VI
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_VI

									--HORAS
									,CASE WHEN L <> '' THEN L END AS HORAS

									--CREDITOS
									,CASE WHEN M <> '' THEN M END AS CREDITOS

									--CREDITOS_ME
									,CASE WHEN O <> '' THEN O END AS CREDITOS_ME

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_T_g2 AND @rowIndexFin_T_g2 --RANGO DE FILAS DEL SEGUNDO BLOQUE ESTANDAR
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_invalidos + ',' +@row_no_numerico_periodo_academico +','+ 
								@row_horas_vacias_periodo_academico + ','+@row_horas_multiples_periodo_academico  + ',' + @row_vacio_creditos + ',' + @row_no_numerico_creditos, ','))
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_T_g2 AND @rowIndexFin_T_g2 --RANGO DE FILAS DEL SEGUNDO BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' + @MSG_INFO + '|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G2)
								AND tmp.rowIndex BETWEEN @rowIndexIni_T_g2 AND @rowIndexFin_T_g2 --RANGO DE FILAS DEL SEGUNDO BLOQUE ESTANDAR

								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
								
								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+@MSG_ERROR+'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+@MSG_ERROR+'|'								
							
							End
						End
						ELSE
						Begin
							--if 1 = 0 select 1
							SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila 62 hasta la Fila 87 no registradas porque no cuentan con Módulo o Horas o Total de horas.'+@MSG_INFO+'|';
						End

					End


					Begin --> GRUPO - 3 
						
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
							@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE 1 = 1
						AND	A <> ''
						AND	B <> '' 						
						AND	E <> '' 						
						AND (N <> '' OR N <> 0) 
						AND (P <> '' OR P <> 0)						
						AND rowIndex BETWEEN @rowIndexIni_T_g3 AND @rowIndexIni_T_g3 --PRIMERA FILA DEL GRUPO REGULAR 3

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos											
							Begin --> transaccional.modulo - GRUPO 3 
							
								INSERT INTO transaccional.modulo
								(
								ID_PLAN_ESTUDIO
								,ID_TIPO_MODULO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,HORAS_ME							
								,TOTAL_HORAS

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G3(ID_MODULO)

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO										
										@ID_PLAN_ESTUDIO
									)

									--ID_TIPO_MODULO
									,@ID_TIPO_MODULO_PROFESIONAL

									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_T_g3
									)

									--HORAS_ME
									,( SELECT N FROM #tmp WHERE rowIndex = @rowIndexIni_T_g3 )

									--TOTAL_HORAS
									,( SELECT P FROM #tmp WHERE rowIndex = @rowIndexIni_T_g3 )
								
									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End

							Begin -->Validar inválidos
									SET @row_cod_uds_invalidos =''
									select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_T_g3  and @rowIndexIni_T_g3 and E<>''
							End

							Begin -->Validar periodo académico válido (número entero)
									SET @row_no_numerico_periodo_academico=''
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((F like '%[^0-9]%' or ISNUMERIC(F)=0 or F =0 OR LEN(F)>@horas_long_max) AND F<>'') OR ((G like '%[^0-9]%' or ISNUMERIC(G)=0 OR G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR
										((H like '%[^0-9]%' or ISNUMERIC(H)=0 or H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR ((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR
										((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR ((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'')										
									)	and 
									rowIndex BETWEEN @rowIndexIni_T_g3 and @rowIndexFin_T_g3 
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 

							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									SET @row_no_valor_unico_periodo_academico =''
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g3 and @rowIndexFin_T_g3
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/

							Begin -->Validar que se haya consignado información de horas 
									SET @row_horas_vacias_periodo_academico =''
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F = '' THEN 1 ELSE 0 END) + (CASE WHEN G = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H = ''THEN 1 ELSE 0 END) + (CASE WHEN I = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J = ''THEN 1 ELSE 0 END) + (CASE WHEN K = ''THEN 1 ELSE 0 END) 
										   = 6 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g3 and @rowIndexFin_T_g3
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que se haya consignado más de un valor como información de horas 
									SET @row_horas_multiples_periodo_academico =''
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN F <> '' THEN 1 ELSE 0 END) + (CASE WHEN G <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN H <> ''THEN 1 ELSE 0 END) + (CASE WHEN I <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN J <> ''THEN 1 ELSE 0 END) + (CASE WHEN K <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_T_g3 and @rowIndexFin_T_g3
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End

							BEGIN -->Validar créditos no vacíos	
								SET @row_vacio_creditos =''						
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (M='')	and 
									rowIndex BETWEEN @rowIndexIni_T_g3 and @rowIndexFin_T_g3 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ 	@row_horas_multiples_periodo_academico								
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') 	
							End
							
							BEGIN -->Validar créditos válidos (numéricos), incluye decimal								
								SET @row_no_numerico_creditos =''
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									( ISNUMERIC(M)=0 AND M<>'')									
									and 
									rowIndex BETWEEN @rowIndexIni_T_g3 and @rowIndexFin_T_g3 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT( @row_cod_uds_invalidos + ','
									+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ','+ 	@row_horas_multiples_periodo_academico	 + ','
									+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End	
												
							Begin --> transaccional.unidad_didactica - GRUPO 3 
												
								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
									,ID_TIPO_UNIDAD_DIDACTICA
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION																

									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II

									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV

									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI

									,HORAS
									,CREDITOS
									,CREDITOS_ME

									,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G3(ID_UNIDAD_DIDACTICA)

								SELECT	
									--ID_MODULO		
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G3)			
								
									--ID_SEMESTRE_ACADEMICO								
									,CASE 								  
										WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
										WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
									END	AS ID_SEMESTRE_ACADEMICO
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,@ID_TIPO_UNIDAD_DIDACTICA_PROFESIONAL AS ID_TIPO_UNIDAD_DIDACTICA 

									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION

									----PERIODO_ACADEMICO_I
									,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

									--------PERIODO_ACADEMICO_II
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

									--------PERIODO_ACADEMICO_III
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

									--------PERIODO_ACADEMICO_IV
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

									--------PERIODO_ACADEMICO_V
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

									--------PERIODO_ACADEMICO_VI
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_VI

									--HORAS
									,CASE WHEN L <> '' THEN L END AS HORAS

									--CREDITOS
									,CASE WHEN M <> '' THEN M END AS CREDITOS

									--CREDITOS_ME
									,CASE WHEN O <> '' THEN O END AS CREDITOS_ME

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_T_g3 AND @rowIndexFin_T_g3 --RANGO DE FILAS DEL TERCER BLOQUE ESTANDAR
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_invalidos + ',' +@row_no_numerico_periodo_academico +','+ 
								@row_horas_vacias_periodo_academico + ','+ 	@row_horas_multiples_periodo_academico	 + ',' + @row_vacio_creditos + ',' + @row_no_numerico_creditos, ','))

								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_T_g3 AND @rowIndexFin_T_g3 --RANGO DE FILAS DEL TERCER BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).'+@MSG_INFO+'' + '|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.'+@MSG_ERROR+'|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G3)
								AND tmp.rowIndex BETWEEN @rowIndexIni_T_g3 AND @rowIndexFin_T_g3 --RANGO DE FILAS DEL TERCER BLOQUE ESTANDAR								
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_invalidos + ',' +@row_no_numerico_periodo_academico +','+ 
								@row_horas_vacias_periodo_academico + ','+ 	@row_horas_multiples_periodo_academico	 + ',' + @row_vacio_creditos + ',' + @row_no_numerico_creditos, ','))

							
								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
								
								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+@MSG_ERROR+'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+@MSG_ERROR+'|'								
							End
						End
						ELSE
						Begin
							--if 1 = 0 select 1
							SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila 92 hasta la Fila 117 no registradas porque no cuentan con Módulo o Horas o Total de horas.'+@MSG_INFO+'|';
						End

					End


					/*Begin --> GRUPO - 4 
					
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
							@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)						
						FROM #tmp
						WHERE 1 = 1
						AND	A <> ''
						AND	B <> '' 						
						AND	E <> '' 						
						AND (N <> '' OR N <> 0) 
						AND (P <> '' OR P <> 0)					
						AND rowIndex BETWEEN 104 AND 104 --PRIMERA FILA DEL CUARTO BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos						
							Begin --> transaccional.modulo - GRUPO 4 
							
								INSERT INTO transaccional.modulo
								(
								ID_PLAN_ESTUDIO
								,ID_TIPO_MODULO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								,HORAS_ME							
								,TOTAL_HORAS

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G4(ID_MODULO)

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO										
										@ID_PLAN_ESTUDIO
									)

									--ID_TIPO_MODULO
									,@ID_TIPO_MODULO_PROFESIONAL

									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = 104
									)

									--HORAS_ME
									,( SELECT N FROM #tmp WHERE rowIndex = 104 )

									--TOTAL_HORAS
									,( SELECT P FROM #tmp WHERE rowIndex = 104 )
								
									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End
												
							Begin --> transaccional.unidad_didactica - GRUPO 4 
												
								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
									,ID_TIPO_UNIDAD_DIDACTICA
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION																
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI
									,HORAS
									,CREDITOS
									,CREDITOS_ME

									,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G4(ID_UNIDAD_DIDACTICA)

								SELECT	
									--ID_MODULO		
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G4)			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 								  
										WHEN F =  '' AND G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' THEN 0
										WHEN 5 > ( CASE WHEN F = '' THEN 1 ELSE 0 END + CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN F <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )								
									END	AS ID_SEMESTRE_ACADEMICO			
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,@ID_TIPO_UNIDAD_DIDACTICA_PROFESIONAL AS ID_TIPO_UNIDAD_DIDACTICA 

									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN '' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
								
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN '' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
			
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION

									--PERIODO_ACADEMICO_I
									,CASE WHEN F <> '' THEN F END AS PERIODO_ACADEMICO_I

									------PERIODO_ACADEMICO_II
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_II

									------PERIODO_ACADEMICO_III
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_III

									------PERIODO_ACADEMICO_IV
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_IV

									------PERIODO_ACADEMICO_V
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_V

									------PERIODO_ACADEMICO_VI
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_VI

									--HORAS
									,CASE WHEN L <> '' THEN L END AS HORAS

									--CREDITOS
									,CASE WHEN M <> '' THEN M END AS CREDITOS

									--CREDITOS_ME
									,CASE WHEN O <> '' THEN O END AS CREDITOS_ME

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN 104 AND 123 --RANGO DE FILAS DEL CUARTO BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN 104 AND 123 --RANGO DE FILAS DEL CUARTO BLOQUE ESTANDAR
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' + '|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila ' + rowIndex + ' registrada pero posiblemente con error.|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G4)
								AND tmp.rowIndex BETWEEN 104 AND 123 --RANGO DE FILAS DEL CUARTO BLOQUE ESTANDAR
							
							End
						End						
						ELSE						
						Begin							
							 SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila 104 hasta la Fila 123 no registradas porque no cuentan con Módulo o Horas o Total de horas.|';
						End
						
					End*/


				End --> FIN: GRUPO ESTANDAR 

				Begin --> GRUPO - CONSOLIDADO 

					Begin --> transaccional.plan_estudio_detalle - CONSOLIDADO
		
						--//Insert datos
						INSERT INTO transaccional.plan_estudio_detalle
						(
							ID_PLAN_ESTUDIO
							,ID_TIPO_UNIDAD_DIDACTICA
							,DESCRIPCION_CONSOLIDADO

							,PERIODO_ACADEMICO_I
							,PERIODO_ACADEMICO_II
							,PERIODO_ACADEMICO_III
							,PERIODO_ACADEMICO_IV
							,PERIODO_ACADEMICO_V
							,PERIODO_ACADEMICO_VI

							,COLUMNA_L
							,COLUMNA_M
							,COLUMNA_N
							,COLUMNA_O
							,COLUMNA_P

							,ORDEN_VISUALIZACION

							,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
						)

						OUTPUT INSERTED.ID_PLAN_ESTUDIO_DETALLE INTO @tblPlanEstudioDetalle_NuevoIdRegistrado(ID_PLAN_ESTUDIO_DETALLE)

						SELECT										
							(--ID_PLAN_ESTUDIO								
								@ID_PLAN_ESTUDIO
							)

							--ID_TIPO_UNIDAD_DIDACTICA			--102,103,104
							,CASE				
								WHEN (SELECT B FROM #tmp WHERE rowIndex = 78) = B THEN (SELECT ID_TIPO_UNIDAD_DIDACTICA FROM maestro.tipo_unidad_didactica ud WHERE ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA_ESPECIFICA)
								WHEN (SELECT B FROM #tmp WHERE rowIndex = 79) = B THEN (SELECT ID_TIPO_UNIDAD_DIDACTICA FROM maestro.tipo_unidad_didactica ud WHERE ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA_EMPLEABILIDAD)
								WHEN (SELECT B FROM #tmp WHERE rowIndex = 80) = B THEN (SELECT ID_TIPO_UNIDAD_DIDACTICA FROM maestro.tipo_unidad_didactica ud WHERE ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA_EXPERIENCIA_FORMATIVA)
								--ELSE ''
							END AS ID_TIPO_UNIDAD_DIDACTICA
								
							--DESCRIPCION_CONSOLIDADO			
							,CASE 
								WHEN B = '' THEN '0' --'ERROR' 
								WHEN B <> '' THEN B 
							END AS DESCRIPCION_CONSOLIDADO

							--PERIODO_ACADEMICO_I
							,CASE 
								WHEN F = '' THEN 0 --'ERROR' 
								WHEN F <> '' THEN convert(int,( convert(decimal, F)))
							END AS PERIODO_ACADEMICO_I

							--PERIODO_ACADEMICO_II
							,CASE 
								WHEN G = '' THEN 0 --'ERROR' 
								WHEN G <> '' THEN convert(int,( convert(decimal, G))) 
							END AS PERIODO_ACADEMICO_II

							--PERIODO_ACADEMICO_III
							,CASE 
								WHEN H = '' THEN 0 --'ERROR' 
								WHEN H <> '' THEN convert(int,( convert(decimal, H))) 
							END AS PERIODO_ACADEMICO_III
				
							--PERIODO_ACADEMICO_IV
							,CASE 
								WHEN I = '' THEN 0 --'ERROR' 
								WHEN I <> '' THEN convert(int,( convert(decimal, I)))
							END AS PERIODO_ACADEMICO_IV
				
							--PERIODO_ACADEMICO_V
							,CASE 
								WHEN J = '' THEN 0 --'ERROR' 
								WHEN J <> '' THEN convert(int,( convert(decimal, J)))
							END AS PERIODO_ACADEMICO_V
				
							--PERIODO_ACADEMICO_VI
							,CASE 
								WHEN K = '' THEN 0 --'ERROR' 
								WHEN K <> '' THEN convert(int,( convert(decimal, K)))
							END AS PERIODO_ACADEMICO_VI

							--COLUMNA_L
							,CASE 							
								WHEN L <> '' THEN CAST(L as decimal(10,2))
							END AS COLUMNA_L

							--COLUMNA_M
							,CASE 							
								WHEN M <> '' THEN CAST(M as decimal(10,2))
							END AS COLUMNA_M

							--COLUMNA_N
							,CASE 							
								WHEN N <> '' THEN CAST(N as decimal(10,2))
							END AS COLUMNA_N

							--COLUMNA_O
							,CASE 							
								WHEN O <> '' THEN CAST(O as decimal(10,2))
							END AS COLUMNA_O

							--COLUMNA_P
							,CASE 							
								WHEN P <> '' THEN CAST(P as decimal(10,2))
							END AS COLUMNA_P



							--ORDEN_VISUALIZACION
							,ROW_NUMBER() OVER (ORDER BY rowIndex)  
							AS ORDEN_VISUALIZACION

							,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
						FROM #tmp
						WHERE 1 = 1		
						AND rowIndex BETWEEN 120 AND 123		--RANGO DE FILAS DEL CONSOLIDADDO --126 AND 129
						ORDER BY CONVERT(INT, rowIndex) ASC

						--//Filas registradas pero con algun VALOR en = 0		
						SELECT @INDEX_REGISTRADOS_CONSOLIDADOS_CERO = COALESCE(@INDEX_REGISTRADOS_CONSOLIDADOS_CERO,'') + 'Fila ' + rowIndex + ' registrada pero uno de sus valores es igual a 0.'+@MSG_INFO+'|'
						FROM transaccional.plan_estudio_detalle ped
						inner join #tmp tmp ON ped.DESCRIPCION_CONSOLIDADO = tmp.B
						WHERE --1 = 1
						( ped.PERIODO_ACADEMICO_I = 0
						OR ped.PERIODO_ACADEMICO_II = 0
						OR ped.PERIODO_ACADEMICO_III = 0
						OR ped.PERIODO_ACADEMICO_IV = 0
						OR ped.PERIODO_ACADEMICO_V = 0
						OR ped.PERIODO_ACADEMICO_VI = 0
						OR ped.SUMA_TOTAL_HORAS_POR_TIPO = 0 )
						AND ped.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
						AND tmp.rowIndex BETWEEN 120 AND 123		--RANGO DE FILAS DEL CONSOLIDADDO  --126 AND 129

						--//Filas registradas pero con algun VALOR en = 0
						SELECT @INDEX_REGISTRADOS_CONSOLIDADOS_CERO = COALESCE(@INDEX_REGISTRADOS_CONSOLIDADOS_CERO,'') + 'Fila ' + rowIndex + ' registrada pero uno de sus valores es igual a 0.'+@MSG_INFO+'|'
						FROM transaccional.plan_estudio_detalle ped
						inner join #tmp tmp ON ped.DESCRIPCION_CONSOLIDADO = tmp.B
						WHERE 1 = 1
						AND ped.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO 
						AND tmp.rowIndex BETWEEN 120 AND 123			--RANGO DE FILAS DEL CONSOLIDADO  --129 AND 129
						AND (ped.TOTAL_CREDITOS_UD = 0 OR ped.SUMA_TOTAL_CREDITOS_UD = 0)

					End

				End --> FIN: GRUPO - CONSOLIDADO

			   End
			
			END --JTOVAR IMPLEMENTACION TECNICO
        
		--End

		Begin --> ITINERARIO MODULAR 

		IF @VALIDAR_ITINERARIO_NOMBRE = UPPER(@TIPO_ITINERARIO) AND @ID_TIPO_ITINERARIO = @ITINERARIO_MODULAR 
			
			Begin --> REGISTRAR EN LA BASE DE DATOS 

				Begin --> REGISTRO BASE 
					
					Begin --> transaccional.plan_estudio 
						
						INSERT INTO transaccional.plan_estudio 
						(
							ID_CARRERAS_POR_INSTITUCION
							,ID_TIPO_ITINERARIO
							,CODIGO_PLAN_ESTUDIOS
							,NOMBRE_PLAN_ESTUDIOS
							,ES_ACTIVO,	ESTADO,	USUARIO_CREACION,	FECHA_CREACION
						)

						OUTPUT INSERTED.ID_PLAN_ESTUDIO INTO @tblPlanEstudio_NuevoIdRegistrado(ID_PLAN_ESTUDIO)

						VALUES
						(
							(	--//ID_CARRERAS_POR_INSTITUCION
								SELECT cpi.ID_CARRERAS_POR_INSTITUCION 
								FROM transaccional.carreras_por_institucion cpi WHERE cpi.ID_INSTITUCION = @ID_INSTITUCION AND cpi.ID_CARRERA = @ID_CARRERA 
								and cpi.ID_TIPO_ITINERARIO= @ID_TIPO_ITINERARIO
								AND cpi.ES_ACTIVO = 1 AND cpi.ESTADO = 1)
							,(	--//ID_TIPO_ITINERARIO
								@ID_TIPO_ITINERARIO
								/*SELECT enum.ID_ENUMERADO 		
								FROM
									transaccional.carreras_por_institucion cpi
									INNER JOIN maestro.carrera c ON cpi.ID_CARRERA = c.ID_CARRERA
									INNER JOIN maestro.nivel_formacion nf ON c.ID_NIVEL_FORMACION = nf.ID_NIVEL_FORMACION
									INNER JOIN sistema.enumerado enum ON cpi.ID_TIPO_ITINERARIO = enum.ID_ENUMERADO
								WHERE --1 = 1 AND
										cpi.ID_INSTITUCION =		@ID_INSTITUCION
									AND cpi.ID_CARRERA =			@ID_CARRERA
									AND enum.ID_TIPO_ENUMERADO =	@CODIGO_ENUMERADO_TIPO_ITINERARIO
									AND cpi.ID_TIPO_ITINERARIO=		@ID_TIPO_ITINERARIO
									AND cpi.ES_ACTIVO =				1
									AND c.ESTADO =					1
									AND nf.ESTADO =					1
									AND enum.ESTADO =				1*/ -->no necesario
							)
							,(--//CODIGO_PLAN_ESTUDIOS - Vacio por ahora hasta definir
								'ConsultarJtovar'	
							)
							,(--//NOMBRE_PLAN_ESTUDIOS
								SELECT E FROM #tmp WHERE rowIndex = 3						
							)
							,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
						)

						--//
						SET @ID_PLAN_ESTUDIO = (SELECT ID_PLAN_ESTUDIO as 'ID_PLAN_ESTUDIO recien registrado' FROM @tblPlanEstudio_NuevoIdRegistrado);

					End
										
					Begin --> transaccional.enfoques_por_plan_estudio  
					
						IF @ID_TIPO_ENFOQUE <> '' AND ISNUMERIC(@ID_TIPO_ENFOQUE) = 1 AND @ID_TIPO_ENFOQUE > 0
							Begin
								INSERT INTO transaccional.enfoques_por_plan_estudio 
								(
									ID_PLAN_ESTUDIO
									,ID_ENFOQUE

									,ES_ACTIVO
									,ESTADO
									,USUARIO_CREACION
									,FECHA_CREACION							
								)
								VALUES
								(							
									(--ID_PLAN_ESTUDIO								
										@ID_PLAN_ESTUDIO
									)

									--ID_ENFOQUE
									,@ID_TIPO_ENFOQUE

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)
							End
							ELSE
							Begin 
								SET @INDEX_NO_REGISTRADOS_ID_TIPO_ENFOQUE = 'Fila: 4 columna H no registrada(s) porque posiblemente tiene un error en tipo enfoque.'+@MSG_ERROR+'|'
							End						
					End

				End --> FIN: REGISTRO BASE 

				Begin --> GRUPO ESTANDAR 
				
					Begin --> GRUPO - 1 
					
						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)
						--*
						FROM #tmp
						WHERE 1 = 1
						AND	B <> '' 						
						AND	E <> '' 						
						AND (R <> '' OR R <> 0) --ANTES P
						AND (V <> '' OR V <> 0)		--ANTES T				
						AND rowIndex BETWEEN @rowIndexIni_g1 AND @rowIndexIni_g1  --PRIMERA FILA DEL PRIMER GRUPO

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos

							Begin --> transaccional.modulo - GRUPO 1 
												
								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								--//*****
								,TOTAL_HORAS_UD
								,TOTAL_CREDITOS_UD
								--//*****

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G1(ID_MODULO)													--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_g1																				--//FRAMOS CAMBIAR AQUI
									)

								
									--//*****
									,(--TOTAL_HORAS_UD		--ANTES P																								--//FRAMOS CAMBIAR AQUI
										SELECT R FROM #tmp WHERE rowIndex = @rowIndexIni_g1									
										)
								
									,(--TOTAL_CREDITOS_UD		 -- --ANTES T
										SELECT V FROM #tmp WHERE rowIndex = @rowIndexIni_g1																				--//FRAMOS CAMBIAR AQUI									
									)
									--//*****
																

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)
							
							End

							Begin --> maestro.unidad_competencia GRUPO 1 

							SET @INDEX_TEMPORAL = '';

								Begin --> maestro.unidad_competencia 01	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 8)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G1)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,1

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)												

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin										
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 8)) + ','			--//framos cambio aqui
									End

								End

								Begin --> maestro.unidad_competencia 02	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 14)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G1)

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,2

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin										
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 14)) + ','			--//framos cambio aqui
									End

								End																	

								Begin --> maestro.unidad_competencia 03	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 21)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G1)

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,3

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)												

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin										
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 21)) + ','			--//framos cambio aqui
									End									
									
								End

								Begin --> maestro.unidad_competencia 04

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 28)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G1)

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,4

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)												

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin										
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 28)) + ','			
									End									
									
								End
								Begin --> Resumen de Mensajes Validacion 

									IF @INDEX_TEMPORAL <> ''
									Begin
										--//Almacena en el index los valores que no fueron registrados
										SET @INDEX_NO_REGISTRADOS_UNIDAD_DE_COMPETENCIA_VACIO = @INDEX_NO_REGISTRADOS_UNIDAD_DE_COMPETENCIA_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' de la columna A se encuentra vacía.'+@MSG_INFO+'|';
									End

								End

							SET @INDEX_TEMPORAL = '';

							End
							
							Begin -->Validar vacíos e inválidos
									select @row_cod_uds_vacios = COALESCE(@row_cod_uds_vacios,'') + rowIndex + ',' from #tmp where  D ='' and 
									rowIndex BETWEEN @rowIndexIni_g1  and @rowIndexFin_g1 AND E<>'' --UDS con nombre UD pero códigos vacíos

									select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_g1  and @rowIndexFin_g1 and E<>''
							End

							Begin -->Validar repeticiones
									SET @rowIndex_tmp = @rowIndexIni_g1
									WHILE (@rowIndex_tmp <= @rowIndexFin_g1  )
									begin
									select @codEval = D from #tmp where rowIndex = @rowIndex_tmp

									set @rowindex_existe = (select top 1 rowIndex from #tmp where rowIndex < @rowIndex_tmp and D =@codEval and D <>''
									and D not like '%[^0-9]%' and LEN(D)<=@cod_ud_long_max and D > 0)
									if @rowindex_existe is not null
									set @row_repeticiones  = @row_repeticiones + convert(varchar(3),@rowIndex_tmp) + ','

									set @rowIndex_tmp = @rowIndex_tmp +1

									set @rowindex_existe =0
									end 
							End
							
							Begin -->Validar periodo académico válido (número entero)
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((G like '%[^0-9]%' or ISNUMERIC(G)=0 or G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR ((H like '%[^0-9]%' or ISNUMERIC(H)=0 OR H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR
										((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR ((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR
										((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'') OR ((L like '%[^0-9]%' or ISNUMERIC(L)=0 or L =0 OR LEN(L)>@horas_long_max) AND L<>'')	OR 
										((M like '%[^0-9]%' or ISNUMERIC(M)=0 or M =0 OR LEN(M)>@horas_long_max) AND M<>'') OR ((N like '%[^0-9]%' or ISNUMERIC(N)=0 or N =0 OR LEN(N)>@horas_long_max) AND N<>'')
									)	and 
									rowIndex BETWEEN @rowIndexIni_g1 and @rowIndexFin_g1 
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 

							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G <> '' THEN 1 ELSE 0 END) + (CASE WHEN H <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I <> ''THEN 1 ELSE 0 END) + (CASE WHEN J <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K <> ''THEN 1 ELSE 0 END) + (CASE WHEN L <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_g1 and @rowIndexFin_g1
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/
							Begin -->Validar que se haya consignado información de horas 
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G = '' THEN 1 ELSE 0 END) + (CASE WHEN H = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I = ''THEN 1 ELSE 0 END) + (CASE WHEN J = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K = ''THEN 1 ELSE 0 END) + (CASE WHEN L = ''THEN 1 ELSE 0 END) +
										   (CASE WHEN M = ''THEN 1 ELSE 0 END) + (CASE WHEN N = ''THEN 1 ELSE 0 END) 
										   = 8 ) 								
									AND rowIndex BETWEEN @rowIndexIni_g1 and @rowIndexFin_g1
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que NO se haya consignado más de un valor como información de horas 
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G <> '' THEN 1 ELSE 0 END) + (CASE WHEN H <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I <> ''THEN 1 ELSE 0 END) + (CASE WHEN J <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K <> ''THEN 1 ELSE 0 END) + (CASE WHEN L <> ''THEN 1 ELSE 0 END) +										   
										   (CASE WHEN M <> ''THEN 1 ELSE 0 END) + (CASE WHEN N <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_g1 and @rowIndexFin_g1
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End

							BEGIN -->Validar horas no vacías
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										O='' OR P=''	--ANTES M, N								
									)	and 
									rowIndex BETWEEN @rowIndexIni_g1 and @rowIndexFin_g1 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico, ','))
									and E<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '') -- para impedir comparación con nulo 
							End

							BEGIN -->Validar horas válidas (ENTERO)								
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((O like '%[^0-9]%' or ISNUMERIC(O)=0) AND O<>'')  OR ((P like '%[^0-9]%' or ISNUMERIC(P)=0 ) AND P<>'')		--AMTES M,N								
									)	and 
									rowIndex BETWEEN @rowIndexIni_g1 and @rowIndexFin_g1 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico, ','))
									and E<>''									
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') -- para impedir comparación con nulo 									
							End

							BEGIN -->Validar suma de horas O+P = Q, ANTES M+N = O
									SELECT @row_no_suma_igual_horas = COALESCE(@row_no_suma_igual_horas, '') + rowIndex + ',' FROM #tmp where  
									( (case when O<>'' then convert(int, O ) else 0 end)
									 +(case when P<>'' then convert(int, P ) else 0 end)
									 <> (case when Q<>'' then convert(int,Q) else 0 end))
									AND rowIndex
									BETWEEN @rowIndexIni_g1 AND @rowIndexFin_g1								
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ',' 
									+ @row_vacio_horas + ',' +@row_no_numerico_horas, ','))
									and E<>''	
									set @row_no_suma_igual_horas = ISNULL(@row_no_suma_igual_horas, '') 									
							End

							BEGIN -->Validar créditos no vacíos							
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (S='' OR T='' OR U='')	and --ANTES Q, R, S
									rowIndex BETWEEN @rowIndexIni_g1 and @rowIndexFin_g1 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ','
									+@row_vacio_horas + ',' +@row_no_numerico_horas +',' +@row_no_suma_igual_horas
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') 	
							End
													
							BEGIN -->Validar créditos válidos (numéricos), incluye decimal
							
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									(( ISNUMERIC(S)=0 AND S<>'')  OR (ISNUMERIC(T)=0 AND T<>'')	OR (ISNUMERIC(U)=0 AND U<>'')	--ANTES Q,R,S
									)
									and 
									rowIndex BETWEEN @rowIndexIni_g1 and @rowIndexFin_g1 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ','
									+@row_vacio_horas + ',' +@row_no_numerico_horas +','+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End							

						 --  BEGIN -->Validar suma de horas Q+R = S
							--		SELECT @row_no_suma_igual_creditos = COALESCE(@row_no_suma_igual_creditos, '') + rowIndex + ',' FROM #tmp where  									
							--		rowIndex
							--		BETWEEN @rowIndexIni_g1 AND @rowIndexFin_g1								
							--		AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
							--		+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ',' 
							--		+ @row_no_numerico_horas + ',' + @row_vacio_creditos+ ',' +@row_no_numerico_creditos +',' +@row_no_suma_igual_horas, ','))
							--		and E<>'' and
							--		( (case when Q<>'' then convert(decimal(5,1), Q ) else 0 end)
							--		 +(case when R<>'' then convert(decimal(5,1), R ) else 0 end)
							--		 <> (case when R<>'' then convert(decimal(5,1), S ) else 0 end))
									 
							--		 set @row_no_suma_igual_creditos = ISNULL(@row_no_suma_igual_creditos, '') 	
							--End

							Begin --> transaccional.unidad_didactica - GRUPO 1 
								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
								
									,ID_TIPO_UNIDAD_DIDACTICA
								
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION
								
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI								
									,PERIODO_ACADEMICO_VII
									,PERIODO_ACADEMICO_VIII

									,TEORICO_PRACTICO_HORAS_UD
									,PRACTICO_HORAS_UD
								
									,HORAS
								
									,TEORICO_PRACTICO_CREDITOS_UD
									,PRACTICO_CREDITOS_UD
								
									,CREDITOS
									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G1(ID_UNIDAD_DIDACTICA)								--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G1)										--//FRAMOS CAMBIAR AQUI			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 
										WHEN G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' AND L =  '' AND M = '' AND N='' THEN 0 --'ERROR'				
										WHEN 7 > ( CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END + CASE WHEN L = '' THEN 1 ELSE 0 END + CASE WHEN M = '' THEN 1 ELSE 0 END + CASE WHEN N = '' THEN 1 ELSE 0 END) THEN 0 --'ERROR'
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN L <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN M <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VII'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN N <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VIII'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									END	AS ID_SEMESTRE_ACADEMICO								
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,CASE
										--WHEN 1 = 1 THEN 1
										WHEN @NOMBRE_TIPO_UNIDAD_ESPECIFICA_EXCEL				= C THEN @ID_TIPO_UNIDAD_DIDACTICA_ESPECIFICA
										WHEN @NOMBRE_TIPO_UNIDAD_EMPLEABILIDAD_EXCEL			= C THEN @ID_TIPO_UNIDAD_DIDACTICA_EMPLEABILIDAD
										WHEN @NOMBRE_TIPO_UNIDAD_EXPERIENCIA_FORMATIVA_EXCEL	= C THEN @ID_TIPO_UNIDAD_DIDACTICA_EXPERIENCIA_FORMATIVA
										ELSE 0
									END AS ID_TIPO_UNIDAD_DIDACTICA
								
									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN 'ERROR' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
			
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN 'ERROR' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
								
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION																								
								
									--PERIODO_ACADEMICO_I
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_I
										
									--PERIODO_ACADEMICO_II
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_II
										
									--PERIODO_ACADEMICO_III
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_III
										
									--PERIODO_ACADEMICO_IV
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_IV
										
									--PERIODO_ACADEMICO_V
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_V
										
									--PERIODO_ACADEMICO_VI
									,CASE WHEN L <> '' THEN L END AS PERIODO_ACADEMICO_VI

									--PERIODO_ACADEMICO_VII --ADD
									,CASE WHEN M <> '' THEN M END AS PERIODO_ACADEMICO_VII

									--PERIODO_ACADEMICO_VIII --ADD
									,CASE WHEN N <> '' THEN N END AS PERIODO_ACADEMICO_VIII
								
									--TEORICO_PRACTICO_HORAS_UD
									,CASE WHEN O <> '' THEN O END AS TEORICO_PRACTICO_HORAS_UD
								
									--PRACTICO_HORAS_UD
									,CASE WHEN P <> '' THEN P END AS PRACTICO_HORAS_UD											

									--HORAS
									,CASE 
										WHEN G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' AND L =  '' AND M='' AND N='' THEN 0 --'ERROR'
										WHEN 7 > ( CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END + CASE WHEN L = '' THEN 1 ELSE 0 END + CASE WHEN M = '' THEN 1 ELSE 0 END  + CASE WHEN N = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN G <> '' THEN G
										WHEN H <> '' THEN H
										WHEN I <> '' THEN I
										WHEN J <> '' THEN J
										WHEN K <> '' THEN K
										WHEN L <> '' THEN L				
										WHEN M <> '' THEN M	--ADD
										WHEN N <> '' THEN N	--ADD
									END	AS HORAS
								
									---TEORICO_PRACTICO_CREDITOS_UD, ANTES Q
									, CASE WHEN S <> '' THEN convert(decimal(5,1),S) END AS TEORICO_PRACTICO_CREDITOS_UD

									--PRACTICO_CREDITOS_UD, ANTES R
									, CASE WHEN T <> '' THEN convert(decimal(5,1),T) END AS PRACTICO_CREDITOS_UD								

									--CREDITOS, ANTES Q,R
									,CASE 
										WHEN S = '' OR T = '' THEN 0	--'ERROR' 
										WHEN S <> '' AND T <> '' THEN convert(decimal(5,1),S) + convert(decimal(5,1),T)
									END AS CREDITOS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_g1 AND @rowIndexFin_g1 --RANGO DE FILAS DEL PRIMER BLOQUE																	--//FRAMOS CAMBIAR AQUI
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_repeticiones + ',' +@row_no_numerico_periodo_academico +',' +
													 @row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico+ ',' + @row_vacio_horas + ',' +@row_no_numerico_horas + ','  +
													 @row_vacio_creditos + ',' + @row_no_suma_igual_horas + ',' + @row_no_numerico_creditos +',' +
													 @row_no_suma_igual_creditos,','))													 													 
								and D <> ''
								and D NOT like '%[^0-9]%'and LEN(D)<=@cod_ud_long_max								
								ORDER BY CONVERT(INT, rowIndex) ASC
							
								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_g1 AND @rowIndexFin_g1 --RANGO DE FILAS DEL PRIMER BLOQUE								
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' + @MSG_INFO+'|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila: ' + rowIndex + ' registrada pero posiblemente con error.|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G1)
								AND tmp.rowIndex BETWEEN @rowIndexIni_g1 AND @rowIndexFin_g1 --RANGO DE FILAS DEL PRIMER BLOQUE

								--Fila no registrada por repeticiones	
								if @row_repeticiones <>''							
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO + 'Fila: ' + SUBSTRING (@row_repeticiones, 1, Len(@row_repeticiones) - 1 ) + ' no registradas(s) porque la columna D tiene valores repetidos.'+@MSG_ERROR+'|'

								--Fila no registrada por codigo de unidad didáctica vacía
								if @row_cod_uds_vacios <>''
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO + 'Fila: ' + SUBSTRING (@row_cod_uds_vacios, 1, Len(@row_cod_uds_vacios) - 1 ) + ' no registradas(s) porque la columna D se encuentra vacía.'+@MSG_ERROR+'|'

								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								/*--Fila no registra por valor no único de periodo académico 
								if @row_no_valor_unico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_valor_unico_periodo_academico, 1, Len(@row_no_valor_unico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene datos o no tiene un valor único.|'
								*/

								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
																
								--Fila no registra por columnas vacías de horas O, P , ANTES m,n
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).'+@MSG_ERROR+'|'	
							

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque en la sección Horas los datos de las columnas O y/o P no son valores enteros.'+@MSG_ERROR+'|'								
								--Fila no registra por M + N <> O
								if @row_no_suma_igual_horas<>''
								set @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS +  'Fila: ' + SUBSTRING (@row_no_suma_igual_horas, 1, Len(@row_no_suma_igual_horas) - 1 ) + ' no registradas(s) porque en la sección Horas la suma de los datos de las columnas O y P no es igual al dato de la columna Q.'+@MSG_ERROR+'|'								

								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+@MSG_ERROR+'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+@MSG_ERROR+'|'								

								--Fila no registra por S + T <> U , ANTES Q,R,S
								if @row_no_suma_igual_creditos <> ''
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_suma_igual_creditos, 1, Len(@row_no_suma_igual_creditos) - 1 ) + ' no registradas(s) porque en la sección Créditos la suma de los datos de las columnas S y T no es igual al dato de la columna U.'+@MSG_ERROR+'|'								
							End

							Begin --> transaccional.unidad_didactica_detalle - GRUPO 1 
								
								--SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO + 'Fila: ';	--//****
							
								DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR1 VARCHAR(50) = ''								
								DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO1 VARCHAR(50) = ''							
								SELECT ID_UNIDAD_DIDACTICA = ID_UNIDAD_DIDACTICA INTO #TempParaWhile01_G1 FROM @tblUnidadDidactica_NuevoIdRegistrado_G1						--//FRAMOS CAMBIAR AQUI								
								WHILE (SELECT COUNT(*) FROM #TempParaWhile01_G1) > 0																						--//FRAMOS CAMBIAR AQUI
								Begin								
									SELECT TOP 1 @ID_UNIDAD_DIDACTICA_TMP = ID_UNIDAD_DIDACTICA FROM #TempParaWhile01_G1													--//FRAMOS CAMBIAR AQUI
								
									Begin --> Proceso a Iterar 									
									
										SELECT --> Obtener unidades didacticas registradas 
										@CODIGO_PREDECESORA_EXCEL = F ,
										@ROW_INDEX_CODIGO_PREDECESORA_EXCEL = rowIndex
										FROM #tmp
										INNER JOIN transaccional.unidad_didactica ud on E = ud.NOMBRE_UNIDAD_DIDACTICA
										WHERE 1 = 1
										AND ud.ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA_TMP										
										AND rowIndex BETWEEN @rowIndexIni_g1 AND @rowIndexFin_g1																										--//FRAMOS CAMBIAR AQUI										
										ORDER BY CONVERT(INT, rowIndex) ASC
										--//										
										
										SET @VALIDAR_CODIGO_PREDECESORA_EXCEL = REPLACE(@CODIGO_PREDECESORA_EXCEL, @DELIMITADOR_CODIGO_PREDECESORA_EXCEL, '') --//Obtener los valores de codigo predecesora sin su delimitador										
																		
										IF @VALIDAR_CODIGO_PREDECESORA_EXCEL = ''
										Begin --> Validar si la celda esta vacía y no la registra 

											SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO1 = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO1 											
											+ CONVERT(VARCHAR,@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) 
											+ ', ' ;											

										End
									
										IF (@VALIDAR_CODIGO_PREDECESORA_EXCEL like '%[^0-9]%' or ISNUMERIC(@VALIDAR_CODIGO_PREDECESORA_EXCEL) = 0) AND LEN(@CODIGO_PREDECESORA_EXCEL) > 0
										Begin --> Validar si la celda tiene error y no la registra 

											SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR1 = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR1 											
											+ CONVERT(VARCHAR,@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) 
											+ ', ' ;	
																														
										End
																				
										Begin  --Validar si los códigos de las unidades predecesoras referenciadas existen. 
											if @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR1 = ''
											begin
												set @ID_SEMESTRE_ACADEMICO_TMP =(select ID_SEMESTRE_ACADEMICO from transaccional.unidad_didactica where ID_UNIDAD_DIDACTICA=@ID_UNIDAD_DIDACTICA_TMP)
											
												select @cont_predecesores_validos_ud = count (1) from transaccional.unidad_didactica tbl1
												inner join transaccional.modulo tbl2 on tbl1.ID_MODULO= tbl2.ID_MODULO AND tbl2.ES_ACTIVO=1
												where 
												tbl2.ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO AND 
												tbl1.ID_SEMESTRE_ACADEMICO< @ID_SEMESTRE_ACADEMICO_TMP and 
												tbl1.CODIGO_UNIDAD_DIDACTICA in (select SplitData from dbo.UFN_SPLIT (CONVERT(VARCHAR(10),@CODIGO_PREDECESORA_EXCEL),@DELIMITADOR_CODIGO_PREDECESORA_EXCEL))
												SET @cont_predecesores_validos_ud=ISNULL(@cont_predecesores_validos_ud,0)											
										
												if (@cont_predecesores_validos_ud<>(select count (1)from dbo.UFN_SPLIT (CONVERT(VARCHAR(10),@CODIGO_PREDECESORA_EXCEL),@DELIMITADOR_CODIGO_PREDECESORA_EXCEL)))
												BEGIN										
														set	@row_cod_uds_precedesores_no_existen = @row_cod_uds_precedesores_no_existen + convert(varchar(50),@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) + ',' ;
														set @VALIDAR_CODIGO_PREDECESORA_EXCEL=''
												END																																
											end
											
										End 										
																	
										IF(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR1='' and ISNUMERIC(@VALIDAR_CODIGO_PREDECESORA_EXCEL) = 1)
										Begin --> Validar si la celda contiene solo numeros fuera de los delimitadores 

												Begin --> Consultar funcion UFN_SPLIT, Iterar e ingresar datos. transaccional.unidad_didactica_detalle
													
														SELECT Id = SplitData INTO #TempParaWhile02_G1 																			--//FRAMOS CAMBIAR AQUI
														FROM dbo.UFN_SPLIT(@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL);	--//Utilizando la funcion para obtener valores		
													
														DECLARE @CODIGO_PREDECESORA_A_INSERTAR_G1 INT = 0;																		--//FRAMOS CAMBIAR AQUI 													
														WHILE (SELECT COUNT(*) FROM #TempParaWhile02_G1) > 0																	--//FRAMOS CAMBIAR AQUI
														Begin								
															SELECT TOP 1 @CODIGO_PREDECESORA_A_INSERTAR_G1 = Id FROM #TempParaWhile02_G1											--//FRAMOS CAMBIAR AQUI	2												

																Begin --> Proceso a Iterar: transaccional.unidad_didactica_detalle - GRUPO 1 

																	INSERT INTO transaccional.unidad_didactica_detalle
																	(
																		ID_UNIDAD_DIDACTICA
																		,CODIGO_PREDECESORA

																		,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION											
																	)
																	VALUES
																	(
																		--ID_UNIDAD_DIDACTICA
																		@ID_UNIDAD_DIDACTICA_TMP

																		--CODIGO_PREDECESORA
																		,@CODIGO_PREDECESORA_A_INSERTAR_G1																			--//FRAMOS CAMBIAR AQUI

																		,@ES_ACTIVO, @ESTADO, @USUARIO_CREACION, GETDATE()											
																	)													

																End														
							
															DELETE #TempParaWhile02_G1 WHERE Id = @CODIGO_PREDECESORA_A_INSERTAR_G1												--//FRAMOS CAMBIAR AQUI
														End
														DROP TABLE #TempParaWhile02_G1																							--//FRAMOS CAMBIAR AQUI											

												End									

										End									

									End
							
									DELETE #TempParaWhile01_G1 WHERE ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA_TMP															--//FRAMOS CAMBIAR AQUI
								End 

								IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO1 <> ''
								Begin									
									SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO = 'Fila: ' + SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO1, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO1) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F se encuentra vacía.'+@MSG_INFO+'|';	--//****
								End

								IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR1<>''
								Begin																		
									SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR = 'Fila: ' + SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR1, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR1) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene un formato inválido.'+@MSG_ERROR+'|';	--//****									
								End	
								
								if @row_cod_uds_precedesores_no_existen <> ''
								Begin
									set @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_NOEXISTE_NOVALIDO ='Fila: ' +   SUBSTRING (@row_cod_uds_precedesores_no_existen, 1, Len(@row_cod_uds_precedesores_no_existen) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene código(s) inválido(s).'+@MSG_ERROR+'|';	--//****									
								End					
							
								DROP TABLE #TempParaWhile01_G1																												--//FRAMOS CAMBIAR AQUI												

							End
						
						End
						ELSE
							Begin
								SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 8 hasta Fila 33 no registrada(s) porque no cuentan con Módulo Formativo, Total Horas o Total créditos U.D.'+@MSG_INFO+'|';
							End

					End --> FIN: GRUPO - 1


					Begin --> GRUPO - 2 

						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)
						--*
						FROM #tmp
						WHERE 1 = 1
						AND	B <> '' 						
						AND	E <> '' 						
						AND (R <> '' OR R <> 0) --ANTES P
						AND (V <> '' OR V <> 0)		--ANTES T				
						AND rowIndex BETWEEN @rowIndexIni_g2 AND @rowIndexIni_g2 --PRIMERA FILA DEL SEGUNDO BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos
					
							Begin --> transaccional.modulo - GRUPO 2 

								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								--//*****
								,TOTAL_HORAS_UD
								,TOTAL_CREDITOS_UD
								--//*****

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G2(ID_MODULO)													--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_g2																				--//FRAMOS CAMBIAR AQUI
									)

								
									--//*****
									,(--TOTAL_HORAS_UD		--ANTES P																								--//FRAMOS CAMBIAR AQUI
										SELECT R FROM #tmp WHERE rowIndex = @rowIndexIni_g2									
										)
								
									,(--TOTAL_CREDITOS_UD		 --ANTES T
										SELECT V FROM #tmp WHERE rowIndex = @rowIndexIni_g2																				--//FRAMOS CAMBIAR AQUI									
									)
									--//*****
																

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End
					
							Begin --> maestro.unidad_competencia GRUPO 2  

							SET @INDEX_TEMPORAL = '';

								Begin --> maestro.unidad_competencia 01	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = @rowIndexIni_g2)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G2)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,1

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																		
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = @rowIndexIni_g2)) + ','			--//framos cambio aqui
									End

								End

								Begin --> maestro.unidad_competencia 02	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 44)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G2)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,2

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																		
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 44)) + ','			--//framos cambio aqui
									End

								End																	

								Begin --> maestro.unidad_competencia 03	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 51)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G2)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,3

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)												

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																		
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 51)) + ','			--//framos cambio aqui
									End

								End

								Begin --> maestro.unidad_competencia 04	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 58)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G2)											

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,4

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)												

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																		
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 58)) + ','			
									End

								End

								Begin --> Resumen de Mensajes Validacion 

									IF @INDEX_TEMPORAL <> ''
									Begin
										--//Almacena en el index los valores que no fueron registrados
										SET @INDEX_NO_REGISTRADOS_UNIDAD_DE_COMPETENCIA_VACIO = @INDEX_NO_REGISTRADOS_UNIDAD_DE_COMPETENCIA_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' de la columna A se encuentra vacía.'+@MSG_INFO+'|';
									End

								End

							SET @INDEX_TEMPORAL = '';

							End

							Begin -->Validar vacíos e inválidos
									set @row_cod_uds_vacios =''
									select @row_cod_uds_vacios = COALESCE(@row_cod_uds_vacios,'') + rowIndex + ',' from #tmp where  D ='' and 
									rowIndex BETWEEN @rowIndexIni_g2  and @rowIndexFin_g2 AND E<>'' --UDS con nombre UD pero códigos vacíos

									set @row_cod_uds_invalidos =''
									select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_g2  and @rowIndexFin_g2 and E<>''
							End
							Begin -->Validar repeticiones
						
									set @row_repeticiones =''
									SET @rowIndex_tmp = @rowIndexIni_g2
									WHILE (@rowIndex_tmp <= @rowIndexFin_g2  )
									begin
									select @codEval = D from #tmp where rowIndex = @rowIndex_tmp

									set @rowindex_existe = (select top 1 rowIndex from #tmp where rowIndex < @rowIndex_tmp and D =@codEval and D <>''
									and D not like '%[^0-9]%' and LEN(D)<=@cod_ud_long_max and D > 0)
									if @rowindex_existe is not null
									set @row_repeticiones  = @row_repeticiones + convert(varchar(3),@rowIndex_tmp) + ','

									set @rowIndex_tmp = @rowIndex_tmp +1

									set @rowindex_existe =0
									end 
							End

							Begin -->Validar periodo académico válido (número entero)
									set @row_no_numerico_periodo_academico =''
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((G like '%[^0-9]%' or ISNUMERIC(G)=0 or G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR ((H like '%[^0-9]%' or ISNUMERIC(H)=0 OR H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR
										((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR ((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR
										((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'') OR ((L like '%[^0-9]%' or ISNUMERIC(L)=0 or L =0 OR LEN(L)>@horas_long_max) AND L<>'') OR
										((M like '%[^0-9]%' or ISNUMERIC(M)=0 or M =0 OR LEN(M)>@horas_long_max) AND M<>'') OR ((N like '%[^0-9]%' or ISNUMERIC(N)=0 or N =0 OR LEN(N)>@horas_long_max) AND N<>'')										
									)	and 
									rowIndex BETWEEN @rowIndexIni_g2 and @rowIndexFin_g2 
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 
							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									set @row_no_valor_unico_periodo_academico =''
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G <> '' THEN 1 ELSE 0 END) + (CASE WHEN H <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I <> ''THEN 1 ELSE 0 END) + (CASE WHEN J <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K <> ''THEN 1 ELSE 0 END) + (CASE WHEN L <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_g2 and @rowIndexFin_g2
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/

							Begin -->Validar que se haya consignado información de horas
									SET  @row_horas_vacias_periodo_academico =''
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G = '' THEN 1 ELSE 0 END) + (CASE WHEN H = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I = ''THEN 1 ELSE 0 END) + (CASE WHEN J = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K = ''THEN 1 ELSE 0 END) + (CASE WHEN L = ''THEN 1 ELSE 0 END) +
										   (CASE WHEN M = ''THEN 1 ELSE 0 END) + (CASE WHEN N = ''THEN 1 ELSE 0 END) 
										   = 8 ) 								
									AND rowIndex BETWEEN @rowIndexIni_g2 and @rowIndexFin_g2
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que NO se haya consignado más de un valor como información de horas 
									SET @row_horas_multiples_periodo_academico =''
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G <> '' THEN 1 ELSE 0 END) + (CASE WHEN H <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I <> ''THEN 1 ELSE 0 END) + (CASE WHEN J <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K <> ''THEN 1 ELSE 0 END) + (CASE WHEN L <> ''THEN 1 ELSE 0 END) +
										   (CASE WHEN M <> ''THEN 1 ELSE 0 END) + (CASE WHEN N <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_g2 and @rowIndexFin_g2
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End
							BEGIN -->Validar horas no vacías
								set @row_vacio_horas =''
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										O='' OR P=''	--ANTES M,N								
									)	and 
									rowIndex BETWEEN @rowIndexIni_g2 and @rowIndexFin_g2 
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' +@row_horas_multiples_periodo_academico , ','))
									and E<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '') -- para impedir comparación con nulo 
							End

							BEGIN -->Validar horas válidas (ENTERO)		
								set @row_no_numerico_horas =''						
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((O like '%[^0-9]%' or ISNUMERIC(O)=0) AND O<>'')  OR ((P like '%[^0-9]%' or ISNUMERIC(P)=0 ) AND P<>'')	--ANTES M,N									
									)	and 
									rowIndex BETWEEN @rowIndexIni_g2 and @rowIndexFin_g2 
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' +@row_horas_multiples_periodo_academico, ','))
									and E<>''									
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') -- para impedir comparación con nulo 									
							End

							BEGIN -->Validar suma de horas O+P = Q, ANTES M,N,O
									set @row_no_suma_igual_horas =''
									SELECT @row_no_suma_igual_horas = COALESCE(@row_no_suma_igual_horas, '') + rowIndex + ',' FROM #tmp where  
									( (case when O<>'' then convert(int, O ) else 0 end)
									 +(case when P<>'' then convert(int, P ) else 0 end)
									 <> (case when Q<>'' then convert(int,Q) else 0 end))
									AND rowIndex
									BETWEEN @rowIndexIni_g2 AND @rowIndexFin_g2
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' +@row_horas_multiples_periodo_academico + ',' 
									+ @row_vacio_horas + ',' +@row_no_numerico_horas, ','))
									and E<>''	
									set @row_no_suma_igual_horas = ISNULL(@row_no_suma_igual_horas, '') 									
							End

							
							BEGIN -->Validar créditos no vacíos	
								set @row_vacio_creditos=''						
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (S='' OR T='' OR U='')	and --ANTES Q, R, S
									rowIndex BETWEEN @rowIndexIni_g2 and @rowIndexFin_g2 
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' +@row_horas_multiples_periodo_academico + ','
									+@row_vacio_horas + ',' +@row_no_numerico_horas +',' +@row_no_suma_igual_horas
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') -- para impedir comparación con nulo 									
							End

							BEGIN -->Validar créditos válidos (numéricos), incluye decimal
								set @row_no_numerico_creditos =''
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									(( ISNUMERIC(S)=0 AND S<>'')  OR (ISNUMERIC(T)=0 AND T<>'')	OR (ISNUMERIC(U)=0 AND U<>'')	--ANTES Q,R,S
									)
									and 
									rowIndex BETWEEN @rowIndexIni_g2 and @rowIndexFin_g2 
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' +@row_horas_multiples_periodo_academico + ','
									+@row_vacio_horas + ',' +@row_no_numerico_horas +','+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End

							--BEGIN -->Validar suma de créditos Q+R = S
							--		set @row_no_suma_igual_creditos=''
							--		SELECT @row_no_suma_igual_creditos = COALESCE(@row_no_suma_igual_creditos, '') + rowIndex + ',' FROM #tmp where  									
							--		rowIndex
							--		BETWEEN @rowIndexIni_g2 AND @rowIndexFin_g2
							--		AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
							--		+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' +@row_horas_multiples_periodo_academico + ',' 
							--		+ @row_no_numerico_horas + ',' + @row_vacio_creditos+ ',' +@row_no_numerico_creditos +',' +@row_no_suma_igual_horas, ','))
							--		and E<>'' AND									
							--		( (case when Q<>'' then convert(decimal(5,1), Q ) else 0 end)
							--		 +(case when R<>'' then convert(decimal(5,1), R ) else 0 end)
							--		 <> (case when R<>'' then convert(decimal(5,1), S ) else 0 end))	
							--		set @row_no_suma_igual_creditos = ISNULL(@row_no_suma_igual_creditos, '') 									
							--End

							Begin --> transaccional.unidad_didactica - GRUPO 2 

								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
								
									,ID_TIPO_UNIDAD_DIDACTICA
								
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION
								
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI								
									,PERIODO_ACADEMICO_VII
									,PERIODO_ACADEMICO_VIII
								
									,TEORICO_PRACTICO_HORAS_UD
									,PRACTICO_HORAS_UD
								
									,HORAS
								
									,TEORICO_PRACTICO_CREDITOS_UD
									,PRACTICO_CREDITOS_UD
								
									,CREDITOS
									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G2(ID_UNIDAD_DIDACTICA)								--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G2)										--//FRAMOS CAMBIAR AQUI			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 
										WHEN G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' AND L =  '' AND M='' AND N='' THEN 0 --'ERROR'				
										WHEN 7 > ( CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END + CASE WHEN L = '' THEN 1 ELSE 0 END + CASE WHEN M = '' THEN 1 ELSE 0 END  + CASE WHEN N = '' THEN 1 ELSE 0 END ) THEN 0 --'ERROR'
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN L <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN M <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VII'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN N <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VIII'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									END	AS ID_SEMESTRE_ACADEMICO								
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,CASE
										--WHEN 1 = 1 THEN 1
										WHEN @NOMBRE_TIPO_UNIDAD_ESPECIFICA_EXCEL				= C THEN @ID_TIPO_UNIDAD_DIDACTICA_ESPECIFICA
										WHEN @NOMBRE_TIPO_UNIDAD_EMPLEABILIDAD_EXCEL			= C THEN @ID_TIPO_UNIDAD_DIDACTICA_EMPLEABILIDAD
										WHEN @NOMBRE_TIPO_UNIDAD_EXPERIENCIA_FORMATIVA_EXCEL	= C THEN @ID_TIPO_UNIDAD_DIDACTICA_EXPERIENCIA_FORMATIVA
										ELSE 0
									END AS ID_TIPO_UNIDAD_DIDACTICA
								
									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN 'ERROR' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
			
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN 'ERROR' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
								
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION																								
								
									--PERIODO_ACADEMICO_I
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_I
										
									--PERIODO_ACADEMICO_II
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_II
										
									--PERIODO_ACADEMICO_III
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_III
										
									--PERIODO_ACADEMICO_IV
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_IV
										
									--PERIODO_ACADEMICO_V
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_V
										
									--PERIODO_ACADEMICO_VI
									,CASE WHEN L <> '' THEN L END AS PERIODO_ACADEMICO_VI

									--PERIODO_ACADEMICO_VII --ADD
									,CASE WHEN M <> '' THEN M END AS PERIODO_ACADEMICO_VII

									--PERIODO_ACADEMICO_VIII --ADD
									,CASE WHEN N <> '' THEN N END AS PERIODO_ACADEMICO_VIII
								
									--TEORICO_PRACTICO_HORAS_UD --ANTES M
									,CASE WHEN O <> '' THEN O END AS TEORICO_PRACTICO_HORAS_UD
								
									--PRACTICO_HORAS_UD --ANTES N
									,CASE WHEN P <> '' THEN P END AS PRACTICO_HORAS_UD											

									--HORAS
									,CASE 
										WHEN G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' AND L =  '' AND M='' AND N='' THEN 0 --'ERROR'
										WHEN 7 > ( CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END + CASE WHEN L = '' THEN 1 ELSE 0 END + CASE WHEN M = '' THEN 1 ELSE 0 END + CASE WHEN N = '' THEN 1 ELSE 0 END) THEN 0 --'ERROR'
										WHEN G <> '' THEN G
										WHEN H <> '' THEN H
										WHEN I <> '' THEN I
										WHEN J <> '' THEN J
										WHEN K <> '' THEN K
										WHEN L <> '' THEN L				
										WHEN M <> '' THEN M --ADD
										WHEN N <> '' THEN N	--ADD
									END	AS HORAS
								
									---TEORICO_PRACTICO_CREDITOS_UD, ANTES Q
									,CASE WHEN S <> '' THEN convert(decimal(5,1),S) END AS TEORICO_PRACTICO_CREDITOS_UD

									--PRACTICO_CREDITOS_UD, ANTES R
									,CASE WHEN T <> '' THEN convert(decimal(5,1),T) END AS PRACTICO_CREDITOS_UD								

									--CREDITOS
									,CASE 
										WHEN S = '' OR T = '' THEN 0	--'ERROR' , ANTES Q,R
										WHEN S <> '' AND T <> '' THEN convert(decimal(5,1),S) + convert(decimal(5,1),T)
									END AS CREDITOS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_g2 AND @rowIndexFin_g2 --RANGO DE FILAS DEL SEGUNDO BLOQUE																	--//FRAMOS CAMBIAR AQUI
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_repeticiones + ',' +@row_no_numerico_periodo_academico +',' +
													 @row_horas_vacias_periodo_academico + ',' +@row_horas_multiples_periodo_academico+ ',' + @row_vacio_horas + ',' +@row_no_numerico_horas + ','  +
													 @row_vacio_creditos + ',' + @row_no_suma_igual_horas + ',' + @row_no_numerico_creditos +',' +
													 @row_no_suma_igual_creditos,','))
								and D <> ''
								and D NOT like '%[^0-9]%'and LEN(D)<=@cod_ud_long_max
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_g2 AND @rowIndexFin_g2 --RANGO DE FILAS DEL SEGUNDO BLOQUE
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' +@MSG_INFO +'|'
								END

								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila: ' + rowIndex + ' registrada pero posiblemente con error.|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 2' FROM @tblModulo_NuevoIdRegistrado_G2)
								AND tmp.rowIndex BETWEEN @rowIndexIni_g2 AND @rowIndexFin_g2 --RANGO DE FILAS DEL SEGUNDO BLOQUE		

								--Fila no registrada por repeticiones	
								if @row_repeticiones <>''							
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO + 'Fila: ' + SUBSTRING (@row_repeticiones, 1, Len(@row_repeticiones) - 1 ) + ' no registradas(s) porque la columna D tiene valores repetidos.'+@MSG_ERROR+'|'

								--Fila no registrada por codigo de unidad didáctica vacía
								if @row_cod_uds_vacios <>''
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO + 'Fila: ' + SUBSTRING (@row_cod_uds_vacios, 1, Len(@row_cod_uds_vacios) - 1 ) + ' no registradas(s) porque la columna D se encuentra vacía.'+@MSG_ERROR+'|'

								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								/*--Fila no registra por valor no único de periodo académico 
								if @row_no_valor_unico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_valor_unico_periodo_academico, 1, Len(@row_no_valor_unico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene datos o no tiene un valor único.|'
								*/
								
								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
								
								--Fila no registra por columnas vacías de horas O,P , ANTES m,n
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).'+@MSG_ERROR+'|'	
							

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque en la sección Horas los datos de las columnas O y/o P no son valores enteros.'+@MSG_ERROR+'|'								
								--Fila no registra por O + P <> Q --ANTES M,N,O
								if @row_no_suma_igual_horas<>''
								set @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS +  'Fila: ' + SUBSTRING (@row_no_suma_igual_horas, 1, Len(@row_no_suma_igual_horas) - 1 ) + ' no registradas(s) porque en la sección Horas la suma de los datos de las columnas O y P no es igual al dato de la columna Q.'+@MSG_ERROR+'|'								

								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+@MSG_ERROR+'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+@MSG_ERROR+'|'								

								--Fila no registra por S + T <> U, ANTES Q,R,S
								if @row_no_suma_igual_creditos <> ''
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_suma_igual_creditos, 1, Len(@row_no_suma_igual_creditos) - 1 ) + ' no registradas(s) porque en la sección Créditos la suma de los datos de las columnas S y T no es igual al dato de la columna U.'+@MSG_ERROR+'|'								
							End

							Begin --> transaccional.unidad_didactica_detalle - GRUPO 2 

								--SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO + 'Fila: ';	--//****
								DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2 VARCHAR(50) =''		
								DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO2 VARCHAR(50)=''
								SET @row_cod_uds_precedesores_no_existen =''						

								SELECT ID_UNIDAD_DIDACTICA = ID_UNIDAD_DIDACTICA INTO #TempParaWhile01_G2 FROM @tblUnidadDidactica_NuevoIdRegistrado_G2						--//FRAMOS CAMBIAR AQUI
								WHILE (SELECT COUNT(*) FROM #TempParaWhile01_G2) > 0																						--//FRAMOS CAMBIAR AQUI
								Begin								
									SELECT TOP 1 @ID_UNIDAD_DIDACTICA_TMP = ID_UNIDAD_DIDACTICA FROM #TempParaWhile01_G2													--//FRAMOS CAMBIAR AQUI

									Begin --> Proceso a Iterar 									
									
										SELECT --> Obtener unidades didacticas registradas 
										@CODIGO_PREDECESORA_EXCEL = F,
										@ROW_INDEX_CODIGO_PREDECESORA_EXCEL = rowIndex
										FROM #tmp
										INNER JOIN transaccional.unidad_didactica ud on E = ud.NOMBRE_UNIDAD_DIDACTICA
										WHERE 1 = 1
										AND ud.ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA_TMP										
										AND rowIndex BETWEEN 32 AND 51																										--//FRAMOS CAMBIAR AQUI
										ORDER BY CONVERT(INT, rowIndex) ASC
										--//										
									
										SET @VALIDAR_CODIGO_PREDECESORA_EXCEL = REPLACE(@CODIGO_PREDECESORA_EXCEL, @DELIMITADOR_CODIGO_PREDECESORA_EXCEL, '') --//Obtener los valores de codigo predecesora sin su delimitador
																		
										IF @VALIDAR_CODIGO_PREDECESORA_EXCEL = ''
										Begin --> Validar si la celda esta vacía y no la registra 

											SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO2 = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO2 											
											+ CONVERT(VARCHAR,@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) 
											+ ', ' ;											

										End
									
										IF (@VALIDAR_CODIGO_PREDECESORA_EXCEL like '%[^0-9]%' or ISNUMERIC(@VALIDAR_CODIGO_PREDECESORA_EXCEL) = 0) AND LEN(@CODIGO_PREDECESORA_EXCEL) > 0
										Begin --> Validar si la celda tiene error y no la registra 

											SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2 = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2 											
											+ CONVERT(VARCHAR,@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) 
											+ ', ' ;											

										End

										Begin  --Validar si los códigos de las unidades predecesoras referenciadas existen. 
											if @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2 =''
											begin
												set @ID_SEMESTRE_ACADEMICO_TMP =(select ID_SEMESTRE_ACADEMICO from transaccional.unidad_didactica where ID_UNIDAD_DIDACTICA=@ID_UNIDAD_DIDACTICA_TMP)
												SET @cont_predecesores_validos_ud = 0
											
												select @cont_predecesores_validos_ud = count (1) from transaccional.unidad_didactica tbl1
												inner join transaccional.modulo tbl2 on tbl1.ID_MODULO= tbl2.ID_MODULO AND tbl2.ES_ACTIVO=1
												where 
												tbl2.ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO AND 
												tbl1.ID_SEMESTRE_ACADEMICO< @ID_SEMESTRE_ACADEMICO_TMP and 
												tbl1.CODIGO_UNIDAD_DIDACTICA in (select SplitData from dbo.UFN_SPLIT (@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL))
												SET @cont_predecesores_validos_ud=ISNULL(@cont_predecesores_validos_ud,0)	
																														
												if (@cont_predecesores_validos_ud<> (select count (1)from dbo.UFN_SPLIT (@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL)))
												BEGIN
														set	@row_cod_uds_precedesores_no_existen = @row_cod_uds_precedesores_no_existen + convert(varchar(50),@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) + ', ' ;
														set @VALIDAR_CODIGO_PREDECESORA_EXCEL=''
												END
											end
											
										End 


										IF(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2='' and ISNUMERIC(@VALIDAR_CODIGO_PREDECESORA_EXCEL) = 1)
										Begin --> Validar si la celda contiene solo numeros fuera de los delimitadores 

												Begin --> Consultar funcion UFN_SPLIT, Iterar e ingresar datos. transaccional.unidad_didactica_detalle
													
														SELECT Id = SplitData INTO #TempParaWhile02_G2 																			--//FRAMOS CAMBIAR AQUI
														FROM dbo.UFN_SPLIT(@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL);	--//Utilizando la funcion para obtener valores		
													
														DECLARE @CODIGO_PREDECESORA_A_INSERTAR_G2 INT = 0;																		--//FRAMOS CAMBIAR AQUI 													
														WHILE (SELECT COUNT(*) FROM #TempParaWhile02_G2) > 0																	--//FRAMOS CAMBIAR AQUI
														Begin								
															SELECT TOP 1 @CODIGO_PREDECESORA_A_INSERTAR_G2 = Id FROM #TempParaWhile02_G2											--//FRAMOS CAMBIAR AQUI	2												

																Begin --> Proceso a Iterar: transaccional.unidad_didactica_detalle - GRUPO 2 

																	INSERT INTO transaccional.unidad_didactica_detalle
																	(
																		ID_UNIDAD_DIDACTICA
																		,CODIGO_PREDECESORA

																		,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION											
																	)
																	VALUES
																	(
																		--ID_UNIDAD_DIDACTICA
																		@ID_UNIDAD_DIDACTICA_TMP

																		--CODIGO_PREDECESORA
																		,@CODIGO_PREDECESORA_A_INSERTAR_G2																			--//FRAMOS CAMBIAR AQUI

																		,@ES_ACTIVO, @ESTADO, @USUARIO_CREACION, GETDATE()											
																	)													

																End														
							
															DELETE #TempParaWhile02_G2 WHERE Id = @CODIGO_PREDECESORA_A_INSERTAR_G2												--//FRAMOS CAMBIAR AQUI
														End
														DROP TABLE #TempParaWhile02_G2																							--//FRAMOS CAMBIAR AQUI											

												End									

										End									

									End
							
									DELETE #TempParaWhile01_G2 WHERE ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA_TMP															--//FRAMOS CAMBIAR AQUI
								End															

								IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO2 <> ''
								Begin
									SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO + 'Fila: ' + SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO2, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO2) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F se encuentra vacía.'+@MSG_INFO+'|';	--//****
								End
									
								IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2 <> ''
								BEGIN
									IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR=''
										SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR = 'Fila: '+  SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene un formato inválido.'+@MSG_ERROR+'|';	--//****
									ELSE
										SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR+ ' Fila: '+  SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR2) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene un formato inválido.'+@MSG_ERROR+'|';	--//****
								END			
								
								if @row_cod_uds_precedesores_no_existen <> ''
								Begin
									set @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_NOEXISTE_NOVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_NOEXISTE_NOVALIDO + 'Fila: ' +   SUBSTRING (@row_cod_uds_precedesores_no_existen, 1, Len(@row_cod_uds_precedesores_no_existen) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene código(s) inválido(s).'+@MSG_ERROR+'|';	--//****									
								End					

								DROP TABLE #TempParaWhile01_G2																												--//FRAMOS CAMBIAR AQUI												

							End

						End
						ELSE
							Begin
								SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 38 hasta Fila 63 no registrada(s) porque no cuentan con Módulo Formativo, Total Horas o Total créditos U.D.'+@MSG_INFO+'|';
							End

					End --> FIN: GRUPO - 2 


					Begin --> GRUPO - 3 

						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)
						--*
						FROM #tmp
						WHERE 1 = 1
						AND	B <> '' 						
						AND	E <> '' 						
						AND (R <> '' OR R <> 0) --ANTES P
						AND (V <> '' OR V <> 0)		--ANTES T				
						AND rowIndex BETWEEN @rowIndexIni_g3 AND @rowIndexIni_g3 --PRIMERA FILA DEL TERCER BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos

							Begin --> transaccional.modulo - GRUPO 3 
												
								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								--//*****
								,TOTAL_HORAS_UD
								,TOTAL_CREDITOS_UD
								--//*****

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G3(ID_MODULO)													--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_g3																				--//FRAMOS CAMBIAR AQUI
									)

								
									--//*****
									,(--TOTAL_HORAS_UD, ANTES P																								--//FRAMOS CAMBIAR AQUI
										SELECT R FROM #tmp WHERE rowIndex = @rowIndexIni_g3									
										)
								
									,(--TOTAL_CREDITOS_UD		 --ANTES T
										SELECT V FROM #tmp WHERE rowIndex = @rowIndexIni_g3																				--//FRAMOS CAMBIAR AQUI									
									)
									--//*****
																

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End
							
							Begin --> maestro.unidad_competencia GRUPO 3  

							SET @INDEX_TEMPORAL = '';

								Begin --> maestro.unidad_competencia 01	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = @rowIndexIni_g3)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G3)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,1

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)												

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																			
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = @rowIndexIni_g3)) + ','			--//framos cambio aqui
									End

								End

								Begin --> maestro.unidad_competencia 02	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 74)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G3)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,2

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)												

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																			
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 74)) + ','			--//framos cambio aqui
									End

								End																	

								Begin --> maestro.unidad_competencia 03	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 81)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G3)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,3

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																		
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 81)) + ','			--//framos cambio aqui
									End

								End

								Begin --> maestro.unidad_competencia 04

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 88)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G3)											

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,4

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																		
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 88)) + ','			
									End

								End

								Begin --> Resumen de Mensajes Validacion 

									IF @INDEX_TEMPORAL <> ''
									Begin
										--//Almacena en el index los valores que no fueron registrados
										SET @INDEX_NO_REGISTRADOS_UNIDAD_DE_COMPETENCIA_VACIO = @INDEX_NO_REGISTRADOS_UNIDAD_DE_COMPETENCIA_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' de la columna A se encuentra vacía.'+@MSG_INFO+'|';
									End

								End
								
							SET @INDEX_TEMPORAL = '';

							End

							Begin -->Validar vacíos e inválidos
									set @row_cod_uds_vacios =''
									select @row_cod_uds_vacios = COALESCE(@row_cod_uds_vacios,'') + rowIndex + ',' from #tmp where  D ='' and 
									rowIndex BETWEEN @rowIndexIni_g3  and @rowIndexFin_g3 AND E<>'' --UDS con nombre UD pero códigos vacíos

									set @row_cod_uds_invalidos =''
									select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_g3  and @rowIndexFin_g3 and E<>''
							End
							
							Begin -->Validar repeticiones
						
									set @row_repeticiones =''
									SET @rowIndex_tmp = @rowIndexIni_g3
									WHILE (@rowIndex_tmp <= @rowIndexFin_g3  )
									begin
									select @codEval = D from #tmp where rowIndex = @rowIndex_tmp

									set @rowindex_existe = (select top 1 rowIndex from #tmp where rowIndex < @rowIndex_tmp and D =@codEval and D <>''
									and D not like '%[^0-9]%' and LEN(D)<=@cod_ud_long_max and D > 0)
									if @rowindex_existe is not null
									set @row_repeticiones  = @row_repeticiones + convert(varchar(3),@rowIndex_tmp) + ','

									set @rowIndex_tmp = @rowIndex_tmp +1

									set @rowindex_existe =0
									end 
							End

							Begin -->Validar periodo académico válido (número entero)
									set @row_no_numerico_periodo_academico =''
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((G like '%[^0-9]%' or ISNUMERIC(G)=0 or G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR ((H like '%[^0-9]%' or ISNUMERIC(H)=0 OR H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR
										((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR ((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR
										((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'') OR ((L like '%[^0-9]%' or ISNUMERIC(L)=0 or L =0 OR LEN(L)>@horas_long_max) AND L<>'') OR
										((M like '%[^0-9]%' or ISNUMERIC(M)=0 or M =0 OR LEN(M)>@horas_long_max) AND M<>'') OR ((N like '%[^0-9]%' or ISNUMERIC(N)=0 or N =0 OR LEN(N)>@horas_long_max) AND N<>'')
									)	and 
									rowIndex BETWEEN @rowIndexIni_g3 and @rowIndexFin_g3 
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 
							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									set @row_no_valor_unico_periodo_academico =''
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G <> '' THEN 1 ELSE 0 END) + (CASE WHEN H <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I <> ''THEN 1 ELSE 0 END) + (CASE WHEN J <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K <> ''THEN 1 ELSE 0 END) + (CASE WHEN L <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_g3 and @rowIndexFin_g3
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/

							Begin -->Validar que se haya consignado información de horas
									SET  @row_horas_vacias_periodo_academico =''
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G = '' THEN 1 ELSE 0 END) + (CASE WHEN H = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I = ''THEN 1 ELSE 0 END) + (CASE WHEN J = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K = ''THEN 1 ELSE 0 END) + (CASE WHEN L = ''THEN 1 ELSE 0 END) +
										   (CASE WHEN M = ''THEN 1 ELSE 0 END) + (CASE WHEN N = ''THEN 1 ELSE 0 END) 
										   = 8 ) 								
									AND rowIndex BETWEEN @rowIndexIni_g3 and @rowIndexFin_g3
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que NO se haya consignado más de un valor como información de horas 
									SET @row_horas_multiples_periodo_academico =''
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G <> '' THEN 1 ELSE 0 END) + (CASE WHEN H <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I <> ''THEN 1 ELSE 0 END) + (CASE WHEN J <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K <> ''THEN 1 ELSE 0 END) + (CASE WHEN L <> ''THEN 1 ELSE 0 END) +
										   (CASE WHEN M <> ''THEN 1 ELSE 0 END) + (CASE WHEN N <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_g3 and @rowIndexFin_g3
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End
							BEGIN -->Validar horas no vacías
								set @row_vacio_horas =''
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										O='' OR P=''--ANTES M,N									
									)	and 
									rowIndex BETWEEN @rowIndexIni_g3 and @rowIndexFin_g3 
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico, ','))
									and E<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '') -- para impedir comparación con nulo 
							End
							BEGIN -->Validar horas válidas (ENTERO)	
								set @row_no_numerico_horas =''							
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((O like '%[^0-9]%' or ISNUMERIC(O)=0) AND O<>'')  OR ((P like '%[^0-9]%' or ISNUMERIC(P)=0 ) AND P<>'')	--ANTES M,N									
									)	and 
									rowIndex BETWEEN @rowIndexIni_g3 and @rowIndexFin_g3 
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico, ','))
									and E<>''									
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') -- para impedir comparación con nulo 									
							End

							BEGIN -->Validar suma de horas O+P = Q, ANTES M,N,O
									set @row_no_suma_igual_horas=''
									SELECT @row_no_suma_igual_horas = COALESCE(@row_no_suma_igual_horas, '') + rowIndex + ',' FROM #tmp where  
									( (case when O<>'' then convert(int, O ) else 0 end)
									 +(case when P<>'' then convert(int, P ) else 0 end)
									 <> (case when Q<>'' then convert(int,Q) else 0 end))
									AND rowIndex
									BETWEEN @rowIndexIni_g3 AND @rowIndexFin_g3								
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ',' 
									+ @row_vacio_horas + ',' +@row_no_numerico_horas, ','))
									and E<>''	
									set @row_no_suma_igual_horas = ISNULL(@row_no_suma_igual_horas, '') 									
							End

							BEGIN -->Validar créditos no vacíos		
								set @row_vacio_creditos	=''
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (S='' OR T='' OR U='')	and --ANTES Q,R,S
									rowIndex BETWEEN @rowIndexIni_g3 and @rowIndexFin_g3 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ','
									+@row_vacio_horas + ',' +@row_no_numerico_horas +',' +@row_no_suma_igual_horas
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') -- para impedir comparación con nulo 									
							End

							BEGIN -->Validar créditos válidos (numéricos), incluye decimal
								set @row_no_numerico_creditos =''				
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									(( ISNUMERIC(S)=0 AND S<>'')  OR (ISNUMERIC(T)=0 AND T<>'')	OR (ISNUMERIC(U)=0 AND U<>'')	--ANTES Q,R,S
									)
									and 
									rowIndex BETWEEN @rowIndexIni_g3 and @rowIndexFin_g3 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ','
									+@row_vacio_horas + ',' +@row_no_numerico_horas +','+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End
							--BEGIN -->Validar suma de horas Q+R = S
							--	set @row_no_suma_igual_creditos=''
							--		SELECT @row_no_suma_igual_creditos = COALESCE(@row_no_suma_igual_creditos, '') + rowIndex + ',' FROM #tmp where  									
							--		rowIndex
							--		BETWEEN @rowIndexIni_g3 AND @rowIndexFin_g3
							--		AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
							--		+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ',' 
							--		+ @row_no_numerico_horas + ',' + @row_vacio_creditos+ ',' +@row_no_numerico_creditos +',' +@row_no_suma_igual_horas, ','))
							--		and E<>'' AND
							--		( (case when Q<>'' then convert(decimal(5,1), Q ) else 0 end)
							--		 +(case when R<>'' then convert(decimal(5,1), R ) else 0 end)
							--		 <> (case when R<>'' then convert(decimal(5,1), S ) else 0 end))
							--		set @row_no_suma_igual_creditos = ISNULL(@row_no_suma_igual_creditos, '') 									
							--End

							Begin --> transaccional.unidad_didactica - GRUPO 3 

								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
								
									,ID_TIPO_UNIDAD_DIDACTICA
								
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION
								
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI	
									,PERIODO_ACADEMICO_VII
									,PERIODO_ACADEMICO_VIII							
								
									,TEORICO_PRACTICO_HORAS_UD
									,PRACTICO_HORAS_UD
								
									,HORAS
								
									,TEORICO_PRACTICO_CREDITOS_UD
									,PRACTICO_CREDITOS_UD
								
									,CREDITOS
									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G3(ID_UNIDAD_DIDACTICA)								--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G3)										--//FRAMOS CAMBIAR AQUI			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 
										WHEN G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' AND L =  '' AND M='' AND N='' THEN 0 --'ERROR'				
										WHEN 7 > ( CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END + CASE WHEN L = '' THEN 1 ELSE 0 END  + CASE WHEN M = '' THEN 1 ELSE 0 END + CASE WHEN N = '' THEN 1 ELSE 0 END  ) THEN 0 --'ERROR'
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN L <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN M <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VII'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN N <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VIII'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									END	AS ID_SEMESTRE_ACADEMICO								
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,CASE
										--WHEN 1 = 1 THEN 1
										WHEN @NOMBRE_TIPO_UNIDAD_ESPECIFICA_EXCEL				= C THEN @ID_TIPO_UNIDAD_DIDACTICA_ESPECIFICA
										WHEN @NOMBRE_TIPO_UNIDAD_EMPLEABILIDAD_EXCEL			= C THEN @ID_TIPO_UNIDAD_DIDACTICA_EMPLEABILIDAD
										WHEN @NOMBRE_TIPO_UNIDAD_EXPERIENCIA_FORMATIVA_EXCEL	= C THEN @ID_TIPO_UNIDAD_DIDACTICA_EXPERIENCIA_FORMATIVA
										ELSE 0
									END AS ID_TIPO_UNIDAD_DIDACTICA
								
									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN 'ERROR' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
			
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN 'ERROR' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
								
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION																								
								
									--PERIODO_ACADEMICO_I
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_I
										
									--PERIODO_ACADEMICO_II
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_II
										
									--PERIODO_ACADEMICO_III
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_III
										
									--PERIODO_ACADEMICO_IV
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_IV
										
									--PERIODO_ACADEMICO_V
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_V
										
									--PERIODO_ACADEMICO_VI
									,CASE WHEN L <> '' THEN L END AS PERIODO_ACADEMICO_VI

									--PERIODO_ACADEMICO_VII --ADD
									,CASE WHEN M <> '' THEN M END AS PERIODO_ACADEMICO_VII

									--PERIODO_ACADEMICO_VIII --ADD
									,CASE WHEN N <> '' THEN N END AS PERIODO_ACADEMICO_VIII
								
									--TEORICO_PRACTICO_HORAS_UD
									,CASE WHEN O <> '' THEN O END AS TEORICO_PRACTICO_HORAS_UD
								
									--PRACTICO_HORAS_UD
									,CASE WHEN P <> '' THEN P END AS PRACTICO_HORAS_UD											

									--HORAS
									,CASE 
										WHEN G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' AND L =  '' AND M='' AND N='' THEN 0 --'ERROR'
										WHEN 7 > ( CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END + CASE WHEN L = '' THEN 1 ELSE 0 END + CASE WHEN M = '' THEN 1 ELSE 0 END + CASE WHEN N = '' THEN 1 ELSE 0 END) THEN 0 --'ERROR'
										WHEN G <> '' THEN G
										WHEN H <> '' THEN H
										WHEN I <> '' THEN I
										WHEN J <> '' THEN J
										WHEN K <> '' THEN K
										WHEN L <> '' THEN L				
										WHEN M <> '' THEN M	--ADD
										WHEN N <> '' THEN N	--ADD
									END	AS HORAS
								
									---TEORICO_PRACTICO_CREDITOS_UD  --ANTES Q
									, CASE WHEN S <> '' THEN convert(decimal(5,1),S) END AS TEORICO_PRACTICO_CREDITOS_UD

									--PRACTICO_CREDITOS_UD --ANTES R
									, CASE WHEN T <> '' THEN convert(decimal(5,1),T) END AS PRACTICO_CREDITOS_UD								

									--CREDITOS
									,CASE 
										WHEN S = '' OR T = '' THEN 0	--'ERROR' --ANTES Q,R
										WHEN S <> '' AND T<> '' THEN convert(decimal(5,1),S) + convert(decimal(5,1),T)
									END AS CREDITOS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_g3 AND @rowIndexFin_g3 --RANGO DE FILAS DEL TERCER BLOQUE																	--//FRAMOS CAMBIAR AQUI								
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_repeticiones + ',' +@row_no_numerico_periodo_academico +',' +
													 @row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico+ ',' + @row_vacio_horas + ',' +@row_no_numerico_horas + ','  +
													 @row_vacio_creditos + ',' + @row_no_suma_igual_horas + ',' + @row_no_numerico_creditos +',' +
													 @row_no_suma_igual_creditos,','))	
								and D <> ''
								and D NOT like '%[^0-9]%'and LEN(D)<=@cod_ud_long_max
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_g3 AND @rowIndexFin_g3 --RANGO DE FILAS DEL TERCER BLOQUE
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' +@MSG_INFO + '|'
								END
		
								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila: ' + rowIndex + ' registrada pero posiblemente con error.|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 3' FROM @tblModulo_NuevoIdRegistrado_G3)
								AND tmp.rowIndex BETWEEN @rowIndexIni_g3 AND @rowIndexFin_g3 --RANGO DE FILAS DEL TERCER BLOQUE	

								--Fila no registrada por repeticiones	
								if @row_repeticiones <>''							
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO + 'Fila: ' + SUBSTRING (@row_repeticiones, 1, Len(@row_repeticiones) - 1 ) + ' no registradas(s) porque la columna D tiene valores repetidos.'+@MSG_ERROR+'|'

								--Fila no registrada por codigo de unidad didáctica vacía
								if @row_cod_uds_vacios <>''
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO + 'Fila: ' + SUBSTRING (@row_cod_uds_vacios, 1, Len(@row_cod_uds_vacios) - 1 ) + ' no registradas(s) porque la columna D se encuentra vacía.'+@MSG_ERROR+'|'

								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								/*--Fila no registra por valor no único de periodo académico 
								if @row_no_valor_unico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_valor_unico_periodo_academico, 1, Len(@row_no_valor_unico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene datos o no tiene un valor único.|'*/
								
								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
								
								--Fila no registra por columnas vacías de horas O,P--ANTES m,n
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).'+@MSG_ERROR+'|'	
							

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque en la sección Horas los datos de las columnas O y/o P no son valores enteros.'+@MSG_ERROR+'|'								

								--Fila no registra por O + P <> Q, ANTES M,N,O
								if @row_no_suma_igual_horas<>''
								set @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS +  'Fila: ' + SUBSTRING (@row_no_suma_igual_horas, 1, Len(@row_no_suma_igual_horas) - 1 ) + ' no registradas(s) porque en la sección Horas la suma de los datos de las columnas O y P no es igual al dato de la columna Q.'+  @MSG_ERROR +'|'								

								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+  @MSG_ERROR +'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+  @MSG_ERROR +'|'								

								--Fila no registra por S + T <> U, ANTES Q,R,S
								if @row_no_suma_igual_creditos <> ''
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_suma_igual_creditos, 1, Len(@row_no_suma_igual_creditos) - 1 ) + ' no registradas(s) porque en la sección Créditos la suma de los datos de las columnas S y T no es igual al dato de la columna U.'+  @MSG_ERROR +'|'								
							End					

							Begin --> transaccional.unidad_didactica_detalle - GRUPO 3 

								--SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO + 'Fila: ';	--//****
								DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3 VARCHAR(50) =''
								DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO3 VARCHAR(50)=''
								SET @row_cod_uds_precedesores_no_existen =''

								SELECT ID_UNIDAD_DIDACTICA = ID_UNIDAD_DIDACTICA INTO #TempParaWhile01_G3 FROM @tblUnidadDidactica_NuevoIdRegistrado_G3						--//FRAMOS CAMBIAR AQUI
								WHILE (SELECT COUNT(*) FROM #TempParaWhile01_G3) > 0																						--//FRAMOS CAMBIAR AQUI
								Begin								
									SELECT TOP 1 @ID_UNIDAD_DIDACTICA_TMP = ID_UNIDAD_DIDACTICA FROM #TempParaWhile01_G3													--//FRAMOS CAMBIAR AQUI

									Begin --> Proceso a Iterar 									
									
										SELECT --> Obtener unidades didacticas registradas 
										@CODIGO_PREDECESORA_EXCEL = F,
										@ROW_INDEX_CODIGO_PREDECESORA_EXCEL = rowIndex
										FROM #tmp
										INNER JOIN transaccional.unidad_didactica ud on E = ud.NOMBRE_UNIDAD_DIDACTICA
										WHERE 1 = 1
										AND ud.ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA_TMP										
										AND rowIndex BETWEEN @rowIndexIni_g3 AND @rowIndexFin_g3																										--//FRAMOS CAMBIAR AQUI
										ORDER BY CONVERT(INT, rowIndex) ASC
										--//										
									
										SET @VALIDAR_CODIGO_PREDECESORA_EXCEL = REPLACE(@CODIGO_PREDECESORA_EXCEL, @DELIMITADOR_CODIGO_PREDECESORA_EXCEL, '') --//Obtener los valores de codigo predecesora sin su delimitador
																		
										IF @VALIDAR_CODIGO_PREDECESORA_EXCEL = ''
										Begin --> Validar si la celda esta vacía y no la registra 

											SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO3 = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO3 											
											+ CONVERT(VARCHAR,@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) 
											+ ', ' ;											

										End
									
										IF (@VALIDAR_CODIGO_PREDECESORA_EXCEL like '%[^0-9]%' or ISNUMERIC(@VALIDAR_CODIGO_PREDECESORA_EXCEL) = 0) AND LEN(@CODIGO_PREDECESORA_EXCEL) > 0
										Begin --> Validar si la celda tiene error y no la registra 

											SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3 = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3											
											+ CONVERT(VARCHAR,@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) 
											+ ', ' ;											

										End

										Begin  --Validar si los códigos de las unidades predecesoras referenciadas existen. 
										if @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3 =''
											begin
												set @ID_SEMESTRE_ACADEMICO_TMP =(select ID_SEMESTRE_ACADEMICO from transaccional.unidad_didactica where ID_UNIDAD_DIDACTICA=@ID_UNIDAD_DIDACTICA_TMP)
												SET @cont_predecesores_validos_ud	= 0
										
												select @cont_predecesores_validos_ud = count (1) from transaccional.unidad_didactica tbl1
												inner join transaccional.modulo tbl2 on tbl1.ID_MODULO= tbl2.ID_MODULO AND tbl2.ES_ACTIVO=1
												where 
												tbl2.ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO AND 
												tbl1.ID_SEMESTRE_ACADEMICO< @ID_SEMESTRE_ACADEMICO_TMP and 
												tbl1.CODIGO_UNIDAD_DIDACTICA in (select SplitData from dbo.UFN_SPLIT (@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL))
												SET @cont_predecesores_validos_ud=ISNULL(@cont_predecesores_validos_ud,0)																		
												if (@cont_predecesores_validos_ud<> (select count (1)from dbo.UFN_SPLIT (@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL)))
												BEGIN
														set	@row_cod_uds_precedesores_no_existen = @row_cod_uds_precedesores_no_existen + convert(varchar(50),@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) + ', ' ;
														set @VALIDAR_CODIGO_PREDECESORA_EXCEL=''
												END
											end											
										End 

										IF(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3='' and ISNUMERIC(@VALIDAR_CODIGO_PREDECESORA_EXCEL) = 1)
										Begin --> Validar si la celda contiene solo numeros fuera de los delimitadores 

												Begin --> Consultar funcion UFN_SPLIT, Iterar e ingresar datos. transaccional.unidad_didactica_detalle
													
														SELECT Id = SplitData INTO #TempParaWhile02_G3 																			--//FRAMOS CAMBIAR AQUI
														FROM dbo.UFN_SPLIT(@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL);	--//Utilizando la funcion para obtener valores		
													
														DECLARE @CODIGO_PREDECESORA_A_INSERTAR_G3 INT = 0;																		--//FRAMOS CAMBIAR AQUI 													
														WHILE (SELECT COUNT(*) FROM #TempParaWhile02_G3) > 0																	--//FRAMOS CAMBIAR AQUI
														Begin								
															SELECT TOP 1 @CODIGO_PREDECESORA_A_INSERTAR_G3 = Id FROM #TempParaWhile02_G3											--//FRAMOS CAMBIAR AQUI	2												

																Begin --> Proceso a Iterar: transaccional.unidad_didactica_detalle - GRUPO 3 

																	INSERT INTO transaccional.unidad_didactica_detalle
																	(
																		ID_UNIDAD_DIDACTICA
																		,CODIGO_PREDECESORA

																		,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION											
																	)
																	VALUES
																	(
																		--ID_UNIDAD_DIDACTICA
																		@ID_UNIDAD_DIDACTICA_TMP

																		--CODIGO_PREDECESORA
																		,@CODIGO_PREDECESORA_A_INSERTAR_G3																			--//FRAMOS CAMBIAR AQUI

																		,@ES_ACTIVO, @ESTADO, @USUARIO_CREACION, GETDATE()											
																	)													

																End														
							
															DELETE #TempParaWhile02_G3 WHERE Id = @CODIGO_PREDECESORA_A_INSERTAR_G3												--//FRAMOS CAMBIAR AQUI
														End
														DROP TABLE #TempParaWhile02_G3																							--//FRAMOS CAMBIAR AQUI											

												End									

										End									

									End
							
									DELETE #TempParaWhile01_G3 WHERE ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA_TMP															--//FRAMOS CAMBIAR AQUI
								End
								
								IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO3 <> ''
								Begin
									SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO + 'Fila: ' + SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO3, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO3) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F se encuentra vacía.'+  @MSG_INFO +'|';	--//****
								End

								IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3 <> ''
								BEGIN
									IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR=''
										SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR = 'Fila: '+  SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3) - 1 ) + '  registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene un formato inválido.'+  @MSG_ERROR +'|';	--//****
									ELSE
										SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR+ ' Fila: '+  SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR3) - 1 ) + '  registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene un formato inválido.'+  @MSG_ERROR +'|';	--//****
								END
								if @row_cod_uds_precedesores_no_existen <> ''
								Begin
									set @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_NOEXISTE_NOVALIDO =@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_NOEXISTE_NOVALIDO + 'Fila: ' +   SUBSTRING (@row_cod_uds_precedesores_no_existen, 1, Len(@row_cod_uds_precedesores_no_existen) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene código(s) inválido(s).'+  @MSG_ERROR +'|';	--//****									
								End			
							
								DROP TABLE #TempParaWhile01_G3																												--//FRAMOS CAMBIAR AQUI												

							End

						End
						ELSE
						Begin
							SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 68 hasta Fila 93 no registrada(s) porque no cuentan con Módulo Formativo, Total Horas o Total créditos U.D.' +  @MSG_INFO + '|'; 
						End

					End --> FIN: GRUPO - 3 

					Begin --> GRUPO - 4 

						SET @CANTIDAD_FILAS_GRUPO_VALIDAS = 0;
						SELECT 
						@CANTIDAD_FILAS_GRUPO_VALIDAS = COUNT(*)
						--*
						FROM #tmp
						WHERE 1 = 1
						AND	B <> '' 						
						AND	E <> '' 						
						AND (R <> '' OR R <> 0) --ANTES P
						AND (V <> '' OR V <> 0)		--ANTES T				
						AND rowIndex BETWEEN @rowIndexIni_g4 AND @rowIndexIni_g4 --PRIMERA FILA DEL CUARTO BLOQUE

						IF @CANTIDAD_FILAS_GRUPO_VALIDAS = 1
						Begin --> Validacion si existen datos

							Begin --> transaccional.modulo - GRUPO 4
												
								INSERT INTO transaccional.modulo 
								(
								ID_PLAN_ESTUDIO
								,CODIGO_MODULO
								,NOMBRE_MODULO

								--//*****
								,TOTAL_HORAS_UD
								,TOTAL_CREDITOS_UD
								--//*****

								,ES_ACTIVO
								,ESTADO
								,USUARIO_CREACION
								,FECHA_CREACION
								)

								OUTPUT INSERTED.ID_MODULO INTO @tblModulo_NuevoIdRegistrado_G4(ID_MODULO)													--//FRAMOS CAMBIAR AQUI

								VALUES	--ID_MODULO
								(
									(--//ID_PLAN_ESTUDIO, dbo.ID,										
										@ID_PLAN_ESTUDIO
									)
									,(--CODIGO_MODULO - Vacio por ahora hasta definir
									'ConsultarJtovar'	
									)
									,(--NOMBRE_MODULO
										SELECT B FROM #tmp WHERE rowIndex = @rowIndexIni_g4																				--//FRAMOS CAMBIAR AQUI
									)

								
									--//*****
									,(--TOTAL_HORAS_UD, ANTES P																								--//FRAMOS CAMBIAR AQUI
										SELECT R FROM #tmp WHERE rowIndex = @rowIndexIni_g4									
										)
								
									,(--TOTAL_CREDITOS_UD		 --ANTES T
										SELECT V FROM #tmp WHERE rowIndex = @rowIndexIni_g4																				--//FRAMOS CAMBIAR AQUI									
									)
									--//*****
																

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								)

							End
							
							Begin --> maestro.unidad_competencia GRUPO 4  

							SET @INDEX_TEMPORAL = '';

								Begin --> maestro.unidad_competencia 01	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = @rowIndexIni_g4)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G4)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,1

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)												

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																			
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = @rowIndexIni_g4)) + ','			--//framos cambio aqui
									End

								End

								Begin --> maestro.unidad_competencia 02	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 104)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G4)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,2

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)												

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																			
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 104)) + ','			--//framos cambio aqui
									End

								End																	

								Begin --> maestro.unidad_competencia 03	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 111)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G4)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,3

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																		
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 111)) + ','			--//framos cambio aqui
									End

								End

								Begin --> maestro.unidad_competencia 04	

									SET @UNIDAD_DE_COMPETENCIA = ''
									SET @UNIDAD_DE_COMPETENCIA = (SELECT A FROM #tmp WHERE rowIndex = 118)
									IF @UNIDAD_DE_COMPETENCIA <> '' --> Si existe Unidad Didactica que graba
									Begin										

										INSERT INTO maestro.unidad_competencia 
										(												   
										CODIGO_UNIDAD_COMPETENCIA
										,NOMBRE_UNIDAD_COMPETENCIA
										,DESCRIPCION_UNIDAD_COMPETENCIA	

										,ES_ACTIVO	
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										OUTPUT INSERTED.ID_UNIDAD_COMPETENCIA INTO @tblUnidadCompetencia_NuevoIdRegistrado(ID_UNIDAD_COMPETENCIA)
										VALUES
										(
											''
											,@UNIDAD_DE_COMPETENCIA
											,''

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										INSERT INTO transaccional.unidad_competencias_por_modulo 
										(
										ID_MODULO
										,ID_UNIDAD_COMPETENCIA
										,ORDEN_VISUALIZACION
										,ES_ACTIVO
										,ESTADO
										,USUARIO_CREACION
										,FECHA_CREACION
										)
										VALUES
										(
											--ID_MODULO
											(SELECT ID_MODULO as 'ID_MODULO recien registrado' FROM @tblModulo_NuevoIdRegistrado_G4)											--//framos cambio aqui

											--ID_UNIDAD_COMPETENCIA
											,(SELECT ID_UNIDAD_COMPETENCIA as 'ID_UNIDAD_COMPETENCIA recien registrado' FROM @tblUnidadCompetencia_NuevoIdRegistrado)

											--ORDEN_VISUALIZACION
											,3

											,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
										)

										DELETE FROM @tblUnidadCompetencia_NuevoIdRegistrado
										
									End
									ELSE
									Begin																		
										SET @INDEX_TEMPORAL = @INDEX_TEMPORAL +  CONVERT(VARCHAR,(SELECT rowIndex FROM #tmp WHERE rowIndex = 118)) + ','			--//framos cambio aqui
									End

								End

								Begin --> Resumen de Mensajes Validacion 

									IF @INDEX_TEMPORAL <> ''
									Begin
										--//Almacena en el index los valores que no fueron registrados
										SET @INDEX_NO_REGISTRADOS_UNIDAD_DE_COMPETENCIA_VACIO = @INDEX_NO_REGISTRADOS_UNIDAD_DE_COMPETENCIA_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' de la columna A se encuentra vacía.'+@MSG_INFO+'|';
									End

								End
								
							SET @INDEX_TEMPORAL = '';

							End

							Begin -->Validar vacíos e inválidos
									set @row_cod_uds_vacios =''
									select @row_cod_uds_vacios = COALESCE(@row_cod_uds_vacios,'') + rowIndex + ',' from #tmp where  D ='' and 
									rowIndex BETWEEN @rowIndexIni_g4  and @rowIndexFin_g4 AND E<>'' --UDS con nombre UD pero códigos vacíos

									set @row_cod_uds_invalidos =''
									select @row_cod_uds_invalidos = COALESCE(@row_cod_uds_invalidos,'') + rowIndex+',' from #tmp 
									where  ((D like '%[^0-9]%' or ISNUMERIC(D) =0) or LEN(D)>@cod_ud_long_max or D = 0) and D<>''
									and rowIndex BETWEEN @rowIndexIni_g4  and @rowIndexFin_g4 and E<>''
							End
							
							Begin -->Validar repeticiones
						
									set @row_repeticiones =''
									SET @rowIndex_tmp = @rowIndexIni_g4
									WHILE (@rowIndex_tmp <= @rowIndexFin_g4  )
									begin
									select @codEval = D from #tmp where rowIndex = @rowIndex_tmp

									set @rowindex_existe = (select top 1 rowIndex from #tmp where rowIndex < @rowIndex_tmp and D =@codEval and D <>''
									and D not like '%[^0-9]%' and LEN(D)<=@cod_ud_long_max and D > 0)
									if @rowindex_existe is not null
									set @row_repeticiones  = @row_repeticiones + convert(varchar(3),@rowIndex_tmp) + ','

									set @rowIndex_tmp = @rowIndex_tmp +1

									set @rowindex_existe =0
									end 
							End

							Begin -->Validar periodo académico válido (número entero)
									set @row_no_numerico_periodo_academico =''
									select @row_no_numerico_periodo_academico = COALESCE(@row_no_numerico_periodo_academico, '') + rowIndex +','
									from #tmp
									where 
									 (
										((G like '%[^0-9]%' or ISNUMERIC(G)=0 or G =0 OR LEN(G)>@horas_long_max) AND G<>'') OR ((H like '%[^0-9]%' or ISNUMERIC(H)=0 OR H =0 OR LEN(H)>@horas_long_max) AND H<>'') OR
										((I like '%[^0-9]%' or ISNUMERIC(I)=0 or I =0 OR LEN(I)>@horas_long_max) AND I<>'') OR ((J like '%[^0-9]%' or ISNUMERIC(J)=0 or J =0 OR LEN(J)>@horas_long_max) AND J<>'') OR
										((K like '%[^0-9]%' or ISNUMERIC(K)=0 or K =0 OR LEN(K)>@horas_long_max) AND K<>'') OR ((L like '%[^0-9]%' or ISNUMERIC(L)=0 or L =0 OR LEN(L)>@horas_long_max) AND L<>'') OR
										((M like '%[^0-9]%' or ISNUMERIC(M)=0 or M =0 OR LEN(M)>@horas_long_max) AND M<>'') OR ((N like '%[^0-9]%' or ISNUMERIC(N)=0 or N =0 OR LEN(N)>@horas_long_max) AND N<>'')
									)	and 
									rowIndex BETWEEN @rowIndexIni_g4 and @rowIndexFin_g4
									and E<>''
									set @row_no_numerico_periodo_academico = ISNULL(@row_no_numerico_periodo_academico, '') -- para impedir comparación con nulo 
							End

							/*Begin -->Validar que se tenga un único valor en la sección Horas del Periodo académico	-incluye que no se tengan todos vacíos	
									set @row_no_valor_unico_periodo_academico =''
									select @row_no_valor_unico_periodo_academico  = COALESCE(@row_no_valor_unico_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G <> '' THEN 1 ELSE 0 END) + (CASE WHEN H <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I <> ''THEN 1 ELSE 0 END) + (CASE WHEN J <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K <> ''THEN 1 ELSE 0 END) + (CASE WHEN L <> ''THEN 1 ELSE 0 END) 
										   <>1) 								
									AND rowIndex BETWEEN @rowIndexIni_g4 and @rowIndexFin_g4
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End*/

							Begin -->Validar que se haya consignado información de horas
									SET  @row_horas_vacias_periodo_academico =''
									select @row_horas_vacias_periodo_academico  = COALESCE(@row_horas_vacias_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G = '' THEN 1 ELSE 0 END) + (CASE WHEN H = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I = ''THEN 1 ELSE 0 END) + (CASE WHEN J = ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K = ''THEN 1 ELSE 0 END) + (CASE WHEN L = ''THEN 1 ELSE 0 END) +
										   (CASE WHEN M = ''THEN 1 ELSE 0 END) + (CASE WHEN N = ''THEN 1 ELSE 0 END) 
										   = 8 ) 								
									AND rowIndex BETWEEN @rowIndexIni_g4 and @rowIndexFin_g4
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico, ','))
									and E <> ''
							End
							Begin -->Validar que NO se haya consignado más de un valor como información de horas 
									SET @row_horas_multiples_periodo_academico =''
									select @row_horas_multiples_periodo_academico  = COALESCE(@row_horas_multiples_periodo_academico, '') + rowIndex  +',' from #tmp
									WHERE ((CASE WHEN G <> '' THEN 1 ELSE 0 END) + (CASE WHEN H <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN I <> ''THEN 1 ELSE 0 END) + (CASE WHEN J <> ''THEN 1 ELSE 0 END) + 
										   (CASE WHEN K <> ''THEN 1 ELSE 0 END) + (CASE WHEN L <> ''THEN 1 ELSE 0 END) +
										   (CASE WHEN M <> ''THEN 1 ELSE 0 END) + (CASE WHEN N <> ''THEN 1 ELSE 0 END) 
										   <> 1 ) 								
									AND rowIndex BETWEEN @rowIndexIni_g4 and @rowIndexFin_g4
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_no_numerico_periodo_academico + ',' + @row_horas_vacias_periodo_academico , ','))
									and E <> ''
							End
							BEGIN -->Validar horas no vacías
								set @row_vacio_horas =''
								select @row_vacio_horas = COALESCE(@row_vacio_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										O='' OR P=''--ANTES M,N									
									)	and 
									rowIndex BETWEEN @rowIndexIni_g4 and @rowIndexFin_g4
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico, ','))
									and E<>''
									set @row_vacio_horas = ISNULL(@row_vacio_horas, '') -- para impedir comparación con nulo 
							End
							BEGIN -->Validar horas válidas (ENTERO)	
								set @row_no_numerico_horas =''							
								select @row_no_numerico_horas = COALESCE(@row_no_numerico_horas, '') + rowIndex +','
									from #tmp
									where 
									 (
										((O like '%[^0-9]%' or ISNUMERIC(O)=0) AND O<>'')  OR ((P like '%[^0-9]%' or ISNUMERIC(P)=0 ) AND P<>'')	--ANTES M,N									
									)	and 
									rowIndex BETWEEN @rowIndexIni_g4 and @rowIndexFin_g4 
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico, ','))
									and E<>''									
									set @row_no_numerico_horas = ISNULL(@row_no_numerico_horas, '') -- para impedir comparación con nulo 									
							End

							BEGIN -->Validar suma de horas O+P = Q, ANTES M,N,O
									set @row_no_suma_igual_horas=''
									SELECT @row_no_suma_igual_horas = COALESCE(@row_no_suma_igual_horas, '') + rowIndex + ',' FROM #tmp where  
									( (case when O<>'' then convert(int, O ) else 0 end)
									 +(case when P<>'' then convert(int, P ) else 0 end)
									 <> (case when Q<>'' then convert(int,Q) else 0 end))
									AND rowIndex
									BETWEEN @rowIndexIni_g4 AND @rowIndexFin_g4							
									AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ',' 
									+ @row_vacio_horas + ',' +@row_no_numerico_horas, ','))
									and E<>''	
									set @row_no_suma_igual_horas = ISNULL(@row_no_suma_igual_horas, '') 									
							End

							BEGIN -->Validar créditos no vacíos		
								set @row_vacio_creditos	=''
								select @row_vacio_creditos = COALESCE(@row_vacio_creditos, '') + rowIndex +','
									from #tmp
									where (S='' OR T='' OR U='')	and --ANTES Q,R,S
									rowIndex BETWEEN @rowIndexIni_g4 and @rowIndexFin_g4 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ','
									+@row_vacio_horas + ',' +@row_no_numerico_horas +',' +@row_no_suma_igual_horas
									, ','))
									and E<>''									
									set @row_vacio_creditos = ISNULL(@row_vacio_creditos, '') -- para impedir comparación con nulo 									
							End

							BEGIN -->Validar créditos válidos (numéricos), incluye decimal
								set @row_no_numerico_creditos =''				
								select @row_no_numerico_creditos = COALESCE(@row_no_numerico_creditos, '') + rowIndex +','
									from #tmp
									where 
									(( ISNUMERIC(S)=0 AND S<>'')  OR (ISNUMERIC(T)=0 AND T<>'')	OR (ISNUMERIC(U)=0 AND U<>'')	--ANTES Q,R,S
									)
									and 
									rowIndex BETWEEN @rowIndexIni_g4 and @rowIndexFin_g4 --no cambiar por la variable declarada anteriormente, se debe evaluar
									and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
									+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ','
									+@row_vacio_horas + ',' +@row_no_numerico_horas +','+@row_vacio_creditos
									, ','))
									and E<>''									
									set @row_no_numerico_creditos = ISNULL(@row_no_numerico_creditos, '') -- para impedir comparación con nulo 									
							End
							--BEGIN -->Validar suma de horas Q+R = S
							--	set @row_no_suma_igual_creditos=''
							--		SELECT @row_no_suma_igual_creditos = COALESCE(@row_no_suma_igual_creditos, '') + rowIndex + ',' FROM #tmp where  									
							--		rowIndex
							--		BETWEEN @rowIndexIni_g4 AND @rowIndexFin_g4
							--		AND rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_cod_uds_vacios + ',' + @row_cod_uds_invalidos + ','
							--		+@row_repeticiones +','+@row_no_numerico_periodo_academico + ',' +@row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico + ',' 
							--		+ @row_no_numerico_horas + ',' + @row_vacio_creditos+ ',' +@row_no_numerico_creditos +',' +@row_no_suma_igual_horas, ','))
							--		and E<>'' AND
							--		( (case when Q<>'' then convert(decimal(5,1), Q ) else 0 end)
							--		 +(case when R<>'' then convert(decimal(5,1), R ) else 0 end)
							--		 <> (case when R<>'' then convert(decimal(5,1), S ) else 0 end))
							--		set @row_no_suma_igual_creditos = ISNULL(@row_no_suma_igual_creditos, '') 									
							--End

							Begin --> transaccional.unidad_didactica - GRUPO 4 

								INSERT INTO transaccional.unidad_didactica
								(
									ID_MODULO
									,ID_SEMESTRE_ACADEMICO
								
									,ID_TIPO_UNIDAD_DIDACTICA
								
									,CODIGO_UNIDAD_DIDACTICA
									,NOMBRE_UNIDAD_DIDACTICA
									,DESCRIPCION
								
									,PERIODO_ACADEMICO_I
									,PERIODO_ACADEMICO_II
									,PERIODO_ACADEMICO_III
									,PERIODO_ACADEMICO_IV
									,PERIODO_ACADEMICO_V
									,PERIODO_ACADEMICO_VI	
									,PERIODO_ACADEMICO_VII
									,PERIODO_ACADEMICO_VIII							
								
									,TEORICO_PRACTICO_HORAS_UD
									,PRACTICO_HORAS_UD
								
									,HORAS
								
									,TEORICO_PRACTICO_CREDITOS_UD
									,PRACTICO_CREDITOS_UD
								
									,CREDITOS
									,ES_ACTIVO,	ESTADO, USUARIO_CREACION,	FECHA_CREACION
								)

								OUTPUT INSERTED.ID_UNIDAD_DIDACTICA INTO @tblUnidadDidactica_NuevoIdRegistrado_G4(ID_UNIDAD_DIDACTICA)								--//FRAMOS CAMBIAR AQUI

								SELECT
									--ID_MODULO			
									(SELECT ID_MODULO as 'ID_MODULO recien registrado 1' FROM @tblModulo_NuevoIdRegistrado_G4)										--//FRAMOS CAMBIAR AQUI			
								
									--ID_SEMESTRE_ACADEMICO
									,CASE 
										WHEN G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' AND L =  '' AND M='' AND N='' THEN 0 --'ERROR'				
										WHEN 7 > ( CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END + CASE WHEN L = '' THEN 1 ELSE 0 END  + CASE WHEN M = '' THEN 1 ELSE 0 END + CASE WHEN N = '' THEN 1 ELSE 0 END  ) THEN 0 --'ERROR'
										WHEN G <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'I'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN H <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'II'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO ) 
										WHEN I <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'III'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN J <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'IV'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN K <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'V'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN L <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VI'		AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN M <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VII'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
										WHEN N <> '' THEN ( SELECT CAST(enum.ID_ENUMERADO AS NVARCHAR(5)) FROM sistema.enumerado enum WHERE enum.VALOR_ENUMERADO = 'VIII'	AND enum.ID_TIPO_ENUMERADO = @CODIGO_ENUMERADO_TIPO_SEMESTRE_ACADEMICO )
									END	AS ID_SEMESTRE_ACADEMICO								
								
									--ID_TIPO_UNIDAD_DIDACTICA
									,CASE
										--WHEN 1 = 1 THEN 1
										WHEN @NOMBRE_TIPO_UNIDAD_ESPECIFICA_EXCEL				= C THEN @ID_TIPO_UNIDAD_DIDACTICA_ESPECIFICA
										WHEN @NOMBRE_TIPO_UNIDAD_EMPLEABILIDAD_EXCEL			= C THEN @ID_TIPO_UNIDAD_DIDACTICA_EMPLEABILIDAD
										WHEN @NOMBRE_TIPO_UNIDAD_EXPERIENCIA_FORMATIVA_EXCEL	= C THEN @ID_TIPO_UNIDAD_DIDACTICA_EXPERIENCIA_FORMATIVA
										ELSE 0
									END AS ID_TIPO_UNIDAD_DIDACTICA
								
									--CODIGO_UNIDAD_DIDACTICA
									,CASE WHEN D = '' THEN 'ERROR' WHEN D <> '' THEN D END AS CODIGO_UNIDAD_DIDACTICA			
			
									--NOMBRE_UNIDAD_DIDACTICA
									,CASE WHEN E = '' THEN 'ERROR' WHEN E <> '' THEN E END AS NOMBRE_UNIDAD_DIDACTICA
								
									--DESCRIPCION
									,'ConsultarJtovar'	AS DESCRIPCION																								
								
									--PERIODO_ACADEMICO_I
									,CASE WHEN G <> '' THEN G END AS PERIODO_ACADEMICO_I
										
									--PERIODO_ACADEMICO_II
									,CASE WHEN H <> '' THEN H END AS PERIODO_ACADEMICO_II
										
									--PERIODO_ACADEMICO_III
									,CASE WHEN I <> '' THEN I END AS PERIODO_ACADEMICO_III
										
									--PERIODO_ACADEMICO_IV
									,CASE WHEN J <> '' THEN J END AS PERIODO_ACADEMICO_IV
										
									--PERIODO_ACADEMICO_V
									,CASE WHEN K <> '' THEN K END AS PERIODO_ACADEMICO_V
										
									--PERIODO_ACADEMICO_VI
									,CASE WHEN L <> '' THEN L END AS PERIODO_ACADEMICO_VI

									--PERIODO_ACADEMICO_VII --ADD
									,CASE WHEN M <> '' THEN M END AS PERIODO_ACADEMICO_VII

									--PERIODO_ACADEMICO_VIII --ADD
									,CASE WHEN N <> '' THEN N END AS PERIODO_ACADEMICO_VIII
								
									--TEORICO_PRACTICO_HORAS_UD
									,CASE WHEN O <> '' THEN O END AS TEORICO_PRACTICO_HORAS_UD
								
									--PRACTICO_HORAS_UD
									,CASE WHEN P <> '' THEN P END AS PRACTICO_HORAS_UD											

									--HORAS
									,CASE 
										WHEN G =  '' AND H =  '' AND I =  '' AND J =  '' AND K =  '' AND L =  '' AND M='' AND N='' THEN 0 --'ERROR'
										WHEN 7 > ( CASE WHEN G = '' THEN 1 ELSE 0 END + CASE WHEN H = '' THEN 1 ELSE 0 END + CASE WHEN I = '' THEN 1 ELSE 0 END + CASE WHEN J = '' THEN 1 ELSE 0 END + CASE WHEN K = '' THEN 1 ELSE 0 END + CASE WHEN L = '' THEN 1 ELSE 0 END + CASE WHEN M = '' THEN 1 ELSE 0 END + CASE WHEN N = '' THEN 1 ELSE 0 END) THEN 0 --'ERROR'
										WHEN G <> '' THEN G
										WHEN H <> '' THEN H
										WHEN I <> '' THEN I
										WHEN J <> '' THEN J
										WHEN K <> '' THEN K
										WHEN L <> '' THEN L				
										WHEN M <> '' THEN M	--ADD
										WHEN N <> '' THEN N	--ADD
									END	AS HORAS
								
									---TEORICO_PRACTICO_CREDITOS_UD  --ANTES Q
									, CASE WHEN S <> '' THEN convert(decimal(5,1),S) END AS TEORICO_PRACTICO_CREDITOS_UD

									--PRACTICO_CREDITOS_UD --ANTES R
									, CASE WHEN T <> '' THEN convert(decimal(5,1),T) END AS PRACTICO_CREDITOS_UD								

									--CREDITOS
									,CASE 
										WHEN S = '' OR T = '' THEN 0	--'ERROR' --ANTES Q,R
										WHEN S <> '' AND T<> '' THEN convert(decimal(5,1),S) + convert(decimal(5,1),T)
									END AS CREDITOS

									,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
								FROM #tmp
								WHERE 1 = 1
								AND E <> ''
								AND rowIndex BETWEEN @rowIndexIni_g4 AND @rowIndexFin_g4 --RANGO DE FILAS DEL TERCER BLOQUE																	--//FRAMOS CAMBIAR AQUI								
								and rowIndex not in (select SplitData from dbo.UFN_SPLIT(@row_repeticiones + ',' +@row_no_numerico_periodo_academico +',' +
													 @row_horas_vacias_periodo_academico + ',' + @row_horas_multiples_periodo_academico+ ',' + @row_vacio_horas + ',' +@row_no_numerico_horas + ','  +
													 @row_vacio_creditos + ',' + @row_no_suma_igual_horas + ',' + @row_no_numerico_creditos +',' +
													 @row_no_suma_igual_creditos,','))	
								and D <> ''
								and D NOT like '%[^0-9]%'and LEN(D)<=@cod_ud_long_max
								ORDER BY CONVERT(INT, rowIndex) ASC

								--//Filas no registradas porque no tienen nombre de la unidad didactica
								SET @INDEX_TEMPORAL = '';

								SELECT @INDEX_TEMPORAL = COALESCE(@INDEX_TEMPORAL,'') + rowIndex + ', '
								FROM #tmp
								WHERE 1 = 1
								AND E = ''
								AND rowIndex BETWEEN @rowIndexIni_g4 AND @rowIndexFin_g4 --RANGO DE FILAS DEL TERCER BLOQUE
								ORDER BY CONVERT(INT, rowIndex) ASC

								IF	@INDEX_TEMPORAL <> '' AND 	
									CHARINDEX(',', @INDEX_TEMPORAL) > 0 AND 
									Len(@INDEX_TEMPORAL) > 1
								BEGIN
									SET @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO = @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 'Fila: ' + SUBSTRING (@INDEX_TEMPORAL, 1, Len(@INDEX_TEMPORAL) - 1 ) + ' no registrada(s).' +@MSG_INFO + '|'
								END
		
								--//Filas registradas pero con ID_SEMESTRE_ACADEMICO = 0 y HORAS = 0		
								SELECT @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO = COALESCE(@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO,'') + 'Fila: ' + rowIndex + ' registrada pero posiblemente con error.|'
								FROM transaccional.unidad_didactica ud
								inner join #tmp tmp ON ud.NOMBRE_UNIDAD_DIDACTICA = tmp.E
								WHERE ud.ID_SEMESTRE_ACADEMICO = 0
								AND ud.ID_MODULO = (SELECT ID_MODULO as 'ID_MODULO recien registrado 4' FROM @tblModulo_NuevoIdRegistrado_G4)
								AND tmp.rowIndex BETWEEN @rowIndexIni_g4 AND @rowIndexFin_g4 --RANGO DE FILAS DEL TERCER BLOQUE	

								--Fila no registrada por repeticiones	
								if @row_repeticiones <>''							
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO + 'Fila: ' + SUBSTRING (@row_repeticiones, 1, Len(@row_repeticiones) - 1 ) + ' no registradas(s) porque la columna D tiene valores repetidos.'+@MSG_ERROR+'|'

								--Fila no registrada por codigo de unidad didáctica vacía
								if @row_cod_uds_vacios <>''
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO + 'Fila: ' + SUBSTRING (@row_cod_uds_vacios, 1, Len(@row_cod_uds_vacios) - 1 ) + ' no registradas(s) porque la columna D se encuentra vacía.'+@MSG_ERROR+'|'

								--Fila no registrada por codigo de unidad didáctica no número entero
								if @row_cod_uds_invalidos <>'' 
								SET @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO = @INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO + 'Fila: ' + SUBSTRING (@row_cod_uds_invalidos, 1, Len(@row_cod_uds_invalidos) - 1 ) + ' no registradas(s) porque la columna D no tiene dato(s) de tipo entero entre 1 y 99.'+@MSG_ERROR+'|'

								--Fila no registra por columnas no numericas de periodo académico 
								if @row_no_numerico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_numerico_periodo_academico, 1, Len(@row_no_numerico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene dato(s) de tipo entero entre 1 y 999.'+@MSG_ERROR+'|'
								
								/*--Fila no registra por valor no único de periodo académico 
								if @row_no_valor_unico_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO = @INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO + 'Fila: ' + SUBSTRING (@row_no_valor_unico_periodo_academico, 1, Len(@row_no_valor_unico_periodo_academico) - 1 ) + ' no registradas(s) porque la sección Horas del Periodo académico no tiene datos o no tiene un valor único.|'*/
								
								--Fila no registra por horas vacías  
								if @row_horas_vacias_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS = @INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS + 'Fila: ' + SUBSTRING (@row_horas_vacias_periodo_academico, 1, Len(@row_horas_vacias_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico no se ha consignado información de horas.'+@MSG_ERROR+'|'

								--Fila no registra por horas múltiples
								if @row_horas_multiples_periodo_academico <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES = @INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 'Fila: ' + SUBSTRING (@row_horas_multiples_periodo_academico, 1, Len(@row_horas_multiples_periodo_academico) - 1 ) + ' no registradas(s) porque en la sección Horas del Periodo académico se ha consignado más de un valor como información de horas.'+@MSG_ERROR+'|'
								
								--Fila no registra por columnas vacías de horas O,P--ANTES m,n
								if @row_vacio_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS + 'Fila: ' + SUBSTRING (@row_vacio_horas, 1, Len(@row_vacio_horas) - 1 ) + ' no registradas(s) porque la sección Horas tiene dato(s) vacío(s).'+@MSG_ERROR+'|'	
							

								--Fila no registra por columnas no numéricas de horas 
								if @row_no_numerico_horas <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS + 'Fila: ' + SUBSTRING (@row_no_numerico_horas, 1, Len(@row_no_numerico_horas) - 1 ) + ' no registradas(s) porque en la sección Horas los datos de las columnas O y/o P no son valores enteros.'+@MSG_ERROR+'|'								

								--Fila no registra por O + P <> Q, ANTES M,N,O
								if @row_no_suma_igual_horas<>''
								set @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS = @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS +  'Fila: ' + SUBSTRING (@row_no_suma_igual_horas, 1, Len(@row_no_suma_igual_horas) - 1 ) + ' no registradas(s) porque en la sección Horas la suma de los datos de las columnas O y P no es igual al dato de la columna Q.'+  @MSG_ERROR +'|'								

								--Fila no registra por columnas vacías de créditos 
								if @row_vacio_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_vacio_creditos, 1, Len(@row_vacio_creditos) - 1 ) + ' no registradas(s) porque la sección créditos tiene dato(s) vacío(s).'+  @MSG_ERROR +'|'								

								--Fila no registra por columnas no numéricas de créditos 
								if @row_no_numerico_creditos <> '' 
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_numerico_creditos, 1, Len(@row_no_numerico_creditos) - 1 ) + ' no registradas(s) porque la sección créditos no tiene dato(s) de tipo numérico.'+  @MSG_ERROR +'|'								

								--Fila no registra por S + T <> U, ANTES Q,R,S
								if @row_no_suma_igual_creditos <> ''
								SET @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS = @INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS + 'Fila: ' + SUBSTRING (@row_no_suma_igual_creditos, 1, Len(@row_no_suma_igual_creditos) - 1 ) + ' no registradas(s) porque en la sección Créditos la suma de los datos de las columnas S y T no es igual al dato de la columna U.'+  @MSG_ERROR +'|'								
							End					

							Begin --> transaccional.unidad_didactica_detalle - GRUPO 4 

								--SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO + 'Fila: ';	--//****
								DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4 VARCHAR(50) =''
								DECLARE @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO4 VARCHAR(50)=''
								SET @row_cod_uds_precedesores_no_existen =''

								SELECT ID_UNIDAD_DIDACTICA = ID_UNIDAD_DIDACTICA INTO #TempParaWhile01_G4 FROM @tblUnidadDidactica_NuevoIdRegistrado_G4						--//FRAMOS CAMBIAR AQUI
								WHILE (SELECT COUNT(*) FROM #TempParaWhile01_G4) > 0																						--//FRAMOS CAMBIAR AQUI
								Begin								
									SELECT TOP 1 @ID_UNIDAD_DIDACTICA_TMP = ID_UNIDAD_DIDACTICA FROM #TempParaWhile01_G4													--//FRAMOS CAMBIAR AQUI

									Begin --> Proceso a Iterar 									
									
										SELECT --> Obtener unidades didacticas registradas 
										@CODIGO_PREDECESORA_EXCEL = F,
										@ROW_INDEX_CODIGO_PREDECESORA_EXCEL = rowIndex
										FROM #tmp
										INNER JOIN transaccional.unidad_didactica ud on E = ud.NOMBRE_UNIDAD_DIDACTICA
										WHERE 1 = 1
										AND ud.ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA_TMP										
										AND rowIndex BETWEEN @rowIndexIni_g4 AND @rowIndexFin_g4																										--//FRAMOS CAMBIAR AQUI
										ORDER BY CONVERT(INT, rowIndex) ASC
										--//										
									
										SET @VALIDAR_CODIGO_PREDECESORA_EXCEL = REPLACE(@CODIGO_PREDECESORA_EXCEL, @DELIMITADOR_CODIGO_PREDECESORA_EXCEL, '') --//Obtener los valores de codigo predecesora sin su delimitador
																		
										IF @VALIDAR_CODIGO_PREDECESORA_EXCEL = ''
										Begin --> Validar si la celda esta vacía y no la registra 

											SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO4 = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO4 											
											+ CONVERT(VARCHAR,@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) 
											+ ', ' ;											

										End
									
										IF (@VALIDAR_CODIGO_PREDECESORA_EXCEL like '%[^0-9]%' or ISNUMERIC(@VALIDAR_CODIGO_PREDECESORA_EXCEL) = 0) AND LEN(@CODIGO_PREDECESORA_EXCEL) > 0
										Begin --> Validar si la celda tiene error y no la registra 

											SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4 = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4											
											+ CONVERT(VARCHAR,@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) 
											+ ', ' ;											

										End

										Begin  --Validar si los códigos de las unidades predecesoras referenciadas existen. 
										if @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4 =''
											begin
												set @ID_SEMESTRE_ACADEMICO_TMP =(select ID_SEMESTRE_ACADEMICO from transaccional.unidad_didactica where ID_UNIDAD_DIDACTICA=@ID_UNIDAD_DIDACTICA_TMP)
												SET @cont_predecesores_validos_ud	= 0
										
												select @cont_predecesores_validos_ud = count (1) from transaccional.unidad_didactica tbl1
												inner join transaccional.modulo tbl2 on tbl1.ID_MODULO= tbl2.ID_MODULO AND tbl2.ES_ACTIVO=1
												where 
												tbl2.ID_PLAN_ESTUDIO= @ID_PLAN_ESTUDIO AND 
												tbl1.ID_SEMESTRE_ACADEMICO< @ID_SEMESTRE_ACADEMICO_TMP and 
												tbl1.CODIGO_UNIDAD_DIDACTICA in (select SplitData from dbo.UFN_SPLIT (@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL))
												SET @cont_predecesores_validos_ud=ISNULL(@cont_predecesores_validos_ud,0)																		
												if (@cont_predecesores_validos_ud<> (select count (1)from dbo.UFN_SPLIT (@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL)))
												BEGIN
														set	@row_cod_uds_precedesores_no_existen = @row_cod_uds_precedesores_no_existen + convert(varchar(50),@ROW_INDEX_CODIGO_PREDECESORA_EXCEL) + ', ' ;
														set @VALIDAR_CODIGO_PREDECESORA_EXCEL=''
												END
											end											
										End 

										IF(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4='' and ISNUMERIC(@VALIDAR_CODIGO_PREDECESORA_EXCEL) = 1)
										Begin --> Validar si la celda contiene solo numeros fuera de los delimitadores 

												Begin --> Consultar funcion UFN_SPLIT, Iterar e ingresar datos. transaccional.unidad_didactica_detalle
													
														SELECT Id = SplitData INTO #TempParaWhile02_G4 																			--//FRAMOS CAMBIAR AQUI
														FROM dbo.UFN_SPLIT(@CODIGO_PREDECESORA_EXCEL,@DELIMITADOR_CODIGO_PREDECESORA_EXCEL);	--//Utilizando la funcion para obtener valores		
													
														DECLARE @CODIGO_PREDECESORA_A_INSERTAR_G4 INT = 0;																		--//FRAMOS CAMBIAR AQUI 													
														WHILE (SELECT COUNT(*) FROM #TempParaWhile02_G4) > 0																	--//FRAMOS CAMBIAR AQUI
														Begin								
															SELECT TOP 1 @CODIGO_PREDECESORA_A_INSERTAR_G4 = Id FROM #TempParaWhile02_G4											--//FRAMOS CAMBIAR AQUI	2												

																Begin --> Proceso a Iterar: transaccional.unidad_didactica_detalle - GRUPO 4

																	INSERT INTO transaccional.unidad_didactica_detalle
																	(
																		ID_UNIDAD_DIDACTICA
																		,CODIGO_PREDECESORA

																		,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION											
																	)
																	VALUES
																	(
																		--ID_UNIDAD_DIDACTICA
																		@ID_UNIDAD_DIDACTICA_TMP

																		--CODIGO_PREDECESORA
																		,@CODIGO_PREDECESORA_A_INSERTAR_G4																			--//FRAMOS CAMBIAR AQUI

																		,@ES_ACTIVO, @ESTADO, @USUARIO_CREACION, GETDATE()											
																	)													

																End														
							
															DELETE #TempParaWhile02_G4 WHERE Id = @CODIGO_PREDECESORA_A_INSERTAR_G4												--//FRAMOS CAMBIAR AQUI
														End
														DROP TABLE #TempParaWhile02_G4																							--//FRAMOS CAMBIAR AQUI											

												End									

										End									

									End
							
									DELETE #TempParaWhile01_G4 WHERE ID_UNIDAD_DIDACTICA = @ID_UNIDAD_DIDACTICA_TMP															--//FRAMOS CAMBIAR AQUI
								End
								
								IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO4 <> ''
								Begin
									SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO + 'Fila: ' + SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO4, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO4) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F se encuentra vacía.'+  @MSG_INFO +'|';	--//****
								End

								IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4 <> ''
								BEGIN
									IF @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR=''
										SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR = 'Fila: '+  SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4) - 1 ) + '  registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene un formato inválido.'+  @MSG_ERROR +'|';	--//****
									ELSE
										SET @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR = @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR+ ' Fila: '+  SUBSTRING (@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4, 1, Len(@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR4) - 1 ) + '  registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene un formato inválido.'+  @MSG_ERROR +'|';	--//****
								END
								if @row_cod_uds_precedesores_no_existen <> ''
								Begin
									set @INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_NOEXISTE_NOVALIDO =@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_NOEXISTE_NOVALIDO + 'Fila: ' +   SUBSTRING (@row_cod_uds_precedesores_no_existen, 1, Len(@row_cod_uds_precedesores_no_existen) - 1 ) + ' registrada(s) pero sin código(s) de U.D. predecesoras porque la columna F tiene código(s) inválido(s).'+  @MSG_ERROR +'|';	--//****									
								End			
							
								DROP TABLE #TempParaWhile01_G4																												--//FRAMOS CAMBIAR AQUI												

							End

						End
						ELSE
						Begin
							SET @INDEX_VALIDAR_GRUPO_VACIO = @INDEX_VALIDAR_GRUPO_VACIO + 'Fila: 80 hasta Fila 99 no registrada(s) porque no cuentan con Módulo Formativo, Total Horas o Total créditos U.D.' +  @MSG_INFO + '|'; 
						End

					End --> FIN: GRUPO - 4
										
				End --> FIN: GRUPO ESTANDAR

				Begin --> GRUPO - CONSOLIDADO 
					
					Begin --> transaccional.plan_estudio_detalle - CONSOLIDADO 

						INSERT INTO transaccional.plan_estudio_detalle 
						(
							ID_PLAN_ESTUDIO
							,ID_TIPO_UNIDAD_DIDACTICA
							,DESCRIPCION_CONSOLIDADO
							,SUMA_HORAS
							,SUMA_CREDITOS
							,PERIODO_ACADEMICO_I
							,PERIODO_ACADEMICO_II
							,PERIODO_ACADEMICO_III
							,PERIODO_ACADEMICO_IV
							,PERIODO_ACADEMICO_V
							,PERIODO_ACADEMICO_VI
							,PERIODO_ACADEMICO_VII --ADD
							,PERIODO_ACADEMICO_VIII --ADD
							,SUMA_TOTAL_HORAS_POR_TIPO
							,TOTAL_CREDITOS_UD
							,SUMA_TOTAL_CREDITOS_UD
							,ORDEN_VISUALIZACION
							,ES_ACTIVO, ESTADO, USUARIO_CREACION, FECHA_CREACION
						)

						OUTPUT INSERTED.ID_PLAN_ESTUDIO_DETALLE INTO @tblPlanEstudioDetalle_NuevoIdRegistrado(ID_PLAN_ESTUDIO_DETALLE)

						SELECT							
							(--ID_PLAN_ESTUDIO								
								@ID_PLAN_ESTUDIO
							)

							--ID_TIPO_UNIDAD_DIDACTICA			
							,CASE				--102,103,104
								WHEN (SELECT B FROM #tmp WHERE rowIndex = 127) = B THEN (SELECT ID_TIPO_UNIDAD_DIDACTICA FROM maestro.tipo_unidad_didactica ud WHERE ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA_ESPECIFICA)
								WHEN (SELECT B FROM #tmp WHERE rowIndex = 128) = B THEN (SELECT ID_TIPO_UNIDAD_DIDACTICA FROM maestro.tipo_unidad_didactica ud WHERE ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA_EMPLEABILIDAD)
								WHEN (SELECT B FROM #tmp WHERE rowIndex = 129) = B THEN (SELECT ID_TIPO_UNIDAD_DIDACTICA FROM maestro.tipo_unidad_didactica ud WHERE ud.ID_TIPO_UNIDAD_DIDACTICA = @ID_TIPO_UNIDAD_DIDACTICA_EXPERIENCIA_FORMATIVA)
								--ELSE ''
							END AS ID_TIPO_UNIDAD_DIDACTICA
								
							--DESCRIPCION_CONSOLIDADO			
							,CASE 
								WHEN B = '' THEN '0' --'ERROR' 
								WHEN B <> '' THEN B 
							END AS DESCRIPCION_CONSOLIDADO

							--SUMA_HORAS				
							,'' AS SUMA_HORAS

							--SUMA_CREDITOS				
							,'' AS SUMA_CREDITOS

							--PERIODO_ACADEMICO_I
							,CASE 
								WHEN G = '' THEN 0 --'ERROR' 
								WHEN G <> '' THEN convert(int,( convert(decimal, G)))
							 END AS PERIODO_ACADEMICO_I							
							--PERIODO_ACADEMICO_II
							,CASE 
								WHEN H = '' THEN 0 --'ERROR' 
								WHEN H <> '' THEN convert(int,( convert(decimal, H)))
							END AS PERIODO_ACADEMICO_II							
							--PERIODO_ACADEMICO_III
							,CASE 
								WHEN I = '' THEN 0 --'ERROR' 
								WHEN I <> '' THEN convert(int,( convert(decimal, I)))
							END AS PERIODO_ACADEMICO_III							
							--PERIODO_ACADEMICO_IV
							,CASE 
								WHEN J = '' THEN 0 --'ERROR' 
								WHEN J <> '' THEN convert(int,( convert(decimal, J)))
							END AS PERIODO_ACADEMICO_IV								
							--PERIODO_ACADEMICO_V
							,CASE 
								WHEN K = '' THEN 0 --'ERROR' 
								WHEN K <> '' THEN convert(int,( convert(decimal, K)))
							END AS PERIODO_ACADEMICO_V
							--PERIODO_ACADEMICO_VI
							,CASE 
								WHEN L = '' THEN 0 --'ERROR' 
								WHEN L <> '' THEN convert(int,( convert(decimal, L)))
							END AS PERIODO_ACADEMICO_VI							
							--PERIODO_ACADEMICO_VII --ADD
							,CASE 
								WHEN M = '' THEN 0 --'ERROR' 
								WHEN M <> '' THEN convert(int,( convert(decimal, M)))
							END AS PERIODO_ACADEMICO_VII	
							--PERIODO_ACADEMICO_VIII --ADD
							,CASE 
								WHEN N = '' THEN 0 --'ERROR' 
								WHEN N <> '' THEN convert(int,( convert(decimal, N)))
							END AS PERIODO_ACADEMICO_VIII						
							--SUMA_TOTAL_HORAS_POR_TIPO_UD
							,CASE 
								WHEN R = '' THEN 0 --'ERROR' ANTES P
								WHEN R <> '' THEN convert(int,( convert(decimal, R)))
							END AS SUMA_TOTAL_HORAS_POR_TIPO_UD						

							--TOTAL_CREDITOS_UD
							,CASE 
								WHEN U = '' THEN 0 --'ERROR' ANTES S
								WHEN U <> '' THEN convert(decimal(5,1),U)
							END AS TOTAL_CREDITOS_UD

							--SUMA_TOTAL_CREDITOS_UD
							,CASE 
								WHEN V = '' THEN 0 --'ERROR' ANTES T
								WHEN V <> '' THEN convert(decimal(5,1),V)
							END AS SUMA_TOTAL_CREDITOS_UD

							--ORDEN_VISUALIZACION
							,ROW_NUMBER() OVER (ORDER BY rowIndex)  
							AS ORDEN_VISUALIZACION

							,@ES_ACTIVO,	@ESTADO,	@USUARIO_CREACION,	GETDATE()
						FROM #tmp
						WHERE 1 = 1		
						AND rowIndex BETWEEN 127 AND 130		--RANGO DE FILAS DEL CONSOLIDADDO  --102 AND 105
						AND B <> ''								--PARA MODULAR FORMATEO 2
						ORDER BY CONVERT(INT, rowIndex) ASC					
						
						--//Filas registradas pero con algun VALOR en = 0		
						SELECT @INDEX_REGISTRADOS_CONSOLIDADOS_CERO = COALESCE(@INDEX_REGISTRADOS_CONSOLIDADOS_CERO,'') + 'Fila ' + rowIndex + ' registrada pero uno de sus valores es igual a 0.'+@MSG_INFO+'|'
						FROM transaccional.plan_estudio_detalle ped
						inner join #tmp tmp ON ped.DESCRIPCION_CONSOLIDADO = tmp.B
						WHERE --1 = 1
						( ped.PERIODO_ACADEMICO_I = 0
						OR ped.PERIODO_ACADEMICO_II = 0
						OR ped.PERIODO_ACADEMICO_III = 0
						OR ped.PERIODO_ACADEMICO_IV = 0
						OR ped.PERIODO_ACADEMICO_V = 0
						OR ped.PERIODO_ACADEMICO_VI = 0
						OR ped.PERIODO_ACADEMICO_VII = 0 --ADD
						OR ped.PERIODO_ACADEMICO_VIII = 0 --ADD
						OR ped.SUMA_TOTAL_HORAS_POR_TIPO = 0 )
						AND ped.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
						AND tmp.rowIndex BETWEEN 127 AND 130			--RANGO DE FILAS DEL CONSOLIDADO  --102  AND 105 

						--//Filas registradas pero con algun VALOR en = 0
						SELECT @INDEX_REGISTRADOS_CONSOLIDADOS_CERO = COALESCE(@INDEX_REGISTRADOS_CONSOLIDADOS_CERO,'') + 'Fila ' + rowIndex + ' registrada pero uno de sus valores es igual a 0.' +  @MSG_INFO + '|'
						FROM transaccional.plan_estudio_detalle ped
						inner join #tmp tmp ON ped.DESCRIPCION_CONSOLIDADO = tmp.B
						WHERE 1 = 1
						AND ped.ID_PLAN_ESTUDIO = @ID_PLAN_ESTUDIO
						AND tmp.rowIndex = 130							--ULTIMA FILA DEL BLOQUE DEL CONSOLIDADO  --1005
						AND (ped.TOTAL_CREDITOS_UD = 0 OR ped.SUMA_TOTAL_CREDITOS_UD = 0)		
				
					End

				End --> FIN: GRUPO - CONSOLIDADO

			End --> FIN: REGISTRAR EN LA BASE DE DATOS
		
		End

	End

--*******************************************************************************************************************************************************************************************************************
	
	Begin --> ELIMINAR TABLA TEMPORAL 
	DROP TABLE #tmp
	--IF 1 = 0 SELECT 1 --Para que no se caiga el Begin End
	End
		
	Begin --> RESPUESTA FINAL 
	
			SET @RESPUETA_MENSAJE = @INDEX_NO_REGISTRADOS_ID_TIPO_ENFOQUE + 									
									@INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO + 
									@INDEX_NO_REGISTRADOS_CODIGO_UD_VACIO + 
									@INDEX_NO_REGISTRADOS_CODIGO_UD_INVALIDO +
									@INDEX_NO_REGISTRADOS_CODIGO_UD_REPETIDO +
									@INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_PERIODO_ACADEMICO + 
									@INDEX_NO_REGISTRADOS_DATOS_NO_UNICOS_PERIODO_ACADEMICO +
									@INDEX_NO_REGISTRADOS_DATOS_HORAS_VACIAS+
									@INDEX_NO_REGISTRADOS_DATOS_HORAS_MULTIPLES + 
									@INDEX_NO_REGISTRADOS_DATOS_VACIOS_HORAS  + --???
									@INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_HORAS +
									@INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_HORAS + 
									@INDEX_NO_REGISTRADOS_DATOS_VACIOS_CREDITOS + 
									@INDEX_NO_REGISTRADOS_DATOS_NO_NUMERICOS_CREDITOS+ 
									@INDEX_NO_REGISTRADOS_DATOS_NO_SUMA_IGUAL_CREDITOS +
									@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_NOEXISTE_NOVALIDO + 
									@INDEX_REGISTRADOS_HORAS_VACIO + 
									@INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO + 									
									@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_VACIO + 
									@INDEX_NO_REGISTRADOS_CODIGO_PREDECESORA_ERROR + 
									@INDEX_VALIDAR_GRUPO_VACIO +									
									@INDEX_REGISTRADOS_CONSOLIDADOS_CERO 
									

			
			if @RESPUETA_MENSAJE ='' 			
			set @RESPUETA_MENSAJE = 'El archivo excel se registró correctamente. No se encontraron observaciones.'			
										
			SELECT 
				EstadoProceso = '1'
				,Mensajes = @RESPUETA_MENSAJE																								,LineaError = @LINEA_ERROR
				,IdPlanEstudio = @ID_PLAN_ESTUDIO

				,INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO			= @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO
				,INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO	= @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO
				,INDEX_REGISTRADOS_CONSOLIDADOS_CERO			= @INDEX_REGISTRADOS_CONSOLIDADOS_CERO 				


			--//VISOR DE MENSAJES SOLO PARA PRUEBA DESCOMENTAR.
			--SELECT SplitData AS 'Lista de Mensajes'  FROM dbo.UFN_SPLIT(@RESPUETA_MENSAJE,'|');
			
	End

	COMMIT TRAN InsertarPlanEstudios
END	TRY
BEGIN CATCH
	
	Begin --> RESPUESTA EN EL CASO DE QUE SE GENERE ERROR 

	SELECT 
		EstadoProceso = '0'
		,Mensajes = @RESPUETA_MENSAJE																								,LineaError = @LINEA_ERROR 

		--PRUEBAS
		,ERROR_MESSAGE() AS 'ERROR_MESSAGE'
		,CAST(ERROR_LINE() AS VARCHAR(100)) AS 'ERROR_LINE'

		,INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO			= @INDEX_NO_REGISTRADOS_NOMBRE_UD_VACIO
		,INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO	= @INDEX_REGISTRADOS_ID_SEMESTRE_ACADEMICO_CERO
		,INDEX_REGISTRADOS_CONSOLIDADOS_CERO			= @INDEX_REGISTRADOS_CONSOLIDADOS_CERO
		

		,CAST(ERROR_NUMBER() AS VARCHAR(MAX)) AS 'ERROR_NUMBER'
		,CAST( ERROR_SEVERITY() AS VARCHAR(MAX)) AS 'ERROR_SEVERITY'
		,CAST(ERROR_STATE() AS VARCHAR(MAX))AS 'ERROR_STATE'
		,ERROR_PROCEDURE() AS 'ERROR_PROCEDURE'
		--,ERROR_LINE() AS 'ERROR_LINE'
		--,ERROR_MESSAGE() AS 'ERROR_MESSAGE' 
		

	ROLLBACK TRAN InsertarPlanEstudios

	End

END CATCH
GO


