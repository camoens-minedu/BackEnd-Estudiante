-- Write your own SQL object definition here, and it'll be included in your package.
-- use db_regia_2
---ESTUDIANTE
SELECT top 50 * FROM maestro.persona where ID_PERSONA = 2467 order by 1 desc
SELECT top 10 * FROM maestro.persona_institucion where ID_PERSONA_INSTITUCION = 2484
SELECT top 10 * FROM transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 2484   ----
select * from transaccional.carreras_por_institucion_detalle where ID_CARRERAS_POR_INSTITUCION_DETALLE = 3558
select top 10 * from transaccional.carreras_por_institucion where ID_CARRERAS_POR_INSTITUCION = 3365
select * from db_digepadron.dbo.carrera where ID_CARRERA = 1327

select * from transaccional.plan_estudio where ID_PLAN_ESTUDIO = 5064

select top 20 * From transaccional.plan_estudio_detalle where ID_PLAN_ESTUDIO = 2592
SELECT * FROM db_auxiliar.dbo.UVW_INSTITUCION where ID_INSTITUCION = 1153
SELECT * FROM db_digepadron.dbo.UVW_INSTITUCION where ID_INSTITUCION = 1153
select * from transaccional.postulantes_por_modalidad where ID_PERSONA_INSTITUCION = 209725
--select top 10 * from maestro.carrera_profesional where ID_CARRERA_PROFESIONAL = 2166
--SELECT top 50 * FROM transaccional.estudiante_institucion where ANIO_EGRESO is null and ID_PERSONA_INSTITUCION = 2484  order by 1 desc


select * from transaccional.plan_estudio_detalle where ID_PLAN_ESTUDIO = 160

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
select * from transaccional.evaluacion_detalle where ID_EVALUACION = 21637

select * from transaccional.modulo

SELECT top 50 * FROM transaccional.programacion_clase order by 1 desc

---------------------------------------

SELECT top 10 * FROM transaccional.promocion_institucion_estudiante ORDER by 1 DESC
SELECT COUNT(1) FROM transaccional.promocion_institucion_estudiante


-----------------

------lista de cursos siguientes matricula	:	USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO
------cabecera datos generales				:	USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA
------Detalle programacion curs				:	USP_MATRICULA_SEL_PROGRAMACION_CLASE
------graba las matriculas					:	USP_MATRICULA_INS_MATRICULA_ESTUDIANTE






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

SELECT * FROM maestro.sede_institucion WHERE ID_SEDE_INSTITUCION = 1577
SELECT * FROM db_digepadron.dbo.institucion WHERE ID_INSTITUCION = 1631

select top 20  * from transaccional.estudiante_institucion where len(APELLIDO_APODERADO) > 0

select * from sistema.enumerado where ID_ENUMERADO = 318



------------------------pruebas sp

SELECT * FROM db_auxiliar.dbo.UVW_INSTITUCION where ID_INSTITUCION = 1153


USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA 1366,113


USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO 2164,3774,3713,113,122281,223474,0,0


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

select * from transaccional.carreras_por_institucion_detalle where ID_CARRERAS_POR_INSTITUCION_DETALLE = 3035
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