// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class tipos_modalidad_por_proceso_admision
    {
        public int ID_TIPOS_MODALIDAD_POR_PROCESO_ADMISION { get; set; }
        public int ID_PROCESO_ADMISION_PERIODO { get; set; }
        public int ID_TIPOS_MODALIDAD_POR_INSTITUCION { get; set; }
        public int META { get; set; }
        public int ID_TIPO_META { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  proceso_admision_periodo ID_PROCESO_ADMISION_PERIODONavigation { get; set; } = null!;
        public  tipos_modalidad_por_institucion ID_TIPOS_MODALIDAD_POR_INSTITUCIONNavigation { get; set; } = null!;
    }
}