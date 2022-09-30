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
where ID_PERSONA= 150103