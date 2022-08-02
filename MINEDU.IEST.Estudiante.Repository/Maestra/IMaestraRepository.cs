using MINEDU.IEST.Estudiante.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MINEDU.IEST.Estudiante.Repository.Maestra
{
    public interface IMaestraRepository
    {
        Task<List<enumerado>> GetListEnumeradosSistema();

    }
}
