﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class enumerado
    {
     
        public int ID_ENUMERADO { get; set; }
        public int ID_TIPO_ENUMERADO { get; set; }
        public int? CODIGO_ENUMERADO { get; set; }
        public string? VALOR_ENUMERADO { get; set; }
        public int? ORDEN_ENUMERADO { get; set; }
        public bool ES_EDITABLE { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  tipo_enumerado ID_TIPO_ENUMERADONavigation { get; set; } = null!;
        public  ICollection<carga_masiva_nominas> carga_masiva_nominasID_SECCIONNavigation { get; set; }
        public  ICollection<carga_masiva_nominas> carga_masiva_nominasID_SEMESTRE_ACADEMICONavigation { get; set; }
        public  ICollection<carga_masiva_nominas> carga_masiva_nominasID_TURNONavigation { get; set; }
    }
}