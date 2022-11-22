namespace MINEDU.IEST.Estudiante.ManagerDto.PerfilEstudiante
{
    public class GetEstudianteInstitucionPerfilDto
    {
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public int? ID_INSTITUCION_BASICA { get; set; }
        public int ID_CARRERAS_POR_INSTITUCION_DETALLE { get; set; }
        public int ID_TURNOS_POR_INSTITUCION { get; set; }
        public int ID_SEMESTRE_ACADEMICO { get; set; }
        public int ID_TIPO_ESTUDIANTE { get; set; }
        public string? CODIGO_ESTUDIANTE { get; set; }
        public int? ANIO_EGRESO { get; set; }
        public int ID_TIPO_DOCUMENTO_APODERADO { get; set; }
        public int ID_TIPO_PARENTESCO { get; set; }
        public string? NUMERO_DOCUMENTO_APODERADO { get; set; }
        public string? NOMBRE_APODERADO { get; set; }
        public string? APELLIDO_APODERADO { get; set; }
        public string? ARCHIVO_FOTO { get; set; }
        public string? ARCHIVO_RUTA { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public int? ID_PLAN_ESTUDIO { get; set; }
        public string xCodigoPeriodoLectivoIngreso { get; set; }
        public string xTextoSituacion { get; set; }
        public string xTextoModalidad { get; set; }
        public string xPeriodoAcademicoActual { get; set; }
        public string xNombreSede { get; set; }

        public GetInstitucionBasicaPerfilDto GetInstitucionBasicaPerfilDto { get; set; }
        public GetPeriodoLecticoPorInstitucionPerfilDto GetPeriodoLecticoPorInstitucionPerfilDto { get; set; }

        public GetTurnosPorInstitucionPerfilDto GetTurnosPorInstitucionPerfilDto { get; set; }


        //public carreras_por_institucion_detalle ID_CARRERAS_POR_INSTITUCION_DETALLENavigation { get; set; } = null!;
        //public institucion_basica? ID_INSTITUCION_BASICANavigation { get; set; }
        //public periodos_lectivos_por_institucion ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation { get; set; } = null!;
        //public persona_institucion ID_PERSONA_INSTITUCIONNavigation { get; set; } = null!;
        //public plan_estudio? ID_PLAN_ESTUDIONavigation { get; set; }
        //public turnos_por_institucion ID_TURNOS_POR_INSTITUCIONNavigation { get; set; } = null!;
        //public ICollection<evaluacion_extraordinaria> evaluacion_extraordinaria { get; set; }
        //public ICollection<liberacion_estudiante> liberacion_estudiante { get; set; }
        //public ICollection<matricula_estudiante> matricula_estudiante { get; set; }
        //public ICollection<reserva_matricula> reserva_matricula { get; set; }
        //public ICollection<retiro_estudiante> retiro_estudiante { get; set; }
    }
}
