using AutoMapper;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;
using MINEDU.IEST.Estudiante.Repository.Maestra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MINEDU.IEST.Estudiante.Manager.Maestra
{
    public class MaestraManager : IMaestraManager
    {
        private readonly IMaestraRepository maestraRepository;
        private readonly IMapper mapper;

        public MaestraManager(IMaestraRepository maestraRepository, IMapper mapper)
        {
            this.maestraRepository = maestraRepository;
            this.mapper = mapper;
        }
        public async Task<List<GetTipoEnumeradoDto>> GetListEnumerado()
        {
            try
            {
                var query = mapper.Map<List<GetTipoEnumeradoDto>>(await maestraRepository.GetListEnumeradosSistema());
                return query;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
