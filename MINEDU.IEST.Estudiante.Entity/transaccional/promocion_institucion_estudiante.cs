// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class promocion_institucion_estudiante
    {
        public int ID_PROMOCION_INSTITUCION_ESTUDIANTE { get; set; }
        public int ID_INSTITUCION { get; set; }
        public int TIPO_PROMOCION { get; set; }
        public int TIPO_VERSION { get; set; }
        public int ID_TIPO_UNIDAD_DIDACTICA { get; set; }
        public int CRITERIO { get; set; }
        public int VALOR { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
    }
}