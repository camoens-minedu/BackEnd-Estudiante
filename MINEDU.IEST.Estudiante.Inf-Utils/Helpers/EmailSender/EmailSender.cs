using MailKit.Net.Smtp;
using MimeKit;
using MINEDU.IEST.Estudiante.Inf_Utils.Dtos;

namespace MINEDU.IEST.Estudiante.Inf_Utils.Helpers.EmailSender
{
    public class EmailSender : IEmailSender
    {
        private readonly MailSettings _mailSettings;
        private readonly ResourceDto _resourceDto;

        //private readonly IWebHostEnvironment hostingEnvironment;

        public EmailSender(MailSettings mailSettings, ResourceDto resourceDto)
        {
            this._mailSettings = mailSettings;
            this._resourceDto = resourceDto;
        }

        public async Task SendEmailAsync(Message message)
        {
            var mailMessage = CreateEmailMessage(message);
            await SendAsync(mailMessage);
        }

        public async Task SendEmailRestauraClaveAsync(Message message)
        {
            var mailMessage = CreateEmailMessageRestauraClave(message);
            await SendAsync(mailMessage);
        }

        private MimeMessage CreateEmailMessageRestauraClave(Message message)
        {
            try
            {
                var emailMessage = new MimeMessage();
                emailMessage.From.Add(new MailboxAddress("DIRECCION IEST - MINEDU", _mailSettings.UsuarioCorreo));
                emailMessage.To.AddRange(message.To);
                emailMessage.Subject = message.Subject;
                var fileHtmlPath = $"{_resourceDto.template_correo}/restaura_clave.html";
                string bodyHtml = string.Empty;

                using (StreamReader SourceReader = System.IO.File.OpenText(fileHtmlPath))
                {
                    bodyHtml = SourceReader.ReadToEnd();

                }
                var bodyBuilder = new BodyBuilder { HtmlBody = getHtmlBody(bodyHtml, message.Content.ToArray()) };

                if (message.Attachments != null && message.Attachments.Any())
                {
                    byte[] fileBytes;
                    foreach (var attachment in message.Attachments)
                    {
                        using (var ms = new MemoryStream())
                        {
                            attachment.CopyTo(ms);
                            fileBytes = ms.ToArray();
                        }

                        bodyBuilder.Attachments.Add(attachment.FileName, fileBytes, ContentType.Parse(attachment.ContentType));
                    }
                }
                //emailMessage.Body = new TextPart(MimeKit.Text.TextFormat.Html)
                //{
                //    Text = bodyBuilder.ToMessageBody().ToString()
                //};
                emailMessage.Body = bodyBuilder.ToMessageBody();

                return emailMessage;
            }
            catch (Exception ex)
            {
                //logger.LogError(ex.Message);
                throw ex;
            }
        }

        private MimeMessage CreateEmailMessage(Message message)
        {
            try
            {
                var emailMessage = new MimeMessage();
                emailMessage.From.Add(new MailboxAddress("DIRECCION IEST - MINEDU", _mailSettings.UsuarioCorreo));
                emailMessage.To.AddRange(message.To);
                emailMessage.Subject = message.Subject;
                var fileHtmlPath = $"{_resourceDto.template_correo}/account_validate.html";
                string bodyHtml = string.Empty;

                using (StreamReader SourceReader = System.IO.File.OpenText(fileHtmlPath))
                {
                    bodyHtml = SourceReader.ReadToEnd();

                }
                var bodyBuilder = new BodyBuilder { HtmlBody = getHtmlBody(bodyHtml, message.Content.ToArray()) };

                if (message.Attachments != null && message.Attachments.Any())
                {
                    byte[] fileBytes;
                    foreach (var attachment in message.Attachments)
                    {
                        using (var ms = new MemoryStream())
                        {
                            attachment.CopyTo(ms);
                            fileBytes = ms.ToArray();
                        }

                        bodyBuilder.Attachments.Add(attachment.FileName, fileBytes, ContentType.Parse(attachment.ContentType));
                    }
                }
                //emailMessage.Body = new TextPart(MimeKit.Text.TextFormat.Html)
                //{
                //    Text = bodyBuilder.ToMessageBody().ToString()
                //};
                emailMessage.Body = bodyBuilder.ToMessageBody();

                return emailMessage;
            }
            catch (Exception ex)
            {
                //logger.LogError(ex.Message);
                throw ex;
            }
        }

        private async Task SendAsync(MimeMessage mailMessage)
        {
            using (var client = new SmtpClient())
            {
                try
                {
                    await client.ConnectAsync(_mailSettings.ServidorCorreo, Convert.ToInt32(_mailSettings.PuertoServidor), true);
                    client.AuthenticationMechanisms.Remove("XOAUTH2");
                    await client.AuthenticateAsync(_mailSettings.UsuarioCorreo, _mailSettings.PasswordCorreo);
                    await client.SendAsync(mailMessage);

                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    await client.DisconnectAsync(true);
                    client.Dispose();
                }
            }
        }


        private string getHtmlBody(string body, string[] model)
        {
            //return string.Format(body, model[0], model[1], model[2]);
            body = body.Replace("{nombre_estudiante}", model[0].ToString());
            body = body.Replace("[USUARIO]", model[1]);
            body = body.Replace("[CLAVE]", model[2]);
            body = body.Replace("{url_activar_cuenta}", _mailSettings.UrlAppcliente);
            body = body.Replace("{text_button}", "Ingresar");
            return body;
        }


        public async Task SendEmailAsync(MailRequest mailRequest)
        {
            var msg = new MimeMessage();
            msg.From.Add(new MailboxAddress("DIRECCION IEST - MINEDU", _mailSettings.UsuarioCorreo));
            msg.To.Add(new MailboxAddress("", mailRequest.ToEmail));
            msg.Subject = mailRequest.Subject;
            msg.Body = new TextPart("plain")
            {
                Text = mailRequest.Body
            };


            using (var mailClient = new SmtpClient())
            {
                try
                {
                    await mailClient.ConnectAsync(_mailSettings.ServidorCorreo, Convert.ToInt32(_mailSettings.PuertoServidor), true); //SecureSocketOptions.None
                    mailClient.AuthenticationMechanisms.Remove("XOAUTH2");
                    await mailClient.AuthenticateAsync(_mailSettings.UsuarioCorreo, _mailSettings.PasswordCorreo);
                    await mailClient.SendAsync(msg);
                }
                catch (Exception ex)
                {

                    throw;
                }
                finally
                {
                    await mailClient.DisconnectAsync(true);
                    mailClient.Dispose();
                }
            }
        }
    }
}
