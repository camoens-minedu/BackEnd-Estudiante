namespace MINEDU.IEST.Estudiante.Inf_Utils.Dtos
{
    public class MailRequest
    {
        public int IdUsuarioDestino { get; set; }
        public string ToEmail { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }

        public List<AdjuntoCorreo> Attachment { get; set; }

        public MailRequest()
        {
            Attachment = new List<AdjuntoCorreo>();
        }
    }

    public class AdjuntoCorreo
    {
        public byte[] Attachment { get; set; }
        public string Filename { get; set; }
    }


}
