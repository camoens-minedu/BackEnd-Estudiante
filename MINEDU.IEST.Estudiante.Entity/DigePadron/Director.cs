﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity.DigePadron
{
    public partial class Director
    {
        public int IdDirector { get; set; }
        public int? IdPersona { get; set; }
        public int? IdInstitucion { get; set; }
        public int? IdDocumentoRespuesta { get; set; }
        public DateTime? FechaInicio { get; set; }
        public DateTime? FechaFin { get; set; }
        public int? Situacion { get; set; }
        public bool? Vigente { get; set; }
        public int Estado { get; set; }
        public int UsuarioInsercion { get; set; }
        public DateTime FechaInsercion { get; set; }
        public int? UsuarioModificacion { get; set; }
        public DateTime? FechaModificacion { get; set; }

        public  Institucion IdInstitucionNavigation { get; set; }
        public  Persona IdPersonaNavigation { get; set; }
    }
}