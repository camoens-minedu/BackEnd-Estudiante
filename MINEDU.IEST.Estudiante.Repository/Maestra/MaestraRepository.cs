using Microsoft.EntityFrameworkCore;
using MINEDU.IEST.Estudiante.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MINEDU.IEST.Estudiante.Repository.Maestra
{
    public class MaestraRepository : IMaestraRepository
    {
        private readonly estudianteContext context;

        public MaestraRepository(estudianteContext context)
        {
            this.context = context;
        }
        public Task<List<enumerado>> GetListEnumeradosSistema()
        {
            try
            {
                return context.enumerado.ToListAsync();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
