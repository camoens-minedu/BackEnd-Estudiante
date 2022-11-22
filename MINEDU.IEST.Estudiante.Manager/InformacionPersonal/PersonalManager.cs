using AutoMapper;
using MINEDU.IEST.Estudiante.Inf_Utils.Enumerados;
using MINEDU.IEST.Estudiante.Manager.Auxiliar;
using MINEDU.IEST.Estudiante.Manager.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.PerfilEstudiante;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi.ValidateUser;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Manager.InformacionPersonal
{
    public class PersonalManager : IPersonalManager
    {
        private readonly MaestrasUnitOfWork _maestrasUnitOfWork;
        private readonly InformacionPersonaUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;
        private readonly IMaestraManager _maestraManager;
        private readonly IAuxiliarManager _auxiliarManager;
        private readonly DigePadronUnitOfWork _digePadronUnitOfWork;
        private readonly SecurityApiUnitOfWork _securityApiUnitOfWork;

        public PersonalManager(MaestrasUnitOfWork maestrasUnitOfWork, InformacionPersonaUnitOfWork unitOfWork, IMapper mapper, IMaestraManager maestraManager, IAuxiliarManager auxiliarManager, DigePadronUnitOfWork digePadronUnitOfWork, SecurityApiUnitOfWork securityApiUnitOfWork)
        {
            this._maestrasUnitOfWork = maestrasUnitOfWork;
            _unitOfWork = unitOfWork;
            this._mapper = mapper;
            _maestraManager = maestraManager;
            this._auxiliarManager = auxiliarManager;
            _digePadronUnitOfWork = digePadronUnitOfWork;
            this._securityApiUnitOfWork = securityApiUnitOfWork;
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

        public async Task<bool> CreateOrUpdateInformacionPersonal(CreateOrUpdatePersonaDto model)
        {
            var persona = _unitOfWork._personaRepository.GetAll(p => p.ID_PERSONA == model.ID_PERSONA, includeProperties: "persona_institucion").FirstOrDefault();
            persona.ID_LENGUA_MATERNA = model.ID_LENGUA_MATERNA;
            persona.ES_DISCAPACITADO = model.ES_DISCAPACITADO;
            persona.PAIS_NACIMIENTO = model.PAIS_NACIMIENTO;
            persona.UBIGEO_NACIMIENTO = model.UBIGEO_NACIMIENTO.ToString();

            var personaInstitucion = persona.persona_institucion.FirstOrDefault();
            personaInstitucion.CORREO = model.CORREO;
            personaInstitucion.CELULAR = model.CELULAR;
            personaInstitucion.DIRECCION_PERSONA = model.DIRECCION_PERSONA;

            _unitOfWork._personaRepository.Update(persona);
            _unitOfWork.Save();

            //update usuario
            var user = _securityApiUnitOfWork._userRepository.GetAll(p => p.Id_Persona == model.ID_PERSONA).FirstOrDefault();
            user.Email = model.CORREO;
            user.NormalizedEmail = model.CORREO;

            _securityApiUnitOfWork._userRepository.Update(user);
            _securityApiUnitOfWork.Save();

            return true;
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
                d.xCodigoPeriodoLectivoIngreso = query.estudiante_institucion.FirstOrDefault().ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation.ID_PERIODO_LECTIVONavigation.CODIGO_PERIODO_LECTIVO;
                d.xTextoSituacion = _maestrasUnitOfWork._maestraRepository.GetById(query.estudiante_institucion.FirstOrDefault().ESTADO).VALOR_ENUMERADO;
                d.xTextoModalidad = _maestrasUnitOfWork._maestraRepository.GetById(query.estudiante_institucion.FirstOrDefault().ID_TIPO_ESTUDIANTE).VALOR_ENUMERADO;
                d.xPeriodoAcademicoActual = _maestrasUnitOfWork._maestraRepository.GetById(query.estudiante_institucion.FirstOrDefault().ID_SEMESTRE_ACADEMICO).VALOR_ENUMERADO;
                d.xNombreSede = _maestrasUnitOfWork._maestraRepository.GetSedeInstitucionByIdCarreraInstitucionDetalle(query.estudiante_institucion.FirstOrDefault().ID_CARRERAS_POR_INSTITUCION_DETALLE).NOMBRE_SEDE;

            });

            /*
                public string xNombreSede { get; set; }
             */

            response.PersonaInstitucionDto.NombreCarrera = _digePadronUnitOfWork._padronCarrera.GetById(query.IdCarrera).NombreCarrera;
            response.PersonaInstitucionDto.NombrePlanEstudio = $"{response.PersonaInstitucionDto.NombreCarrera} - {query.NombrePlanEstudio}";
            return response;

        }

        public Task<GetValidatePersonaDto> GetPersonaForConfirm(int idPersona)
        {
            try
            {
                var query = _unitOfWork._personaRepository.GetAll(p => p.ID_PERSONA == idPersona, includeProperties: "persona_institucion").FirstOrDefault();
                var response = _mapper.Map<GetValidatePersonaDto>(query) ?? new GetValidatePersonaDto();
                response.personaInstituciones = _mapper.Map<List<GetValidatePersonaInstitucionDto>>(query.persona_institucion);
                return Task.FromResult(response);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        #endregion


    }
}
