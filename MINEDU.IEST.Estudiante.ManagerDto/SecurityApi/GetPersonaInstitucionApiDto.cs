using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar;

namespace MINEDU.IEST.Estudiante.ManagerDto.SecurityApi
{
    public class GetPersonaInstitucionApiDto
    {
        public int ID_PERSONA_INSTITUCION { get; set; }
        public int ID_PERSONA { get; set; }
        public int ID_INSTITUCION { get; set; }
        public GetAuxInstitucionDto institucion { get; set; }
        public bool tieneCarreras { get; set; }
        public List<GetEstudianteInsitucionApiDto> carreras { get; set; }
    }
}
