﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable disable

namespace MINEDU.IEST.Estudiante.Entity.SecurityApi
{
    public partial class Persona
    {
        public int IdPersona { get; set; }
        public int IdTipoDocumento { get; set; }
        public string NumeroDocumentoPersona { get; set; }
        public string NombrePersona { get; set; }
        public string ApellidoPaternoPersona { get; set; }
        public string ApellidoMaternoPersona { get; set; }
        public DateTime FechaNacimientoPersona { get; set; }
        public short SexoPersona { get; set; }
        public int IdLenguaMaterna { get; set; }
        public bool? EsDiscapacitado { get; set; }
        public string UbigeoNacimiento { get; set; }
        public int PaisNacimiento { get; set; }
        public int Estado { get; set; }
        public string UsuarioCreacion { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string UsuarioModificacion { get; set; }
        public DateTime? FechaModificacion { get; set; }
      
    }
}