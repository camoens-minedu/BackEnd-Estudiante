using MINEDU.IEST.Estudiante.Contexto.Data.Auxiliar;
using MINEDU.IEST.Estudiante.Repository.Auxiliar;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.UnitOfWork
{
    public class AuxiliarUnitOfWork : IUnitOfWork<AuxiliarDbContext>
    {

        private readonly AuxiliarDbContext _context;
        public IAuxiliarRepository _auxiliarRepository { get; }

        public AuxiliarUnitOfWork(AuxiliarDbContext context, IAuxiliarRepository auxiliarRepository)
        {
            this._context = context;
            _auxiliarRepository = auxiliarRepository;
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
        // ~AuxiliarUnitOfWork()
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
