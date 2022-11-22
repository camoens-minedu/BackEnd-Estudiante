using AutoMapper;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Entity.Auxiliar;
using MINEDU.IEST.Estudiante.Entity.SecurityApi;
using MINEDU.IEST.Estudiante.Entity.StoreProcedure;
using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar;
using MINEDU.IEST.Estudiante.ManagerDto.Auxiliar.Pais;
using MINEDU.IEST.Estudiante.ManagerDto.InformacionPersonal;
using MINEDU.IEST.Estudiante.ManagerDto.Maestra;
using MINEDU.IEST.Estudiante.ManagerDto.PerfilEstudiante;
using MINEDU.IEST.Estudiante.ManagerDto.PreMatricula;
using MINEDU.IEST.Estudiante.ManagerDto.Reporte.FichaMatricula;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi.ValidateUser;
using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure;
using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure.Reportes;

namespace MINEDU.IEST.Estudiante.Manager.MappingDto
{
    public class AutoMapperHelper : Profile
    {
        public AutoMapperHelper()
        {
            #region Maestras

            CreateMap<enumerado, GetTipoEnumeradoDto>();
            CreateMap<enumerado, GetEnumeradoComboDto>();

            #endregion

            #region Informacion - personal
            CreateMap<persona_institucion, GetPersonaInstitucionShortDto>();
            CreateMap<persona, GetPersonaDto>();


            #endregion

            #region Perfil Estudiante

            CreateMap<turno_equivalencia, GetTurnoEquivalenciaPerfilDto>();
            CreateMap<institucion_basica, GetInstitucionBasicaPerfilDto>();
            CreateMap<periodos_lectivos_por_institucion, GetPeriodoLecticoPorInstitucionPerfilDto>();
            CreateMap<turnos_por_institucion, GetTurnosPorInstitucionPerfilDto>();


            CreateMap<persona_institucion, GetPersonaInstitucionPerfilDto>();
            CreateMap<estudiante_institucion, GetEstudianteInstitucionPerfilDto>();


            #endregion

            #region Auxiliar

            CreateMap<PaisAuxiliar, GetPaisDto>()
                .ForMember(dest => dest.Codigo, opt => opt.MapFrom(c => Convert.ToInt32(c.Codigo.Substring(0, 5))));
            CreateMap<UbigeoAuxiliar, GetUbigeoAuxiliarDto>();
            CreateMap<UvwUbigeoReniec, GetUbigeoAuxiliarDto>()
                .ForMember(dest => dest.CodigoUbigeo, opt => opt.MapFrom(c => c.CODIGO_UBIGEO))
                .ForMember(dest => dest.DepartamentoUbigeo, opt => opt.MapFrom(c => c.DEPARTAMENTO_UBIGEO))
                .ForMember(dest => dest.ProvinciaUbigeo, opt => opt.MapFrom(c => c.PROVINCIA_UBIGEO))
                .ForMember(dest => dest.DistritoUbigeo, opt => opt.MapFrom(c => c.DISTRITO_UBIGEO))
                .ForMember(dest => dest.nombreFull, opt => opt.MapFrom(c => $"{c.DEPARTAMENTO_UBIGEO} / {c.PROVINCIA_UBIGEO} / {c.DISTRITO_UBIGEO}"));

     
            #endregion

            #region Store Procedure
            CreateMap<USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULAResult, GetCabeceraMatriculaSpDto>();
            CreateMap<USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADOResult, GetListMatriculaCurso>();
            CreateMap<ProgramacionCurso, GetListProgramacionCurso>();

            #endregion

            #region Pre-MAtricula

            CreateMap<matricula_estudiante, GetMatriculaEstudianteDto>()
               .ForMember(dest => dest.periodoAcademico, opt => opt.MapFrom(c => c.ID_PERIODO_ACADEMICONavigation))
                .ReverseMap();
            CreateMap<programacion_clase_por_matricula_estudiante, GetProgramacionClasePorMatriculaEstudianteDto>().ReverseMap();
            CreateMap<programacion_matricula, GetProgramacionMatriculaDto>();
            CreateMap<periodo_academico, GetMatriculaPeriodoAcademicoDto>();


            #endregion

            #region Reportes - Ficha

            CreateMap<matricula_estudiante, GetFichaMatriculaEstudianteDto>()
                .ForMember(dest => dest.estudianteInstitucion, opt => opt.MapFrom(c => c.ID_ESTUDIANTE_INSTITUCIONNavigation))

                    .ForMember(dest => dest.DetalleMatriculaCursos, opt => opt.MapFrom(c => c.programacion_clase_por_matricula_estudiante));

            CreateMap<estudiante_institucion, GetFichaEstudiante_institucionDto>()
                .ForMember(dest => dest.personaInstitucion, opt => opt.MapFrom(c => c.ID_PERSONA_INSTITUCIONNavigation));
            CreateMap<persona_institucion, GetFichaPersona_institucionDto>()
                .ForMember(dest => dest.persona, opt => opt.MapFrom(c => c.ID_PERSONANavigation));
            CreateMap<persona, GetFichaPersona>();


            CreateMap<programacion_clase_por_matricula_estudiante, GetFichaProgramacion_clase_por_matricula_estudianteDto>()
                .ForMember(dest => dest.programacionClase, opt => opt.MapFrom(c => c.ID_PROGRAMACION_CLASENavigation))

                ;

            CreateMap<programacion_clase, GetFichaProgramacion_claseDto>()
                  .ForMember(dest => dest.listUnidadDidacticasPC, opt => opt.MapFrom(c => c.unidades_didacticas_por_programacion_clase))
                    .ForMember(dest => dest.sesion_programacion_clase, opt => opt.MapFrom(c => c.sesion_programacion_clase))
                ;

            CreateMap<unidades_didacticas_por_programacion_clase, GetFichaUnidades_didacticas_por_programacion_claseDto>()
                 .ForMember(dest => dest.unidadEnfoque, opt => opt.MapFrom(c => c.ID_UNIDADES_DIDACTICAS_POR_ENFOQUENavigation));

            CreateMap<unidades_didacticas_por_enfoque, GetFichaUnidades_didacticas_por_enfoqueDto>()
                 .ForMember(dest => dest.unidadDidactica, opt => opt.MapFrom(c => c.ID_UNIDAD_DIDACTICANavigation));


            CreateMap<unidad_didactica, GetFichaUnidad_didacticaDto>();
            CreateMap<sesion_programacion_clase, GetFichaSesionProgramacionClaseDto>()
                 .ForMember(dest => dest.Aula, opt => opt.MapFrom(c => c.ID_AULANavigation));

            CreateMap<aula, GetFichaAulaDto>()
                 .ForMember(dest => dest.sede, opt => opt.MapFrom(c => c.ID_SEDE_INSTITUCIONNavigation));

            CreateMap<sede_institucion, GetFichaSedeInstitucion>();


            CreateMap<USP_EVALUACION_SEL_LISTA_HISTORIAL_ACADEMICO_ESTUDIANTEResult, GetHistorialAcademicoDto>();
            CreateMap<USP_MATRICULA_RPT_BOLETA_NOTASResult, GetBoletaNotasByMatriculaDto>();

            CreateMap<estudiante_institucion, GetFichaEstudiante_institucionHistorialDto>()
                 .ForMember(dest => dest.personaInstitucion, opt => opt.MapFrom(c => c.ID_PERSONA_INSTITUCIONNavigation));
            ;
            #endregion

            #region Seguridad API

            CreateMap<Persona, GetPersonaApiDto>();
            CreateMap<User, GetUserDto>();
            CreateMap<Role, GetRolDto>();

            CreateMap<persona_institucion, GetPersonaInstitucionApiDto>();
            CreateMap<estudiante_institucion, GetEstudianteInsitucionApiDto>()
                .ForMember(dest => dest.ID_CARRERA, opt => opt.MapFrom(c => c.ID_CARRERAS_POR_INSTITUCION_DETALLENavigation.ID_CARRERAS_POR_INSTITUCIONNavigation.ID_CARRERA))
                .ForMember(dest => dest.ID_SEDE_INSTITUCION, opt => opt.MapFrom(c => c.ID_CARRERAS_POR_INSTITUCION_DETALLENavigation.ID_SEDE_INSTITUCION));

            CreateMap<UvwInstitucion, GetAuxInstitucionDto>();
            CreateMap<persona, GetValidatePersonaDto>();
            CreateMap<persona_institucion, GetValidatePersonaInstitucionDto>();



            #endregion
        }


    }
}
