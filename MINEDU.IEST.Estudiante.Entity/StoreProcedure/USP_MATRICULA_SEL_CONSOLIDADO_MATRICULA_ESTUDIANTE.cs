namespace MINEDU.IEST.Estudiante.Entity.StoreProcedure
{
    public class USP_MATRICULA_SEL_CONSOLIDADO_MATRICULA_ESTUDIANTE
    {
        public long ID_MATRICULA_ESTUDIANTE { get; set; }

        public string CODIGO_PERIODO_LECTIVO { get; set; }

        public DateTime FECHA_MATRICULA { get; set; }

        public string SITUACION { get; set; }

        public long UD_MATRICULADOS { get; set; }

        public double CRED_MATRICULADOS { get; set; }

        public long UD_APROBADOS { get; set; }

        public double CRED_APROBADOS { get; set; }
    }
}
