using MINEDU.IEST.Estudiante.Entity.DigePadron;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.DigePadron
{
    public interface IUbigeoRepository : IGenericRepository<Distrito>
    {
        Task<Distrito> GetDistritoAll(string codigo);
    }
}