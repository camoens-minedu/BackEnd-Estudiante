﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity.DigePadron
{
    public partial class Local
    {
        public int IdLocal { get; set; }
        public int? IdInstitucion { get; set; }
        public string CodigoLocal { get; set; }
        public int? Numero { get; set; }
        public int? TipoLocal { get; set; }
        public string NombreLocal { get; set; }
        public int? TipoVia { get; set; }
        public string NombreVia { get; set; }
        public string NumeroVia { get; set; }
        public string CodigoDepartamento { get; set; }
        public string CodigoProvincia { get; set; }
        public string CodigoDistrito { get; set; }
        public string CentroPoblado { get; set; }
        public int? TipoZona { get; set; }
        public string DreGre { get; set; }
        public int Estado { get; set; }
        public int UsuarioInsercion { get; set; }
        public DateTime FechaInsercion { get; set; }
        public int? UsuarioModificacion { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public string ArchivoResolucion { get; set; }

        public  Institucion IdInstitucionNavigation { get; set; }
    }
}