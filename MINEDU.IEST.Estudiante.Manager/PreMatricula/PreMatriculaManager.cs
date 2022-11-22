using AutoMapper;
using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.ManagerDto.PreMatricula;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;

namespace MINEDU.IEST.Estudiante.Manager.PreMatricula
{
    public class PreMatriculaManager : IPreMatriculaManager
    {
        private readonly PreMatriculaUnitOfWork _unitOfWork;
        private readonly IMapper _mapper;

        public PreMatriculaManager(PreMatriculaUnitOfWork unitOfWork, IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            this._mapper = mapper;
        }

        public async Task<bool> GetValidateMatriculaExistente(int idEstudiante, int idPeriodoLectivoPorInstitucion)
        {
            var query = _unitOfWork._preMatriculaRepository.GetAll(p => p.ID_ESTUDIANTE_INSTITUCION == idEstudiante
            && p.ID_PERIODOS_LECTIVOS_POR_INSTITUCION == idPeriodoLectivoPorInstitucion
            && (p.ESTADO == 1 || p.ESTADO == 3)
            && p.ES_ACTIVO);
            return (query.Count() > 0);
        }


        public async Task<bool> CreateOrUpdatePreMatricula(GetMatriculaEstudianteDto entity)
        {
            try
            {
                var matEstudiante = _mapper.Map<matricula_estudiante>(entity);
                var programacionCurso = _mapper.Map<List<programacion_clase_por_matricula_estudiante>>(entity.GetProgramacionClasePorMatriculaEstudianteDtos);
                matEstudiante.programacion_clase_por_matricula_estudiante = programacionCurso;



                matEstudiante.FECHA_MODIFICACION = matEstudiante.FECHA_MATRICULA = matEstudiante.FECHA_CREACION = DateTime.Now;
                matEstudiante.USUARIO_MODIFICACION = matEstudiante.USUARIO_CREACION;
                matEstudiante.ESTADO = 3; //Pre-matricula: Situacion Pendiente de Aprobación

                matEstudiante.programacion_clase_por_matricula_estudiante.ForEach(p =>
                {
                    p.FECHA_MODIFICACION = p.FECHA_CREACION = DateTime.Now;
                    p.USUARIO_CREACION = p.USUARIO_MODIFICACION = matEstudiante.USUARIO_CREACION;
                });

                _unitOfWork._preMatriculaRepository.Insert(matEstudiante);
                _unitOfWork.Save();
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public async Task<List<GetMatriculaEstudianteDto>> GetFichasEstudianteByIdPersona(int idEstudiante)
        {
            var query = _unitOfWork._preMatriculaRepository
                .GetAll(p => p.ID_ESTUDIANTE_INSTITUCION == idEstudiante 
                //&& p.ESTADO == 1 
                //&& p.ES_ACTIVO
                , p => p.OrderByDescending(r => r.FECHA_MATRICULA)
                , "ID_PERIODO_ACADEMICONavigation");
            var response = _mapper.Map<List<GetMatriculaEstudianteDto>>(query);
            return await Task.FromResult(response);

        }
    }
}
