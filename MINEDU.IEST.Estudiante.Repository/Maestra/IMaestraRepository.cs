using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Inf_Utils.Enumerados;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.Maestra
{
    public interface IMaestraRepository : IGenericRepository<enumerado>
    {
        Task<List<enumerado>> GetListEnumeradosSistema();
        Task<Dictionary<EnumeradoCabecera, List<enumerado>>> GetListEnumeradoByGrupo(List<EnumeradoCabecera> listaMaestra);
    }
}
