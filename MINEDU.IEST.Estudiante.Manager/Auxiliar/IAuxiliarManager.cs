using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar.Pais;

namespace MINEDU.IEST.Estudiante.Manager.Auxiliar
{
    public interface IAuxiliarManager
    {
        Task<List<GetPaisDto>> GetPaisAll();
        Task<GetPaisDto> GetPaisByCodigo(string codigo);
        Task<GetUbigeoAuxiliarDto> GetUbigeoAuxiliarById(string id);
        Task<List<GetUbigeoAuxiliarDto>> GetUbigeoReniecByFitro(string filtro);
    }
}