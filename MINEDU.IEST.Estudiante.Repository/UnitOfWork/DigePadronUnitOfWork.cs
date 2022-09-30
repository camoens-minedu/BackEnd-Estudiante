using MINEDU.IEST.Estudiante.Contexto.Data.DigePadron;
using MINEDU.IEST.Estudiante.Repository.Base;
using MINEDU.IEST.Estudiante.Repository.DigePadron;

namespace MINEDU.IEST.Estudiante.Repository.UnitOfWork
{
    public class DigePadronUnitOfWork : IUnitOfWork<digePadronDbContext>
    {

        private digePadronDbContext _context;
        public IUbigeoRepository _ubigeoRepository { get; }
        public ICarreraPadronRepository _padronCarrera { get; }


        public DigePadronUnitOfWork(digePadronDbContext context, IUbigeoRepository ubigeoRepository, ICarreraPadronRepository padronCarrera)
        {
            _context = context;
            _ubigeoRepository = ubigeoRepository;
            _padronCarrera = padronCarrera;
        }

        public void Save()
        {
            _context.SaveChanges();
        }

        public void SaveAsync()
        {
            _context.SaveChangesAsync();
        }

        private bool disposedValue;
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
        // ~CarreraPadronUnitOfWork()
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
