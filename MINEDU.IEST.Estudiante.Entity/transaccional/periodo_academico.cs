﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class periodo_academico
    {
       public int ID_PERIODO_ACADEMICO { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public string? NOMBRE_PERIODO_ACADEMICO { get; set; }
        public DateTime? FECHA_INICIO { get; set; }
        public DateTime? FECHA_FIN { get; set; }
        public bool? ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  periodos_lectivos_por_institucion ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation { get; set; } = null!;
        public  ICollection<carga> carga { get; set; }
        public  ICollection<cierre_periodo_clases> cierre_periodo_clases { get; set; }
        public  ICollection<matricula_estudiante> matricula_estudiante { get; set; }
        public  ICollection<programacion_clase> programacion_clase { get; set; }
    }
}