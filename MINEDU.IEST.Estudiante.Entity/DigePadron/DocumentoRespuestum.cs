﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity.DigePadron
{
    public partial class DocumentoRespuestum
    {
        public DocumentoRespuestum()
        {
            DocumentoRespuestaDetalles = new HashSet<DocumentoRespuestaDetalle>();
            InstitucionMovimientos = new HashSet<InstitucionMovimiento>();
        }

        public int IdDocumentoRespuesta { get; set; }
        public int? TipoDocumento { get; set; }
        public int? TipoTramite { get; set; }
        public string NumeroDocumento { get; set; }
        public DateTime? FechaDocumento { get; set; }
        public string NombreArchivo { get; set; }
        public string RutaArchivo { get; set; }
        public int? Estado { get; set; }
        public int? UsuarioInsercion { get; set; }
        public DateTime? FechaInsercion { get; set; }
        public int? UsuarioModificacion { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public string CodigoModular { get; set; }
        public string NombreTramite { get; set; }
        public string NombreDocumento { get; set; }
        public int? AnioDocumento { get; set; }
        public int? TipoRespuestaAdministrativa { get; set; }
        public string Observacion { get; set; }
        public string PeriodoVigencia { get; set; }
        public int? IdInstitucion { get; set; }

        public  Institucion IdInstitucionNavigation { get; set; }
        public  ICollection<DocumentoRespuestaDetalle> DocumentoRespuestaDetalles { get; set; }
        public  ICollection<InstitucionMovimiento> InstitucionMovimientos { get; set; }
    }
}