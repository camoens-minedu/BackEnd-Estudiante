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
        public async Task<UvwUbigeoReniec> GetUbigeoReniecById(string id) => await _context.UbigeoReniec.FirstOrDefaultAsync(p => p.CODIGO_UBIGEO == id);

        public async Task<UvwInstitucion> GetInstitucion(int idInstitucion)
        {

            try
            {
                var query = await _context.UvwInstitucions.FirstOrDefaultAsync(p => p.IdInstitucion == idInstitucion);
                return query;
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }


        public async Task<List<UvwUbigeoReniec>> GetUbigeoReniecByFitro(string filtro)
        {


            //var query = (await _context.UbigeoReniec.Select(p => p.DISTRITO_UBIGEO.Contains(filtro)).ToListAsync());

            //var query = await _context.UbigeoReniec
            //.Contains()
            //.Where(p =>
            //filtro.ToUpper().Contains(p.DEPARTAMENTO_UBIGEO.ToUpper()) ||
            //filtro.ToUpper().Contains(p.PROVINCIA_UBIGEO.ToUpper()) ||
            //filtro.Contains(p.DISTRITO_UBIGEO))
            //filtro.StartsWith(p.DISTRITO_UBIGEO))
            //.Skip(20)
            //.ToListAsync();

            var distrito = await (from s in _context.UbigeoReniec
                                  where filtro.Contains(s.DISTRITO_UBIGEO)
                                  select s)
                               .Take(10)
                               .ToListAsync();

            var provincia = await (from s in _context.UbigeoReniec
                                   where filtro.Contains(s.PROVINCIA_UBIGEO)
                                   select s)
                              .Take(10)
                              .ToListAsync();

            var departamento = await (from s in _context.UbigeoReniec
                                      where filtro.Contains(s.DEPARTAMENTO_UBIGEO)
                                      select s)
                            .Take(10)
                            .ToListAsync();

            var result = distrito.Union(provincia).Union(departamento).ToList();
            //var query = await _context.UbigeoReniec
            //.Where(p => filtro.ToUpper().Contains((p.DEPARTAMENTO_UBIGEO.ToUpper() + " / " + p.PROVINCIA_UBIGEO.ToUpper() + " / " + p.DISTRITO_UBIGEO.ToUpper())))
            //.Skip(20)
            //.ToListAsync();


            return result;
        }


    }
}
