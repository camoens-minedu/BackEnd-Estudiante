using Microsoft.AspNetCore.Identity;

namespace MINEDU.IEST.Estudiante.Entity.Security
{
    public class ApplicationUser : IdentityUser
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string SurName { get; set; }
        public int Id_Persona { get; set; }

    }
}
