using Microsoft.AspNet.Identity;
using MINEDU.IEST.Estudiante.Entity.SecurityApi;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.SecurityApi
{
    public interface IUserRepository: IGenericRepository<User>
    {
        IPasswordHasher PasswordHasher { get; set; }

        Task<bool> claveCompare(string clave, int idPersona);
        Task<Persona> GetPersonaCorreo(int idPersona);
        Task<User> GetUserByIdPersona(int idPersona);
        Task<User> GetUserByUserName(int idPersona);
        User UpdatePassword(string userName, string newPassword);
    }
}