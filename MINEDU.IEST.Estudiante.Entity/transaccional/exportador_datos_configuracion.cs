﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class exportador_datos_configuracion
    {
       public int ID_EXPORTADOR_DATOS_CONFIGURACION { get; set; }
        public int ID_EXPORTADOR_DATOS { get; set; }
        public int ID_INSTITUCION { get; set; }
        public string NOMBRE_CONFIGURACION { get; set; } = null!;
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  exportador_datos ID_EXPORTADOR_DATOSNavigation { get; set; } = null!;
        public  ICollection<exportador_datos_configuracion_detalle> exportador_datos_configuracion_detalle { get; set; }
    }
}