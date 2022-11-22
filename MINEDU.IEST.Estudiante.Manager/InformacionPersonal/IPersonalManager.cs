using MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal;
using MINEDU.IEST.Estudiante.ManagerDto.PerfilEstudiante;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi.ValidateUser;

namespace MINEDU.IEST.Estudiante.Manager.InformacionPersonal
{
    public interface IPersonalManager
    {
        Task<bool> CreateOrUpdateInformacionPersonal(CreateOrUpdatePersonaDto model);
        Task<GetPerfilEstudianteForEdit> GetEstudiantePerfil(int idInstitucion, int idCarrera);
        Task<GetInfoPersonalForEdit> GetInfoPersonalForEdit(int idPersona, int idPersonaInstitucion);
        Task<GetValidatePersonaDto> GetPersonaForConfirm(int idPersona);
    }
}