﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class enfoque
    {
       

        public int ID_ENFOQUE { get; set; }
        public int ID_MODALIDAD_ESTUDIO { get; set; }
        public string NOMBRE_ENFOQUE { get; set; } = null!;
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  ICollection<enfoques_por_plan_estudio> enfoques_por_plan_estudio { get; set; }
    }
}