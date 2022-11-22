using MINEDU.IEST.Estudiante.Contexto.Data.SecurityApi;
using MINEDU.IEST.Estudiante.Repository.Base;
using MINEDU.IEST.Estudiante.Repository.SecurityApi;

namespace MINEDU.IEST.Estudiante.Repository.UnitOfWork
{
    public class SecurityApiUnitOfWork : IUnitOfWork<SecurityApiDbContext>
    {
        private readonly SecurityApiDbContext _context;
        public IUserRepository _userRepository { get; }
        public IRoleRepository _roleRepository { get; }

        public SecurityApiUnitOfWork(SecurityApiDbContext context, IUserRepository userRepository, IRoleRepository roleRepository)
        {
            this._context = context;
            _userRepository = userRepository;
            _roleRepository = roleRepository;
        }
        private bool disposedValue;

        public void Save()
        {
           _context.SaveChanges();
        }

        public async Task SaveAsync()
        {
            await _context.SaveChangesAsync();

        }

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    _context.Dispose();
                }

                // TODO: free unmanaged resources (unmanaged objects) and override finalizer
                // TODO: set large fields to null
                disposedValue = true;
            }
        }

        // // TODO: override finalizer only if 'Dispose(bool disposing)' has code to free unmanaged resources
        // ~SecurityApiUnitOfWork()
        // {
        //     // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
        //     Dispose(disposing: false);
        // }

        public void Dispose()
        {
            // Do not change this code. Put cleanup code in 'Dispose(bool disposing)' method
            Dispose(disposing: true);
            GC.SuppressFinalize(this);
        }
    }
}
