using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MINEDU.IEST.Estudiante.WebApiEst.Controllers
{
    [ApiController]
    public class ReporteController : BaseController
    {
        [HttpGet("GetHistorialAcademico")]
        public List<int> HistorialAcademico()
        {
            return new List<int> { 1, 2, 3 };
        }

        [HttpGet("GetBoletaNotas")]
        public List<int> BoletaNotas()
        {
            return new List<int> { 1, 2, 3 };
        }

        [HttpGet("GetPerfilAcademico")]
        public List<int> PerfilAcademico()
        {
            return new List<int> { 1, 2, 3 };
        }
        [HttpGet("GetReporteAsistencia")]
        public List<int> ReporteAsistencia()
        {
            return new List<int> { 1, 2, 3 };
        }
    }
}
