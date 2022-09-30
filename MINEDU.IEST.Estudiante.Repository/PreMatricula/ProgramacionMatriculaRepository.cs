using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.PreMatricula
{
    public class ProgramacionMatriculaRepository : GenericRepository<programacion_clase_por_matricula_estudiante>, IProgramacionMatriculaRepository
    {
        public ProgramacionMatriculaRepository(estudianteContext context) : base(context)
        {
        }
    }
}
