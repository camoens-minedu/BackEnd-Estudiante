// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class resoluciones_por_carreras_por_institucion
    {
        public int ID_RESOLUCIONES_POR_CARRERAS_POR_INSTITUCION { get; set; }
        public int ID_RESOLUCION { get; set; }
        public int ID_CARRERAS_POR_INSTITUCION { get; set; }
        public int? ID_SEDE_INSTITUCION { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  carreras_por_institucion ID_CARRERAS_POR_INSTITUCIONNavigation { get; set; } = null!;
        public  resolucion ID_RESOLUCIONNavigation { get; set; } = null!;
        public  sede_institucion? ID_SEDE_INSTITUCIONNavigation { get; set; }
    }
}