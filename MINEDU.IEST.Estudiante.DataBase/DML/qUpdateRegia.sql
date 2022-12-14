--alter table Security.Users
--	add Id_Persona int null

update Security.Users
	set Id_Persona = 152143   --150053   ---150103  -- 152143
where Id = '6504901d-d0f4-4f32-8d63-a6defb880322'

go

update Security.Users
	set Id_Persona = 150052
where Id = '87e10ab7-cca8-4267-8b5d-2b6ff8d01583'

go

update Security.Users
	set Id_Persona = 150050
where Id = '8df07f4e-c392-4f90-88a3-3c13ccfcce9f'

go


update maestro.persona_institucion
set CORREO = 'camoens1@outlook.com'
where ID_PERSONA= 150104

go

UPDATE transaccional.matricula_estudiante
	SET ES_ACTIVO = 1, ESTADO = 3
WHERE ID_MATRICULA_ESTUDIANTE = 229876

----------------

update transaccional.programacion_matricula
	set FECHA_INICIO = '2022-10-01', FECHA_FIN = '2022-12-22'
where ID_PROGRAMACION_MATRICULA = 4226

GO

select top 10 * from transaccional.programacion_matricula where ID_PERIODOS_LECTIVOS_POR_INSTITUCION = 1329

SELECT * FROM transaccional.matricula_estudiante TM WHERE --TM.ID_PROGRAMACION_MATRICULA = 4226 AND 
TM.ID_ESTUDIANTE_INSTITUCION = 114864


SELECT distinct top 1 [p].[ID_PERIODO_ACADEMICO], [p0].[ID_PERIODO_ACADEMICO], [p].[ESTADO], [p0].[ID_PERIODOS_LECTIVOS_POR_INSTITUCION], [p1].[ID_PERIODO_LECTIVO], [p2].[CODIGO_PERIODO_LECTIVO]
FROM [transaccional].[programacion_clase] AS [p]
  INNER JOIN [transaccional].[periodo_academico] AS [p0] ON [p].[ID_PERIODO_ACADEMICO] = [p0].[ID_PERIODO_ACADEMICO]      
  INNER JOIN [transaccional].[periodos_lectivos_por_institucion] AS [p1] ON [p0].[ID_PERIODOS_LECTIVOS_POR_INSTITUCION] = [p1].[ID_PERIODOS_LECTIVOS_POR_INSTITUCION]
  INNER JOIN [maestro].[periodo_lectivo] AS [p2] ON [p1].[ID_PERIODO_LECTIVO] = [p2].[ID_PERIODO_LECTIVO]
WHERE (([p1].[ID_INSTITUCION] =827) AND ([p].[ESTADO] = 1)) AND ([p].[ES_ACTIVO] = CAST(1 AS bit))
go
