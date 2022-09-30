namespace MINEDU.IEST.Estudiante.ManagerDto.PerfilEstudiante
{
    public class GetInstitucionBasicaPerfilDto
    {
        public int ID_INSTITUCION_BASICA { get; set; }
        public int ID_TIPO_INSTITUCION_BASICA { get; set; }
        public string? CODIGO_MODULAR_IE_BASICA { get; set; }
        public string? NOMBRE_IE_BASICA { get; set; }
        public int ID_NIVEL_IE_BASICA { get; set; }
        public int ID_TIPO_GESTION_IE_BASICA { get; set; }
        public string? DIRECCION_IE_BASICA { get; set; }
        public int ID_PAIS { get; set; }
        public string? UBIGEO_IE_BASICA { get; set; }
        public int ESTADO { get; set; }
    }
}
