﻿using MINEDU.IEST.Estudiante.Entity.StoreProcedure;

namespace MINEDU.IEST.Estudiante.Repository.StoreProcedure
{
    public interface IStoreProcedureRepository
    {
        Task<List<USP_MATRICULA_RPT_BOLETA_NOTASResult>> GetBoletasNotas(int ID_MATRICULA_ESTUDIANTE, int ID_PERIODOS_LECTIVOS_POR_INSTITUCION);
        Task<List<USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADOResult>> GetCursosMatricula(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_PLAN_ESTUDIO, int ID_SEMESTRE_ACADEMICO_ACTUAL, int ID_ESTUDIANTE_INSTITUCION, int ID_MATRICULA_ESTUDIANTE, bool ES_UNIDAD_DIDACTICA_EF, int Pagina, int Registros, bool ES_MATRICULA_CON_UD_PREVIAS);
        Task<List<USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULAResult>> GetDatosGeneralesMatricula(int? ID_PLAN_ESTUDIO, int? ID_SEMESTRE_ACADEMICO);
        Task<List<USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTEResult>> GetHistorialAcademico(int ID_INSTITUCION, int ID_TIPO_DOCUMENTO, string ID_NUMERO_DOCUMENTO, int ID_SEDE_INSTITUCION, int ID_CARRERA, int ID_PLAN_ESTUDIO, int ID_PERIODO_LECTIVO_INSTITUCION);
        Task<List<USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_ESTUDIANTE>> GetMatriculaConsolidados(int ID_ESTUDIANTE_INSTITUCION, int ID_PERIODOS_LECTIVOS_POR_INSTITUCION);
        Task<List<ProgramacionCurso>> GetProgramacionCurso(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_UNIDAD_DIDACTICA);
    }
}