using MINEDU.IEST.Estudiante.Contexto.Data.Audit;
using MINEDU.IEST.Estudiante.Entity.Audit;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.Audit
{
    public class AuditLogRepository : GenericRepository<AuditLog>, IAuditLogRepository
    {
        public AuditLogRepository(AuditDbContext context) : base(context)
        {
        }
    }
}
