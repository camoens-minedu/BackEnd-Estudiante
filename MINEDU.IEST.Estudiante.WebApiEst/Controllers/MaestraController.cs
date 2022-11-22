using Microsoft.AspNetCore.Mvc;
using MINEDU.IEST.Estudiante.Manager.Auxiliar;
using MINEDU.IEST.Estudiante.Manager.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;

namespace MINEDU.IEST.Estudiante.WebApiEst.Controllers
{
    [ApiController]
    //[Audit]
    public class MaestraController : BaseController
    {
        private readonly IMaestraManager maestraManager;
        private readonly ILogger<MaestraController> logger;
        private readonly IAuxiliarManager _auxiliarManager;

        public MaestraController(IMaestraManager maestraManager, ILogger<MaestraController> logger, IAuxiliarManager auxiliarManager)
        {
            this.maestraManager = maestraManager;
            this.logger = logger;
            this._auxiliarManager = auxiliarManager;
        }



        #region Sistemas
        [HttpGet("GetListEnumerados")]
        public async Task<List<GetTipoEnumeradoDto>> ListaEnumerados()
        {
            try
            {
                logger.LogInformation("---ingreso a la api---");
                return await maestraManager.GetListEnumerado();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message, ex);
                throw;
            }
        }


        [HttpGet("getubigeofiltro/{filtro}")]
        public async Task<IActionResult> getUbigeoFiltro(string filtro)
        {
            try
            {
                return Ok(await _auxiliarManager.GetUbigeoReniecByFitro(filtro));
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message, ex);
                throw;
            }
        }

        #endregion




    }
}
