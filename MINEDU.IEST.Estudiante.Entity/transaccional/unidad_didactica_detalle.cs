// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class unidad_didactica_detalle
    {
        public int ID_UNIDAD_DIDACTICA_DETALLE { get; set; }
        public int ID_UNIDAD_DIDACTICA { get; set; }
        public string CODIGO_PREDECESORA { get; set; } = null!;
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  unidad_didactica ID_UNIDAD_DIDACTICANavigation { get; set; } = null!;
    }
}