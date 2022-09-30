using Microsoft.AspNet.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using MINEDU.IEST.Estudiante.Contexto.Data.SecurityApi;
using MINEDU.IEST.Estudiante.Entity.SecurityApi;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.SecurityApi
{
    public class UserRepository : GenericRepository<User>, IUserRepository
    {
        private readonly SecurityApiDbContext _context;
        private IPasswordHasher _passwordHasher;

        public UserRepository(SecurityApiDbContext context) : base(context)
        {
            this._context = context;
            _passwordHasher = new PasswordHasher();
        }

        public IPasswordHasher PasswordHasher
        {
            get
            {
                return _passwordHasher;
            }
            set
            {
                if (value == null)
                {
                    throw new ArgumentNullException("value");
                }
                _passwordHasher = value;
            }
        }

        public async Task<User> GetUserByUserName(int idPersona)
        {
            var user = _context.Users
                .Where(p => p.Id_Persona == idPersona)
                .Select(r => new User
                {
                    Id = r.Id,
                    UserName = r.UserName,
                    Email = r.Email,
                    FirstName = r.FirstName,
                    LastName = r.LastName,
                    SurName = r.SurName,
                    Id_Persona = r.Id_Persona,
                    UserRoles = r.UserRoles.Select(ur => new UserRole
                    {
                        Role = new Role
                        {
                            Name = ur.Role.Name,
                            Id = ur.Role.Id
                        }
                    }).ToList()
                });

            var resul = await user.FirstOrDefaultAsync() ?? new User();

            resul.Persona = await _context.Personas
                .Select(p => new Persona
                {
                    IdPersona = p.IdPersona,
                    IdTipoDocumento = p.IdTipoDocumento,
                    NumeroDocumentoPersona = p.NumeroDocumentoPersona,
                    ApellidoPaternoPersona = p.ApellidoPaternoPersona,
                    ApellidoMaternoPersona = p.ApellidoMaternoPersona,
                    NombrePersona = p.NombrePersona,
                })
                .FirstOrDefaultAsync(p => p.IdPersona == resul.Id_Persona);

            return resul;
        }


        public async Task<Persona> GetPersonaCorreo(int idPersona)
        {
            return await _context.Personas.FirstOrDefaultAsync(p => p.IdPersona == idPersona);
        }

        public User UpdatePassword(string userName, string newPassword)
        {
            User user = _context.Users.Where(u => u.UserName == userName).FirstOrDefault();
            user.PasswordHash = PasswordHasher.HashPassword(newPassword);

            return user;
        }

        public async Task<User> GetUserByIdPersona(int idPersona) => await _context.Users.FirstOrDefaultAsync(p => p.Id_Persona == idPersona);

    }
}
