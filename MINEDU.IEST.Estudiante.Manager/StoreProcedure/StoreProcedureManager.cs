using AutoMapper;
using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Manager.StoreProcedure
{
    public class StoreProcedureManager : IStoreProcedureManager
    {
        private readonly IMapper _mapper;
        private readonly StoreProcedureUnitOfWork _storeProcedureUnitOfWork;
        public StoreProcedureManager(IMapper mapper, StoreProcedureUnitOfWork storeProcedureUnitOfWork)
        {
            _mapper = mapper;
            _storeProcedureUnitOfWork = storeProcedureUnitOfWork;
        }

        public async Task<GetCabeceraMatriculaSpDto> GetCabeceraMatricula(int? ID_PLAN_ESTUDIO, int? ID_SEMESTRE_ACADEMICO)
        {
            var resul = await _storeProcedureUnitOfWork._spRepository.GetDatosGeneralesMatricula(ID_PLAN_ESTUDIO, ID_SEMESTRE_ACADEMICO);
            GetCabeceraMatriculaSpDto? getCabeceraMatriculaSpDto = _mapper.Map<List<GetCabeceraMatriculaSpDto>>(resul).FirstOrDefault();
            return getCabeceraMatriculaSpDto;
        }

        public async Task<List<GetListMatriculaCurso>> GetCursosMatricula(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_PLAN_ESTUDIO, int ID_SEMESTRE_ACADEMICO_ACTUAL, int ID_ESTUDIANTE_INSTITUCION, int ID_MATRICULA_ESTUDIANTE, bool ES_UNIDAD_DIDACTICA_EF, int Pagina, int Registros, bool ES_MATRICULA_CON_UD_PREVIAS)
        {
            var resul = await _storeProcedureUnitOfWork._spRepository.GetCursosMatricula(ID_INSTITUCION, ID_PERIODO_ACADEMICO, ID_PLAN_ESTUDIO, ID_SEMESTRE_ACADEMICO_ACTUAL, ID_ESTUDIANTE_INSTITUCION, ID_MATRICULA_ESTUDIANTE, ES_UNIDAD_DIDACTICA_EF, Pagina, Registros, ES_MATRICULA_CON_UD_PREVIAS);
            return _mapper.Map<List<GetListMatriculaCurso>>(resul);
        }


        public async Task<List<GetListProgramacionCurso>> GetProgramacionCurso(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_UNIDAD_DIDACTICA)
        {
            var resul = await _storeProcedureUnitOfWork._spRepository.GetProgramacionCurso(ID_INSTITUCION, ID_PERIODO_ACADEMICO, ID_UNIDAD_DIDACTICA);
            return _mapper.Map<List<GetListProgramacionCurso>>(resul);
        }
    }
}
