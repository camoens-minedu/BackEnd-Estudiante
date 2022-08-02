using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MINEDU.IEST.Estudiante.WebApiEst.Controllers
{

    [ApiController]
    public class InformacionPersonal : BaseController
    {
        [HttpGet("GetInformacionGeneral")]
        public List<int> InformacionGeneral()
        {
            return new List<int> { 1, 2, 3 };
        }
        [HttpGet("GetPerfilEstudiante")]
        public List<int> PerfilEstudiante()
        {
            return new List<int> { 1, 2, 3 };
        }
        [HttpGet("GetPorfalAcademico")]
        public List<int> PortalAcademico()
        {
            return new List<int> { 1, 2, 3 };
        }


    }
}
