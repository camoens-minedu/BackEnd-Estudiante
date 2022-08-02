using MINEDU.IEST.Estudiante.ManagerDto.Maestra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MINEDU.IEST.Estudiante.Manager.Maestra
{
    public interface IMaestraManager
    {
        #region Sistemas

        Task<List<GetTipoEnumeradoDto>> GetListEnumerado();

        #endregion
    }
}
