namespace MINEDU.IEST.Estudiante.ManagerDto.PreMatricula
{
    public class GetProgramacionMatriculaDto
    {
        public int ID_PROGRAMACION_MATRICULA { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public int ID_TIPO_MATRICULA { get; set; }
        public DateTime? FECHA_INICIO { get; set; }
        public DateTime? FECHA_FIN { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public bool CERRADO { get; set; }
    }
}
