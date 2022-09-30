﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class matricula_estudiante
    {
        public int ID_MATRICULA_ESTUDIANTE { get; set; }
        public int ID_PROGRAMACION_MATRICULA { get; set; }
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public int ID_PERIODO_ACADEMICO { get; set; }
        public int ID_SEMESTRE_ACADEMICO { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; }
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
        public DateTime FECHA_MATRICULA { get; set; }

        public estudiante_institucion ID_ESTUDIANTE_INSTITUCIONNavigation { get; set; }
        public periodos_lectivos_por_institucion ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation { get; set; }
        public periodo_academico ID_PERIODO_ACADEMICONavigation { get; set; }
        public programacion_matricula ID_PROGRAMACION_MATRICULANavigation { get; set; }
        public List<evaluacion_detalle> evaluacion_detalle { get; set; }
        public List<evaluacion_experiencia_formativa> evaluacion_experiencia_formativa { get; set; }
        public List<programacion_clase_por_matricula_estudiante> programacion_clase_por_matricula_estudiante { get; set; }
    }
}