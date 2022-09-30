namespace MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal
{
    public class GetPersonaInstitucionDto
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
    }
}
