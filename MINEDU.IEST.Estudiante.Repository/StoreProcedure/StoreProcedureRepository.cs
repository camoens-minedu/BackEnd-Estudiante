using Dapper;
using MINEDU.IEST.Estudiante.Contexto.Data.Estudiante;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Entity.StoreProcedure;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers.Dapper;
using MINEDU.IEST.Estudiante.Repository.Base;
using System.Data;

namespace MINEDU.IEST.Estudiante.Repository.StoreProcedure
{
    public class StoreProcedureRepository : GenericRepository<matricula_estudiante>, IStoreProcedureRepository
    {
        private readonly estudianteContext _context;
        private readonly IDapper _database;
        public StoreProcedureRepository(estudianteContext context, IDapper database) : base(context)
        {
            this._context = context;
            _database = database;
        }

        public async Task<List<USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULAResult>> GetDatosGeneralesMatricula(int? ID_PLAN_ESTUDIO, int? ID_SEMESTRE_ACADEMICO)
        {
            var procedureName = "USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULA";
            var parameters = new DynamicParameters();
            parameters.Add("ID_PLAN_ESTUDIO", ID_PLAN_ESTUDIO, DbType.Int32, ParameterDirection.Input);
            parameters.Add("ID_SEMESTRE_ACADEMICO", ID_SEMESTRE_ACADEMICO, DbType.Int32, ParameterDirection.Input);

            var qResult = await _database.GetAll<USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULAResult>(procedureName, parameters, CommandType.StoredProcedure);
            return qResult;
        }


        public async Task<List<USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADOResult>> GetCursosMatricula(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_PLAN_ESTUDIO, int ID_SEMESTRE_ACADEMICO_ACTUAL, int ID_ESTUDIANTE_INSTITUCION, int ID_MATRICULA_ESTUDIANTE, bool ES_UNIDAD_DIDACTICA_EF, int Pagina, int Registros, bool ES_MATRICULA_CON_UD_PREVIAS)
        {
            var procedureName = "USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADO";
            var parameters = new DynamicParameters();
            parameters.Add("ID_INSTITUCION", ID_INSTITUCION, DbType.Int32, ParameterDirection.Input);
            parameters.Add("ID_PERIODO_ACADEMICO", ID_PERIODO_ACADEMICO, DbType.Int32, ParameterDirection.Input);
            parameters.Add("ID_PLAN_ESTUDIO", ID_PLAN_ESTUDIO, DbType.Int32, ParameterDirection.Input);
            parameters.Add("ID_SEMESTRE_ACADEMICO_ACTUAL", ID_SEMESTRE_ACADEMICO_ACTUAL, DbType.Int32, ParameterDirection.Input);
            parameters.Add("ID_ESTUDIANTE_INSTITUCION", ID_ESTUDIANTE_INSTITUCION, DbType.Int32, ParameterDirection.Input);
            parameters.Add("ID_MATRICULA_ESTUDIANTE", ID_MATRICULA_ESTUDIANTE, DbType.Int32, ParameterDirection.Input);
            parameters.Add("_ES_UNIDAD_DIDACTICA_EF", ES_UNIDAD_DIDACTICA_EF, DbType.Boolean, ParameterDirection.Input);
            //parameters.Add("ES_MATRICULA_CON_UD_PREVIAS", ES_MATRICULA_CON_UD_PREVIAS, DbType.Boolean, ParameterDirection.Input);
            parameters.Add("Pagina", Pagina, DbType.Int32, ParameterDirection.Input);
            parameters.Add("Registros", Registros, DbType.Int32, ParameterDirection.Input);


            var qResult = await _database.GetAll<USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADOResult>(procedureName, parameters, CommandType.StoredProcedure);
            return qResult;
        }

        public async Task<List<ProgramacionCurso>> GetProgramacionCurso(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_UNIDAD_DIDACTICA)
        {
            var procedureName = "USP_MATRICULA_SEL_PROGRAMACION_CLASE";
            var parameters = new DynamicParameters();
            parameters.Add("ID_INSTITUCION", ID_INSTITUCION, DbType.Int32, ParameterDirection.Input);
            parameters.Add("ID_PERIODO_ACADEMICO", ID_PERIODO_ACADEMICO, DbType.Int32, ParameterDirection.Input);
            parameters.Add("ID_UNIDAD_DIDACTICA", ID_UNIDAD_DIDACTICA, DbType.Int32, ParameterDirection.Input);


            var qResult = await _database.GetAll<ProgramacionCurso>(procedureName, parameters, CommandType.StoredProcedure);
            return qResult;
        }


        #region Reportes

        public async Task<List<USP_MATRICULA_RPT_BOLETA_NOTASResult>> GetBoletasNotas(int ID_MATRICULA_ESTUDIANTE, int ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
        {
            var procedureName = "USP_MATRICULA_RPT_BOLETA_NOTAS";
            var parameters = new DynamicParameters();
            parameters.Add("ID_MATRICULA_ESTUDIANTE", ID_MATRICULA_ESTUDIANTE, DbType.Int32, ParameterDirection.Input);
            parameters.Add("ID_PERIODOS_LECTIVOS_POR_INSTITUCION", ID_PERIODOS_LECTIVOS_POR_INSTITUCION, DbType.Int32, ParameterDirection.Input);

            var qResult = await _database.GetAll<USP_MATRICULA_RPT_BOLETA_NOTASResult>(procedureName, parameters, CommandType.StoredProcedure);
            return qResult;
        }

        public async Task<List<USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTEResult>> GetHistorialAcademico(int ID_INSTITUCION, int ID_TIPO_DOCUMENTO, string ID_NUMERO_DOCUMENTO, int ID_SEDE_INSTITUCION, int ID_CARRERA, int ID_PLAN_ESTUDIO, int ID_PERIODO_LECTIVO_INSTITUCION)
        {
            var procedureName = "USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE";
            //var procedureName = "USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE_test_ilozano";
            var parameters = new DynamicParameters();
            parameters.Add("@ID_INSTITUCION", ID_INSTITUCION, DbType.Int32, ParameterDirection.Input);
            parameters.Add("@ID_TIPO_DOCUMENTO", ID_TIPO_DOCUMENTO, DbType.Int32, ParameterDirection.Input);
            parameters.Add("@ID_NUMERO_DOCUMENTO", ID_NUMERO_DOCUMENTO, DbType.Int32, ParameterDirection.Input);
            parameters.Add("@ID_SEDE_INSTITUCION", ID_SEDE_INSTITUCION, DbType.Int32, ParameterDirection.Input);
            parameters.Add("@ID_CARRERA", ID_CARRERA, DbType.Int32, ParameterDirection.Input);
            parameters.Add("@ID_PLAN_ESTUDIO", ID_PLAN_ESTUDIO, DbType.Int32, ParameterDirection.Input);
            parameters.Add("@ID_PERIODO_LECTIVO_INSTITUCION", ID_PERIODO_LECTIVO_INSTITUCION, DbType.Int32, ParameterDirection.Input);

            var qResult = await _database.GetAll<USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTEResult>(procedureName, parameters, CommandType.StoredProcedure);
            return qResult;
        }

        public async Task<List<USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_ESTUDIANTE>> GetMatriculaConsolidados(int ID_ESTUDIANTE_INSTITUCION, int ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
        {
            var procedureName = "USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_ESTUDIANTE";
            //var procedureName = "USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTE_test_ilozano";
            var parameters = new DynamicParameters();
            parameters.Add("@ID_ESTUDIANTE_INSTITUCION", ID_ESTUDIANTE_INSTITUCION, DbType.Int32, ParameterDirection.Input);
            parameters.Add("@ID_PERIODOS_LECTIVOS_POR_INSTITUCION", ID_PERIODOS_LECTIVOS_POR_INSTITUCION, DbType.Int32, ParameterDirection.Input);

            var qResult = await _database.GetAll<USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_ESTUDIANTE>(procedureName, parameters, CommandType.StoredProcedure);
            return qResult;
        }

        #endregion

    }
}


