﻿// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class programacion_clase_por_matricula_estudiante
    {
        public int ID_PROGRAMACION_CLASE_POR_MATRICULA_ESTUDIANTE { get; set; }
        public int ID_PROGRAMACION_CLASE { get; set; }
        public int ID_MATRICULA_ESTUDIANTE { get; set; }
        public int ID_ESTADO_UNIDAD_DIDACTICA { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public  matricula_estudiante ID_MATRICULA_ESTUDIANTENavigation { get; set; } = null!;
        public  programacion_clase ID_PROGRAMACION_CLASENavigation { get; set; } = null!;
    }
}