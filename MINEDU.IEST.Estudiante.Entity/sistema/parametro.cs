namespace MINEDU.IEST.Estudiante.Entity
{
    public partial class parametro
    {
        public int ID_PARAMETRO { get; set; }
        public int? CODIGO_PARAMETRO { get; set; }
        public string? NOMBRE_PARAMETRO { get; set; }
        public string? VALOR_PARAMETRO { get; set; }
        public string? DESCRIPCION { get; set; }
        public int ESTADO { get; set; }
        public string USUARIO_CREACION { get; set; } = null!;
        public DateTime FECHA_CREACION { get; set; }
        public string? USUARIO_MODIFICACION { get; set; }
        public DateTime? FECHA_MODIFICACION { get; set; }
    }
}