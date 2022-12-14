// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class institucion_basica
    {
       

        public int ID_INSTITUCION_BASICA { get; set; }
        public int ID_TIPO_INSTITUCION_BASICA { get; set; }
        public string? CODIGO_MODULAR_IE_BASICA { get; set; }
        public string? NOMBRE_IE_BASICA { get; set; }
        public int ID_NIVEL_IE_BASICA { get; set; }
        public int ID_TIPO_GESTION_IE_BASICA { get; set; }
        public string? DIRECCION_IE_BASICA { get; set; }
        public int ID_PAIS { get; set; }
        public string? UBIGEO_IE_BASICA { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  ICollection<estudiante_institucion> estudiante_institucion { get; set; }
        public  ICollection<postulantes_por_modalidad> postulantes_por_modalidad { get; set; }
    }
}