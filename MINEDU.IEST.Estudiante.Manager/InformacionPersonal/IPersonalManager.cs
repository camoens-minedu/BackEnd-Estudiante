using MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal;
using MINEDU.IEST.Estudiante.ManagerDto.PerfilEstudiante;

namespace MINEDU.IEST.Estudiante.Manager.InformacionPersonal
{
    public interface IPersonalManager
    {
        Task<GetPerfilEstudianteForEdit> GetEstudiantePerfil(int idInstitucion, int idCarrera);
        Task<GetInfoPersonalForEdit> GetInfoPersonalForEdit(int idPersona, int idPersonaInstitucion);
    }
}