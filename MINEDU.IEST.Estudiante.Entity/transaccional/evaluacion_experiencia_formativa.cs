﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class evaluacion_experiencia_formativa
    {
        public int ID_EVALUACION_EXPERIENCIA_FORMATIVA { get; set; }
        public int ID_MATRICULA_ESTUDIANTE { get; set; }
        public int ID_UNIDADES_DIDACTICAS_POR_ENFOQUE { get; set; }
        public decimal? NOTA { get; set; }
        public int? CIERRE_EVALUACION { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  matricula_estudiante ID_MATRICULA_ESTUDIANTENavigation { get; set; } = null!;
        public  unidades_didacticas_por_enfoque ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation { get; set; } = null!;
    }
}