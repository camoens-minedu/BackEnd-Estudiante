// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class proceso_admision_periodo
    {
        public int ID_PROCESO_ADMISION_PERIODO { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public string NOMBRE_PROCESO_ADMISION { get; set; } = null!;
        public DateTime? FECHA_INICIO { get; set; }
        public DateTime? FECHA_FIN { get; set; }
        public string? MODALIDADES { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  periodos_lectivos_por_institucion ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation { get; set; } = null!;
        public  ICollection<comision_proceso_admision> comision_proceso_admision { get; set; }
        public  ICollection<examen_admision_sede> examen_admision_sede { get; set; }
        public  ICollection<modalidades_por_proceso_admision> modalidades_por_proceso_admision { get; set; }
        public  ICollection<tipos_modalidad_por_proceso_admision> tipos_modalidad_por_proceso_admision { get; set; }
    }
}