﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity.DigePadron
{
    public partial class IndicadorLogro
    {
        public int IdIndicadorLogro { get; set; }
        public int? IdUnidadCompetencia { get; set; }
        public string CodigoIndicadorLogro { get; set; }
        public string Descripcion { get; set; }
        public int? Estado { get; set; }
        public int? UsuarioInsercion { get; set; }
        public DateTime? FechaInsercion { get; set; }
        public int? UsuarioModificacion { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public string Correlativo { get; set; }

        public  UnidadCompetencium IdUnidadCompetenciaNavigation { get; set; }
    }
}