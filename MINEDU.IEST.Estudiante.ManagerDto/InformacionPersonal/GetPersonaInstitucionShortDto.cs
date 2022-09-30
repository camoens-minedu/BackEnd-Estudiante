using MINEDU.IEST.Estudiante.ManagerDto.Maestra;

namespace MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal
{
    public class GetPersonaInstitucionShortDto
    {
        public int ID_PERSONA_INSTITUCION { get; set; }
        public int ID_INSTITUCION { get; set; }
        public short ESTADO_CIVIL { get; set; }
        public string? UBIGEO_PERSONA { get; set; }
        public string? DIRECCION_PERSONA { get; set; }
        public string TELEFONO { get; set; } = null!;
        public string? CELULAR { get; set; }
        public string? CELULAR2 { get; set; }
        public string? CORREO { get; set; }
        public int ID_TIPO_DISCAPACIDAD { get; set; }
        public string UbigeoFull { get; set; }
        public int ESTADO { get; set; }
    }
}
