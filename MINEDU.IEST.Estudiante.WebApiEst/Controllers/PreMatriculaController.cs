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

        [HttpGet("{idPlan}/{idSemestre}/{idPeriodoLectivoByInstitucion}")]
        public async Task<IActionResult> GetCabeceraMatricula(int idPlan, int idSemestre, int idPeriodoLectivoByInstitucion)
        {
            var query = await storeProcedureManager.GetCabeceraMatricula(idPlan, idSemestre, idPeriodoLectivoByInstitucion);
            if (query.ProgramacionMatricula.ID_PROGRAMACION_MATRICULA == 0)
            {
                return NotFound("No se encontró una matricula programda para el periodo actual");
            }

            return Ok(query);
        }


        [HttpGet("GetListMatriculaCurso")]
        public async Task<IActionResult> MatriculaForEdi([FromQuery] GetMatriculaRequestDto model)
        {
            var responseData = new GetPreMatriculaCabeceraListCursoDto();
            var cabacera = await storeProcedureManager.GetCabeceraMatricula(model.ID_PLAN_ESTUDIO, model.ID_SEMESTRE_ACADEMICO_ACTUAL, model.ID_PERIODOS_LECTIVOS_POR_INSTITUCION);

            if (cabacera?.ProgramacionMatricula?.ID_PROGRAMACION_MATRICULA == null)
            {
                return NotFound("No se encontró una matricula programada para el periodo actual");
            }

            if (await _preMatriculaManager.GetValidateMatriculaExistente(model.ID_ESTUDIANTE_INSTITUCION, model.ID_PERIODOS_LECTIVOS_POR_INSTITUCION))
            {
                return NotFound("Ya existe una matrícula registrada para este periodo lectivo");
            }


            var cursos = await storeProcedureManager.GetCursosMatricula(
                model.ID_INSTITUCION,
                model.ID_PERIODO_ACADEMICO,
                model.ID_PLAN_ESTUDIO,
                model.ID_SEMESTRE_ACADEMICO_ACTUAL,
                model.ID_ESTUDIANTE_INSTITUCION,
                model.ID_MATRICULA_ESTUDIANTE,
                model.ES_UNIDAD_DIDACTICA_EF,
                model.Pagina,
                model.Registros,
                model.ES_MATRICULA_CON_UD_PREVIAS);

            responseData.cabecera = cabacera;
            responseData.listaCursos = cursos;

            return Ok(responseData);
        }

        [HttpGet("GetListProgramacionCurso/{idInstitucion}/{idPeriodoAcademico}/{idUnidadDidactica}")]
        public async Task<IActionResult> ListaProgramacionCurso(int idInstitucion, int idPeriodoAcademico, int idUnidadDidactica)
        {
            return Ok(await storeProcedureManager.GetProgramacionCurso(idInstitucion, idPeriodoAcademico, idUnidadDidactica));
        }

        [HttpGet("{idEstudiante:int}")]
        public async Task<IActionResult> GetMatriculasRegistradas(int idEstudiante) =>
           Ok(await _preMatriculaManager.GetFichasEstudianteByIdPersona(idEstudiante));


        #endregion
    }
}
