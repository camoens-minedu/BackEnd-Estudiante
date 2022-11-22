using MINEDU.IEST.Estudiante.ManagerDto.PreMatricula;

namespace MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure
{
    public class GetCabeceraMatriculaSpDto
    {
        public decimal? TotalCreditos { get; set; }
        public decimal? NumeroMaximoCreditosAdicionales { get; set; }

        public GetProgramacionMatriculaDto? ProgramacionMatricula { get; set; }
    }
}
