-- Write your own SQL object definition here, and it'll be included in your package.

USE db_regia_5

select top 100 * from transaccional.matricula_estudiante ORDER by 1 DESC

select * from transaccional.estudiante_institucion where ID_ESTUDIANTE_INSTITUCION = 186338

select * from maestro.persona_institucion where ID_PERSONA_INSTITUCION = 209725

select top 10 * from maestro.carrera_profesional where ID_CARRERA_PROFESIONAL = 1255
select top 10 * from transaccional.carreras_por_institucion where ID_CARRERAS_POR_INSTITUCION = 2166


select * from db_digepadron.dbo.carrera where ID_CARRERA = 1255


select ID_PERSONA_INSTITUCION,ID_CARRERAS_POR_INSTITUCION_DETALLE , COUNT(1) 
from transaccional.estudiante_institucion where ES_ACTIVO  = 1 
GROUP by ID_PERSONA_INSTITUCION,ID_CARRERAS_POR_INSTITUCION_DETALLE 
HAVING COUNT(1)>2 order by ID_PERSONA_INSTITUCION desc


SELECT * from maestro.persona_institucion where ID_PERSONA_INSTITUCION = 375228
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION =375228
GO

------------------------------------------------------------------------
select DISTINCT p.ID_PERSONA, COUNT(1) 
from maestro.persona_institucion p 
inner join transaccional.estudiante_institucion e on e.ID_PERSONA_INSTITUCION = p.ID_PERSONA_INSTITUCION
WHERE e.ESTADO = 1 and e.ES_ACTIVO = 1 GROUP by p.ID_PERSONA HAVING COUNT(1)>2 order by p.ID_PERSONA desc

select * from maestro.persona_institucion where ID_PERSONA = 150103
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION in(151214,151223,151235,153261)


select * from maestro.persona_institucion where ID_PERSONA = 152143
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION in(153285,153289)


--------------------------------------
GO
select ID_PERSONA_INSTITUCION, COUNT(1) 
from transaccional.estudiante_institucion 
where ESTADO = 1 
    and ES_ACTIVO = 1 
GROUP by ID_PERSONA_INSTITUCION 
HAVING COUNT(1) > 1
ORDER by ID_PERSONA_INSTITUCION DESC

GO
select * from maestro.persona_institucion where ID_PERSONA_INSTITUCION = 413231

GO

select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 413231

select pi.ID_PERSONA, COUNT(1)
from maestro.persona_institucion pi
INNER join transaccional.estudiante_institucion ei on pi.ID_PERSONA_INSTITUCION = ei.ID_PERSONA_INSTITUCION
GROUP by pi.ID_PERSONA--, pi.ID_INSTITUCION
HAVING COUNT(1) >1
ORDER by pi.ID_PERSONA desc

select * from maestro.persona_institucion where ID_PERSONA = 152143
GO

select pi.ID_PERSONA, COUNT(1)
from maestro.persona_institucion pi
--INNER join transaccional.estudiante_institucion ei on pi.ID_PERSONA_INSTITUCION = ei.ID_PERSONA_INSTITUCION
GROUP by pi.ID_PERSONA--, pi.ID_INSTITUCION
HAVING COUNT(1) >1
ORDER by pi.ID_PERSONA desc


GO
select pi.ID_PERSONA, COUNT(ei.ID_PERSONA_INSTITUCION)
from maestro.persona_institucion pi
inner join transaccional.estudiante_institucion ei on pi.ID_PERSONA_INSTITUCION = ei.ID_PERSONA_INSTITUCION
GROUP by pi.ID_PERSONA
HAVING COUNT(ei.ID_PERSONA_INSTITUCION) > 1
ORDER by pi.ID_PERSONA desc
go
select * from maestro.persona_institucion where ID_PERSONA = 371324--371420
select * from maestro.persona_institucion where ID_INSTITUCION = 3185 and ID_PERSONA = 399894
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION in (382829,387967)

GO

select pi.ID_PERSONA,pi.ID_PERSONA_INSTITUCION, COUNT(ei.ID_PERSONA_INSTITUCION)
from maestro.persona_institucion pi
inner join (
    select b.* from maestro.persona_institucion a inner join transaccional.estudiante_institucion b on a.ID_PERSONA_INSTITUCION = b.ID_PERSONA_INSTITUCION
) ei on pi.ID_PERSONA_INSTITUCION = ei.ID_PERSONA_INSTITUCION
GROUP by pi.ID_PERSONA, pi.ID_PERSONA_INSTITUCION
HAVING COUNT(ei.ID_PERSONA_INSTITUCION) > 1
ORDER by pi.ID_PERSONA desc
GO

----alumno en 2 instituciones 
select * from maestro.persona_institucion where ID_PERSONA = 371324--371420

----alumno en 2 carreas
select * from transaccional.estudiante_institucion where ID_PERSONA_INSTITUCION = 413231

go

----152143
select u.Id_Persona,u.* from Security.Users u

select * from Security.UserLogins