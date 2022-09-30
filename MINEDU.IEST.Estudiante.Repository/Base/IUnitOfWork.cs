using Microsoft.EntityFrameworkCore;

namespace MINEDU.IEST.Estudiante.Repository.Base
{
    public interface IUnitOfWork<DBContext> : IDisposable where DBContext : DbContext
    {
        void Save();
        void SaveAsync();
    }
}