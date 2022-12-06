using AutoMapper;
using Microsoft.Extensions.Configuration;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Entity.SecurityApi;
using MINEDU.IEST.Estudiante.Inf_Utils.Constants;
using MINEDU.IEST.Estudiante.Inf_Utils.Dtos;
using MINEDU.IEST.Estudiante.Inf_Utils.Enumerados;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers.EmailSender;
using MINEDU.IEST.Estudiante.Inf_Utils.Helpers.FileManager;
using MINEDU.IEST.Estudiante.Manager.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi.ValidateUser;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Manager.SecurityApi
{
    public class SecurityApiManager : ISecurityApiManager
    {
        private readonly IMapper _mapper;
        private readonly SecurityApiUnitOfWork _securityApiUnitOfWork;
        private readonly IEmailSender _emailSender;
        private readonly InformacionPersonaUnitOfWork _personalUnitOfWork;
        private readonly DigePadronUnitOfWork _digePadronUnitOfWork;
        private readonly AuxiliarUnitOfWork _auxiliarUnitOfWork;
        private readonly IMaestraManager _maestrasManager;
        private readonly PreMatriculaUnitOfWork _preMatriculaUnitOfWork;
        private readonly ResourceDto _resourceDto;
        private readonly IStorageManager _storageManager;

        public SecurityApiManager(IMapper mapper, SecurityApiUnitOfWork securityApiUnitOfWork, IEmailSender emailSender, InformacionPersonaUnitOfWork unitOfWork, DigePadronUnitOfWork digePadronUnitOfWork, AuxiliarUnitOfWork auxiliarUnitOfWork, IMaestraManager maestrasManager, PreMatriculaUnitOfWork preMatriculaUnitOfWork, ResourceDto resourceDto, IStorageManager storageManager)
        {
            _mapper = mapper;
            _securityApiUnitOfWork = securityApiUnitOfWork;
            _emailSender = emailSender;
            _personalUnitOfWork = unitOfWork;
            _digePadronUnitOfWork = digePadronUnitOfWork;
            _auxiliarUnitOfWork = auxiliarUnitOfWork;
            _maestrasManager = maestrasManager;
            _preMatriculaUnitOfWork = preMatriculaUnitOfWork;
            this._resourceDto = resourceDto;
            _storageManager = storageManager;
        }

        public async Task<GetUserDto> GetUserByUserName(int idPersona)
        {
            var response = new GetUserDto();
            var menus = new List<MenuDto>();


            var query = await _securityApiUnitOfWork._userRepository.GetUserByUserName(idPersona);
            response = _mapper.Map<GetUserDto>(query);
            menus = GetOpcionesUserMock();
            //if (response.roles.Any(p => p.Name == Roles.User))
            //{
            //}
            //if (response.roles.Any(p => p.Name == Roles.Administrator))
            //{
            //    menus = GetOpcionesAdministratorMock();
            //}

            response.opciones = menus;
            response.instituciones = await GetInstitucionesAsync(query.Id_Persona);
            response.tieneInstituciones = (response.instituciones.Count > 1);

            return response;
        }

        public async Task<List<GetPersonaInstitucionApiDto>> GetInstitucionesAsync(int id_Persona)
        {
            var query = await _personalUnitOfWork._personaRepository.GetPersonaIntitucionLogin(id_Persona);
            var response = _mapper.Map<List<GetPersonaInstitucionApiDto>>(query);

            foreach (var item in response)
            {
                //item.ID_PERIODO_ACADEMICO = (await _preMatriculaUnitOfWork._preMatriculaRepository.GetPeriodoAcademicoForMatricula(item.ID_INSTITUCION)).ID_PERIODO_ACADEMICO;

                var resul = await _personalUnitOfWork._personaRepository.GetListEstudianteInstitucion(item.ID_PERSONA_INSTITUCION);


                item.carreras = _mapper.Map<List<GetEstudianteInsitucionApiDto>>(resul);

                var periodoAcademicosSesion = await (_preMatriculaUnitOfWork._preMatriculaRepository.GetPeriodoLectivoByIdInstituto(item.ID_INSTITUCION));

                item.ID_PERIODO_ACADEMICO = periodoAcademicosSesion.ID_PERIODO_ACADEMICO;
                item.ID_PERIODOS_LECTIVOS_POR_INSTITUCION_main = periodoAcademicosSesion.ID_PERIODO_ACADEMICONavigation.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation.ID_PERIODOS_LECTIVOS_POR_INSTITUCION;
                item.CODIGO_PERIODO_LECTIVO = periodoAcademicosSesion?.ID_PERIODO_ACADEMICONavigation?.ID_PERIODOS_LECTIVOS_POR_INSTITUCIONNavigation?.ID_PERIODO_LECTIVONavigation?.CODIGO_PERIODO_LECTIVO;

                item.institucion = _mapper.Map<GetAuxInstitucionDto>(await _auxiliarUnitOfWork._auxiliarRepository.GetInstitucion(item.ID_INSTITUCION));

                item.tieneCarreras = item.carreras.Count > 1;


            }

            response.ForEach(p =>
            {
                p.carreras.ForEach(cr =>
                {
                    cr.NombreCarrera = _digePadronUnitOfWork._padronCarrera.GetById(cr.ID_CARRERA).NombreCarrera;
                    MemoryStream _output = null;
                    if (_resourceDto.IsDev)
                    {
                        _output = new MemoryStream(System.IO.File.ReadAllBytes($"{_resourceDto.Images}/users/6.jpg"));
                    }
                    else
                    {
                        _output = new MemoryStream(System.IO.File.ReadAllBytes($"{cr.ARCHIVO_RUTA}"));
                    }
                    cr.fotoBase64 = _storageManager.Base64ToFileBase64(_storageManager.GetBase64(_output), "image/jpg");
                });
            });
            return response;
        }

        public async Task<GetUserDto> CreateOrUpdateUser(GetUserDto userDto)
        {
            var role = _securityApiUnitOfWork._roleRepository.GetAll(p => p.NormalizedName == Roles.User.ToUpper()).FirstOrDefault();
            User user = _mapper.Map<User>(userDto);
            user.Id = Guid.NewGuid().ToString();
            user.EmailConfirmed = true;
            user.NormalizedUserName = user.UserName.ToUpper();
            user.NormalizedEmail = user.Email.ToUpper();
            user.SecurityStamp = Guid.NewGuid().ToString();
            user.ConcurrencyStamp = Guid.NewGuid().ToString();
            user.LockoutEnabled = true;
            user.UserRoles.Add(new UserRole { Role = role });

            _securityApiUnitOfWork._userRepository.Insert(user);
            _securityApiUnitOfWork.Save();

            _securityApiUnitOfWork._userRepository.UpdatePassword(user.UserName, userDto.textPassword);
            await _emailSender.SendEmailAsync(new MailRequest
            {
                Body = "Demo de clave",
                Subject = "Test",
                ToEmail = "camoens1@outlook.com"
            });

            return _mapper.Map<GetUserDto>(user);
        }

        public async Task<List<GetEnumeradoComboDto>> GetTipoDocumento()
        {
            List<EnumeradoCabecera> listaMaestra = new List<EnumeradoCabecera>();
            Dictionary<EnumeradoCabecera, List<GetEnumeradoComboDto>> oListaEnumMaestras;

            listaMaestra.Add(EnumeradoCabecera.TIPO_DOCUMENTO);

            oListaEnumMaestras = await _maestrasManager.GetListEnumeradoByGrupo(listaMaestra);

            return oListaEnumMaestras[EnumeradoCabecera.TIPO_DOCUMENTO].ToList();

        }


        public async Task<GetValidatePersonaDto> GetPersonaInstitucionValidate(int tipoDocumento, string nroDocumento, string correo)
        {

            try
            {
                //Validamos si existe...
                var query = await _personalUnitOfWork._personaRepository.GetPersonaInstitucionValidate(tipoDocumento, nroDocumento, correo);
                var response = _mapper.Map<GetValidatePersonaDto>(query) ?? new GetValidatePersonaDto();

                if (response.ID_PERSONA > 0) // si exsisten el alumno
                {
                    var clave = Guid.NewGuid().ToString().Substring(0, 6);

                    response.personaInstituciones = _mapper.Map<List<GetValidatePersonaInstitucionDto>>(query.persona_institucion);
                    //Si exsisten el usuario
                    var userExsiste = await _securityApiUnitOfWork._userRepository.GetUserByIdPersona(response.ID_PERSONA);
                    if (userExsiste == null)
                    {
                        //Creamos usuario
                        var role = _securityApiUnitOfWork._roleRepository.GetAll(p => p.NormalizedName == Roles.User.ToUpper()).FirstOrDefault();
                        User user = new User
                        {
                            Id = Guid.NewGuid().ToString(),
                            EmailConfirmed = true,
                            NormalizedEmail = response.personaInstituciones.FirstOrDefault().CORREO.ToUpper(),
                            NormalizedUserName = response.NUMERO_DOCUMENTO_PERSONA,
                            SecurityStamp = Guid.NewGuid().ToString(),
                            ConcurrencyStamp = Guid.NewGuid().ToString(),
                            LockoutEnabled = true,
                            Email = response.personaInstituciones.FirstOrDefault().CORREO.ToUpper(),
                            Id_Persona = response.ID_PERSONA,
                            FirstName = response.NOMBRE_PERSONA,
                            LastName = response.APELLIDO_PATERNO_PERSONA,
                            SurName = response.APELLIDO_MATERNO_PERSONA,
                            UserName = response.NUMERO_DOCUMENTO_PERSONA,
                            UserRoles = new List<UserRole> { new UserRole { Role = role } },
                        };


                        _securityApiUnitOfWork._userRepository.Insert(user);
                        _securityApiUnitOfWork.Save();

                        _securityApiUnitOfWork._userRepository.UpdatePassword(user.UserName, clave);
                        _securityApiUnitOfWork.Save();
                    }

                    //enviar correo de notificacion
                    var message = new Message(new string[] { query.persona_institucion.FirstOrDefault().CORREO } //, query.persona_institucion.FirstOrDefault().CORREO
                    , "Activación de cuenta"
                    , new string[]
                    {
                        response.NOMBRE_PERSONA,
                         response.NUMERO_DOCUMENTO_PERSONA,
                        clave
                    }
                    , null);

                    await _emailSender.SendEmailAsync(message);
                }
                return response;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }


        public async Task<GetValidatePersonaDto> GetForgotPassword(string email, string codigo)
        {
            try
            {
                var response = new GetValidatePersonaDto();
                var query = _securityApiUnitOfWork._userRepository.GetAll(p => p.UserName.ToUpper() == codigo.ToUpper() && p.Email.ToUpper() == email.ToUpper()).FirstOrDefault();

                if (query != null)
                {
                    var persona = _personalUnitOfWork._personaRepository.GetAll(p => p.ID_PERSONA == query.Id_Persona, includeProperties: "persona_institucion").FirstOrDefault();
                    response.ID_PERSONA = persona.ID_PERSONA;
                    response.NOMBRE_PERSONA = persona.NOMBRE_PERSONA;
                    response.APELLIDO_PATERNO_PERSONA = persona.APELLIDO_PATERNO_PERSONA;
                    response.APELLIDO_MATERNO_PERSONA = persona.APELLIDO_MATERNO_PERSONA;
                    response.personaInstituciones = _mapper.Map<List<GetValidatePersonaInstitucionDto>>(persona.persona_institucion);

                    var clave = Guid.NewGuid().ToString().Substring(0, 6);
                    _securityApiUnitOfWork._userRepository.UpdatePassword(query.UserName, clave);
                    _securityApiUnitOfWork.Save();

                    var message = new Message(new string[] { response.personaInstituciones?.FirstOrDefault()?.CORREO } //, query.persona_institucion.FirstOrDefault().CORREO
                  , "Restauración de clave"
                  , new string[]
                  {
                        response.NOMBRE_PERSONA,
                         codigo,
                        clave
                  }
                  , null);

                    await _emailSender.SendEmailRestauraClaveAsync(message);
                }

                return response;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public async Task<bool> GetChangePassword(int idPersona, string oldClave, string newClave)
        {
            try
            {
                //var query = await _securityApiUnitOfWork._userRepository.claveCompare(oldClave, idPersona);
                //if (query)
                //{

                var user = _securityApiUnitOfWork._userRepository.GetAll(p => p.Id_Persona == idPersona).FirstOrDefault();
                _securityApiUnitOfWork._userRepository.UpdatePassword(user.UserName, newClave);
                _securityApiUnitOfWork.Save();

                var message = new Message(new string[] { user.Email }, "Cambio de Contraseña"
                    , new string[]
                    {
                            user.FirstName,
                            user.UserName,
                            newClave
                    }
                    , null);
                await _emailSender.SendEmailRestauraClaveAsync(message);
                //}
                return true;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }


        #region Metodos privados

        private List<MenuDto> GetOpcionesAdministratorMock()
        {
            return new List<MenuDto>
            {
                new MenuDto { state = "", name = "Opciones del Sistema", type = "saperator", icon="av_timer"},
                new MenuDto { state = "Home", name = "Inicio", type = "link", icon="home" },
                new MenuDto { state = "organizacion-cat", name = "Organizaciones", type = "link", icon="corporate_fare" },
                new MenuDto { state = "puntaje-obtenido", name = "Pundaje Obtenido", type = "link", icon="sports_score" },
                new MenuDto { state = "resultado", name = "Resultados", type = "link", icon="dataset" },
                new MenuDto { state = "plan-accion", name = "Planes de Acción", type = "link", icon="list_alt" },
                new MenuDto { state = "monitoreo", name = "Monitoreo", type = "link", icon="query_stats" },
            };
        }

        private List<MenuDto> GetOpcionesUserMock()
        {
            return new List<MenuDto>
            {
                new MenuDto { state = "", name = "Opciones del Sistema", type = "saperator", icon="av_timer"},
                new MenuDto { state = "home", name = "Inicio", type = "link", icon="home" },
                new MenuDto { state = "estudiante", name = "Estudiante", type = "sub", icon="av_timer",
                                children = new List<Child>
                                {
                                    new Child { state="informacion-general", name="Informacion General", type="link"},
                                    new Child { state="perfil-estudiante", name="Perfil del Estudiante", type="link"},
                                }
                },
                new MenuDto { state = "matricula", name = "Matricula", type = "sub", icon="insert_drive_file",
                                badge = new List<Badge>{ new Badge { type = "warning", value = "=>"} },
                                children = new List<Child>
                                {
                                    new Child { state="pre-matricula", name="Pre-Matricula", type="link"},
                                    new Child { state="matricula-consolidacion", name="Consolidacion Matricula", type="link"},
                                }
                },
                 new MenuDto { state = "reporte", name = "Reporte", type = "sub", icon="insert_chart",
                                children = new List<Child>
                                {
                                    new Child { state="reporte-historial", name="Historial Academico", type="link"},
                                    new Child { state="boleta-notas", name="Boleta de Notas", type="link"},
                                    //new Child { state="perfil-academico", name="Perfil Academico", type="link"},
                                }
                },
            };

        }



        #endregion


    }
}
