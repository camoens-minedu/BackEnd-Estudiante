﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class traslado_estudiante
    {
       
        public int ID_TRASLADO_ESTUDIANTE { get; set; }
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public int ID_SITUACION_ACADEMICA_ORIGEN { get; set; }
        public int ID_SITUACION_ACADEMICA_DESTINO { get; set; }
        public int ID_TIPO_TRASLADO { get; set; }
        public int ID_LIBERACION_ESTUDIANTE { get; set; }
        public DateTime? FECHA_INICIO { get; set; }
        public DateTime? FECHA_FIN { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
        public int? ID_TIPO_SOLICITUD { get; set; }
        public bool? ES_CONVALIDACION_EXONERADA { get; set; }
        public int? ID_ESTUDIANTE_INSTITUCION_NUEVO { get; set; }

        public  ICollection<requisitos_por_traslado_estudiante> requisitos_por_traslado_estudiante { get; set; }
        public  ICollection<traslado_estudiante_detalle> traslado_estudiante_detalle { get; set; }
    }
}