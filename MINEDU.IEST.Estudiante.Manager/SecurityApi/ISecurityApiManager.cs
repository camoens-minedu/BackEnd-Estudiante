using MINEDU.IEST.Estudiante.ManagerDto.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi.ValidateUser;

namespace MINEDU.IEST.Estudiante.Manager.SecurityApi
{
    public interface ISecurityApiManager
    {
        Task<GetUserDto> CreateOrUpdateUser(GetUserDto userDto);
        Task<GetValidatePersonaDto> GetPersonaInstitucionValidate(int tipoDocumento, string nroDocumento, string correo);
        Task<List<GetEnumeradoComboDto>> GetTipoDocumento();
        Task<GetUserDto> GetUserByUserName(int idPersona);
        Task<List<GetPersonaInstitucionApiDto>> GetInstitucionesAsync(int id_Persona);
        Task<GetValidatePersonaDto> GetForgotPassword(string email, string codigo);
        Task<bool> GetChangePassword(int idPersona, string oldClave, string newClave);
    }
}