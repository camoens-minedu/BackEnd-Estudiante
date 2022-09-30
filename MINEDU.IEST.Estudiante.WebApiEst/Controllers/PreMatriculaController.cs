using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MINEDU.IEST.Estudiante.Manager.PreMatricula;
using MINEDU.IEST.Estudiante.Manager.StoreProcedure;
using MINEDU.IEST.Estudiante.ManagerDto.PreMatricula;

namespace MINEDU.IEST.Estudiante.WebApiEst.Controllers
{
    [ApiController]
    public class PreMatriculaController : BaseController
    {
        private readonly IStoreProcedureManager storeProcedureManager;
        private readonly IPreMatriculaManager _preMatriculaManager;

        public PreMatriculaController(IStoreProcedureManager storeProcedureManager, IPreMatriculaManager preMatriculaManager)
        {
            this.storeProcedureManager = storeProcedureManager;
            _preMatriculaManager = preMatriculaManager;
        }

        #region EF Core Registro

        [HttpPost("CreateOrUpdatePreMatricula")]
        public async Task<IActionResult> CreateOrUpdatePreMatricula(GetMatriculaEstudianteDto model)
        {
            return Ok(await _preMatriculaManager.CreateOrUpdatePreMatricula(model));
        }


        #endregion
        #region Store - Procedure
        [HttpGet("{idPlan}/{idSemestre}")]
        public async Task<IActionResult> GetCabeceraMatricula(int idPlan, int idSemestre) => Ok(await storeProcedureManager.GetCabeceraMatricula(idPlan, idSemestre));


        [HttpGet("GetListMatriculaCurso")]
        public async Task<IActionResult> MatriculaForEdi(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_PLAN_ESTUDIO, int ID_SEMESTRE_ACADEMICO_ACTUAL, int ID_ESTUDIANTE_INSTITUCION, int ID_MATRICULA_ESTUDIANTE, bool ES_UNIDAD_DIDACTICA_EF, int Pagina, int Registros, bool ES_MATRICULA_CON_UD_PREVIAS)
        {
            return Ok(await storeProcedureManager.GetCursosMatricula(ID_INSTITUCION, ID_PERIODO_ACADEMICO, ID_PLAN_ESTUDIO, ID_SEMESTRE_ACADEMICO_ACTUAL, ID_ESTUDIANTE_INSTITUCION, ID_MATRICULA_ESTUDIANTE, ES_UNIDAD_DIDACTICA_EF, Pagina, Registros, ES_MATRICULA_CON_UD_PREVIAS));
        }


        [HttpGet("GetListProgramacionCurso/{idInstitucion}/{idPeriodoAcademico}/{idUnidadDidactica}")]
        public async Task<IActionResult> ListaProgramacionCurso(int idInstitucion, int idPeriodoAcademico, int idUnidadDidactica)
        {
            return Ok(await storeProcedureManager.GetProgramacionCurso(idInstitucion, idPeriodoAcademico, idUnidadDidactica));
        }
        #endregion



    }
}
