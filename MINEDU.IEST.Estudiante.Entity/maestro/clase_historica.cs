// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class clase_historica
    {
        public int ID_CLASE_HISTORICA { get; set; }
        public int ID_INSTITUCION { get; set; }
        public int ID_SEDE_INSTITUCION { get; set; }
        public int ID_PERIODO_LECTIVO { get; set; }
        public int? PROGRAMA_ESTUDIO { get; set; }
        public int? PROGRAMA_ESTUDIO_HISTORICO { get; set; }
        public int PLAN_ESTUDIO { get; set; }
        public int CICLO { get; set; }
        public int SECCION { get; set; }
        public int TURNO { get; set; }
        public int NIVEL_FORMATIVO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
        public bool? ESTADO { get; set; }
    }
}