using MINEDU.IEST.Estudiante.ManagerDto.Maestra;

namespace MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal
{
    public class GetPersonaDto
    {
        public int ID_PERSONA { get; set; }
        public int ID_TIPO_DOCUMENTO { get; set; }
        public string NUMERO_DOCUMENTO_PERSONA { get; set; } = null!;
        public string NOMBRE_PERSONA { get; set; } = null!;
        public string APELLIDO_PATERNO_PERSONA { get; set; } = null!;
        public string? APELLIDO_MATERNO_PERSONA { get; set; }
        public DateTime FECHA_NACIMIENTO_PERSONA { get; set; }
        public short SEXO_PERSONA { get; set; }

        public int ID_LENGUA_MATERNA { get; set; }
        public bool? ES_DISCAPACITADO { get; set; }
        public string? UBIGEO_NACIMIENTO { get; set; }
        public int PAIS_NACIMIENTO { get; set; }
        public int ESTADO { get; set; }

        public string UbigeoNacimientoFull { get; set; }

        public List<GetPersonaInstitucionShortDto> ListPersonaInstitucion { get; set; }

    }
}
