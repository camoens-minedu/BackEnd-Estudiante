using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Repository.Base;
using MINEDU.IEST.Estudiante.Repository.InformacionPersonal;

namespace MINEDU.IEST.Estudiante.Repository.UnitOfWork
{
    public class InformacionPersonaUnitOfWork : IUnitOfWork<estudianteContext>
    {

        private estudianteContext _context;
        public IInformacionPersonaRepository _personaRepository { get; }

        public InformacionPersonaUnitOfWork(estudianteContext context, IInformacionPersonaRepository personaRepository)
        {
            _context = context;
            _personaRepository = personaRepository;
        }

        private bool disposedValue;

        public void Save()
        {
            _context.SaveChanges();
        }

        public void SaveAsync()
        {
            _context.SaveChangesAsync();
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects)}
                    _context.Dispose();
                }

                // TODO: free unmanaged resources (unmanaged objects) and override finalizer
                // TODO: set large fields to null
                disposedValue = true;
            }
        }

        // // TODO: override finalizer only if 'Dispose(bool disposing)' has code to free unmanaged resources
        // ~InformacionPersonaUnitOfWork()
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
