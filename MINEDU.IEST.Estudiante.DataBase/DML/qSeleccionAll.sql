-- Write your own SQL object definition here, and it'll be included in your package.
-- use db_regia_2
---ESTUDIANTE
SELECT top 50 * FROM maestro.persona where ID_PERSONA = 2467 order by 1 desc
SELECT top 10 * FROM maestro.persona_institucion where ID_PERSONA_INSTITUCION = 2484
SELECT top 10 * FROM transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 2484   ----
select * from transaccional.carreras_por_institucion_detalle where ID_CARRERAS_POR_INSTITUCION_DETALLE = 3558
select top 10 * from transaccional.carreras_por_institucion where ID_CARRERAS_POR_INSTITUCION = 3365
select * from db_digepadron.dbo.carrera where ID_CARRERA = 1327

select top 10 * from transaccional.plan_estudio where ID_PLAN_ESTUDIO = 5064

select top 20 * From transaccional.plan_estudio_detalle where ID_PLAN_ESTUDIO = 2592
SELECT * FROM db_auxiliar.dbo.UVW_INSTITUCION where ID_INSTITUCION = 1153
SELECT * FROM db_digepadron.dbo.UVW_INSTITUCION where ID_INSTITUCION = 1153
select * from transaccional.postulantes_por_modalidad where ID_PERSONA_INSTITUCION = 209725
--select top 10 * from maestro.carrera_profesional where ID_CARRERA_PROFESIONAL = 2166
--SELECT top 50 * FROM transaccional.estudiante_institucion where ANIO_EGRESO is null and ID_PERSONA_INSTITUCION = 2484  order by 1 desc


select * from transaccional.plan_estudio_detalle where ID_PLAN_ESTUDIO = 160
select * from sistema.enumerado where ID_ENUMERADO = 100
------

SELECT  p.PAIS_NACIMIENTO , COUNT(1)
FROM maestro.persona p
GROUP BY p.PAIS_NACIMIENTO 




--------------


SELECT top 50 * FROM maestro.personal_institucion where ID_PERSONA_INSTITUCION = 2484   ----


-----------------
select * from maestro.persona_institucion where ID_PERSONA = 150045
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION in(151141)

-----PERFIL

SELECT top 10 ESTADO,* FROM transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 151141   ----

SELECT * FROM transaccional.periodos_lectivos_por_institucion where ID_PERIODOS_LECTIVOS_POR_INSTITUCION = 3906
select * from maestro.periodo_lectivo where ID_PERIODO_LECTIVO = 5

SELECT ESTADO,COUNT(1) FROM transaccional.estudiante_institucion GROUP by ESTADO


----tipos
select * from sistema.tipo_enumerado ---where ID_TIPO_ENUMERADO = 2
select * from sistema.enumerado where ID_TIPO_ENUMERADO = 413

-----PRE MATRICULA---------------------
SELECT top 10 * FROM transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 151141
SELECT top 10 * FROM transaccional.matricula_estudiante where ID_ESTUDIANTE_INSTITUCION = 136811
SELECT top 10 * FROM transaccional.programacion_clase_por_matricula_estudiante where ID_MATRICULA_ESTUDIANTE = 70847
SELECT top 10 * FROM transaccional.programacion_clase where ID_PROGRAMACION_CLASE = 31579
SELECT top 10 * FROM transaccional.unidades_didacticas_por_programacion_clase where ID_PROGRAMACION_CLASE = 31579
SELECT top 10 * FROM transaccional.unidades_didacticas_por_enfoque where ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = 3991
SELECT top 10 * FROM transaccional.unidad_didactica where ID_UNIDAD_DIDACTICA = 5448
SELECT top 10 * FROM transaccional.sesion_programacion_clase where ID_PROGRAMACION_CLASE = 31579

select * from transaccional.evaluacion where ID_PROGRAMACION_CLASE = 31579
select * from transaccional.evaluacion_detalle where ID_EVALUACION = 21637 and ID_MATRICULA_ESTUDIANTE = 70801
select * from transaccional.programacion_clase where ID_PROGRAMACION_CLASE = 31579
select * from transaccional.unidad_didactica where ID_UNIDAD_DIDACTICA = 5448


select * from transaccional.matricula_estudiante where ID_MATRICULA_ESTUDIANTE = 70801
select * from transaccional.programacion_clase_por_matricula_estudiante where ID_MATRICULA_ESTUDIANTE = 70801
select top 100 * from transaccional.programacion_clase where ID_EVALUACION is not null

select top 10 * from transaccional.modulo

SELECT top 50 * FROM transaccional.programacion_clase order by 1 desc


---------------------------------------

SELECT top 10 * FROM transaccional.promocion_institucion_estudiante ORDER by 1 DESC
SELECT COUNT(1) FROM transaccional.promocion_institucion_estudiante


-----------------

------lista de cursos siguientes matricula	:	USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO
------cabecera datos generales				:	USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA
------Detalle programacion curs				:	USP_MATRICULA_SEL_PROGRAMACION_CLASE
------graba las matriculas					:	USP_MATRICULA_INS_MATRICULA_ESTUDIANTE

sp_helptext USP_MATRICULA_SEL_PROGRAMACION_CLASE



USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA 1366,113


-------




----alumno en 2 instituciones 
select * from maestro.persona_institucion where ID_PERSONA = 371324--371420

----alumno en 2 carreas
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 413231

--IdPersonas
--IdPersonaInstitucion
--IdCarrera




--------------------\\10.200.4.164\Registra\P\ESTUDIANTES_FOTOS\c1ad2af9-64ea-4581-b9c3-02ee01f7c4be.jpeg

SELECT PAIS_NACIMIENTO, COUNT(1) FROM maestro.persona group by PAIS_NACIMIENTO 

---ESTUDIANTE
--SELECT * FROM maestro.persona WHERE PAIS_NACIMIENTO = 186

select * from maestro.persona where ID_PERSONA = 150053
select * from maestro.persona_institucion where ID_PERSONA = 150053
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 151149

SELECT top 50 * FROM maestro.persona where ID_PERSONA = 371324 order by 1 desc
SELECT top 10 * FROM maestro.persona_institucion where ID_PERSONA = 371324
SELECT top 10 * FROM transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 382829   ----
select * from transaccional.carreras_por_institucion_detalle where ID_CARRERAS_POR_INSTITUCION_DETALLE = 3558
select top 10 * from transaccional.carreras_por_institucion where ID_CARRERAS_POR_INSTITUCION = 3365
select * from db_digepadron.dbo.carrera where ID_CARRERA = 1327
go
select top 50 * from transaccional.postulantes_por_modalidad where ID_PERSONA_INSTITUCION = 382829
select * from maestro.institucion_basica  WHERE ID_INSTITUCION_BASICA = 35513
select * from maestro.turnos_por_institucion where ID_TURNOS_POR_INSTITUCION = 658
select * from maestro.turno_equivalencia where ID_TURNO_EQUIVALENCIA = 1
select * from sistema.enumerado where ID_TIPO_ENUMERADO = 5
select * from sistema.tipo_enumerado where ID_TIPO_ENUMERADO = 5

select * from transaccional.periodos_lectivos_por_institucion where ID_PERIODOS_LECTIVOS_POR_INSTITUCION = 7695 
select * from maestro.periodo_lectivo where ID_PERIODO_LECTIVO = 9


select top 50 * from transaccional.postulantes_por_modalidad ORDER by 1 DESC


select * from sistema.tipo_enumerado where ID_TIPO_ENUMERADO = 92330
select * from sistema.enumerado where ID_TIPO_ENUMERADO = 25

select * from sistema.enumerado where ID_ENUMERADO = 92330

select * from sistema.enumerado WHERE ID_ENUMERADO = 5

SELECT top 10 * FROM maestro.sede_institucion WHERE ID_SEDE_INSTITUCION = 1577
SELECT * FROM db_digepadron.dbo.institucion WHERE ID_INSTITUCION = 1631

select top 20  * from transaccional.estudiante_institucion where len(APELLIDO_APODERADO) > 0

select * from sistema.enumerado where ID_ENUMERADO = 318



------------------------pruebas sp

SELECT * FROM db_auxiliar.dbo.UVW_INSTITUCION where ID_INSTITUCION = 1153
sp_helptext USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO

USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA 1366,113


USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO 2164,3774,3713,113,122281,223474,0,0
exec USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO 2164,3774,3713,113,122281,223474,0  

USP_MATRICULA_SEL_PROGRAMACION_CLASE 1911,3882,112155


SELECT top 50 * FROM maestro.persona where ID_PERSONA = 371324

select top 10 * from maestro.persona 

go

select top 10 * from Security.Users
go


select distinct top 100  p.* 
from transaccional.estudiante_institucion e
inner join maestro.persona_institucion  pi on pi.ID_PERSONA_INSTITUCION = e.ID_PERSONA_INSTITUCION
inner join maestro.persona p on p.ID_PERSONA = pi.ID_PERSONA
where YEAR( p.FECHA_NACIMIENTO_PERSONA )=2002
and e.ESTADO = 1 and e.ES_ACTIVO = 1
order by p.ID_PERSONA desc
go
select * from Security.Users

select * from maestro.persona where ID_PERSONA= 371324



select * from maestro.persona where ID_PERSONA = 150031
select * from maestro.persona_institucion where ID_PERSONA = 150031
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 151127
go


select top 10 * from transaccional.periodos_lectivos_por_institucion where ID_INSTITUCION = 1799 ---identidicar cual es abierto....

go


SELECT ID_PERIODO_ACADEMICO,ESTADO = (CASE WHEN SUM(ESTADO)>0 THEN 1 ELSE 0 END)
FROM (
	SELECT DISTINCT ID_PERIODO_ACADEMICO,ESTADO
	FROM transaccional.programacion_clase
	WHERE ES_ACTIVO=1
) p
GROUP BY ID_PERIODO_ACADEMICO


--------


SELECT p.ID_PERIODO_ACADEMICO,ESTADO = (CASE WHEN SUM(p.ESTADO)>0 THEN 1 ELSE 0 END)
FROM (
	SELECT DISTINCT ID_PERIODO_ACADEMICO,ESTADO
	FROM transaccional.programacion_clase
	WHERE ES_ACTIVO=1
) p
INNER JOIN transaccional.periodo_academico pa ON p.ID_PERIODO_ACADEMICO=pa.ID_PERIODO_ACADEMICO
INNER JOIN transaccional.periodos_lectivos_por_institucion plpi ON pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
WHERE ID_INSTITUCION=1799
GROUP BY p.ID_PERIODO_ACADEMICO

-----------------
SELECT distinct TOP 10  p.ID_PERIODO_ACADEMICO, p.ESTADO
FROM transaccional.programacion_clase p
INNER JOIN transaccional.periodo_academico pa ON p.ID_PERIODO_ACADEMICO=pa.ID_PERIODO_ACADEMICO
INNER JOIN transaccional.periodos_lectivos_por_institucion plpi ON pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
WHERE plpi.ID_INSTITUCION=1799
and p.ES_ACTIVO = 1

select top 10 * from transaccional.periodo_academico pa
select top 10 * from transaccional.periodos_lectivos_por_institucion pa

select * from maestro.persona where ID_PERSONA = 152143


select top 100  e.* from transaccional.estudiante_institucion e where e.ID_TIPO_PARENTESCO > 0 and e.ESTADO = 1 and e.ES_ACTIVO = 1 order by 1 desc
go

select * from Security.Roles

select * from Security.Users where Id_Persona = 150103

select * From Security.UserRoles

----------doble institucion

select * from maestro.persona_institucion where ID_PERSONA = 152143
go
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION in (153285,153289)
go

select * from maestro.persona where ID_PERSONA =150103 
select * from maestro.persona_institucion where ID_PERSONA = 150103
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION in(151214,151223,151235,153261)

select * from transaccional.carreras_por_institucion_detalle where ID_CARRERAS_POR_INSTITUCION_DETALLE = 2166
select top 10 * from transaccional.carreras_por_institucion where ID_CARRERAS_POR_INSTITUCION = 2896

select * from maestro.persona_institucion where ID_PERSONA = 150045

select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION in(151141)

SELECT * FROM db_auxiliar.dbo.UVW_INSTITUCION where ID_INSTITUCION in (1968,2680)

SELECT * FROM db_auxiliar.dbo.UVW_INSTITUCION where ID_INSTITUCION in (1968,2680)

go

select p.ID_TIPO_DOCUMENTO, COUNT(1) from maestro.persona p group by p.ID_TIPO_DOCUMENTO

go

select * from sistema.enumerado where ID_ENUMERADO in (26,27,317,28)

select * from maestro.persona where ID_TIPO_DOCUMENTO = 317

-----------

------lista de cursos siguientes matricula	:	USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO
------cabecera datos generales				:	USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA
------Detalle programacion curs				:	USP_MATRICULA_SEL_PROGRAMACION_CLASE
------graba las matriculas					:	USP_MATRICULA_INS_MATRICULA_ESTUDIANTE

sp_helptext USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA

select * from sistema.parametro

go

sp_helptext USP_MATRICULA_INS_MATRICULA_ESTUDIANTE





/*
TEST PRE-MATRICULA
*/


SELECT TOP 10 * FROM transaccional.matricula_estudiante ORDER BY 1 DESC
SELECT * FROM transaccional.matricula_estudiante where ID_ESTUDIANTE_INSTITUCION = 137952 ORDER BY FECHA_MATRICULA desc

select * from 
GO
SELECT TOP 10 * FROM transaccional.programacion_clase_por_matricula_estudiante ORDER BY 1 DESC
GO

select * from transaccional.programacion_matricula where ID_PERIODOS_LECTIVOS_POR_INSTITUCION = 3959


select * from transaccional.evaluacion where ID_PROGRAMACION_CLASE = 15626
select * from transaccional.evaluacion_detalle where ID_EVALUACION = 2585 and ID_MATRICULA_ESTUDIANTE = 44532

select * from transaccional.matricula_estudiante where ID_MATRICULA_ESTUDIANTE = 44532
select * from transaccional.programacion_clase_por_matricula_estudiante where ID_MATRICULA_ESTUDIANTE = 44532

select * from transaccional.unidades_didacticas_por_programacion_clase where ID_PROGRAMACION_CLASE = 15635
select * from transaccional.unidades_didacticas_por_enfoque where ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = 40429
select * from transaccional.unidad_didactica where ID_UNIDAD_DIDACTICA = 45003


select * from transaccional.programacion_clase where ID_PROGRAMACION_CLASE = 31579
select * from transaccional.unidad_didactica where ID_UNIDAD_DIDACTICA = 5448

select * from sistema.enumerado where ID_ENUMERADO = 170
select * from sistema.enumerado where ID_TIPO_ENUMERADO = 52


EXEC USP_REPORTE_MONITOREO_MATRICULA 3938

exec USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE 221,26,'75571952',27,1311,1258,403

exec USP_EVALUACION_SEL_ESTUDIANTE_INSTITUTO 607,4039,26,73182945


go

select * from transaccional.matricula_estudiante where ID_MATRICULA_ESTUDIANTE = 228875
select * from transaccional.programacion_clase_por_matricula_estudiante where ID_MATRICULA_ESTUDIANTE = 228875
select * from transaccional.programacion_clase where ID_PROGRAMACION_CLASE = 15626
select * from transaccional.sesion_programacion_clase where ID_PROGRAMACION_CLASE = 15626
select * from transaccional.unidades_didacticas_por_programacion_clase where ID_PROGRAMACION_CLASE = 15738
select * from transaccional.unidades_didacticas_por_enfoque where ID_UNIDADES_DIDACTICAS_POR_ENFOQUE = 40408
select * from transaccional.unidad_didactica where ID_UNIDAD_DIDACTICA = 44982
select * from maestro.aula where ID_AULA = 3878
select * from maestro.sede_institucion where ID_SEDE_INSTITUCION = 196
go

select * from transaccional.programacion_clase where ID_PERSONAL_INSTITUCION
select * from maestro.persona where ID_PERSONA = 6262
select * from maestro.persona_institucion where ID_PERSONA = 6262
select * from maestro.personal_institucion where ID_PERSONA_INSTITUCION = 6280

---2022-1

select * from sistema.enumerado where ID_TIPO_ENUMERADO = 38



sp_helptext USP_EVALUACION_SEL_INFORMACION_ACADEMICA_GESTIONAR


go


USP_EVALUACION_SEL_ESTUDIANTE_INSTITUTO 607,4039,26,73182945

USP_EVALUACION_SEL_INFORMACION_ACADEMICA_GESTIONAR 7843,45093,3
USP_EVALUACION_SEL_INFORMACION_ACADEMICA_GESTIONAR 4139,137928,9

EXEC USP_MATRICULA_RPT_BOLETA_NOTAS 228850,4133

go

sp_helptext USP_MATRICULA_RPT_BOLETA_NOTAS


select * from maestro.periodo_lectivo where ID_PERIODO_LECTIVO = 3903


------------------------query con JM


select * from transaccional.matricula_estudiante where ID_ESTUDIANTE_INSTITUCION = 103029
select * from transaccional.estudiante_institucion where ID_ESTUDIANTE_INSTITUCION = 103029
select * from maestro.persona_institucion where ID_PERSONA_INSTITUCION = 118209
select * from maestro.persona where ID_PERSONA = 117512

select top 10 * from db_auxiliar..UVW_UBIGEO_RENIEC where CODIGO_UBIGEO = '010202'
select top 100 * from db_auxiliar..UVW_UBIGEO_RENIEC where (DEPARTAMENTO_UBIGEO + PROVINCIA_UBIGEO + DISTRITO_UBIGEO )  like '%RIMAC%'

sp_helptext db_auxiliar..UVW_UBIGEO_RENIEC

select * from transaccional.programacion_matricula where ID_PERIODOS_LECTIVOS_POR_INSTITUCION = 1329

SELECT distinct TOP 10  p.ID_PERIODO_ACADEMICO, plpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION ,pl.CODIGO_PERIODO_LECTIVO , p.ESTADO
FROM transaccional.programacion_clase p
INNER JOIN transaccional.periodo_academico pa ON p.ID_PERIODO_ACADEMICO=pa.ID_PERIODO_ACADEMICO
INNER JOIN transaccional.periodos_lectivos_por_institucion plpi ON pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
INNER join maestro.periodo_lectivo pl on plpi.ID_PERIODO_LECTIVO = pl.ID_PERIODO_LECTIVO
WHERE plpi.ID_INSTITUCION=827
and p.ES_ACTIVO = 1 and p.ESTADO = 1
go

 SELECT [u].[CODIGO_UBIGEO], [u].[DEPARTAMENTO_UBIGEO], [u].[DISTRITO_UBIGEO], [u].[PROVINCIA_UBIGEO]
      FROM [UVW_UBIGEO_RENIEC] AS [u]
      WHERE (((@__filtro_0 LIKE N'') OR (CHARINDEX(@__filtro_0, [u].[DEPARTAMENTO_UBIGEO]) > 0)) OR ((@__filtro_0 LIKE N'') OR (CHARINDEX(@__filtro_0, [u].[PROVINCIA_UBIGEO]) > 0))) OR ((@__filtro_0 LIKE N'') OR (CHARINDEX(@__filtro_0, [u].[DISTRITO_UBIGEO]) > 0))
      ORDER BY (SELECT 1)
      OFFSET @__p_1 ROWS

update maestro.persona_institucion
set UBIGEO_PERSONA = '010202'
where ID_PERSONA_INSTITUCION = 118209


update maestro.persona_institucion
set CORREO = 'camoens1@outlook.com'
where ID_PERSONA_INSTITUCION = 118209
010202


update transaccional.programacion_matricula
	set FECHA_INICIO = '2022-10-01', FECHA_FIN = '2022-10-20'
where ID_PROGRAMACION_MATRICULA = 333


go
select top 10 * from db_auxiliar..UVW_UBIGEO_RENIEC where CODIGO_UBIGEO = '071002'

SELECT pl.*
    FROM transaccional.periodos_lectivos_por_institucion a
    inner join maestro.periodo_lectivo pl on a.ID_PERIODO_LECTIVO = pl.ID_PERIODO_LECTIVO
where a.ID_PERIODOS_LECTIVOS_POR_INSTITUCION= 1519

go

select * from sistema.enumerado where ID_TIPO_ENUMERADO = 60
select * from sistema.enumerado where ID_ENUMERADO = 112


SELECT * FROM transaccional.carreras_por_institucion_detalle where ID_CARRERAS_POR_INSTITUCION_DETALLE = 616
select * from maestro.sede_institucion where ID_SEDE_INSTITUCION = 154


go


sp_helptext USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA

select top 50 * from transaccional.matricula_estudiante where ID_MATRICULA_ESTUDIANTE = 228876 order by 1 DESC

select * from transaccional.programacion_clase_por_matricula_estudiante where ID_MATRICULA_ESTUDIANTE = 228876



	SELECT distinct TOP 10  p.ID_PERIODO_ACADEMICO, plpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION ,pl.CODIGO_PERIODO_LECTIVO , p.ESTADO
FROM transaccional.programacion_clase p
INNER JOIN transaccional.periodo_academico pa ON p.ID_PERIODO_ACADEMICO=pa.ID_PERIODO_ACADEMICO
INNER JOIN transaccional.periodos_lectivos_por_institucion plpi ON pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
INNER join maestro.periodo_lectivo pl on plpi.ID_PERIODO_LECTIVO = pl.ID_PERIODO_LECTIVO
WHERE plpi.ID_INSTITUCION=1911
and p.ES_ACTIVO = 1 and p.ESTADO = 1
go


SELECT top 10 * FROM db_auxiliar.dbo.UVW_UBIGEO_RENIEC



go




SELECT distinct TOP 10 p.ID_PROGRAMACION_CLASE ,p.ID_PERIODO_ACADEMICO, plpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION ,pl.CODIGO_PERIODO_LECTIVO , p.ESTADO
FROM transaccional.programacion_clase p
INNER JOIN transaccional.periodo_academico pa ON p.ID_PERIODO_ACADEMICO=pa.ID_PERIODO_ACADEMICO
INNER JOIN transaccional.periodos_lectivos_por_institucion plpi ON pa.ID_PERIODOS_LECTIVOS_POR_INSTITUCION=plpi.ID_PERIODOS_LECTIVOS_POR_INSTITUCION
INNER join maestro.periodo_lectivo pl on plpi.ID_PERIODO_LECTIVO = pl.ID_PERIODO_LECTIVO
WHERE plpi.ID_INSTITUCION=1911
and p.ES_ACTIVO = 1 and p.ESTADO = 1
go

select * from transaccional.programacion_matricula where ID_PERIODOS_LECTIVOS_POR_INSTITUCION = 4139



select * from maestro.persona_institucion where ID_PERSONA_INSTITUCION = 151172


select top 10 * from transaccional.matricula_estudiante order by 1 desc


select top 10 * from transaccional.programacion_clase
go

SELECT distinct top 1 [p].[ID_PERIODO_ACADEMICO], [p0].[ID_PERIODO_ACADEMICO], [p].[ESTADO], [p0].[ID_PERIODOS_LECTIVOS_POR_INSTITUCION], [p1].[ID_PERIODO_LECTIVO], [p2].[CODIGO_PERIODO_LECTIVO]
FROM [transaccional].[programacion_clase] AS [p]
  INNER JOIN [transaccional].[periodo_academico] AS [p0] ON [p].[ID_PERIODO_ACADEMICO] = [p0].[ID_PERIODO_ACADEMICO]      
  INNER JOIN [transaccional].[periodos_lectivos_por_institucion] AS [p1] ON [p0].[ID_PERIODOS_LECTIVOS_POR_INSTITUCION] = [p1].[ID_PERIODOS_LECTIVOS_POR_INSTITUCION]
  INNER JOIN [maestro].[periodo_lectivo] AS [p2] ON [p1].[ID_PERIODO_LECTIVO] = [p2].[ID_PERIODO_LECTIVO]
WHERE (([p1].[ID_INSTITUCION] =827) AND ([p].[ESTADO] = 1)) AND ([p].[ES_ACTIVO] = CAST(1 AS bit))
go

select * from transaccional.programacion_clase where ID_PERIODO_ACADEMICO = 3882

go

SELECT * from [Security].Users
go

select top 100 pi.ID_PERSONA_INSTITUCION, ei.ID_ESTUDIANTE_INSTITUCION ,p.NUMERO_DOCUMENTO_PERSONA, p.APELLIDO_PATERNO_PERSONA, p.APELLIDO_MATERNO_PERSONA, p.NOMBRE_PERSONA, pi.CORREO
from transaccional.matricula_estudiante me
inner join transaccional.estudiante_institucion ei on me.ID_ESTUDIANTE_INSTITUCION = ei.ID_ESTUDIANTE_INSTITUCION
inner join 	maestro.persona_institucion pi on pi.ID_PERSONA_INSTITUCION = ei.ID_PERSONA_INSTITUCION
inner join maestro.persona p on p.ID_PERSONA = pi.ID_PERSONA
left join [Security].Users u on u.Id_Persona = p.ID_PERSONA
where ei.ESTADO = 1 and ei.ES_ACTIVO = 1
ORDER by me.ID_MATRICULA_ESTUDIANTE DESC

------------------
ID_PERSONA_INSTITUCION	ID_ESTUDIANTE_INSTITUCION	NUMERO_DOCUMENTO_PERSONA	APELLIDO_PATERNO_PERSONA	APELLIDO_MATERNO_PERSONA	NOMBRE_PERSONA	CORREO
129264	114867	44977275	LOPEZ	TINEO	YUDITH	lopeztineoyudith@gmail.com




select * from transaccional.matricula_estudiante where ID_ESTUDIANTE_INSTITUCION = 114862
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 129259

select * from maestro.persona_institucion where ID_PERSONA_INSTITUCION = 129259
select * from maestro.persona where ID_PERSONA = 128429

go

select top 10 * from sistema.enumerado 

USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE 221,26,'73046240',27,1255,442,403 	
USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE 221,26,'73046240',27,1255,442,3842 	
USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE 221,26,'75571952',27,1311,1258,403 

GO

USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE_test_ilozano 221,26,'75571952',27,1311,1258,403

SELECT top 10  VALOR_ENUMERADO FROM sistema.enumerado

GO

SELECT * FROM maestro.persona where NUMERO_DOCUMENTO_PERSONA = '48607394'

select * from maestro.persona_institucion where ID_PERSONA = 128431

select * from [Security].Users where Id_Persona = 128431


USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_ESTUDIANTE 114862,1329
go

sp_helptext USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_ESTUDIANTE