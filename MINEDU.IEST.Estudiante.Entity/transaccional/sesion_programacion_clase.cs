﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class sesion_programacion_clase
    {
        public int ID_SESION_PROGRAMACION_CLASE { get; set; }
        public int ID_PROGRAMACION_CLASE { get; set; }
        public int ID_AULA { get; set; }
        public int? DIA { get; set; }
        public string? HORA_INICIO { get; set; }
        public string? HORA_FIN { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
        public int ID_TIPO_CLASE { get; set; }
        public int? ID_PERSONAL_INSTITUCION { get; set; }
        public int? ID_DOCENTE_CLASE { get; set; }

        public  aula ID_AULANavigation { get; set; } = null!;
        public  programacion_clase ID_PROGRAMACION_CLASENavigation { get; set; } = null!;
    }
}