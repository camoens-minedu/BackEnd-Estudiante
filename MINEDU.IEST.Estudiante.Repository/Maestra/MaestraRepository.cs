using Microsoft.EntityFrameworkCore;
using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Inf_Utils.Enumerados;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.Maestra
{
    public class MaestraRepository : GenericRepository<enumerado>, IMaestraRepository
    {
        private readonly estudianteContext _context;

        public MaestraRepository(estudianteContext context) : base(context)
        {
            this._context = context;
        }
        public async Task<List<enumerado>> GetListEnumeradosSistema()
        {
            try
            {
                return await _context.enumerado.ToListAsync();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public async Task<Dictionary<EnumeradoCabecera, List<enumerado>>> GetListEnumeradoByGrupo(List<EnumeradoCabecera> listaMaestra)
        {
            var listaEntera = listaMaestra.Select(x => (int)x).ToList();

            var lista = await _context.enumerado.Where(p => listaEntera.Contains(p.ID_TIPO_ENUMERADO)).OrderBy(l => l.ORDEN_ENUMERADO).ToListAsync();

            Dictionary<EnumeradoCabecera, List<enumerado>> listaRes = new Dictionary<EnumeradoCabecera, List<enumerado>>();

            foreach (EnumeradoCabecera item in listaMaestra)
            {
                listaRes.Add(item, (from x in lista
                                    where x.ID_TIPO_ENUMERADO == (int)item && x.ESTADO == 1
                                    select x).ToList());
            }
            return listaRes;
        }


        public sede_institucion GetSedeInstitucionByIdCarreraInstitucionDetalle(int idCarInstitucionDetalle)
        {
            var query = from x in _context.carreras_por_institucion_detalle
                        join si in _context.sede_institucion on x.ID_SEDE_INSTITUCION equals si.ID_SEDE_INSTITUCION
                        where x.ID_CARRERAS_POR_INSTITUCION_DETALLE == idCarInstitucionDetalle
                        select new sede_institucion
                        {
                            ID_SEDE_INSTITUCION = si.ID_SEDE_INSTITUCION,
                            NOMBRE_SEDE = si.NOMBRE_SEDE,
                            DIRECCION_SEDE = si.DIRECCION_SEDE
                        };

            return query.FirstOrDefault();
        }

    }
}
