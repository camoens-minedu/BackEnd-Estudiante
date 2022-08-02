﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class programacion_clase
    {
       public int ID_PROGRAMACION_CLASE { get; set; }
        public int ID_PERSONAL_INSTITUCION { get; set; }
        public int ID_SEDE_INSTITUCION { get; set; }
        public int ID_PERIODO_ACADEMICO { get; set; }
        public int ID_TURNOS_POR_INSTITUCION { get; set; }
        public int ID_SECCION { get; set; }
        public int? ID_EVALUACION { get; set; }
        public string? CODIGO_CLASE { get; set; }
        public string NOMBRE_CLASE { get; set; } = null!;
        public int? VACANTE_CLASE { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
        public int? ID_PERSONAL_INSTITUCION_SECUNDARIO { get; set; }

        public  evaluacion? ID_EVALUACIONNavigation { get; set; }
        public  periodo_academico ID_PERIODO_ACADEMICONavigation { get; set; } = null!;
        public  sede_institucion ID_SEDE_INSTITUCIONNavigation { get; set; } = null!;
        public  turnos_por_institucion ID_TURNOS_POR_INSTITUCIONNavigation { get; set; } = null!;
        public  ICollection<evaluacion> evaluacion { get; set; }
        public  ICollection<programacion_clase_por_matricula_estudiante> programacion_clase_por_matricula_estudiante { get; set; }
        public  ICollection<sesion_programacion_clase> sesion_programacion_clase { get; set; }
        public  ICollection<unidades_didacticas_por_programacion_clase> unidades_didacticas_por_programacion_clase { get; set; }
    }
}