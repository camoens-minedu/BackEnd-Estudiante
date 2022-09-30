using Microsoft.AspNetCore.Mvc;
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

        public MaestraController(IMaestraManager maestraManager, ILogger<MaestraController> logger)
        {
            this.maestraManager = maestraManager;
            this.logger = logger;
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
        #endregion




    }
}
