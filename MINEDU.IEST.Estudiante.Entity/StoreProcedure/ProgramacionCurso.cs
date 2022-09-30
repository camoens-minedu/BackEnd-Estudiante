namespace MINEDU.IEST.Estudiante.Entity.StoreProcedure
{
    public class ProgramacionCurso
    {
        public long IdProgramacionClase { get; set; }
        public long IdUnidadDidactica { get; set; }
        public long IdSedeInstitucion { get; set; }
        public string SedeInstitucion { get; set; }
        public string Seccion { get; set; }
        public string NombreClase { get; set; }
        public string Turno { get; set; }
        public long IdPersonalInstitucion { get; set; }
        public string Docente { get; set; }
        public string Aulas { get; set; }
        public string Horarios { get; set; }
        public long Vacante { get; set; }
        public long VacantesDisp { get; set; }
        public long Row { get; set; }
    }
}
