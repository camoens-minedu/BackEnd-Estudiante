﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class convalidacion_detalle
    {
        public int ID_CONVALIDACION_DETALLE { get; set; }
        public int ID_CONVALIDACION { get; set; }
        public int ID_UNIDAD_DIDACTICA { get; set; }
        public decimal NOTA { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  convalidacion ID_CONVALIDACIONNavigation { get; set; } = null!;
        public  unidad_didactica ID_UNIDAD_DIDACTICANavigation { get; set; } = null!;
    }
}