// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class personal_institucion
    {
       

        public int ID_PERSONAL_INSTITUCION { get; set; }
        public int ID_PERSONA_INSTITUCION { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public int CONDICION_LABORAL { get; set; }
        public int CARGO_PERSONA { get; set; }
        public int ID_TIPO_PERSONAL { get; set; }
        public int ID_ROL { get; set; }
        public int? ID_PERMISO_PASSPORT { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  periodos_lectivos_por_institucion ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation { get; set; } = null!;
        public  persona_institucion ID_PERSONA_INSTITUCIONNavigation { get; set; } = null!;
        public  ICollection<comision_proceso_admision> comision_proceso_admision { get; set; }
        public  ICollection<evaluador_admision_modalidad> evaluador_admision_modalidad { get; set; }
    }
}