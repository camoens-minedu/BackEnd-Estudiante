﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class evaluador_admision_modalidad
    {
   
        public int ID_EVALUADOR_ADMISION_MODALIDAD { get; set; }
        public int ID_MODALIDADES_POR_PROCESO_ADMISION { get; set; }
        public int ID_PERSONAL_INSTITUCION { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  modalidades_por_proceso_admision ID_MODALIDADES_POR_PROCESO_ADMISIONNavigation { get; set; } = null!;
        public  personal_institucion ID_PERSONAL_INSTITUCIONNavigation { get; set; } = null!;
        public  ICollection<distribucion_examen_admision> distribucion_examen_admision { get; set; }
    }
}