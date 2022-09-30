using AutoMapper;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Inf_Utils.Enumerados;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Manager.Maestra
{
    public class MaestraManager : IMaestraManager
    {
        private readonly MaestrasUnitOfWork _unitOfWork;
        private readonly IMapper mapper;

        public MaestraManager(IMapper mapper, MaestrasUnitOfWork unitOfWork)
        {

            this.mapper = mapper;
            _unitOfWork = unitOfWork;
        }
        public async Task<List<GetTipoEnumeradoDto>> GetListEnumerado()
        {
            try
            {
                var query = mapper.Map<List<GetTipoEnumeradoDto>>(await _unitOfWork._maestraRepository.GetListEnumeradosSistema());
                return query;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<Dictionary<EnumeradoCabecera, List<GetEnumeradoComboDto>>> GetListEnumeradoByGrupo(List<EnumeradoCabecera> listaMaestra)
        {
            try
            {
                Dictionary<EnumeradoCabecera, List<enumerado>> lista = await _unitOfWork._maestraRepository.GetListEnumeradoByGrupo(listaMaestra);
                var listaEntera = listaMaestra.Select(x => (int)x).ToList();
                Dictionary<EnumeradoCabecera, List<GetEnumeradoComboDto>> listaRes = new Dictionary<EnumeradoCabecera, List<GetEnumeradoComboDto>>();
                foreach (EnumeradoCabecera item in listaEntera)
                {
                    listaRes.Add(item, mapper.Map<List<GetEnumeradoComboDto>>(lista[item]));
                }
                return listaRes;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

    }
}
