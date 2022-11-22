using MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure;

namespace MINEDU.IEST.Estudiante.ManagerDto.PreMatricula
{
    public class GetPreMatriculaCabeceraListCursoDto
    {
        public GetCabeceraMatriculaSpDto cabecera { get; set; }
        public List<GetListMatriculaCurso> listaCursos { get; set; }


    }
}
