using MINEDU.IEST.Estudiante.Entity;
using MINEDU.IEST.Estudiante.Repository.Base;

namespace MINEDU.IEST.Estudiante.Repository.InformacionPersonal
{
    public interface IInformacionPersonaRepository: IGenericRepository<persona>
    {
        Task<persona_institucion> GetEstudiantePerfil(int idInstitucion, int idCarrera);
        Task<persona> GetPersonaAlumno(int idPersona, int idPersonaInstitucion);
        Task<persona> GetPersonaInstitucionValidate(int tipoDocumento, string nroDocumento, string correo);
        Task<List<persona_institucion>> GetPersonaIntitucionLogin(int idPersona);
        Task<List<estudiante_institucion>> GetListEstudianteInstitucion(int idInstitucion);
        Task<estudiante_institucion> GetListEstudianteInstitucion(int idInstitucion, int idEstudiante);
        Task<string> GetPeriodoLectivoIngreso(int idPeriodoLectivoPorInstitucion);
    }
}