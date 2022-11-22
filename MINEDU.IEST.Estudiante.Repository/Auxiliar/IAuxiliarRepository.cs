using MINEDU.IEST.Estudiante.Entity.Auxiliar;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.Auxiliar
{
    public interface IAuxiliarRepository : IGenericRepository<PaisAuxiliar>
    {
        Task<UvwInstitucion> GetInstitucion(int idInstitucion);
        Task<PaisAuxiliar> GetPaisAuxiliarByCodigo(string codigo);
        Task<UbigeoAuxiliar> GetUbigeoAuxiliarById(string id);
        Task<List<UvwUbigeoReniec>> GetUbigeoReniecByFitro(string fitro);
        Task<UvwUbigeoReniec> GetUbigeoReniecById(string id);
    }
}
