namespace MINEDU.IEST.Estudiante.ManagerDto.SecurityApi
{
    public class GetEstudianteInsitucionApiDto
    {

        /*
            = p.ID_PERSONA_INSTITUCION,
                             = p.ID_PERSONA_INSTITUCION,

         */
        public int ID_ESTUDIANTE_INSTITUCION { get; set; }
        public int ID_PERSONA_INSTITUCION { get; set; }
        public int ID_CARRERAS_POR_INSTITUCION_DETALLE { get; set; }
        public int ID_SEDE_INSTITUCION { get; set; }
        public int ID_CARRERA { get; set; }
        public int ID_SEMESTRE_ACADEMICO { get; set; }
        public int ID_PLAN_ESTUDIO { get; set; }
        public int ID_PERIODOS_LECTIVOS_POR_INSTITUCION { get; set; }
        public string? ARCHIVO_FOTO { get; set; }
        public string? ARCHIVO_RUTA { get; set; }
        public string NombreCarrera { get; set; }
        public string fotoBase64 { get; set; }



    }
}
