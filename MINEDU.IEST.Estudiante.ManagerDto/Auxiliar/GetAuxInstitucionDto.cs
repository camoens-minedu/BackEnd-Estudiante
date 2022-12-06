namespace MINEDU.IEST.Estudiante.ManagerDto.Auxiliar
{
    public class GetAuxInstitucionDto
    {
        public int IdInstitucion { get; set; }
        public string TipoInstitucionNombre { get; set; }
        public int? TipoInstitucion { get; set; }
        public string NombreInstitucion { get; set; }
        public string CodigoModular { get; set; }
        public int? TipoGestion { get; set; }
        public string TipoGestionNombre { get; set; }
        public string Direccion { get; set; }
        public string CodigoDepartamento { get; set; }
        public string NombreDepartamento { get; set; }
        public string CodigoProvincia { get; set; }
        public string NombreProvincia { get; set; }
        public string CodigoDistrito { get; set; }
        public string NombreDistrito { get; set; }
        public string CentroPoblado { get; set; }
        public string ValidadoEscale { get; set; }
        public string EstadoEscale { get; set; }
        public int? Orden { get; set; }
        public int? Grupo { get; set; }
        public DateTime? FechaInicio { get; set; }
        public DateTime? FechaFin { get; set; }
        public bool? Habilitada { get; set; }
        public string DreGre { get; set; }
        public string PaginaWeb { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        public string Celular { get; set; }
        public string EmailSoporteEstudiante { get; set; }
        public string TelefonoSoporteEstudiante { get; set; }
        public string CelularSoporteEstudiante { get; set; }
    }
}
