using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Repository.Base;
using MINEDU.IEST.Estudiante.Repository.Maestra;

namespace MINEDU.IEST.Estudiante.Repository.UnitOfWork
{
    public class MaestrasUnitOfWork : IUnitOfWork<estudianteContext>
    {

        private estudianteContext _context;
        public IMaestraRepository _maestraRepository { get; }


        public MaestrasUnitOfWork(estudianteContext context, IMaestraRepository maestraRepository)
        {
            _context = context;
            _maestraRepository = maestraRepository;
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
                    // TODO: dispose managed state (managed objects)
                    _context.Dispose();
                }

                // TODO: free unmanaged resources (unmanaged objects) and override finalizer
                // TODO: set large fields to null
                disposedValue = true;
            }
        }

        // // TODO: override finalizer only if 'Dispose(bool disposing)' has code to free unmanaged resources
        // ~MaestrasUnitOfWork()
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
