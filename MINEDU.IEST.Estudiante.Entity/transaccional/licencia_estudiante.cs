﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class licencia_estudiante
    {
     
        public int ID_LICENCIA_ESTUDIANTE { get; set; }
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public int ID_TIPO_LICENCIA { get; set; }
        public int? ID_TIEMPO_PERIODO_LICENCIA { get; set; }
        public DateTime? FECHA_INICIO { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
        public string ARCHIVO_RD { get; set; } = null!;
        public string ARCHIVO_RUTA { get; set; } = null!;

        public  ICollection<reingreso_estudiante> reingreso_estudiante { get; set; }
    }
}