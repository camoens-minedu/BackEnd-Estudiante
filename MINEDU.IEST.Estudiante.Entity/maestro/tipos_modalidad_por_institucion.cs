// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class tipos_modalidad_por_institucion
    {
       

        public int ID_TIPOS_MODALIDAD_POR_INSTITUCION { get; set; }
        public int ID_TIPO_MODALIDAD { get; set; }
        public int ID_INSTITUCION { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  tipo_modalidad ID_TIPO_MODALIDADNavigation { get; set; } = null!;
        public  ICollection<postulantes_por_modalidad> postulantes_por_modalidad { get; set; }
        public  ICollection<requisitos_por_tipo_modalidad> requisitos_por_tipo_modalidad { get; set; }
        public  ICollection<tipos_modalidad_por_proceso_admision> tipos_modalidad_por_proceso_admision { get; set; }
    }
}