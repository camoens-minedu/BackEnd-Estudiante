using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar.Pais;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;

namespace MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal
{
    public class GetInfoPersonalForEdit
    {
        public GetPersonaDto Persona { get; set; }

        public List<GetEnumeradoComboDto> tipoDocumento { get; set; }
        public List<GetEnumeradoComboDto> sexo { get; set; }
        public List<GetEnumeradoComboDto> tipoLenguaMaterna { get; set; }
        public List<GetPaisDto> paises { get; set; }
    }
}
