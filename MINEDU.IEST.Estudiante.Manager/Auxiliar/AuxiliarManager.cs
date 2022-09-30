using AutoMapper;
using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar.Pais;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Manager.Auxiliar
{
    public class AuxiliarManager : IAuxiliarManager
    {
        private readonly IMapper _mapper;
        private readonly AuxiliarUnitOfWork _auxiliarUnitOfWork;

        public AuxiliarManager(IMapper mapper, AuxiliarUnitOfWork auxiliarUnitOfWork)
        {
            this._mapper = mapper;
            this._auxiliarUnitOfWork = auxiliarUnitOfWork;
        }

        public async Task<GetPaisDto> GetPaisByCodigo(string codigo)
        {
            var query = await _auxiliarUnitOfWork._auxiliarRepository.GetPaisAuxiliarByCodigo($"{codigo}00000");
            return _mapper.Map<GetPaisDto>(query);

        }


        public async Task<List<GetPaisDto>> GetPaisAll()
        {
            return _mapper.Map<List<GetPaisDto>>(_auxiliarUnitOfWork._auxiliarRepository.GetAll());
        }


        public async Task<GetUbigeoAuxiliarDto> GetUbigeoAuxiliarById(string id)
        {
            return _mapper.Map<GetUbigeoAuxiliarDto>(_auxiliarUnitOfWork._auxiliarRepository.GetUbigeoAuxiliarById(id));
        }


    }
}
