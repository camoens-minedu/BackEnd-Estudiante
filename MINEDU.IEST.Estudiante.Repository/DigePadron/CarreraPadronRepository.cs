using MINEDU.IEST.Estudiante.Contexto.Data.DigePadron;
using MINEDU.IEST.Estudiante.Entity.DigePadron;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.DigePadron
{
    public class CarreraPadronRepository : GenericRepository<Carrera>, ICarreraPadronRepository
    {

        public CarreraPadronRepository(digePadronDbContext context) : base(context)
        {

        }


    }
}
