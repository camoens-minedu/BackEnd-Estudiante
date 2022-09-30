using MINEDU.IEST.Estudiante.ManagerDto.PreMatricula;

namespace MINEDU.IEST.Estudiante.Manager.PreMatricula
{
    public interface IPreMatriculaManager
    {
        Task<bool> CreateOrUpdatePreMatricula(GetMatriculaEstudianteDto entity);
    }
}