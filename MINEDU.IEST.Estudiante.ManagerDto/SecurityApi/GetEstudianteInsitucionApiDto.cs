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
        public int ID_CARRERA { get; set; }
        public string NombreCarrera { get; set; }


    }
}
