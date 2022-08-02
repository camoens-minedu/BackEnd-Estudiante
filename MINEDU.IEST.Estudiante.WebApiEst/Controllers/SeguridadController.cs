using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MINEDU.IEST.Estudiante.WebApiEst.Controllers
{
   
    [ApiController]
    public class SeguridadController : BaseController
    {
        [HttpGet]
        public bool LoginEstudiante(string codUsuario, string clave)
        {
            return true;
        }
    }
}
