namespace MINEDU.IEST.Estudiante.ManagerDto.PreMatricula
{
    public class GetMatriculaRequestDto
    {
        public int ID_INSTITUCION { get; set; }
        public int ID_PERIODO_ACADEMICO { get; set; }
        public int ID_PLAN_ESTUDIO { get; set; }
        public int ID_SEMESTRE_ACADEMICO_ACTUAL { get; set; }
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public int ID_MATRICULA_ESTUDIANTE { get; set; }
        public bool ES_UNIDAD_DIDACTICA_EF { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public int Pagina { get; set; }
        public int Registros { get; set; }
        public bool ES_MATRICULA_CON_UD_PREVIAS { get; set; }
    }
}
