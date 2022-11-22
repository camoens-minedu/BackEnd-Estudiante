namespace MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure.Reportes
{
    public class GetBoletaNotasByMatriculaDto
    {
        public long? ROW { get; set; }
        public string NOMBRE_DEPARTAMENTO { get; set; }
        public string NOMBRE_PROVINCIA { get; set; }
        public string NOMBRE_DISTRITO { get; set; }
        public string CODIGO_MODULAR { get; set; }
        public string DRE_GRE { get; set; }
        public string NOMBRE_INSTITUCION { get; set; }
        public string TIPO_GESTION_NOMBRE { get; set; }
        public string NUMERO_DOCUMENTO_PERSONA { get; set; }
        public string ESTUDIANTE { get; set; }
        public string NIVEL_FORMACION { get; set; }
        public string FOTO { get; set; }
        public string CODIGO_PERIODO_LECTIVO { get; set; }
        public string NOMBRE_CARRERA { get; set; }
        public string TIPO_PLAN_ESTUDIOS { get; set; }
        public string NOMBRE_PLAN_ESTUDIOS { get; set; }
        public string SEMESTRE_ACADEMICO_ESTUDIANTE { get; set; }
        public string SEMESTRE_ACADEMICO_UNIDAD_DIDACTICA { get; set; }
        public string NOMBRE_PERIODO_ACADEMICO { get; set; }
        public int ID_MATRICULA_ESTUDIANTE { get; set; }
        public string NOMBRE_UNIDAD_DIDACTICA { get; set; }
        public decimal? NOTA { get; set; }
    }
}
