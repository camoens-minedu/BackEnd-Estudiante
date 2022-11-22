using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi;

namespace MINEDU.IEST.Estudiante.ManagerDto.Reporte.FichaMatricula
{
    public class GetFichaMatriculaEstudianteDto
    {
        public int ID_MATRICULA_ESTUDIANTE { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public GetEstudianteInsitucionApiDto carrera { get; set; }
        public GetAuxInstitucionDto instituto { get; set; }
        public GetFichaEstudiante_institucionDto estudianteInstitucion { get; set; }
        public List<GetFichaProgramacion_clase_por_matricula_estudianteDto> DetalleMatriculaCursos { get; set; }


    }

    #region REporte historial
    public class GetFichaEstudiante_institucionHistorialDto
    {
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public GetEstudianteInsitucionApiDto carrera { get; set; }
        public GetAuxInstitucionDto instituto { get; set; }
        public GetFichaPersona_institucionDto personaInstitucion { get; set; }
    } 
    #endregion

    public class GetFichaEstudiante_institucionDto
    {
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public GetFichaPersona_institucionDto personaInstitucion { get; set; }
    }

    public class GetFichaPersona_institucionDto
    {
        public int ID_PERSONA_INSTITUCION { get; set; }
        public GetFichaPersona persona { get; set; }
    }

    public class GetFichaPersona
    {
        public int ID_PERSONA { get; set; }
        public string NUMERO_DOCUMENTO_PERSONA { get; set; } = null!;
        public string NOMBRE_PERSONA { get; set; } = null!;
        public string APELLIDO_PATERNO_PERSONA { get; set; } = null!;
        public string? APELLIDO_MATERNO_PERSONA { get; set; }

        public string fullName => $"{APELLIDO_PATERNO_PERSONA} {APELLIDO_MATERNO_PERSONA}, {NOMBRE_PERSONA}";

    }

    public class GetFichaProgramacion_clase_por_matricula_estudianteDto
    {
        public int ID_MATRICULA_ESTUDIANTE { get; set; }
        public int ID_PROGRAMACION_CLASE { get; set; }
        public int ID_ESTADO_UNIDAD_DIDACTICA { get; set; }
        public GetFichaProgramacion_claseDto programacionClase { get; set; }

    }

    public class GetFichaProgramacion_claseDto
    {
        public int ID_PROGRAMACION_CLASE { get; set; }
        public int ID_PERSONAL_INSTITUCION { get; set; }
        public string NombreProfesor { get; set; }
        public List<GetFichaUnidades_didacticas_por_programacion_claseDto> listUnidadDidacticasPC { get; set; }
        public List<GetFichaSesionProgramacionClaseDto> sesion_programacion_clase { get; set; }
    }
    public class GetFichaUnidades_didacticas_por_programacion_claseDto
    {
        public int ID_UNIDADES_DIDACTICAS_POR_PROGRAMACION_CLASE { get; set; }
        public int ID_PROGRAMACION_CLASE { get; set; }
        public int ID_UNIDADES_DIDACTICAS_POR_ENFOQUE { get; set; }
        public GetFichaUnidades_didacticas_por_enfoqueDto unidadEnfoque { get; set; }

    }

    public class GetFichaUnidades_didacticas_por_enfoqueDto
    {
        public int ID_UNIDADES_DIDACTICAS_POR_ENFOQUE { get; set; }
        public int ID_TIPO_UNIDAD_DIDACTICA { get; set; }
        public int ID_UNIDAD_DIDACTICA { get; set; }
        public GetFichaUnidad_didacticaDto unidadDidactica { get; set; }

    }

    public class GetFichaUnidad_didacticaDto
    {
        public string CODIGO_UNIDAD_DIDACTICA { get; set; }
        public int ID_SEMESTRE_ACADEMICO { get; set; }
        public string texto_SEMESTRE_ACADEMICO { get; set; }
        public string NOMBRE_UNIDAD_DIDACTICA { get; set; }
        public string DESCRIPCION { get; set; }
        public decimal HORAS { get; set; }
        public decimal CREDITOS { get; set; }

    }

    public class GetFichaSesionProgramacionClaseDto
    {
        public int ID_PROGRAMACION_CLASE { get; set; }
        public int ID_AULA { get; set; }
        public int DIA { get; set; }
        public string HORA_INICIO { get; set; }
        public string HORA_FIN { get; set; }
        public GetFichaAulaDto Aula { get; set; }

    }

    public class GetFichaAulaDto
    {
        public string NOMBRE_AULA { get; set; }
        public int ID_PISO { get; set; }
        public int CATEGORIA_AULA { get; set; }
        public string UBICACION_AULA { get; set; }
        public GetFichaSedeInstitucion sede { get; set; }
    }

    public class GetFichaSedeInstitucion
    {
        public string NOMBRE_SEDE { get; set; }
        public string CODIGO_SEDE { get; set; }
        public string DIRECCION_SEDE { get; set; }
    }
}
