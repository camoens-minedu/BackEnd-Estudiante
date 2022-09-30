using Microsoft.AspNetCore.Mvc;
using MINEDU.IEST.Estudiante.Manager.Auxiliar;

namespace MINEDU.IEST.Estudiante.WebApiEst.Controllers
{
    [ApiController]
    public class AuxiliarController : BaseController
    {
        private readonly IAuxiliarManager _auxiliarManager;

        public AuxiliarController(IAuxiliarManager auxiliarManager)
        {
            this._auxiliarManager = auxiliarManager;
        }

        [HttpGet("{codPais}")]
        public async Task<IActionResult> GetPaisByCodigo(string codPais) => Ok(await _auxiliarManager.GetPaisByCodigo(codPais));
    }
}
