using MINEDU.IEST.Estudiante.Entity;

namespace MINEDU.IEST.Estudiante.Repository.Reporte
{
    public interface IReporteRepository
    {
        Task<estudiante_institucion> GetReporteCabeceraByIdEstudianteInstitucion(int idEstudiante);
        Task<matricula_estudiante> GetReporteFichaById(int idMatricula);
    }
}