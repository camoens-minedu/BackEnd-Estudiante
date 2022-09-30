using Microsoft.EntityFrameworkCore;
using MINEDU.IEST.Estudiante.Contexto.Data.DigePadron;
using MINEDU.IEST.Estudiante.Entity.DigePadron;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.DigePadron
{
    public class UbigeoRepository : GenericRepository<Distrito>, IUbigeoRepository
    {
        private readonly digePadronDbContext _context;

        public UbigeoRepository(digePadronDbContext context) : base(context)
        {
            this._context = context;
        }


        public async Task<Distrito> GetDistritoAll(string codigo)
        {
            var query = from d in _context.Distritos
                        join p in _context.Provincia on d.CodigoProvincia equals p.CodigoProvincia
                        join dpto in _context.Departamentos on p.CodigoDepartamento equals dpto.CodigoDepartamento
                        where d.CodigoDistrito.Equals(codigo)
                        select new Distrito
                        {
                            CodigoDistrito = d.CodigoDistrito,
                            CodigoDepartamento = d.CodigoDepartamento,
                            CodigoProvincia = d.CodigoProvincia,
                            NombreDistrito = d.NombreDistrito,
                            Estado = d.Estado,
                            ubigeoCompleto = $"{dpto.NombreDepartamento} / {p.NombreProvincia} / {d.NombreDistrito}"
                        };

            return await query.FirstOrDefaultAsync();
        }
    }
}
