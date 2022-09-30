namespace MINEDU.IEST.Estudiante.ManagerDto.PreMatricula
{
    public class GetMatriculaEstudianteDto
    {
        public int ID_MATRICULA_ESTUDIANTE { get; set; }
        public int ID_PROGRAMACION_MATRICULA { get; set; }
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public int ID_PERIODO_ACADEMICO { get; set; }
        public int ID_SEMESTRE_ACADEMICO { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
       

        public List<GetProgramacionClasePorMatriculaEstudianteDto> GetProgramacionClasePorMatriculaEstudianteDtos { get; set; }
    }
}
