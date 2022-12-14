// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class programacion_matricula
    {
        public int ID_PROGRAMACION_MATRICULA { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public int ID_TIPO_MATRICULA { get; set; }
        public DateTime? FECHA_INICIO { get; set; }
        public DateTime? FECHA_FIN { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
        public bool CERRADO { get; set; }

        public periodos_lectivos_por_institucion ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation { get; set; } = null!;
        public ICollection<carga> carga { get; set; }
        public ICollection<matricula_estudiante> matricula_estudiante { get; set; }
    }
}