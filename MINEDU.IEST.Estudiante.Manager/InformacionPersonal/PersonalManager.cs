using AutoMapper;
using MINEDU.IEST.Estudiante.Inf_Utils.Enumerados;
using MINEDU.IEST.Estudiante.Manager.Auxiliar;
using MINEDU.IEST.Estudiante.Manager.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.PerfilEstudiante;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Manager.InformacionPersonal
{
    public class PersonalManager : IPersonalManager
    {
        private readonly InformacionPersonaUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;
        private readonly IMaestraManager _maestraManager;
        private readonly IAuxiliarManager _auxiliarManager;
        private readonly DigePadronUnitOfWork _digePadronUnitOfWork;

        public PersonalManager(InformacionPersonaUnitOfWork unitOfWork, IMapper mapper, IMaestraManager maestraManager, IAuxiliarManager auxiliarManager, DigePadronUnitOfWork digePadronUnitOfWork)
        {
            _unitOfWork = unitOfWork;
            this._mapper = mapper;
            _maestraManager = maestraManager;
            this._auxiliarManager = auxiliarManager;
            _digePadronUnitOfWork = digePadronUnitOfWork;
        }


        public async Task<GetInfoPersonalForEdit> GetInfoPersonalForEdit(int idPersona, int idPersonaInstitucion)
        {
            var response = new GetInfoPersonalForEdit();
            var query = await _unitOfWork._personaRepository.GetPersonaAlumno(idPersona, idPersonaInstitucion);
            if (query == null)
            {
                return response;
            }
            response.Persona = _mapper.Map<GetPersonaDto>(query);
            response.Persona.ListPersonaInstitucion = _mapper.Map<List<GetPersonaInstitucionShortDto>>(query.persona_institucion);

            if (response.Persona.UBIGEO_NACIMIENTO != null)
            {
                var reqUbigeo = await _auxiliarManager.GetUbigeoAuxiliarById(response.Persona.UBIGEO_NACIMIENTO);
                response.Persona.UbigeoNacimientoFull = $"{reqUbigeo.DepartamentoUbigeo} / {reqUbigeo.ProvinciaUbigeo} / {reqUbigeo.DistritoUbigeo}";
            }

            List<EnumeradoCabecera> listaMaestra = new List<EnumeradoCabecera>();
            Dictionary<EnumeradoCabecera, List<GetEnumeradoComboDto>> oListaEnumMaestras;

            listaMaestra.Add(EnumeradoCabecera.TIPO_DOCUMENTO);
            listaMaestra.Add(EnumeradoCabecera.TIPO_SEXO);
            listaMaestra.Add(EnumeradoCabecera.LENGUA);

            oListaEnumMaestras = await _maestraManager.GetListEnumeradoByGrupo(listaMaestra);

            response.tipoLenguaMaterna = oListaEnumMaestras[EnumeradoCabecera.LENGUA];
            response.sexo = oListaEnumMaestras[EnumeradoCabecera.TIPO_SEXO];
            response.tipoDocumento = oListaEnumMaestras[EnumeradoCabecera.TIPO_DOCUMENTO];

            response.paises = await _auxiliarManager.GetPaisAll();


            return response;
        }

        #region Perfiles

        public async Task<GetPerfilEstudianteForEdit?> GetEstudiantePerfil(int idInstitucion, int idCarrera)
        {
            var response = new GetPerfilEstudianteForEdit();
            var query = await _unitOfWork._personaRepository.GetEstudiantePerfil(idInstitucion, idCarrera);
            if (query == null) return null;
            response.PersonaInstitucionDto = _mapper.Map<GetPersonaInstitucionPerfilDto>(query);
            response.PersonaInstitucionDto.EstudianteInstitucionPerfilDtos = _mapper.Map<List<GetEstudianteInstitucionPerfilDto>>(query.estudiante_institucion);
            response.PersonaInstitucionDto.EstudianteInstitucionPerfilDtos.ForEach(d =>
            {
                d.GetInstitucionBasicaPerfilDto = _mapper.Map<GetInstitucionBasicaPerfilDto>(query.estudiante_institucion.FirstOrDefault().ID_INSTITUCION_BASICANavigation);
                d.GetPeriodoLecticoPorInstitucionPerfilDto = _mapper.Map<GetPeriodoLecticoPorInstitucionPerfilDto>(query.estudiante_institucion.FirstOrDefault().ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation);
                d.GetTurnosPorInstitucionPerfilDto = _mapper.Map<GetTurnosPorInstitucionPerfilDto>(query.estudiante_institucion.FirstOrDefault().ID_TURNOS_POR_INSTITUCIONNavigation);
                d.GetTurnosPorInstitucionPerfilDto.GetTurnoEquivalenciaPerfilDto = _mapper.Map<GetTurnoEquivalenciaPerfilDto>(query.estudiante_institucion.FirstOrDefault().ID_TURNOS_POR_INSTITUCIONNavigation.ID_TURNO_EQUIVALENCIANavigation);

            });

            response.PersonaInstitucionDto.NombreCarrera = _digePadronUnitOfWork._padronCarrera.GetById(query.IdCarrera).NombreCarrera;
            response.PersonaInstitucionDto.NombrePlanEstudio = $"{response.PersonaInstitucionDto.NombreCarrera} - {query.NombrePlanEstudio}";
            return response;

        }
        #endregion
    }
}
