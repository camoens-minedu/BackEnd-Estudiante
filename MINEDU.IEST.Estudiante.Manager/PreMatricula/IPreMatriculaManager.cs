using MINEDU.IEST.Estudiante.ManagerDto.PreMatricula;

namespace MINEDU.IEST.Estudiante.Manager.PreMatricula
{
    public interface IPreMatriculaManager
    {
        Task<bool> CreateOrUpdatePreMatricula(GetMatriculaEstudianteDto entity);
        Task<List<GetMatriculaEstudianteDto>> GetFichasEstudianteByIdPersona(int idEstudiante);
        Task<bool> GetValidateMatriculaExistente(int idEstudiante, int idPeriodoLectivoPorInstitucion);
    }
}