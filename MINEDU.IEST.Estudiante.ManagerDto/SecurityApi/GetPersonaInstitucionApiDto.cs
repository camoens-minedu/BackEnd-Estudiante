using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar;

namespace MINEDU.IEST.Estudiante.ManagerDto.SecurityApi
{
    public class GetPersonaInstitucionApiDto
    {
        public int ID_PERSONA_INSTITUCION { get; set; }
        public int ID_PERSONA { get; set; }
        public int ID_INSTITUCION { get; set; }
        public int ID_PERIODO_ACADEMICO { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION_main { get; set; }
        public string CODIGO_PERIODO_LECTIVO { get; set; }
        public GetAuxInstitucionDto institucion { get; set; }
        public bool tieneCarreras { get; set; }
        public List<GetEstudianteInsitucionApiDto> carreras { get; set; }
    }
}
