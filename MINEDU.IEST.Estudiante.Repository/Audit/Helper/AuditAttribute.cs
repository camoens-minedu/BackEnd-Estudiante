using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using MINEDU.IEST.Estudiante.Entity.Audit;
using MINEDU.IEST.Estudiante.Repository.UnitOfWork;
using System.Diagnostics;
using System.Text;
using System.Text.Json;

namespace MINEDU.IEST.Estudiante.Repository.Audit.Helper
{
    public class AuditAttribute : TypeFilterAttribute
    {
        public AuditAttribute() : base(typeof(AuditAttributeImpl))
        {

        }

        public class AuditAttributeImpl : IActionFilter
        {
            private readonly Stopwatch _stopWatch;
            private readonly AuditUnitOfWork _unitOfWork;
            private DateTime _time;
            public AuditAttributeImpl(AuditUnitOfWork unitOfWork)
            {
                _stopWatch = new Stopwatch();
                _time = new DateTime();
                _unitOfWork = unitOfWork;
            }
            public void OnActionExecuted(ActionExecutedContext context)
            {
                _stopWatch.Stop();
                AuditLog auditLog = GetInfo(context);
                SaveInfo(auditLog);
            }

            public void OnActionExecuting(ActionExecutingContext context)
            {
                _stopWatch.Reset();
                _stopWatch.Start();

                _time = DateTime.Now;
            }

            private AuditLog GetInfo(ActionExecutedContext context)
            {
                var executionTime = _stopWatch.ElapsedMilliseconds;
                var bodyStr = "";
                var headersStr = "";
                var req = context.HttpContext.Request;
                var headers = context.HttpContext.Request.Headers;

                // req.EnableRewind();
                using (StreamReader reader = new StreamReader(req.Body, Encoding.UTF8, true, 1024, true)) { bodyStr = reader.ReadToEndAsync().Result; }
                headersStr = string.Join("\n", headers.ToList().Select(s => $"{s.Key} => {s.Value}").ToArray());

                var controller = (context.Controller is ControllerBase) ? ((ControllerBase)context.Controller) : ((Controller)context.Controller);

                AuditLog auditLog = new AuditLog
                {
                    Time = _time,
                    UserName = context.HttpContext.User.Identity.Name ?? "-",
                    Service = controller.ControllerContext.ActionDescriptor.ControllerTypeInfo.Name ?? string.Empty,
                    Action = ((ControllerActionDescriptor)context.ActionDescriptor).ActionName,
                    Duration = executionTime,
                    Ipaddress = context.HttpContext.Connection.RemoteIpAddress?.ToString(),
                    Browser = context.HttpContext.Request.Headers["User-Agent"],
                    Request = JsonSerializer.Serialize(new RequestDto
                    {
                        Body = bodyStr,
                        Headers = headersStr,
                        Host = req.Host.Host,
                        Port = req.Host.Port.ToString(),
                        Method = req.Method,
                        Path = req.Path,
                        Protocol = req.Protocol,
                        QueryString = req.QueryString.ToString()
                    }),
                    Response = "",//JsonSerializer.Serialize(context.HttpContext.Request),
                    Error = ""
                };

                return auditLog;
            }
            private void SaveInfo(AuditLog auditLog)
            {
                _unitOfWork._auditLogRepository.Insert(auditLog);
                _unitOfWork.Save();

            }
        }
    }
}
