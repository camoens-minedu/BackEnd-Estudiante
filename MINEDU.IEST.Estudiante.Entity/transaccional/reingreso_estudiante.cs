// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable
using System;
using System.Collections.Generic;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class reingreso_estudiante
    {
        public int ID_REINGRESO_ESTUDIANTE { get; set; }
        public int? ID_LICENCIA_ESTUDIANTE { get; set; }
        public int? ID_RESERVA_MATRICULA { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public DateTime? FECHA_FIN { get; set; }
        public string TIEMPO_LICENCIA { get; set; } = null!;
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  licencia_estudiante? ID_LICENCIA_ESTUDIANTENavigation { get; set; }
        public  reserva_matricula? ID_RESERVA_MATRICULANavigation { get; set; }
    }
}