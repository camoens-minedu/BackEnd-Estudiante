﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class liberacion_estudiante
    {
        public int ID_LIBERACION_ESTUDIANTE { get; set; }
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public int ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
        public string? NRO_RD { get; set; }
        public string? ARCHIVO_RD { get; set; }
        public string? ARCHIVO_RUTA { get; set; }

        public  estudiante_institucion ID_ESTUDIANTE_INSTITUCIONNavigation { get; set; } = null!;
        public  periodos_lectivos_por_institucion ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation { get; set; } = null!;
    }
}