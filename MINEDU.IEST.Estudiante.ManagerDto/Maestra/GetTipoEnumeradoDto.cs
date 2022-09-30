namespace MINEDU.IEST.Estudiante.ManagerDto.Maestra
{
    public class GetTipoEnumeradoDto
    {
        public int ID_ENUMERADO { get; set; }
        public int ID_TIPO_ENUMERADO { get; set; }
        public int? CODIGO_ENUMERADO { get; set; }
        public string? VALOR_ENUMERADO { get; set; }
        public int? ORDEN_ENUMERADO { get; set; }
        public bool ES_EDITABLE { get; set; }
        public int ESTADO { get; set; }
    }
}
