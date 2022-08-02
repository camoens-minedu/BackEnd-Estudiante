using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MINEDU.IEST.Estudiante.WebApiEst.Controllers
{
    [ApiController]
    public class PreMatriculaController : BaseController
    {
        [HttpGet("GetListPreMatricula")]
        public List<int> ListPreMatricula()
        {
            return new List<int> { 1, 2, 3 };
        }

        [HttpGet("GetMatriculaForEdit")]
        public List<int> MatriculaForEdi(int id)
        {
            return new List<int> { 1, 2, 3 };
        }


        [HttpPost("CreateOrUpdatePreMatricula")]
        public List<int> CreateOrUpdatePreMatricula()
        {
            return new List<int> { 1, 2, 3 };
        }

    }
}
