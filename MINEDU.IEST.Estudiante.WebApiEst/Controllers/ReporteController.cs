using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MINEDU.IEST.Estudiante.Inf_Utils.Filters;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers;
using MINEDU.IEST.Estudiante.Manager.Reporte;
using MINEDU.IEST.Estudiante.Manager.StoreProcedure;

namespace MINEDU.IEST.Estudiante.WebApiEst.Controllers
{
    [ApiController]
    [ServiceFilter(typeof(ModelValidationAttribute))]
    public class ReporteController : BaseController
    {
        private readonly ILogger<InformacionPersonal> _logger;
        private readonly IReporteManager _reporteManager;
        private readonly IStoreProcedureManager _spManager;

        public ReporteController(ILogger<InformacionPersonal> logger, IReporteManager reporteManager, IStoreProcedureManager spManager)
        {
            _logger = logger;
            this._reporteManager = reporteManager;
            this._spManager = spManager;
        }

        [HttpGet("{idMatricula:int}")]
        public async Task<IActionResult> GetFichaMatriculaById(int idMatricula) => Ok(await _reporteManager.GetRepoteFichaByIdMatricula(idMatricula));

        [HttpGet("{idMatricula:int}/{idPeriodoLectivoByInstituto:int}")]
        public async Task<IActionResult> GetBoletasNotas(int idMatricula, int idPeriodoLectivoByInstituto)
        {
            var result = await _reporteManager.GetRepoteBoletaNotasByEstudiante(idMatricula, idPeriodoLectivoByInstituto);
            if (string.IsNullOrEmpty(result.base64))
            {
                ModelState.AddModelError("idMatricula", $"La matricula: {idMatricula}, no fue encontrada.");
                return UnprocessableEntity(ExtensionTools.Validaciones(ModelState));
            }
            return Ok(result);

        }//Ok(await _spManager.GetBoletasNotas(idMatricula, idPeriodoLectivoByInstituto));

        //int ID_INSTITUCION, int ID_TIPO_DOCUMENTO, string ID_NUMERO_DOCUMENTO, int ID_SEDE_INSTITUCION, int ID_CARRERA, int ID_PLAN_ESTUDIO, int ID_PERIODO_LECTIVO_INSTITUCION
        [AllowAnonymous]
        [HttpGet("{ID_INSTITUCION:int}/{ID_TIPO_DOCUMENTO:int}/{ID_NUMERO_DOCUMENTO}/{ID_SEDE_INSTITUCION:int}/{ID_CARRERA:int}/{ID_PLAN_ESTUDIO:int}/{ID_PERIODO_LECTIVO_INSTITUCION:int}")]
        public async Task<IActionResult> GetHistorialAcademico(int ID_INSTITUCION, int ID_TIPO_DOCUMENTO, string ID_NUMERO_DOCUMENTO, int ID_SEDE_INSTITUCION, int ID_CARRERA, int ID_PLAN_ESTUDIO, int ID_PERIODO_LECTIVO_INSTITUCION) =>
            Ok(await _reporteManager.GetReporteHistorialAcademicoByEstudiante(ID_INSTITUCION, ID_TIPO_DOCUMENTO, ID_NUMERO_DOCUMENTO, ID_SEDE_INSTITUCION, ID_CARRERA, ID_PLAN_ESTUDIO, ID_PERIODO_LECTIVO_INSTITUCION));
        //Ok(await _spManager.GetHistorialAcademico(idPeriodoLectivoByInstituto, idEstudiante, idEvaluacionExtra));


    }
}
