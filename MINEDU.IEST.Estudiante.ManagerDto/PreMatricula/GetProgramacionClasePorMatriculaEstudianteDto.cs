namespace MINEDU.IEST.Estudiante.ManagerDto.PreMatricula
{
    public class GetProgramacionClasePorMatriculaEstudianteDto
    {
        public int ID_PROGRAMACION_CLASE_POR_MATRICULA_ESTUDIANTE { get; set; }
        public int ID_PROGRAMACION_CLASE { get; set; }
        public int ID_MATRICULA_ESTUDIANTE { get; set; }
        public int ID_ESTADO_UNIDAD_DIDACTICA { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
    }
}
