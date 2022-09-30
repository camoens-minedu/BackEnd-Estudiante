using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure;

namespace MINEDU.IEST.Estudiante.Manager.StoreProcedure
{
    public interface IStoreProcedureManager
    {
        Task<GetCabeceraMatriculaSpDto> GetCabeceraMatricula(int? ID_PLAN_ESTUDIO, int? ID_SEMESTRE_ACADEMICO);
        Task<List<GetListMatriculaCurso>> GetCursosMatricula(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_PLAN_ESTUDIO, int ID_SEMESTRE_ACADEMICO_ACTUAL, int ID_ESTUDIANTE_INSTITUCION, int ID_MATRICULA_ESTUDIANTE, bool ES_UNIDAD_DIDACTICA_EF, int Pagina, int Registros, bool ES_MATRICULA_CON_UD_PREVIAS);
        Task<List<GetListProgramacionCurso>> GetProgramacionCurso(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_UNIDAD_DIDACTICA);
    }
}