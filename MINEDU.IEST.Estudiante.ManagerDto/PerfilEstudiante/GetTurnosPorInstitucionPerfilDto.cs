namespace MINEDU.IEST.Estudiante.ManagerDto.PerfilEstudiante
{
    public class GetTurnosPorInstitucionPerfilDto
    {
        public int ID_TURNOS_POR_INSTITUCION { get; set; }
        public int ID_TURNO_EQUIVALENCIA { get; set; }

        public GetTurnoEquivalenciaPerfilDto GetTurnoEquivalenciaPerfilDto { get; set; }
    }
}
