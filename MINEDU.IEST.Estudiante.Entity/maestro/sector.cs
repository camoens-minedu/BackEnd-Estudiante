// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class sector
    {
       
        public int ID_SECTOR { get; set; }
        public string CODIGO_SECTOR { get; set; } = null!;
        public string NOMBRE_SECTOR { get; set; } = null!;
        public string? DESCRIPCION_SECTOR { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  ICollection<familia_productiva> familia_productiva { get; set; }
    }
}