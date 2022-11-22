using MINEDU.IEST.Estudiante.ManagerDto.Reporte;

namespace MINEDU.IEST.Estudiante.Manager.Reporte
{
    public interface IReporteManager
    {
        Task<GetPdfDto> GetReporteHistorialAcademicoByEstudiante(int ID_INSTITUCION, int ID_TIPO_DOCUMENTO, string ID_NUMERO_DOCUMENTO, int ID_SEDE_INSTITUCION, int ID_CARRERA, int ID_PLAN_ESTUDIO, int ID_PERIODO_LECTIVO_INSTITUCION);
        Task<GetPdfDto> GetRepoteBoletaNotasByEstudiante(int idMatricula, int idPeriodoLectivoByInstitucion);
        Task<GetPdfDto> GetRepoteFichaByIdMatricula(int idMatricula);
    }
}
