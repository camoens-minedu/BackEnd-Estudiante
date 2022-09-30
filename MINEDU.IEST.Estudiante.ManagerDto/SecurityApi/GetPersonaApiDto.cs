namespace MINEDU.IEST.Estudiante.ManagerDto.SecurityApi
{
    public class GetPersonaApiDto
    {
        public int IdPersona { get; set; }
        public int IdTipoDocumento { get; set; }
        public string NumeroDocumentoPersona { get; set; }
        public string NombrePersona { get; set; }
        public string ApellidoPaternoPersona { get; set; }
        public string ApellidoMaternoPersona { get; set; }
        
    }
}
