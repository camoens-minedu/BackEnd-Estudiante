using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.PreMatricula
{
    public interface IPreMatriculaRepository : IGenericRepository<matricula_estudiante>
    {
        Task<programacion_clase> GetPeriodoAcademicoForMatricula(int idInstitucion);
        Task<programacion_clase> GetPeriodoLectivoByIdInstituto(int idInstituto);
        Task<programacion_matricula> GetProgramacionMatriculaByPeriodo(int ID_PERIODOS_LECTIVOS_POR_INSTITUCION);
    }
}
