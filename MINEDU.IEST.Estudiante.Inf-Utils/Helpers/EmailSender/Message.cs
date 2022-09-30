using Microsoft.AspNetCore.Http;
using MimeKit;

namespace MINEDU.IEST.Estudiante.Inf_Utils.Helpers.EmailSender
{
    public class Message
    {
        public List<MailboxAddress> To { get; set; }
        public string Subject { get; set; }
        public List<string> Content { get; set; }
        public IFormFileCollection Attachments { get; set; }
        public Message(IEnumerable<string> to, string subject, IEnumerable<string> content, IFormFileCollection attachments = null)
        {
            To = new List<MailboxAddress>();
            To.AddRange(to.Select(x => new MailboxAddress("email", x)));
            Subject = subject;
            Content = new List<string>();
            Content.AddRange(content.Select(x => new string(x)));
            Attachments = attachments;
        }
    }
}
