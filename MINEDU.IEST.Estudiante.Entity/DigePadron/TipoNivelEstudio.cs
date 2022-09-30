﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity.DigePadron
{
    public partial class TipoNivelEstudio
    {
        public TipoNivelEstudio()
        {
            CarreraAdicionals = new HashSet<CarreraAdicional>();
            CarreraDcbies = new HashSet<CarreraDcby>();
            CarreraDcbs = new HashSet<CarreraDcb>();
        }

        public int IdNivelEstudio { get; set; }
        public string NombreNivelEstudio { get; set; }
        public int? UltimoDigitoClasificador { get; set; }
        public int? TipoNivelFormacion { get; set; }
        public string TipoPeriodoDuracion { get; set; }
        public string DuracionMinima { get; set; }
        public int? Estado { get; set; }
        public int? UsuarioInsercion { get; set; }
        public DateTime? FechaInsercion { get; set; }
        public int? UsuarioModificacion { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public int? DigitoNivelFormativoDcb { get; set; }

        public  ICollection<CarreraAdicional> CarreraAdicionals { get; set; }
        public  ICollection<CarreraDcby> CarreraDcbies { get; set; }
        public  ICollection<CarreraDcb> CarreraDcbs { get; set; }
    }
}