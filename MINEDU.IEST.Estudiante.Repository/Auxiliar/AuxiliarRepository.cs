using Microsoft.EntityFrameworkCore;
using MINEDU.IEST.Estudiante.Contexto.Data.Auxiliar;
using MINEDU.IEST.Estudiante.Entity.Auxiliar;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.Auxiliar
{
    public class AuxiliarRepository : GenericRepository<PaisAuxiliar>, IAuxiliarRepository
    {
        private readonly AuxiliarDbContext _context;

        public AuxiliarRepository(AuxiliarDbContext context) : base(context)
        {
            this._context = context;
        }

        public async Task<PaisAuxiliar> GetPaisAuxiliarByCodigo(string codigo) => await _context.TblPais.FirstOrDefaultAsync(p => p.Codigo.Equals(codigo));


        public async Task<UbigeoAuxiliar> GetUbigeoAuxiliarById(string id) => await _context.TblUbigeos.FirstOrDefaultAsync(p => p.CodigoUbigeo == id);

        public async Task<UvwInstitucion> GetInstitucion(int idInstitucion) 
            => await _context.UvwInstitucions.FirstOrDefaultAsync(p => p.IdInstitucion==idInstitucion);

    }
}
