using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure;
using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure.Reportes;

namespace MINEDU.IEST.Estudiante.Manager.StoreProcedure
{
    public interface IStoreProcedureManager
    {
        Task<List<GetBoletaNotasByMatriculaDto>> GetBoletasNotas(int ID_MATRICULA_ESTUDIANTE, int ID_PERIODOS_LECTIVOS_POR_INSTITUCION);
        Task<GetCabeceraMatriculaSpDto> GetCabeceraMatricula(int? ID_PLAN_ESTUDIO, int? ID_SEMESTRE_ACADEMICO, int ID_PERIODOS_LECTIVOS_POR_INSTITUCION);
        Task<List<GetListMatriculaCurso>> GetCursosMatricula(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_PLAN_ESTUDIO, int ID_SEMESTRE_ACADEMICO_ACTUAL, int ID_ESTUDIANTE_INSTITUCION, int ID_MATRICULA_ESTUDIANTE, bool ES_UNIDAD_DIDACTICA_EF, int Pagina, int Registros, bool ES_MATRICULA_CON_UD_PREVIAS);
        Task<List<GetHistorialAcademicoDto>> GetHistorialAcademico(int ID_INSTITUCION, int ID_TIPO_DOCUMENTO, string ID_NUMERO_DOCUMENTO, int ID_SEDE_INSTITUCION, int ID_CARRERA, int ID_PLAN_ESTUDIO, int ID_PERIODO_LECTIVO_INSTITUCION);
        Task<List<GetListProgramacionCurso>> GetProgramacionCurso(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_UNIDAD_DIDACTICA);
    }
}