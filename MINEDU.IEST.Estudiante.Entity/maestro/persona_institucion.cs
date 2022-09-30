using System.ComponentModel.DataAnnotations.Schema;

namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class persona_institucion
    {

        public int ID_PERSONA_INSTITUCION { get; set; }
        public int ID_PERSONA { get; set; }
        public int ID_INSTITUCION { get; set; }
        public short ESTADO_CIVIL { get; set; }
        public int PAIS_PERSONA { get; set; }
        public string? UBIGEO_PERSONA { get; set; }
        public string? DIRECCION_PERSONA { get; set; }
        public string TELEFONO { get; set; } = null!;
        public string? CELULAR { get; set; }
        public string? CELULAR2 { get; set; }
        public string? CORREO { get; set; }
        public int ID_TIPO_DISCAPACIDAD { get; set; }
        public int ID_GRADO_PROFESIONAL { get; set; }
        public string? OCUPACION_PERSONA { get; set; }
        public string? TITULO_PROFESIONAL { get; set; }
        public int? ID_CARRERA_PROFESIONAL { get; set; }
        public string? INSTITUCION_PROFESIONAL { get; set; }
        public int? ANIO_INICIO { get; set; }
        public int? ANIO_FIN { get; set; }
        public int NIVEL_EDUCATIVO { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }

        public carrera_profesional? ID_CARRERA_PROFESIONALNavigation { get; set; }
        public persona ID_PERSONANavigation { get; set; }
        public List<estudiante_institucion> estudiante_institucion { get; set; }
        public List<personal_institucion> personal_institucion { get; set; }
        public List<postulantes_por_modalidad> postulantes_por_modalidad { get; set; }


        #region Adicionales
        [NotMapped]
        public int IdCarrera { get; set; }
        [NotMapped]
        public string NombrePlanEstudio { get; set; }
        [NotMapped]
        public DateTime fechaNacimiento { get; set; }
        [NotMapped] 
        public string codigoEstudiante { get; set; }
        #endregion
    }
}