﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class distribucion_examen_admision
    {
        public int ID_DISTRIBUCION_EXAMEN_ADMISION { get; set; }
        public int ID_EVALUADOR_ADMISION_MODALIDAD { get; set; }
        public int ID_EXAMEN_ADMISION_SEDE { get; set; }
        public int ID_AULA { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  aula ID_AULANavigation { get; set; } = null!;
        public  evaluador_admision_modalidad ID_EVALUADOR_ADMISION_MODALIDADNavigation { get; set; } = null!;
        public  examen_admision_sede ID_EXAMEN_ADMISION_SEDENavigation { get; set; } = null!;
        public  ICollection<distribucion_evaluacion_admision_detalle> distribucion_evaluacion_admision_detalle { get; set; }
    }
}