﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class proceso_sistema
    {
        public int ID_PROCESO_SISTEMA { get; set; }
        public int ID_TIPO_PROCESO { get; set; }
        public int ID_REGISTRO_ASOCIADO { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
    }
}