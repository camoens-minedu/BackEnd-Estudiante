// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity.DigePadron
{
    public partial class UnidadCompetenciaCarrera
    {
        public int IdUnidadCompetenciaCarrera { get; set; }
        public int? IdCarreraDcb { get; set; }
        public int? Estado { get; set; }
        public int? UsuarioInsercion { get; set; }
        public DateTime? FechaInsercion { get; set; }
        public int? UsuarioModificacion { get; set; }
        public DateTime? FechaModificaion { get; set; }

        public  CarreraDcb IdCarreraDcbNavigation { get; set; }
    }
}