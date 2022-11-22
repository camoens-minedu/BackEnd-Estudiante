using AutoMapper;
using MINEDU.IEST.Estudiante.ManagerDto.PreMatricula;
using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure;
using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure.Reportes;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Manager.StoreProcedure
{
    public class StoreProcedureManager : IStoreProcedureManager
    {
        private readonly IMapper _mapper;
        private readonly StoreProcedureUnitOfWork _storeProcedureUnitOfWork;
        private readonly PreMatriculaUnitOfWork _preMatriculaUnitOfWork;

        public StoreProcedureManager(IMapper mapper, StoreProcedureUnitOfWork storeProcedureUnitOfWork, PreMatriculaUnitOfWork _preMatriculaUnitOfWork)
        {
            _mapper = mapper;
            _storeProcedureUnitOfWork = storeProcedureUnitOfWork;
            this._preMatriculaUnitOfWork = _preMatriculaUnitOfWork;
        }

        public async Task<GetCabeceraMatriculaSpDto> GetCabeceraMatricula(int? ID_PLAN_ESTUDIO, int? ID_SEMESTRE_ACADEMICO, int ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
        {
            try
            {
                GetCabeceraMatriculaSpDto? getCabeceraMatriculaSpDto = new GetCabeceraMatriculaSpDto();
                var programacionMatricula = await _preMatriculaUnitOfWork._preMatriculaRepository.GetProgramacionMatriculaByPeriodo(ID_PERIODOS_LECTIVOS_POR_INSTITUCION);
                if (programacionMatricula != null)
                {
                    var resul = await _storeProcedureUnitOfWork._spRepository.GetDatosGeneralesMatricula(ID_PLAN_ESTUDIO, ID_SEMESTRE_ACADEMICO);
                    getCabeceraMatriculaSpDto = _mapper.Map<List<GetCabeceraMatriculaSpDto>>(resul).FirstOrDefault();
                    getCabeceraMatriculaSpDto.ProgramacionMatricula = _mapper.Map<GetProgramacionMatriculaDto>(programacionMatricula);
                }


                return getCabeceraMatriculaSpDto;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public async Task<List<GetListMatriculaCurso>> GetCursosMatricula(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_PLAN_ESTUDIO, int ID_SEMESTRE_ACADEMICO_ACTUAL, int ID_ESTUDIANTE_INSTITUCION, int ID_MATRICULA_ESTUDIANTE, bool ES_UNIDAD_DIDACTICA_EF, int Pagina, int Registros, bool ES_MATRICULA_CON_UD_PREVIAS)
        {
            var qPeriodoAcademico = await _preMatriculaUnitOfWork._preMatriculaRepository.GetPeriodoAcademicoForMatricula(ID_INSTITUCION);

            var resul = await _storeProcedureUnitOfWork._spRepository.GetCursosMatricula(ID_INSTITUCION, qPeriodoAcademico.ID_PERIODO_ACADEMICO, ID_PLAN_ESTUDIO, ID_SEMESTRE_ACADEMICO_ACTUAL, ID_ESTUDIANTE_INSTITUCION, ID_MATRICULA_ESTUDIANTE, ES_UNIDAD_DIDACTICA_EF, Pagina, Registros, ES_MATRICULA_CON_UD_PREVIAS);
            return _mapper.Map<List<GetListMatriculaCurso>>(resul);
        }


        public async Task<List<GetListProgramacionCurso>> GetProgramacionCurso(int ID_INSTITUCION, int ID_PERIODO_ACADEMICO, int ID_UNIDAD_DIDACTICA)
        {
            var qPeriodoAcademico = await _preMatriculaUnitOfWork._preMatriculaRepository.GetPeriodoAcademicoForMatricula(ID_INSTITUCION);

            var resul = await _storeProcedureUnitOfWork._spRepository.GetProgramacionCurso(ID_INSTITUCION, qPeriodoAcademico.ID_PERIODO_ACADEMICO, ID_UNIDAD_DIDACTICA);
            return _mapper.Map<List<GetListProgramacionCurso>>(resul);
        }

        #region Reportes


        public async Task<List<GetBoletaNotasByMatriculaDto>> GetBoletasNotas(int ID_MATRICULA_ESTUDIANTE, int ID_PERIODOS_LECTIVOS_POR_INSTITUCION)
        {
            var qPeriodoAcademico = await _storeProcedureUnitOfWork._spRepository.GetBoletasNotas(ID_MATRICULA_ESTUDIANTE, ID_PERIODOS_LECTIVOS_POR_INSTITUCION);

            return _mapper.Map<List<GetBoletaNotasByMatriculaDto>>(qPeriodoAcademico);
        }

        public async Task<List<GetHistorialAcademicoDto>> GetHistorialAcademico(int ID_INSTITUCION, int ID_TIPO_DOCUMENTO, string ID_NUMERO_DOCUMENTO, int ID_SEDE_INSTITUCION, int ID_CARRERA, int ID_PLAN_ESTUDIO, int ID_PERIODO_LECTIVO_INSTITUCION)
        {


            var qPeriodoAcademico = await _storeProcedureUnitOfWork._spRepository.GetHistorialAcademico(ID_INSTITUCION, ID_TIPO_DOCUMENTO, ID_NUMERO_DOCUMENTO, ID_SEDE_INSTITUCION, ID_CARRERA, ID_PLAN_ESTUDIO, ID_PERIODO_LECTIVO_INSTITUCION);

            return _mapper.Map<List<GetHistorialAcademicoDto>>(qPeriodoAcademico);
        }

        #endregion
    }
}
