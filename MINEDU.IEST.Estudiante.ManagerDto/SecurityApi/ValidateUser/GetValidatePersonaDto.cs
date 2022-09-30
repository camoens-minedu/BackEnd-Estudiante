namespace MINEDU.IEST.Estudiante.ManagerDto.SecurityApi.ValidateUser
{
    public class GetValidatePersonaDto
    {
        public int ID_PERSONA { get; set; }
        public int ID_TIPO_DOCUMENTO { get; set; }
        public string NUMERO_DOCUMENTO_PERSONA { get; set; }
        public string APELLIDO_PATERNO_PERSONA { get; set; }
        public string APELLIDO_MATERNO_PERSONA { get; set; }
        public string NOMBRE_PERSONA { get; set; }
        public virtual List<GetValidatePersonaInstitucionDto> personaInstituciones { get; set; }

    }


    public class GetValidatePersonaInstitucionDto
    {
        public string CORREO { get; set; }
    }
}
