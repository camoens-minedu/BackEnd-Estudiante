// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class requisito
    {
      

        public int ID_REQUISITO { get; set; }
        public int ID_PROCESO { get; set; }
        public string NOMBRE_REQUISITO { get; set; } = null!;
        public string? DESCRIPCION_REQUISITO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  ICollection<requisitos_por_tipo_modalidad> requisitos_por_tipo_modalidad { get; set; }
        public  ICollection<requisitos_por_traslado_institucion> requisitos_por_traslado_institucion { get; set; }
    }
}