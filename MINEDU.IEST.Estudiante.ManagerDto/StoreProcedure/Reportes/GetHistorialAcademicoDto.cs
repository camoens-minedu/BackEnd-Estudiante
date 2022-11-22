using MINEDU.IEST.Estudiante.ManagerDto.Reporte.FichaMatricula;

namespace MINEDU.IEST.Estudiante.ManagerDto.StoreProcedure.Reportes
{

    public class GetHistorialCabecera
    {
        public GetFichaEstudiante_institucionHistorialDto cabecera { get; set; }
        public List<GetHistorialAcademicoDto> DetalleSpHistorial { get; set; }

    }
    public class GetHistorialAcademicoDto
    {
        public long Total { get; set; }

        public string CODIGO_PERIODO_LECTIVO { get; set; }

        public string SEMESTRE_ACTUAL { get; set; }

        public long ID_INSTITUCION { get; set; }

        public string CODIGO_MODULAR { get; set; }

        public string NOMBRE_INSTITUCION { get; set; }

        public long ID_SEDE_INSTITUCION { get; set; }

        public string NOMBRE_SEDE { get; set; }

        public long ID_CARRERA { get; set; }

        public string NOMBRE_CARRERA { get; set; }

        public long ID_PLAN_ESTUDIO { get; set; }

        public string NOMBRE_PLAN_ESTUDIOS { get; set; }

        public long ID_TIPO_ITINERARIO { get; set; }

        public string NOMBRE_TIPO_ITINERARIO { get; set; }

        public string NUMERO_DOCUMENTO_PERSONA { get; set; }

        public string TIPO_DOCUMENTO_PERSONA { get; set; }

        public string ESTUDIANTE { get; set; }

        public string FOTO { get; set; }

        public string SEMESTRE_ACADEMICO_UD { get; set; }

        public long ID_UNIDAD_DIDACTICA { get; set; }

        public string NOMBRE_UNIDAD_DIDACTICA { get; set; }

        public double HORAS { get; set; }

        public double CREDITOS { get; set; }

        public double? NOTA { get; set; }
    }
}
