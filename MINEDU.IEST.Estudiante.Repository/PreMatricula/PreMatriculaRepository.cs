using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.PreMatricula
{
    public class PreMatriculaRepository : GenericRepository<matricula_estudiante>, IPreMatriculaRepository
    {
        public PreMatriculaRepository(estudianteContext context) : base(context)
        {
        }
    }
}
