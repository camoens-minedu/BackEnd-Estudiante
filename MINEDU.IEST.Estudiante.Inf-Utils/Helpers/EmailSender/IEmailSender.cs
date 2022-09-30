using MINEDU.IEST.Estudiante.Inf_Utils.Dtos;

namespace MINEDU.IEST.Estudiante.Inf_Utils.Helpers.EmailSender
{
    public interface IEmailSender
    {
        Task SendEmailAsync(MailRequest mailRequest);
        Task SendEmailAsync(Message message);
    }
}