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


        public async Task<bool> CreateOrUpdatePreMatricula(GetMatriculaEstudianteDto entity)
        {
            var matEstudiante = _mapper.Map<matricula_estudiante>(entity);
            var programacionCurso = _mapper.Map<List<programacion_clase_por_matricula_estudiante>>(entity.GetProgramacionClasePorMatriculaEstudianteDtos);
            matEstudiante.programacion_clase_por_matricula_estudiante = programacionCurso;

            _unitOfWork._preMatriculaRepository.Insert(matEstudiante);
            _unitOfWork.SaveAsync();
            return true;
        }
    }
}
