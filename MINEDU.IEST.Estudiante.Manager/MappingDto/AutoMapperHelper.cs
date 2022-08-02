using AutoMapper;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;

namespace MINEDU.IEST.Estudiante.Manager.MappingDto
{
    public class AutoMapperHelper : Profile
    {
        public AutoMapperHelper()
        {
            #region Maestras

            CreateMap<enumerado, GetTipoEnumeradoDto>();

            #endregion
        }


    }
}
