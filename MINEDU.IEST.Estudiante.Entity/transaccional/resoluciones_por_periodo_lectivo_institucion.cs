﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class resoluciones_por_periodo_lectivo_institucion
    {
        
        public int ID_RESOLUCIONES_POR_PERIODO_LECTIVO_INSTITUCION { get; set; }
        public int ID_RESOLUCION { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  periodos_lectivos_por_institucion ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation { get; set; } = null!;
        public  resolucion ID_RESOLUCIONNavigation { get; set; } = null!;
        public  ICollection<meta_carrera_institucion> meta_carrera_institucion { get; set; }
    }
}