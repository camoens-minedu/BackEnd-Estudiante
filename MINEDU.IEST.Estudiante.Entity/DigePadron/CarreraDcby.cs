﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable

namespace MINEDU.IEST.Estudiante.Entity.DigePadron
{
    public partial class CarreraDcby
    {
        public int IdCarreraDcbIes { get; set; }
        public string CodigoCarreraDcbIes { get; set; }
        public string NombreCarreraDcbIes { get; set; }
        public string Correlativo { get; set; }
        public int? IdActividadEconomica { get; set; }
        public int? IdNivelEstudio { get; set; }
        public int? TipoPeriodoDuracion { get; set; }
        public string Duracion { get; set; }
        public int? TipoClasificador { get; set; }
        public int? IdSector { get; set; }
        public int? IdFamiliaProductiva { get; set; }
        public string Creditos { get; set; }
        public int? Horas { get; set; }
        public int? Vigencia { get; set; }
        public int? Estado { get; set; }
        public int? UsuarioInsercion { get; set; }
        public DateTime? FechaInsercion { get; set; }
        public int? UsuarioModificacion { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public  TipoNivelEstudio IdNivelEstudioNavigation { get; set; }
    }
}