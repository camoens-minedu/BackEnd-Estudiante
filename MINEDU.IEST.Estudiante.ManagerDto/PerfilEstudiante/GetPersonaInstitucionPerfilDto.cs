namespace MINEDU.IEST.Estudiante.ManagerDto.PerfilEstudiante
{
    public class GetPersonaInstitucionPerfilDto
    {
        public int ID_PERSONA_INSTITUCION { get; set; }
        public int ID_PERSONA { get; set; }
        public short ESTADO_CIVIL { get; set; }
        public int PAIS_PERSONA { get; set; }
        public string? UBIGEO_PERSONA { get; set; }
        public string? DIRECCION_PERSONA { get; set; }
        public string TELEFONO { get; set; } = null!;
        public string? CELULAR { get; set; }
        public string? CELULAR2 { get; set; }
        public string? CORREO { get; set; }
        public int? ANIO_INICIO { get; set; }
        public int? ANIO_FIN { get; set; }
        public DateTime fechaNacimiento { get; set; }
        public string codigoEstudiante { get; set; }
        public List<GetEstudianteInstitucionPerfilDto> EstudianteInstitucionPerfilDtos { get; set; }

        public int IdCarrera { get; set; }
        public string NombrePlanEstudio { get; set; }
        public string NombreCarrera { get; set; }
    }
}
