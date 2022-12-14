// <auto-generated> This file has been auto generated by EF Core Power Tools. </auto-generated>
#nullable enable

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class postulantes_por_modalidad
    {
        public int ID_POSTULANTES_POR_MODALIDAD { get; set; }
        public int ID_MODALIDADES_POR_PROCESO_ADMISION { get; set; }
        public int ID_TIPOS_MODALIDAD_POR_INSTITUCION { get; set; }
        public int ID_EXAMEN_ADMISION_SEDE { get; set; }
        public int ID_PERSONA_INSTITUCION { get; set; }
        public int ID_INSTITUCION_BASICA { get; set; }
        public string? CODIGO_POSTULANTE { get; set; }
        public string? _CODIGO_ESTUDIANTE { get; set; }
        public int? ANIO_EGRESO { get; set; }
        public int ID_TIPO_DOCUMENTO_APODERADO { get; set; }
        public string? NUMERO_DOCUMENTO_APODERADO { get; set; }
        public string? NOMBRE_APODERADO { get; set; }
        public string? APELLIDO_APODERADO { get; set; }
        public int ID_TIPO_PARENTEZCO { get; set; }
        public int ID_TIPO_PAGO { get; set; }
        public string? NUMERO_COMPROBANTE { get; set; }
        public decimal? MONTO_PAGO { get; set; }
        public string? MOTIVO_EXONERACION { get; set; }
        public bool ES_ACTIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
        public string? ARCHIVO_FOTO { get; set; }
        public string? ARCHIVO_RUTA { get; set; }
        public string? ARCHIVO_COMPROBANTE { get; set; }
        public string? ARCHIVO_COMPROBANTE_RUTA { get; set; }

        public examen_admision_sede ID_EXAMEN_ADMISION_SEDENavigation { get; set; } = null!;
        public institucion_basica ID_INSTITUCION_BASICANavigation { get; set; } = null!;
        public modalidades_por_proceso_admision ID_MODALIDADES_POR_PROCESO_ADMISIONNavigation { get; set; } = null!;
        public persona_institucion ID_PERSONA_INSTITUCIONNavigation { get; set; } = null!;
        public tipos_modalidad_por_institucion ID_TIPOS_MODALIDAD_POR_INSTITUCIONNavigation { get; set; } = null!;
        public ICollection<distribucion_evaluacion_admision_detalle> distribucion_evaluacion_admision_detalle { get; set; }
        public ICollection<opciones_por_postulante> opciones_por_postulante { get; set; }
        public ICollection<requisitos_por_postulante> requisitos_por_postulante { get; set; }
        public ICollection<resultados_por_postulante> resultados_por_postulante { get; set; }
    }
}