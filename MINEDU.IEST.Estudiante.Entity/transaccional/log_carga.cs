﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class log_carga
    {
        public int ID_LOG_CARGA { get; set; }
        public int ID_DET_ARCHIVO { get; set; }
        public int? NRO_REGISTRO_EXCEL { get; set; }
        public string? MENSAJE { get; set; }
        public int? ES_VIGENTE { get; set; }
        public DateTime? FECHA_INICIO_VIGENCIA { get; set; }
        public DateTime? FECHA_FIN_VIGENCIA { get; set; }
        public DateTime FECHA_CREACION { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime? FECHA_MODIFICACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public int ES_BORRADO { get; set; }

        public  carga_detalle ID_DET_ARCHIVONavigation { get; set; } = null!;
    }
}