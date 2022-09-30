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
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi;
using MINEDU.IEST.Estudiante.ManagerDto.SecurityApi.ValidateUser;
using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure;

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

            #endregion


            #region Store Procedure
            CreateMap<USP_MATRICULA_SEL_DATOS_GENERALES_MATRICULAResult, GetCabeceraMatriculaSpDto>();
            CreateMap<USP_MATRICULA_SEL_UNIDADES_DIDACTICAS_PAGINADOResult, GetListMatriculaCurso>();
            CreateMap<ProgramacionCurso, GetListProgramacionCurso>();

            #endregion


            #region Pre-MAtricula

            CreateMap<matricula_estudiante, GetMatriculaEstudianteDto>();
            CreateMap<programacion_clase_por_matricula_estudiante, GetProgramacionClasePorMatriculaEstudianteDto>();

            #endregion


            #region Seguridad API

            CreateMap<Persona, GetPersonaApiDto>();
            CreateMap<User, GetUserDto>();
            CreateMap<Role, GetRolDto>();

            CreateMap<persona_institucion, GetPersonaInstitucionApiDto>();
            CreateMap<estudiante_institucion, GetEstudianteInsitucionApiDto>()
                .ForMember(dest => dest.ID_CARRERA, opt => opt.MapFrom(c => c.ID_CARRERAS_POR_INSTITUCION_DETALLENavigation.ID_CARRERAS_POR_INSTITUCIONNavigation.ID_CARRERA));

            CreateMap<UvwInstitucion, GetAuxInstitucionDto>();
            CreateMap<persona, GetValidatePersonaDto>();
            CreateMap<persona_institucion, GetValidatePersonaInstitucionDto>();



            #endregion
        }


    }
}
