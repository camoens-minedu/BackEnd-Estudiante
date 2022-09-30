namespace MINEDU.IEST.Estudiante.ManagerDto.SecurityApi
{
    public class GetUserDto
    {
        public string Id { get; set; }
        //public string FirstName { get; set; }
        //public string LastName { get; set; }
        //public string SurName { get; set; }
        //public string UserName { get; set; }
        //public string NormalizedUserName { get; set; }
        public string Email { get; set; }
        public int Id_Persona { get; set; }
        public GetPersonaApiDto persona { get; set; }
        //public List<GetRolDto> roles { get; set; }
        public List<MenuDto> opciones { get; set; }

        public List<GetPersonaInstitucionApiDto> instituciones { get; set; }
        public bool tieneInstituciones { get; set; }
        public string textPassword { get; set; }

        public string fotoBase64 { get; set; }


        //public List<GetEstudianteInsitucionApiDto> listaEstudianteInstitucion { get; set; }
        //public List<Role> Roles { get; set; }

        //public Persona Persona { get; set; }
    }
}
