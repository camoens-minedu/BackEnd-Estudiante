using MINEDU.IEST.Estudiante.Contexto.Data.Audit;
using MINEDU.IEST.Estudiante.Entity.Audit;
using MINEDU.IEST.Estudiante.Repository.Audit;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.UnitOfWork
{
    public class AuditUnitOfWork : IUnitOfWork<AuditDbContext>
    {
        private AuditDbContext _context;
        public IAuditLogRepository _auditLogRepository { get; }

        public AuditUnitOfWork(AuditDbContext context, IAuditLogRepository auditLogRepository)
        {
            _context = context;
            _auditLogRepository = auditLogRepository;
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
                    _context.Dispose();
                }

                // TODO: free unmanaged resources (unmanaged objects) and override finalizer
                // TODO: set large fields to null
                disposedValue = true;
            }
        }

        // // TODO: override finalizer only if 'Dispose(bool disposing)' has code to free unmanaged resources
        // ~AuditUnitOfWork()
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
