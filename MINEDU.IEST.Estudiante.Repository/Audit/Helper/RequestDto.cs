namespace MINEDU.IEST.Estudiante.Repository.Audit.Helper
{
    public class RequestDto
    {
        public string Body { get; set; }
        public string Headers { get; set; }
        public string QueryString { get; set; }
        public string Host { get; set; }
        public string Port { get; set; }
        public string Path { get; set; }
        public string Method { get; set; }
        public string Protocol { get; set; }
    }
}
