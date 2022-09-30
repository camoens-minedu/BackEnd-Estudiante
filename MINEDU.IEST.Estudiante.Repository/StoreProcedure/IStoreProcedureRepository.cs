using MINEDU.IEST.Estudiante.Entity.StoreProcedure;

namespace MINEDU.IEST.Estudiante.Repository.StoreProcedure
{
    public interface IStoreProcedureRepository
    {
        Task<List<USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADOResult>> GetCursosMatricula(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_PLAN_ESTUDIO, int ID_SEMESTRE_ACADEMICO_ACTUAL, int ID_ESTUDIANTE_INSTITUCION, int ID_MATRICULA_ESTUDIANTE, bool ES_UNIDAD_DIDACTICA_EF, int Pagina, int Registros, bool ES_MATRICULA_CON_UD_PREVIAS);
        Task<List<USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULAResult>> GetDatosGeneralesMatricula(int? ID_PLAN_ESTUDIO, int? ID_SEMESTRE_ACADEMICO);
        Task<List<ProgramacionCurso>> GetProgramacionCurso(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_UNIDAD_DIDACTICA);
    }
}