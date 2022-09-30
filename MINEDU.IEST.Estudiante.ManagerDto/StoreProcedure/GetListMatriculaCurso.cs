namespace MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure
{
    public class GetListMatriculaCurso
    {
        public long IdUnidadDidactica { get; set; }
        public long IdTipoUnidadDidactica { get; set; }
        public string NombreTipoUnidadDidactica { get; set; }
        public long IdModulo { get; set; }
        public string NombreModulo { get; set; }
        public long IdSemestreAcademico { get; set; }
        public long CodigoUnidadDidactica { get; set; }
        public string NombreUnidadDidactica { get; set; }
        public double Horas { get; set; }
        public double Creditos { get; set; }
        public string SemestreAcademico { get; set; }
        public string Estado { get; set; }
        public long NroClasesProgramadas { get; set; }
        public long IdCierreEvaluacion { get; set; }
        public long IdEstadoUnidadDidactica { get; set; }
        public long IdMatriculaEstudiante { get; set; }
        public long IdEvaluacionExperienciaFormativa { get; set; }
        public double Nota { get; set; }
        public long PermiteEditar { get; set; }
        public long Row { get; set; }
        public long Total { get; set; }
    }
}
